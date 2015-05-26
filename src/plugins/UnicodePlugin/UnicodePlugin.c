/* Automatically generated by
	VMPluginCodeGenerator VMMaker.oscog-eem.1325 uuid: a0bb0f7f-5e6e-48a7-bf73-fa5d135e06c0
   from
	UnicodePlugin VMMaker.oscog-eem.1325 uuid: a0bb0f7f-5e6e-48a7-bf73-fa5d135e06c0
 */
static char __buildInfo[] = "UnicodePlugin VMMaker.oscog-eem.1325 uuid: a0bb0f7f-5e6e-48a7-bf73-fa5d135e06c0 " __DATE__ ;



#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

/* Default EXPORT macro that does nothing (see comment in sq.h): */
#define EXPORT(returnType) returnType

/* Do not include the entire sq.h file but just those parts needed. */
/*  The virtual machine proxy definition */
#include "sqVirtualMachine.h"
/* Configuration options */
#include "sqConfig.h"
/* Platform specific definitions */
#include "sqPlatformSpecific.h"

#define true 1
#define false 0
#define null 0  /* using 'null' because nil is predefined in Think C */
#ifdef SQUEAK_BUILTIN_PLUGIN
#undef EXPORT
// was #undef EXPORT(returnType) but screws NorCroft cc
#define EXPORT(returnType) static returnType
#endif

#include "UnicodePlugin.h"
#include "sqMemoryAccess.h"


/*** Constants ***/


/*** Function Prototypes ***/
static char * asCString(sqInt stringOop);
static sqInt copyStringintomax(sqInt stringOop, char *stringPtr, sqInt maxChars);
static void * cWordsPtrminSize(sqInt oop, sqInt minSize);
EXPORT(const char*) getModuleName(void);
EXPORT(sqInt) primitiveClipboardGet(void);
EXPORT(sqInt) primitiveClipboardPut(void);
EXPORT(sqInt) primitiveClipboardSize(void);
EXPORT(sqInt) primitiveDrawString(void);
EXPORT(sqInt) primitiveGetFontList(void);
EXPORT(sqInt) primitiveGetXRanges(void);
EXPORT(sqInt) primitiveMeasureString(void);
EXPORT(sqInt) primitiveSetColors(void);
EXPORT(sqInt) primitiveSetFont(void);
EXPORT(sqInt) setInterpreter(struct VirtualMachine*anInterpreter);


/*** Variables ***/

#if !defined(SQUEAK_BUILTIN_PLUGIN)
static sqInt (*booleanValueOf)(sqInt obj);
static sqInt (*failed)(void);
static void * (*firstIndexableField)(sqInt oop);
static sqInt (*integerObjectOf)(sqInt value);
static sqInt (*isBytes)(sqInt oop);
static sqInt (*isWords)(sqInt oop);
static sqInt (*makePointwithxValueyValue)(sqInt xValue, sqInt yValue);
static sqInt (*pop)(sqInt nItems);
static sqInt (*popthenPush)(sqInt nItems, sqInt oop);
static sqInt (*stSizeOf)(sqInt oop);
static sqInt (*stackIntegerValue)(sqInt offset);
static sqInt (*stackValue)(sqInt offset);
static sqInt (*success)(sqInt aBoolean);
#else /* !defined(SQUEAK_BUILTIN_PLUGIN) */
extern sqInt booleanValueOf(sqInt obj);
extern sqInt failed(void);
extern void * firstIndexableField(sqInt oop);
extern sqInt integerObjectOf(sqInt value);
extern sqInt isBytes(sqInt oop);
extern sqInt isWords(sqInt oop);
extern sqInt makePointwithxValueyValue(sqInt xValue, sqInt yValue);
extern sqInt pop(sqInt nItems);
extern sqInt popthenPush(sqInt nItems, sqInt oop);
extern sqInt stSizeOf(sqInt oop);
extern sqInt stackIntegerValue(sqInt offset);
extern sqInt stackValue(sqInt offset);
extern sqInt success(sqInt aBoolean);
extern
#endif
struct VirtualMachine* interpreterProxy;
static const char *moduleName =
#ifdef SQUEAK_BUILTIN_PLUGIN
	"UnicodePlugin VMMaker.oscog-eem.1325 (i)"
