inline primitive generators generated code
genLowcodeZeroExtend64From16
	<option: #LowcodeVM>
	<inline: true>
	"Generated by the Lowcode instruction generator."
	| valueHigh value valueLow |
	BytesPerWord = 4 ifTrue: [
		self allocateRegistersForLowcodeInteger2: [:valueLowValue :valueHighValue |
			valueLow := valueLowValue.
			valueHigh := valueHighValue.
		].

		self ssNativeTop nativePopToReg: valueLow secondReg: valueHigh.
		self ssNativePop: 1.

		self ZeroExtend16R: valueLow R: valueLow.
		self MoveCq: 0 R: valueHigh.
		self ssPushNativeRegister: valueLow secondRegister: valueHigh.

	] ifFalse: [
		self allocateRegistersForLowcodeInteger: [:valueValue |
			value := valueValue.
		].

		self ssNativeTop nativePopToReg: value.
		self ssNativePop: 1.

		self ZeroExtend16R: value R: value.
		self ssPushNativeRegister: value.

	].
	^ 0

