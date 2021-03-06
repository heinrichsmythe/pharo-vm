system primitives
primitiveGetIndMenuWithCommandID: menuHandleOop commandID: aCommandID
	<var: #menuHandle type: #MenuHandle>
	<var: #commandID type: #MenuCommand>
	<var: #applicationMenu type: #MenuHandle>
	<var: #outIndex type: #MenuItemIndex>
	| menuHandle commandID applicationMenu outIndex |
	self primitive: 'primitiveGetIndMenuWithCommandID'
		parameters: #(Oop Oop).
	menuHandle := self cCoerce: (interpreterProxy positiveMachineIntegerValueOf: menuHandleOop) to: 'MenuHandle'.
	commandID := self cCoerce: (interpreterProxy positive32BitValueOf: aCommandID) to: 'MenuCommand'.
	(self ioCheckMenuHandle: menuHandle) ifFalse: [^interpreterProxy success: false].
	self cppIf: #'TARGET_API_MAC_CARBON'
		ifTrue: [self cCode: 'GetIndMenuItemWithCommandID(menuHandle, kHICommandHide, 1,
                   &applicationMenu, &outIndex);' inSmalltalk: [menuHandle]].
	outIndex asSmallIntegerObj. "to avoid elimination of the variable..."
	^interpreterProxy positiveMachineIntegerFor: (self cCoerce: applicationMenu to: #'usqIntptr_t')