#else
	"UnicodePlugin VMMaker.oscog-eem.1325 (e)"
#endif
;



/*	Return a C char * pointer into the given Squeak string object. */
/*	Warning: A Squeak string is not necessarily null-terminated. */
/*	Warning: the resulting pointer may become invalid after the next garbage
	collection and should only be using during the current primitive call.
 */

	/* UnicodePlugin>>#asCString: */
static char *
asCString(sqInt stringOop)
{
	success(isBytes(stringOop));
	return (failed()
		? 0
		: ((char *) (firstIndexableField(stringOop))));
}


/*	Copy the Squeak string into a temporary buffer and add a terminating null
	byte. Fail if there is not sufficent space in the buffer.
 */

	/* UnicodePlugin>>#copyString:into:max: */
static sqInt
copyStringintomax(sqInt stringOop, char *stringPtr, sqInt maxChars)
{
    sqInt count;
    sqInt i;
    char *srcPtr;

	if (!((isBytes(stringOop))
		 && (((count = stSizeOf(stringOop))) < maxChars))) {
		success(0);
		return 0;
	}
	srcPtr = ((char *) (firstIndexableField(stringOop)));
	for (i = 1; i <= count; i += 1) {
		*stringPtr++ = *srcPtr++;
	}
	*stringPtr = 0;
	return 0;
}


/*	Return a C pointer to the first indexable field of oop, which must be a
	words object of at least the given size.
 */
/*	Warning: the resulting pointer may become invalid after the next garbage
	collection and should only be using during the current primitive call.
 */

	/* UnicodePlugin>>#cWordsPtr:minSize: */
static void *
cWordsPtrminSize(sqInt oop, sqInt minSize)
{
	success((isWords(oop))
	 && ((stSizeOf(oop)) >= minSize));
	return (failed()
		? 0
		: ((void *) (firstIndexableField(oop))));
}


/*	Note: This is hardcoded so it can be run from Squeak.
	The module name is used for validating a module *after*
	it is loaded to check if it does really contain the module
	we're thinking it contains. This is important! */

	/* InterpreterPlugin>>#getModuleName */
EXPORT(const char*)
getModuleName(void)
{
	return moduleName;
}


/*	Read the clipboard into the given UTF16 string.. */

	/* UnicodePlugin>>#primitiveClipboardGet */
EXPORT(sqInt)
primitiveClipboardGet(void)
{
    sqInt count;
    unsigned short *utf16;
    sqInt utf16Length;
    sqInt utf16Oop;

	utf16Oop = stackValue(0);
	success(isWords(utf16Oop));
	if (failed()) {
		return 0;
	}
	utf16 = ((unsigned short *) (firstIndexableField(utf16Oop)));
	utf16Length = 2 * (stSizeOf(utf16Oop));
	count = unicodeClipboardGet(utf16, utf16Length);
	popthenPush(2, integerObjectOf(count));
	return 0;
}


/*	Set the clipboard to a UTF16 string.. */

	/* UnicodePlugin>>#primitiveClipboardPut */
EXPORT(sqInt)
primitiveClipboardPut(void)
{
    sqInt count;
    sqInt strOop;
    unsigned short *utf16;
    sqInt utf16Length;

	strOop = stackValue(1);
	count = stackIntegerValue(0);
	success(isWords(strOop));
	if (failed()) {
		return 0;
	}
	utf16 = ((unsigned short *) (firstIndexableField(strOop)));
	utf16Length = 2 * (stSizeOf(strOop));
	if ((count >= 0) && (count < utf16Length)) {
		utf16Length = count;
	}
	unicodeClipboardPut(utf16, utf16Length);
	pop(2);
	return 0;
}

	/* UnicodePlugin>>#primitiveClipboardSize */
EXPORT(sqInt)
primitiveClipboardSize(void)
{
    sqInt count;

	count = unicodeClipboardSize();
	popthenPush(1, integerObjectOf(count));
	return 0;
}

	/* UnicodePlugin>>#primitiveDrawString */
