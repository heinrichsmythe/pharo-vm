generate machine code
concretizeSubRR
	"Will get inlined into concretizeAt: switch."
	<inline: true>
	| regLHS regRHS |
	regLHS := self concreteRegister: (operands at: 0).
	regRHS := self concreteRegister: (operands at: 1).
	machineCode
		at: 0 put: (self rexR: regRHS x: 0 b: regLHS);
		at: 1 put: 16r2b;
		at: 2 put: (self mod: ModReg RM: regLHS RO: regRHS).
	^machineCodeSize := 3