compaction
updatePointersInMobileObjectsWithTop: initialTop
	"Sweep the mobile portion of the heap, updating all references to objects to their eventual locations.
	 Remember to update the savedFirstFields of pointer objects, as these have been forwarded.
	 This enumeration matches that in planCompactSavingForwarders and copyAndUnmarkMobileObjects."

	| toFinger top previousPin |
	toFinger := manager startOfObject: firstFreeObject.
	top := initialTop.
	self deny: (manager isMarked: firstFreeObject).
	manager allOldSpaceEntitiesFrom: firstFreeObject do:
		[:o|
		 self assert: (previousPin isNil or: [toFinger < previousPin]).
		 (manager isMarked: o) ifTrue:
			[(manager isPinned: o)
				ifTrue: "The empty gaps between two adjacent pinned objects (when not filled below) are freed."
					[self updatePointersIn: o.
					 previousPin ifNotNil:
						[toFinger := manager addressAfter: previousPin].
					 previousPin := o]
				ifFalse:
					[| availableSpace bytes next |
					 (top := top + manager bytesPerOop) >= savedFirstFieldsSpace limit ifTrue:
						[^false].
					 [previousPin notNil
					  and: [availableSpace := (manager startOfObject: previousPin) - toFinger.
							bytes := manager bytesInObject: o.
							bytes ~= availableSpace
							 and: [bytes + (2 * manager allocationUnit) < availableSpace]]] whileTrue:
						["The object does not fit in the space between toFinger and previousPin.
						  Move toFinger beyond previousPin and update previousPin appropriately."
						 toFinger := manager addressAfter: previousPin.
						 next := manager objectStartingAt: toFinger.
						 next >= o ifTrue:
							[^self continueUpdatePointersInMobileObjectsFrom: next withTop: top].
						 previousPin := (manager isPinned: next) ifTrue: [next]].
					 self updatePointersIn: o savedFirstFieldPointer: top.
					 toFinger := toFinger + (manager bytesInObject: o)]]].
	^true