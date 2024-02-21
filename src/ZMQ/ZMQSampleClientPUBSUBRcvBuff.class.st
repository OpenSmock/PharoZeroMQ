"
ZMQSampleClientPUBSUBRcvBuff provides an example on how to use ZMQ, on the client side, using a PUB-SUB pattern with a receive method that uses a buffer as a message receiver.

Responsibility part: I can send and receive messages from a server connected on the same IP/port address as I am. Each socket is unidirectional. I can subscribe to a list of different topics.

Collaborators Part: I mainly rely on ZMQ-Core and ZMQSampleAbstract

Here is an example on how to use this class :
client := ZMQSampleClientPUBSUBRcvBuff new. ""Creates instance""
client connectSubscriberRcvBuffer. ""Connects sockets""
client connectPublisher.
client send: 'Hello World'. ""Sends message to clients who subscribe to this subject or to none.""
client  cleanUp. ""Destroys the socket""
"
Class {
	#name : #ZMQSampleClientPUBSUBRcvBuff,
	#superclass : #ZMQSampleAbstractPUBSUB,
	#pools : [
		'ZMQConstants'
	],
	#category : #'ZMQ-Samples'
}

{ #category : #'accessing - defaults' }
ZMQSampleClientPUBSUBRcvBuff class >> defaultPortPUB [

	^ 31002
]

{ #category : #'accessing - defaults' }
ZMQSampleClientPUBSUBRcvBuff class >> defaultPortSUB [

	^ 31001
]

{ #category : #connecting }
ZMQSampleClientPUBSUBRcvBuff >> connectPublisher [
	"Socket connection as a Publisher"

	self socketSender: (ZMQSocket new: ZMQ_PUB).
	self socketSender connect: 'tcp://' , self class defaultIP , ':'
		, self class defaultPortPUB printString
]

{ #category : #connecting }
ZMQSampleClientPUBSUBRcvBuff >> connectSubscriberRcvBuffer [
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

	self startThreadRcvBuffer
]

{ #category : #accessing }
ZMQSampleClientPUBSUBRcvBuff >> processName [

	^ 'ZMQ Client recv Buffer'
]