EXPORT(sqInt)
primitiveDrawString(void)
{
    sqInt bitmapOop;
    void *bitmapPtr;
    sqInt h;
    sqInt result;
    char *utf8;
    sqInt utf8Length;
    sqInt utf8Oop;
    sqInt w;

	utf8Oop = stackValue(3);
	/* begin asCString: */
	success(isBytes(utf8Oop));
	utf8 = (failed()
		? 0
		: ((char *) (firstIndexableField(utf8Oop))));
	w = stackIntegerValue(2);
	h = stackIntegerValue(1);
	bitmapOop = stackValue(0);
	/* begin cWordsPtr:minSize: */
	success((isWords(bitmapOop))
	 && ((stSizeOf(bitmapOop)) >= (w * h)));
	bitmapPtr = (failed()
		? 0
		: ((void *) (firstIndexableField(bitmapOop))));
	if (failed()) {
		return null;
	}
	utf8Length = stSizeOf(utf8Oop);
	unicodeDrawString(utf8, utf8Length, &w, &h, bitmapPtr);
	result = makePointwithxValueyValue(w, h);
	popthenPush(5, result);
	return 0;
}

	/* UnicodePlugin>>#primitiveGetFontList */
EXPORT(sqInt)
primitiveGetFontList(void)
{
    sqInt count;
    char *str;
    sqInt strLength;
    sqInt strOop;

	strOop = stackValue(0);
	/* begin asCString: */
	success(isBytes(strOop));
	str = (failed()
		? 0
		: ((char *) (firstIndexableField(strOop))));
	if (failed()) {
		return null;
	}
	strLength = stSizeOf(strOop);
	count = unicodeGetFontList(str, strLength);
	popthenPush(2, integerObjectOf(count));
	return 0;
}

	/* UnicodePlugin>>#primitiveGetXRanges */
EXPORT(sqInt)
primitiveGetXRanges(void)
{
    sqInt count;
    sqInt resultLength;
    sqInt resultOop;
    int *resultPtr;
    char *utf8;
    sqInt utf8Length;
    sqInt utf8Oop;

	utf8Oop = stackValue(1);
	/* begin asCString: */
	success(isBytes(utf8Oop));
	utf8 = (failed()
		? 0
		: ((char *) (firstIndexableField(utf8Oop))));
	resultOop = stackValue(0);
	/* begin cWordsPtr:minSize: */
	success((isWords(resultOop))
	 && ((stSizeOf(resultOop)) >= 0));
	resultPtr = ((void *) ((failed()
	? 0
	: ((void *) (firstIndexableField(resultOop))))));
	if (failed()) {
		return null;
	}
	utf8Length = stSizeOf(utf8Oop);
	resultLength = stSizeOf(resultOop);
	count = unicodeGetXRanges(utf8, utf8Length, resultPtr, resultLength);
	popthenPush(3, integerObjectOf(count));
	return 0;
}

	/* UnicodePlugin>>#primitiveMeasureString */
EXPORT(sqInt)
primitiveMeasureString(void)
{
    sqInt h;
    sqInt result;
    char *utf8;
    sqInt utf8Length;
    sqInt utf8Oop;
    sqInt w;

	utf8Oop = stackValue(0);
	/* begin asCString: */
	success(isBytes(utf8Oop));
	utf8 = (failed()
		? 0
		: ((char *) (firstIndexableField(utf8Oop))));
	if (failed()) {
		return null;
	}
	w = (h = 0);
	utf8Length = stSizeOf(utf8Oop);
	unicodeMeasureString(utf8, utf8Length, &w, &h);
	result = makePointwithxValueyValue(w, h);
	popthenPush(2, result);
	return 0;
}

	/* UnicodePlugin>>#primitiveSetColors */
EXPORT(sqInt)
primitiveSetColors(void)
{
    sqInt bgBlue;
    sqInt bgGreen;
    sqInt bgRed;
    sqInt fgBlue;
    sqInt fgGreen;
    sqInt fgRed;
    sqInt mapBGToTransparent;

	fgRed = stackIntegerValue(6);
	fgGreen = stackIntegerValue(5);
	fgBlue = stackIntegerValue(4);
	bgRed = stackIntegerValue(3);
	bgGreen = stackIntegerValue(2);
	bgBlue = stackIntegerValue(1);
	mapBGToTransparent = booleanValueOf(stackValue(0));
	if (failed()) {
		return null;
	}
	unicodeSetColors(fgRed, fgGreen, fgBlue, bgRed, bgGreen, bgBlue, mapBGToTransparent);
	pop(7);
	return 0;
}

	/* UnicodePlugin>>#primitiveSetFont */
