initialization
computeFullBlockEntryOffsets
	"Generate the entry code for a method to determine cmEntryOffset and cmNoCheckEntryOffset.  We
	 need cmNoCheckEntryOffset up front to be able to generate the map starting from cmNoCheckEntryOffset"
	"stack allocate the various collections so that they
	 are effectively garbage collected on return."
	<var: 'sendMissCall' type: #'AbstractInstruction *'>
	self allocateOpcodes: 24 bytecodes: 0.
	methodOrBlockNumArgs := 0.
	self compileFullBlockEntry.
	self computeMaximumSizes.
	self generateInstructionsAt: methodZoneBase + (self sizeof: CogMethod).
	cbEntryOffset := fullBlockEntry address - methodZoneBase.
	cbNoSwitchEntryOffset := fullBlockNoContextSwitchEntry address - methodZoneBase