directory primitives
makeDirEntryName: entryName size: entryNameSize createDate: createDate modDate: modifiedDate isDir: dirFlag fileSize: fileSize posixPermissions: posixPermissions isSymlink: symlinkFlag
	<var: 'entryName' type: #'char *'>
	<var: 'fileSize' type: #squeakFileOffsetType>
	<option: #PharoVM>
	| modDateOop createDateOop nameString results stringPtr posixPermissionsOop fileSizeOop |
	<var: 'stringPtr' type: #'char *'>

	"allocate storage for results, remapping newly allocated
	 oops if required in case GC happens during allocation"
	results := interpreterProxy instantiateClass: interpreterProxy classArray indexableSize: 7.
	self remapOop: results in:
		[nameString := interpreterProxy instantiateClass: interpreterProxy classString indexableSize: entryNameSize.
		 self remapOop: nameString in:
			[createDateOop := interpreterProxy positive32BitIntegerFor: createDate.
			 self remapOop: createDateOop in:
				[modDateOop := interpreterProxy positive32BitIntegerFor: modifiedDate.
				 self remapOop: modDateOop in:
					[fileSizeOop := interpreterProxy positive64BitIntegerFor: fileSize.
					 self remapOop: fileSizeOop in:
						[posixPermissionsOop := interpreterProxy positive32BitIntegerFor: posixPermissions]]]]].

	"copy name into Smalltalk string"
	stringPtr := interpreterProxy firstIndexableField: nameString.
	0 to: entryNameSize - 1 do:
		[ :i |
		self cCode: [stringPtr at: i put: (entryName at: i)]
			inSmalltalk: [interpreterProxy storeByte: i ofObject: nameString withValue: (entryName at: i+1) asciiValue]].

	interpreterProxy
		storePointer: 0 ofObject: results withValue: nameString;
		storePointer: 1 ofObject: results withValue: createDateOop;
		storePointer: 2 ofObject: results withValue: modDateOop;
		storePointer: 3 ofObject: results withValue: (dirFlag
														ifTrue: [interpreterProxy trueObject]
														ifFalse: [interpreterProxy falseObject]);
		storePointer: 4 ofObject: results withValue: fileSizeOop;
		storePointer: 5 ofObject: results withValue: posixPermissionsOop;
		storePointer: 6 ofObject: results withValue: (symlinkFlag
														ifTrue: [interpreterProxy trueObject]
														ifFalse: [interpreterProxy falseObject]).
	^results