EXPORT(sqInt)
primitiveSetFont(void)
{
    sqInt antiAliasFlag;
    sqInt boldFlag;
    char fontName[200];
    sqInt fontSize;
    sqInt italicFlag;

	copyStringintomax(stackValue(4), fontName, 200);
	fontSize = stackIntegerValue(3);
	boldFlag = booleanValueOf(stackValue(2));
	italicFlag = booleanValueOf(stackValue(1));
	antiAliasFlag = booleanValueOf(stackValue(0));
	if (failed()) {
		return null;
	}
	unicodeSetFont(fontName, fontSize, boldFlag, italicFlag, antiAliasFlag);
	pop(5);
	return 0;
}


/*	Note: This is coded so that it can be run in Squeak. */

	/* InterpreterPlugin>>#setInterpreter: */
EXPORT(sqInt)
setInterpreter(struct VirtualMachine*anInterpreter)
{
    sqInt ok;

	interpreterProxy = anInterpreter;
	ok = ((interpreterProxy->majorVersion()) == (VM_PROXY_MAJOR))
	 && ((interpreterProxy->minorVersion()) >= (VM_PROXY_MINOR));
	if (ok) {
		
#if !defined(SQUEAK_BUILTIN_PLUGIN)
		booleanValueOf = interpreterProxy->booleanValueOf;
		failed = interpreterProxy->failed;
		firstIndexableField = interpreterProxy->firstIndexableField;
		integerObjectOf = interpreterProxy->integerObjectOf;
		isBytes = interpreterProxy->isBytes;
		isWords = interpreterProxy->isWords;
		makePointwithxValueyValue = interpreterProxy->makePointwithxValueyValue;
		pop = interpreterProxy->pop;
		popthenPush = interpreterProxy->popthenPush;
		stSizeOf = interpreterProxy->stSizeOf;
		stackIntegerValue = interpreterProxy->stackIntegerValue;
		stackValue = interpreterProxy->stackValue;
		success = interpreterProxy->success;
#endif /* !defined(SQUEAK_BUILTIN_PLUGIN) */
	}
	return ok;
}


#ifdef SQUEAK_BUILTIN_PLUGIN

void* UnicodePlugin_exports[][3] = {
	{"UnicodePlugin", "getModuleName", (void*)getModuleName},
	{"UnicodePlugin", "primitiveClipboardGet\000\000", (void*)primitiveClipboardGet},
	{"UnicodePlugin", "primitiveClipboardPut\000\000", (void*)primitiveClipboardPut},
	{"UnicodePlugin", "primitiveClipboardSize\000\377", (void*)primitiveClipboardSize},
	{"UnicodePlugin", "primitiveDrawString\000\000", (void*)primitiveDrawString},
	{"UnicodePlugin", "primitiveGetFontList\000\000", (void*)primitiveGetFontList},
	{"UnicodePlugin", "primitiveGetXRanges\000\000", (void*)primitiveGetXRanges},
	{"UnicodePlugin", "primitiveMeasureString\000\000", (void*)primitiveMeasureString},
	{"UnicodePlugin", "primitiveSetColors\000\000", (void*)primitiveSetColors},
	{"UnicodePlugin", "primitiveSetFont\000\000", (void*)primitiveSetFont},
	{"UnicodePlugin", "setInterpreter", (void*)setInterpreter},
	{NULL, NULL, NULL}
};

#else /* ifdef SQ_BUILTIN_PLUGIN */

signed char primitiveClipboardGetAccessorDepth = 0;
signed char primitiveClipboardPutAccessorDepth = 0;
signed char primitiveDrawStringAccessorDepth = 0;
signed char primitiveGetFontListAccessorDepth = 0;
signed char primitiveGetXRangesAccessorDepth = 0;
signed char primitiveMeasureStringAccessorDepth = 0;
signed char primitiveSetColorsAccessorDepth = 0;
signed char primitiveSetFontAccessorDepth = 0;

#endif /* ifdef SQ_BUILTIN_PLUGIN */