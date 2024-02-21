"
ZMQSampleClientPUBSUB provides an example on how to use ZMQ, on the client side, using a PUB-SUB pattern.

Responsibility part: I can send and receive messages from a server connected on the same IP/port address as I am. Each socket is unidirectional. I can subscribe to a list of different topics.

Collaborators Part: I mainly rely on ZMQ-Core and ZMQSampleAbstract

Here is an example on how to use this class :
client := ZMQSampleClientPUBSUB new. ""Creates instance""
client connectSubscriber. ""Connects sockets""
client connectPublisher.
client send: 'Hello World'. ""Sends message to clients who subscribe to this subject or to none.""
client  cleanUp. ""Destroys the socket""


"
Class {
	#name : #ZMQSampleClientPUBSUB,
	#superclass : #ZMQSampleAbstractPUBSUB,
	#pools : [
		'ZMQConstants'
	],
	#category : #'ZMQ-Samples'
}

{ #category : #'accessing - defaults' }
ZMQSampleClientPUBSUB class >> defaultPortPUB [

	^ 31002
]

{ #category : #'accessing - defaults' }
ZMQSampleClientPUBSUB class >> defaultPortSUB [

	^ 31001
]

{ #category : #connecting }
ZMQSampleClientPUBSUB >> connectPublisher [
	"Socket connection as a Publisher"

	self socketSender: (ZMQSocket new: ZMQ_PUB).
	self socketSender connect: 'tcp://' , self class defaultIP , ':'
		, self class defaultPortPUB printString
]

{ #category : #connecting }
ZMQSampleClientPUBSUB >> connectSubscriber [
	"Socket connection as a Subscriber"

	self socketReceiver: (ZMQSocket new: ZMQ_SUB).
	self socketReceiver connect: 'tcp://' , self class defaultIP , ':'
		, self class defaultPortSUB printString.

	topicReceiver ifEmpty: [ topicReceiver addLast: '' ].

	"Subscribe to value's argument topics. Can only receive messages beginning by said values"
	1 to: topicReceiver size do: [ :e |
		self socketReceiver
			optionKey: ZMQ_SUBSCRIBE
			optValue: (topicReceiver at: e) ].

"	self socketReceiver optionKey: ZMQ_BACKLOG optValue: '100'."

	self threaded
		ifFalse: [ self startThread ]
		ifTrue: [ self startThreadWorker ]
]

{ #category : #accessing }
ZMQSampleClientPUBSUB >> processName [
^'ZMQ Client'
]
