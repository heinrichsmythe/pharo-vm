directory primitives
makeDirEntryName: entryName size: entryNameSize createDate: createDate modDate: modifiedDate isDir: dirFlag fileSize: fileSize posixPermissions: posixPermissions isSymlink: symlinkFlag
	<var: 'entryName' type: 'char *'>
	<var: 'fileSize' type: 'squeakFileOffsetType '>
	<option: #PharoVM>

	| modDateOop createDateOop nameString results stringPtr posixPermissionsOop fileSizeOop |
	<var: 'stringPtr' type: 'char *'>

	"allocate storage for results, remapping newly allocated
	 oops in case GC happens during allocation"
	interpreterProxy pushRemappableOop:
		(interpreterProxy instantiateClass: (interpreterProxy classArray) indexableSize: 7).
	interpreterProxy pushRemappableOop:
		(interpreterProxy instantiateClass: (interpreterProxy classString) indexableSize: entryNameSize).
	interpreterProxy pushRemappableOop: 
		(interpreterProxy positive32BitIntegerFor: createDate).
	interpreterProxy pushRemappableOop: 
		(interpreterProxy positive32BitIntegerFor: modifiedDate).
	interpreterProxy pushRemappableOop:
		(interpreterProxy positive64BitIntegerFor: fileSize).
	interpreterProxy pushRemappableOop: 
		(interpreterProxy positive32BitIntegerFor: posixPermissions).

	posixPermissionsOop := interpreterProxy popRemappableOop.
	fileSizeOop := interpreterProxy popRemappableOop.
	modDateOop := interpreterProxy popRemappableOop.
	createDateOop := interpreterProxy popRemappableOop.
	nameString  := interpreterProxy popRemappableOop.
	results := interpreterProxy popRemappableOop.

	"copy name into Smalltalk string"
	stringPtr := interpreterProxy firstIndexableField: nameString.
	0 to: entryNameSize - 1 do: [ :i |
		stringPtr at: i put: (entryName at: i).
	].

	interpreterProxy storePointer: 0 ofObject: results withValue: nameString.
	interpreterProxy storePointer: 1 ofObject: results withValue: createDateOop.
	interpreterProxy storePointer: 2 ofObject: results withValue: modDateOop.
	dirFlag
		ifTrue: [ interpreterProxy storePointer: 3 ofObject: results withValue: interpreterProxy trueObject ]
		ifFalse: [ interpreterProxy storePointer: 3 ofObject: results withValue: interpreterProxy falseObject ].
	interpreterProxy storePointer: 4 ofObject: results withValue: fileSizeOop.
	interpreterProxy storePointer: 5 ofObject: results withValue: posixPermissionsOop.
	symlinkFlag
		ifTrue: [ interpreterProxy storePointer:  6 ofObject: results withValue: interpreterProxy trueObject ]
		ifFalse: [ interpreterProxy storePointer: 6 ofObject: results withValue: interpreterProxy falseObject ].
	^ results