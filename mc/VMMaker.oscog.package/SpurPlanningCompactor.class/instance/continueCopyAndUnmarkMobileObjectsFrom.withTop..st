compaction
continueCopyAndUnmarkMobileObjectsFrom: anUnpinnedEntity withTop: top
	"copyAndUnmarkMobileObjects has encountered a run of pinned objects around which
	 it cannot compact, but savedFirstFieldsSpace is still not full.  Continue the pass with a
	 new firstFreeObject, resetting it before continuing.
	 Answer if the end of the heap was reached (savedFirstFieldsSpace has not overflowed)."
	| result savedFirstFreeObject savedFirstMobileObject nextFreeObject |
	self assert: (self oop: anUnpinnedEntity isLessThan: manager endOfMemory).
	self deny: (manager isPinned: anUnpinnedEntity).
	savedFirstFreeObject := firstFreeObject.
	savedFirstMobileObject := firstMobileObject.
	nextFreeObject := self scanForFirstFreeAndFirstMobileObjectFrom: anUnpinnedEntity.
	firstMobileObject := savedFirstMobileObject.
	nextFreeObject ifNil:
		[^true].
	firstFreeObject := nextFreeObject.
	result := self copyAndUnmarkMobileObjectsWithTop: top.
	firstFreeObject := savedFirstFreeObject.
	^result