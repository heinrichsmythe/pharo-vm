bytecode generator support
nextDescriptorExtensionsAndNextPCInto: aQuaternaryBlock
	"Peek ahead and deliver the next descriptor, extension bytes and next pc."
	<inline: true>
	| savedB0 savedB1 savedB2 savedB3 savedEA savedEB savedNEB descriptor bcpc |
	<var: #descriptor type: #'BytecodeDescriptor *'>
	descriptor := self generatorAt: byte0.
	savedB0 := byte0. savedB1 := byte1. savedB2 := byte2. savedB3 := byte3.
	savedEA := extA. savedEB := extB. savedNEB := numExtB.
	bcpc := bytecodePC + descriptor numBytes.
	[bcpc > endPC ifTrue:
		[^aQuaternaryBlock value: nil value: 0 value: 0 value: 0].
	 byte0 := (objectMemory fetchByte: bcpc ofObject: methodObj)  + bytecodeSetOffset.
	 descriptor := self generatorAt: byte0.
	 self loadSubsequentBytesForDescriptor: descriptor at: bcpc.
	 descriptor isExtension ifFalse:
		[| eA eB |
		 eA := extA. eB := extB.
		 extA := savedEA. extB := savedEB. numExtB := savedNEB.
		 byte0 := savedB0. byte1 := savedB1. byte2 := savedB2. byte3 := savedB3.
	 	 ^aQuaternaryBlock value: descriptor value: eA value: eB value: bcpc].
	 self perform: descriptor generator.
	 bcpc := bcpc + descriptor numBytes.
	 true] whileTrue