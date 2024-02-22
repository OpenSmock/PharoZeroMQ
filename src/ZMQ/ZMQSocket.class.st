"
ZMQ Socket contains all actions that you can do with a socket. Warning, if ou want to use synchronous calls with a TFWorker, not all sockets supports multi-threading and the image might crash or freeze during the use.
REP-REQ, PUB-SUB are not thread safe.

Collaborators Part: I mainly rely on ZMQInterface and ZMQConstants.
To understand how to use it, please refer to ZMQ-Sample.

Instance Variables:

pointer:<aPointer>, points to the socket's address in memory
context:<aZMQContext>
url:<anAddress>, url to bind/connect a socket to
type:<aSmallInteger>, a number that describes the type of socket, see ZMQConstants for available values

"
Class {
	#name : #ZMQSocket,
	#superclass : #Object,
	#instVars : [
		'pointer',
		'context',
		'url',
		'type'
	],
	#pools : [
		'ZMQConstants'
	],
	#category : #'ZMQ-Core'
}

{ #category : #'instance creation' }
ZMQSocket class >> bind: anURLString type: aSocketType [

	| socket |
	socket := self context: (ZMQContext new: 1) type: aSocketType.
	socket bind: anURLString.
	^socket
]

{ #category : #'instance creation' }
ZMQSocket class >> connect: anURLString type: aSocketType [

	| socket |
	socket := self context: (ZMQContext new: 1) type: aSocketType.
	socket connect: anURLString.
	^socket
]

{ #category : #'instance creation' }
ZMQSocket class >> context: aContext type: aSocketType [

	| socket ztype |
	socket := self new.
	socket context: aContext.
	ztype := aSocketType isSymbol
		         ifTrue: [ ZMQInterface default resolveType: aSocketType ]
		         ifFalse: [ aSocketType ].
	socket type: ztype.
	socket pointer:
		(ZMQInterface default socket: socket context pointer type: ztype).
	^ socket
]

{ #category : #'instance creation' }
ZMQSocket class >> new: aSocketType [
	ZMQConstants  initConstants .
	^self type: aSocketType
]

{ #category : #'instance creation' }
ZMQSocket class >> type: aSocketType [

	^self context: (ZMQContext new: 1) type: aSocketType
]

{ #category : #'api - connect' }
ZMQSocket >> bind: anURLString [
|ret|
	url := anURLString.
	 pointer ifNotNil: [
		  ret := ZMQInterface default socket: pointer bind: anURLString ].
	self zmqErrorHandler: ret.
	^ self
]

{ #category : #'api - connect' }
ZMQSocket >> cleanUp [

	"type = ZMQ_REP ifTrue: [ self unbind: url ].
	type = ZMQ_REQ ifTrue: [ self disconnect: url ]."
	"ZMQSampleClientPUBSUB  ifTrue: [ self unbind: url ].
	self class = ZMQSampleServerPUBSUB ifTrue: [ self disconnect: url ]."
	" This next line can't work as we don't know if its server or client plus it works without it and whats above"
	"type = ZMQ_SUB ifTrue: [ self disconnect: url ]."

	self close.
	context destroy
]

{ #category : #'api - connect' }
ZMQSocket >> close [

	| ret |
	pointer ifNotNil: [ ret := ZMQInterface default socketClose: pointer ].
	self zmqErrorHandler: ret.
	^ self
]

{ #category : #'api - connect' }
ZMQSocket >> connect: anURLString [
|ret|
	url := anURLString.
	 pointer ifNotNil: [ret:=
		  ZMQInterface default socket: pointer connect: anURLString ].
	self zmqErrorHandler: ret.
	^ ret
]

{ #category : #accessing }
ZMQSocket >> context [

	^context
]

{ #category : #accessing }
ZMQSocket >> context: anObject [

	context := anObject
]

{ #category : #'api - connect' }
ZMQSocket >> disconnect: anURLString [

	| ret |
	pointer ifNotNil: [
		ret := ZMQInterface default socket: pointer disconnect: anURLString ].
self zmqErrorHandler: ret.
	^ self
]

{ #category : #'api - options' }
ZMQSocket >> optionKey: aKeyOption [
|ret|
	 pointer ifNotNil: [
		  ret:=ZMQInterface default socket: pointer getOption: aKeyOption ].
	self zmqErrorHandler: ret.
	^ ret
]

{ #category : #'api - options' }
ZMQSocket >> optionKey: aKeyOption optValue: aValueOption [

	| ret |
	pointer ifNotNil: [
		ret := ZMQInterface default
			       socket: pointer
			       setOption: aKeyOption
			       optValue: aValueOption ].
	self zmqErrorHandler: ret.
	^ ret
]

{ #category : #accessing }
ZMQSocket >> pointer [

	^pointer
]

{ #category : #accessing }
ZMQSocket >> pointer: anObject [

	pointer := anObject
]

{ #category : #'api - messaging' }
ZMQSocket >> receive [

	^ self recv: 1000 flags: ZMQ_WAIT 
]

{ #category : #'api - messaging' }
ZMQSocket >> receiveDontWait [

	^ self recv: 1000 flags: ZMQ_DONTWAIT 
]

{ #category : #'api - messaging' }
ZMQSocket >> receiveMsg [

	| ret |
	ret := self recvMsgWithFlags: ZMQ_WAIT .
	self zmqErrorHandler: ret.
	^ ret
]

{ #category : #'api - messaging' }
ZMQSocket >> receiveMsgDontWait [

	| ret |
	ret := self recvMsgWithFlags: ZMQ_DONTWAIT .
	self zmqErrorHandler: ret.
	^ ret
]

{ #category : #'api - messaging' }
ZMQSocket >> recv: aMaxSize [

	^ self recv: aMaxSize flags: ZMQ_WAIT 
]

{ #category : #'api - messaging' }
ZMQSocket >> recv: aMaxSize flags: flags [

	| aBuffer |
	aBuffer := ByteArray new: aMaxSize.
	ZMQInterface default
		socket: pointer
		recv: aBuffer
		len: aMaxSize
		flags: flags.


	^ aBuffer contents
]

{ #category : #'api - messaging' }
ZMQSocket >> recvMsgWithFlags: flags [

	| message ret |
	message := ValueHolder new.
	ret := ZMQInterface default
		       socket: pointer
		       recvMsg: message
		       flags: flags.

	ret = -1 ifTrue: [
		self error: ' on receive:'
			, (ZMQLibraryInterface zmq_strerror: ZMQLibraryInterface zmq_errno) ].
	^ message contents
]

{ #category : #'initialize - release' }
ZMQSocket >> release [
 super release.
	self cleanUp
]

{ #category : #'api - messaging' }
ZMQSocket >> send: aStringOrByteArray [

	| ret |
	ret := self send: aStringOrByteArray flags: ZMQ_WAIT .
	self zmqErrorHandler: ret.
	^ self
]

{ #category : #'api - messaging' }
ZMQSocket >> send: aStringOrByteArray flags: flags [
|ret|
	pointer ifNotNil: [ret :=
		  ZMQInterface default
			  socket: pointer
			  send: aStringOrByteArray
			  flags: flags ].
		self zmqErrorHandler: ret.
	^ ret
]

{ #category : #accessing }
ZMQSocket >> type [

	^ type
]

{ #category : #accessing }
ZMQSocket >> type: aType [

	type := aType
]

{ #category : #'api - connect' }
ZMQSocket >> unbind: anURLString [

	| ret |
	pointer ifNotNil: [
		ret := ZMQInterface default socket: pointer unbind: anURLString ].

	self zmqErrorHandler: ret.
	^ self
]

{ #category : #accessing }
ZMQSocket >> url [

	^ url
]

{ #category : #accessing }
ZMQSocket >> url: anObject [

	url := anObject
]

{ #category : #'error handling' }
ZMQSocket >> zmqErrorHandler: aReturn [
aReturn = -1 ifTrue: [
		self error: (ZMQLibraryInterface zmq_strerror: ZMQLibraryInterface zmq_errno) ].
	^ aReturn
]
