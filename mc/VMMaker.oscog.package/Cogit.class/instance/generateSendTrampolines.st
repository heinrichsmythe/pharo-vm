initialization
generateSendTrampolines
	0 to: NumSendTrampolines - 1 do:
		[:numArgs|
		ordinarySendTrampolines
			at: numArgs
			put: (self genTrampolineFor: #ceSend:super:to:numArgs:
					  called: (self trampolineName: 'ceSend' numArgs: numArgs)
					  arg: ClassReg
					  arg: 0
					  arg: ReceiverResultReg
					  arg: (self numArgsOrSendNumArgsReg: numArgs))].

	"Generate these in the middle so they are within [firstSend, lastSend]."
	self cppIf: NewspeakVM ifTrue: [self generateNewspeakSendTrampolines].
	self cppIf: BytecodeSetHasDirectedSuperSend ifTrue:
		[0 to: NumSendTrampolines - 1 do:
			[:numArgs|
			directedSuperSendTrampolines
				at: numArgs
				put: (self genTrampolineFor: #ceSend:above:to:numArgs:
						  called: (self trampolineName: 'ceDirectedSuperSend' numArgs: numArgs)
						  arg: ClassReg
						  arg: TempReg
						  arg: ReceiverResultReg
						  arg: (self numArgsOrSendNumArgsReg: numArgs))]].

	0 to: NumSendTrampolines - 1 do:
		[:numArgs|
		superSendTrampolines
			at: numArgs
			put: (self genTrampolineFor: #ceSend:super:to:numArgs:
					  called: (self trampolineName: 'ceSuperSend' numArgs: numArgs)
					  arg: ClassReg
					  arg: 1
					  arg: ReceiverResultReg
					  arg: (self numArgsOrSendNumArgsReg: numArgs))].
	firstSend := ordinarySendTrampolines at: 0.
	lastSend := superSendTrampolines at: NumSendTrampolines - 1