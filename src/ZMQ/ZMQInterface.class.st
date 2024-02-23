"
ZMQ Interface is used by ZMQSocket as a bridge to ZMQLibraryInterface wich contains the FFI calls to ZMQ lib.


"
Class {
	#name : #ZMQInterface,
	#superclass : #Object,
	#classVars : [
		'default'
	],
	#pools : [
		'ZMQConstants'
	],
	#category : #'ZMQ-Core'
}

{ #category : #'instance creation' }
ZMQInterface class >> default [

	default ifNil: [ default := self new ].
	^ default
]

{ #category : #'api - context' }
ZMQInterface >> ctxDestroy: aContextPointer [

	^[ZMQLibraryInterface zmq_term: aContextPointer] on: Error
		do: [self error: 'ZMQ context destruction error']
]

{ #category : #'api - context' }
ZMQInterface >> ctxInit: intIoThreads [

	^[ZMQLibraryInterface zmq_init: intIoThreads] on: Error 
		do: [self error: 'ZMQ context creation error']
]

{ #category : #'api - socket' }
ZMQInterface >> socket: aSocketPtr bind: anURLString [

	^[ZMQLibraryInterface zmq_bind: aSocketPtr with: anURLString]
		on: Error
		do: [self error: 'ZMQ socket bind(',anURLString,') error']
]

{ #category : #'api - socket' }
ZMQInterface >> socket: aSocketPtr connect: anURLString [

	^[ZMQLibraryInterface zmq_connect: aSocketPtr with: anURLString]
		on: Error
		do: [self error: 'ZMQ socket connect(',anURLString,') error']
]

{ #category : #'api - socket' }
ZMQInterface >> socket: aSocketPtr disconnect: anURLString [

	^[ZMQLibraryInterface zmq_disconnect: aSocketPtr with: anURLString]
		on: Error
		do: [self error: 'ZMQ socket disconnect(',anURLString,') error']
]

{ #category : #'api - socket - options deprecated' }
ZMQInterface >> socket: aSocketPtr getOption: anOptionKey [

	| aBuffer aSize |
	aSize := FFIArray newType: #size_t size: 1.
	aSize at: 1 put: 100.
	"aBuffer := (FFITypeArray ofType: 'char' size: (aSize at: 1)) new."
	aBuffer := FFIArray newType: #char size: 100.


	^ [
	  ZMQLibraryInterface
		  zmq_getsockopt: aSocketPtr
		  with: anOptionKey
		  with: aBuffer
		  with: aSize ]
		  on: Error
		  do: [ "'ZMQ_BACKLOG' = anOptionKey ifTrue: [
		^ self getOptionBacklogFor: aSocketPtr ].
	'ZMQ_TYPE' = anOptionKey ifTrue: [
		^ self getOptionBacklogFor: aSocketPtr ].
"
			  self error:
				  (ZMQLibraryInterface zmq_strerror: ZMQLibraryInterface zmq_errno) ]
]

{ #category : #'api - socket - options' }
ZMQInterface >> socket: aSocketPtr option: aOptionInt value: aBacklogValue [
	| len |
	len := aBacklogValue size.
	^[ZMQLibraryInterface zmq_setsockopt: aSocketPtr with: aOptionInt with: aBacklogValue with: len.]
		on: Error
		do: [self error: 'ZMQ socket Option(',aOptionInt printString,' error']
]

{ #category : #'api - socket - options deprecated' }
ZMQInterface >> socket: aSocketPtr optionName: anOptionName optValue: aBuffer [

	| len |
	len := aBuffer size.

	^ [
	  ZMQLibraryInterface
		  zmq_getsockopt: aSocketPtr
		  with: anOptionName
		  with: aBuffer
		  with: len ]
		  on: Error
		  do: [
		  self error: 'ZMQ socket getOption (' , anOptionName , ') error' ]
]

{ #category : #'api - socket' }
ZMQInterface >> socket: aSocketPtr recv: aBuffer len: aMaxSize flags: flags [
	"Receive a message, with max size len
	buffer is a ValueHolder
	return the message size"

	| ret |
	[ "zmq receive "
	ret := ZMQLibraryInterface
		       zmq_recv: aSocketPtr
		       with: aBuffer
		       with: aMaxSize
		       with: flags.

	^ ret ]
		on: Error
		do: [ :ex |
			self error: 
				(ZMQLibraryInterface zmq_strerror: ZMQLibraryInterface zmq_errno) ]
]

{ #category : #'api - socket' }
ZMQInterface >> socket: aSocketPtr recvMsg: buffer flags: flags [
	"Receive a message, with max size len
	buffer is a ValueHolder
	return the message size"

	| zmqMsg |
	buffer class = ValueHolder ifFalse: [
		self error: 'ZMQ socket recv error: buffer should be a ValueHolder' ].

	^ [
	  | msg ba nbytes baList isEndMessage isReadableMsg |
	  "memory allocation"
	  baList := OrderedCollection new.
	  msg := ZMQ_msg_t new.


	  isEndMessage := false.
	  [ isEndMessage ] whileFalse: [
		  ZMQLibraryInterface zmq_msg_init: msg.
		  "zmq recveive message"
		  ZMQLibraryInterface zmq_recvmsg: aSocketPtr msg: msg with: flags.
		  nbytes := ZMQLibraryInterface zmq_msg_size: msg.
		  isReadableMsg := true.

		  "test null pointer"
		  nbytes = -1 ifTrue: [
			  isEndMessage := (ZMQLibraryInterface zmq_msg_more: msg) = 0.
			  ZMQLibraryInterface zmq_msg_close: msg.
			  "reponse vide"
			  baList add: (ByteArray new: 0).
			  isReadableMsg := false ].

		  isReadableMsg ifTrue: [ "Conversion as a byte array"
			  nbytes = 0
				  ifTrue: [ ba := ByteArray new: nbytes ]
				  ifFalse: [
					  zmqMsg := ZMQLibraryInterface zmq_msg_data: msg.
					  ba := zmqMsg getHandle copyFrom: 1 to: nbytes ].

			  "is the last part or not ?"
			  isEndMessage := (ZMQLibraryInterface zmq_msg_more: msg) = 0.

			  "free memory"
			  ZMQLibraryInterface zmq_msg_close: msg.
			  baList add: ba ] ].
	  "received data store in buffer valueHolder"
	  buffer contents: baList.
	  ^ self ]
		  on: Error
		  do: [ :ex | self error: 'ZMQ socket recv error' ]
]

{ #category : #'api - socket' }
ZMQInterface >> socket: aSocketPtr send: buffer flags: flags [

	| len |
	len := buffer size.
	^[ZMQLibraryInterface zmq_send: aSocketPtr with: buffer with: len with: flags]
		on: Error
		do: [self error: 'ZMQ socket send error']
]

{ #category : #'api - socket - options deprecated' }
ZMQInterface >> socket: pointer setOption: aKeyOption optValue: aValueOption [

	| aSize |
	"aSize := (FFITypeArray ofType: 'int' size: 1) new.
	aSize at: 1 put: 100."
	aSize := aValueOption class = ByteString
		         ifTrue: [ aValueOption size ]
		         ifFalse: [
			         (FFITypeArray ofType: 'size_t' size: 1) new
				         at: 1
				         put: (aValueOption at: 1) ].

	^ [
	  ZMQLibraryInterface
		  zmq_setsockopt: pointer
		  with: aKeyOption
		  with: aValueOption
		  with: aSize ]
		  on: Error
		  do: [
			  self error:
				  (ZMQLibraryInterface zmq_strerror: ZMQLibraryInterface zmq_errno) ]
]

{ #category : #'api - socket' }
ZMQInterface >> socket: aPointerContext type: anIntegerType [
	

	^ [
	  ZMQLibraryInterface zmq_socket: aPointerContext type: anIntegerType ]
		  on: Error
		  do: [
			  self error:
				  'ZMQ type: ' , anIntegerType printString
				  , ' socket creation error' ]
]

{ #category : #'api - socket' }
ZMQInterface >> socket: aSocketPtr unbind: anURLString [


	^ [ ZMQLibraryInterface zmq_unbind: aSocketPtr with: anURLString ]
		  on: Error
		  do: [ self error: 'ZMQ socket unbind(' , anURLString , ') error' ]
]

{ #category : #'api - socket' }
ZMQInterface >> socketClose: socketPtr [


	^ [ ZMQLibraryInterface zmq_close: socketPtr ]
		  on: Error
		  do: [ self error: 'ZMQ socket destruction error' ]
]

{ #category : #accessing }
ZMQInterface >> version [

	^ZMQLibraryInterface version 
]
