"
FFI declaration of a zmq_msg_t. This is the format used to transmit messages.
Don't access directly a message through this Class.


OFFSET__ UChar64: <anFFIUInt8>
"
Class {
	#name : #'ZMQ_msg_t',
	#superclass : #FFIExternalStructure,
	#classVars : [
		'OFFSET__',
		'UChar64'
	],
	#category : #'ZMQ-Core'
}

{ #category : #fields }
ZMQ_msg_t class >> fieldsDesc [
" self rebuildFieldAccessors "
^#(
	 UChar64 _;
	)
]

{ #category : #'class initialization' }
ZMQ_msg_t class >> initialize [ 
	UChar64 := FFITypeArray ofType: 'uchar' size: 64.

]

{ #category : #'accessing structure variables' }
ZMQ_msg_t >> _ [
	"This method was automatically generated"
	^(FFITypeArray ofType: #FFIUInt8 size: 64) fromHandle: (handle copyFrom: OFFSET__ to: OFFSET__ + 63)
]

{ #category : #'accessing structure variables' }
ZMQ_msg_t >> _: anObject [
	"This method was automatically generated"
	handle replaceFrom: OFFSET__ to: OFFSET__ + 63 with: anObject getHandle startingAt: 1
]
