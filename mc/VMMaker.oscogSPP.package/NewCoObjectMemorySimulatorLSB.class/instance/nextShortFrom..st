initialization
nextShortFrom: aStream
	"Read a 16-bit quantity from the given (binary) stream."
	^aStream nextLittleEndianNumber: 2