compaction
updatePointers
	"Sweep the heap, updating all objects to their eventual locations.
	 Remember to update the savedFirstFields of pointer objects, as these have been forwarded."
	| onePass |
	self logPhase: 'updating pointers...'.
	"If savedFirstFieldsSpace is empty there is nothing to do."
	savedFirstFieldsSpace top < savedFirstFieldsSpace start ifTrue:
		[^self].
	coInterpreter mapInterpreterOops.
	self updatePointersInManagerHeapEntities.
	self updatePointersInSurvivingObjects.
	self updatePointersInInitialImmobileObjects.
	onePass := self updatePointersInMobileObjectsWithTop: savedFirstFieldsSpace start - manager bytesPerOop.
	onePass ifFalse:
		[self updatePointersInObjectsOverflowingSavedFirstFieldsSpace]