bytecode generators
genSpecialSelectorArithmetic
	| primDescriptor rcvrIsConst argIsConst rcvrIsInt argIsInt rcvrInt argInt result
	 jumpNotSmallInts jumpContinue index rcvrReg argReg regMask |
	<var: #jumpContinue type: #'AbstractInstruction *'>
	<var: #primDescriptor type: #'BytecodeDescriptor *'>
	<var: #jumpNotSmallInts type: #'AbstractInstruction *'>
	primDescriptor := self generatorAt: byte0.
	argIsInt := (argIsConst := self ssTop type = SSConstant)
				 and: [objectMemory isIntegerObject: (argInt := self ssTop constant)].
	rcvrIsInt := (rcvrIsConst := (self ssValue: 1) type = SSConstant)
				 and: [objectMemory isIntegerObject: (rcvrInt := (self ssValue: 1) constant)].

	(argIsInt and: [rcvrIsInt]) ifTrue:
		[rcvrInt := objectMemory integerValueOf: rcvrInt.
		 argInt := objectMemory integerValueOf: argInt.
		 primDescriptor opcode caseOf: {
			[AddRR]	-> [result := rcvrInt + argInt].
			[SubRR]	-> [result := rcvrInt - argInt].
			[AndRR]	-> [result := rcvrInt bitAnd: argInt].
			[OrRR]	-> [result := rcvrInt bitOr: argInt] }.
		(objectMemory isIntegerValue: result) ifTrue:
			["Must annotate the bytecode for correct pc mapping."
			^self ssPop: 2; ssPushAnnotatedConstant: (objectMemory integerObjectOf: result)].
		^self genSpecialSelectorSend].

	"If there's any constant involved other than a SmallInteger don't attempt to inline."
	((rcvrIsConst and: [rcvrIsInt not])
	 or: [argIsConst and: [argIsInt not]]) ifTrue:
		[^self genSpecialSelectorSend].

	"If we know nothing about the types then better not to inline as the inline cache and
	 primitive code is not terribly slow so wasting time on duplicating tag tests is pointless."
	(argIsInt or: [rcvrIsInt]) ifFalse:
		[^self genSpecialSelectorSend].

	"Since one or other of the arguments is an integer we can very likely profit from inlining.
	 But if the other type is not SmallInteger or if the operation overflows then we will need to do a send.
	 Since we're allocating values in registers we would like to keep those registers live on the inlined path
	 and reload registers along the non-inlined send path.  But any values that would need to be spilled
	 along the non-inlined path must be captured before the split so that both paths can join.  If we don't
	 capture the values on the non-iblined path we could access stale values.  So for all stack entries that
	 would be spilled along the non-inlined path, assign them to registers, or spill if none are available."
	argIsInt
		ifTrue:
			[rcvrReg := self allocateRegForStackEntryAt: 1.
			 (self ssValue: 1) popToReg: rcvrReg.
			 self MoveR: rcvrReg R: TempReg.
			 regMask := self registerMaskFor: rcvrReg]
		ifFalse:
			[self allocateRegForStackTopTwoEntriesInto: [:rTop :rNext| argReg := rTop. rcvrReg := rNext].
			 self ssTop popToReg: argReg.
			 (self ssValue: 1) popToReg: rcvrReg.
			 self MoveR: argReg R: TempReg.
			 regMask := self registerMaskFor: rcvrReg and: argReg].
	self ssPop: 2.
	self captureUnspilledSpillsForSpecialSelectorSend: regMask.
	jumpNotSmallInts := (argIsInt or: [rcvrIsInt])
							ifTrue: [objectRepresentation genJumpNotSmallIntegerInScratchReg: TempReg]
							ifFalse: [objectRepresentation genJumpNotSmallIntegersIn: rcvrReg andScratch: TempReg scratch: ClassReg].
	primDescriptor opcode caseOf: {
		[AddRR] -> [argIsInt
						ifTrue:
							[self AddCq: argInt - ConstZero R: rcvrReg.
							 jumpContinue := self JumpNoOverflow: 0.
							 "overflow; must undo the damage before continuing"
							 self SubCq: argInt - ConstZero R: rcvrReg]
						ifFalse:
							[objectRepresentation genRemoveSmallIntegerTagsInScratchReg: rcvrReg.
							 self AddR: argReg R: rcvrReg.
							jumpContinue := self JumpNoOverflow: 0.
							"overflow; must undo the damage before continuing"
							 rcvrIsInt
								ifTrue: [self MoveCq: rcvrInt R: rcvrReg]
								ifFalse:
									[self SubR: argReg R: rcvrReg.
									 objectRepresentation genSetSmallIntegerTagsIn: rcvrReg]]].
		[SubRR] -> [argIsInt
						ifTrue:
							[self SubCq: argInt - ConstZero R: rcvrReg.
							 jumpContinue := self JumpNoOverflow: 0.
							 "overflow; must undo the damage before continuing"
							 self AddCq: argInt - ConstZero R: rcvrReg]
						ifFalse:
							[objectRepresentation genRemoveSmallIntegerTagsInScratchReg: argReg.
							 self SubR: argReg R: rcvrReg.
							 jumpContinue := self JumpNoOverflow: 0.
							 "overflow; must undo the damage before continuing"
							 self AddR: argReg R: rcvrReg.
							 objectRepresentation genSetSmallIntegerTagsIn: argReg]].
		[AndRR] -> [argIsInt
						ifTrue: [self AndCq: argInt R: rcvrReg]
						ifFalse: [self AndR: argReg R: rcvrReg].
					jumpContinue := self Jump: 0].
		[OrRR]	-> [argIsInt
						ifTrue: [self OrCq: argInt R: rcvrReg]
						ifFalse: [self OrR: argReg R: rcvrReg].
					jumpContinue := self Jump: 0] }.
	jumpNotSmallInts jmpTarget: self Label.
	self ssPushRegister: rcvrReg.
	self copySimStackToScratch: (simSpillBase min: simStackPtr - 1).
	self ssPop: 1.
	self ssFlushTo: simStackPtr.
	self deny: rcvrReg = Arg0Reg.
	argIsInt
		ifTrue: [self MoveCq: argInt R: Arg0Reg]
		ifFalse: [argReg ~= Arg0Reg ifTrue: [self MoveR: argReg R: Arg0Reg]].
	rcvrReg ~= ReceiverResultReg ifTrue: [self MoveR: rcvrReg R: ReceiverResultReg].
	index := byte0 - self firstSpecialSelectorBytecodeOffset.
	self genMarshalledSend: index negated - 1 numArgs: 1 sendTable: ordinarySendTrampolines.
	self reconcileRegisterStateForJoinAfterSpecialSelectorSend.
	jumpContinue jmpTarget: self Label.
	^0