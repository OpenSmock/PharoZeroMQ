"
ZMQSampleServerPUBSUBRcvBuff provides an example on how to use ZMQ, on the server side, using a SUB/PUB patternswith a receive method that uses a buffer as a message receiver.

Responsibility part: I can send and receive messages from clients connected on the same IP/port address as I am.

Collaborators Part: I mainly rely on ZMQ-Core and ZMQSampleAbstract

Here is an example on how to use this class :
serv := ZMQSampleServerPUBSUBRcvBuff new. ""Creates instance""
serv connectSubscriberRcvBuffer. ""Connects sockets""
serv connectPublisher.
serv send: 'Hello World'. ""Sends message to clients who subscribe to this subject or to none.""
serv  cleanUp. ""Destroys the socket""

Instance Variables
socketP:		<aZMQSocket> of type Publisher, accessible through socketSender
socketS:		<aZMQSocket> of type Subscriber, accessible through socketReceiver
"
Class {
	#name : #ZMQSampleServerPUBSUBRcvBuff,
	#superclass : #ZMQSampleAbstractPUBSUB,
	#pools : [
		'ZMQConstants'
	],
	#category : #'ZMQ-Samples'
}

{ #category : #'accessing - defaults' }
ZMQSampleServerPUBSUBRcvBuff class >> defaultPortPUB [

	^ 31001
]

{ #category : #'accessing - defaults' }
ZMQSampleServerPUBSUBRcvBuff class >> defaultPortSUB [

	^ 31002
]

{ #category : #connecting }
ZMQSampleServerPUBSUBRcvBuff >> connectPublisher [
	"Socket connection as Publisher"

	self socketSender: (ZMQSocket new: ZMQ_PUB).
	self socketSender bind: 'tcp://' , self class defaultIP , ':'
		, self class defaultPortPUB printString
]

{ #category : #connecting }
ZMQSampleServerPUBSUBRcvBuff >> connectSubscriberRcvBuffer [
	"Socket connection as a Subscriber"

	self socketReceiver: (ZMQSocket new: ZMQ_SUB).
	self socketReceiver bind: 'tcp://' , self class defaultIP , ':'
		, self class defaultPortSUB printString.

	topicReceiver ifEmpty: [ topicReceiver addLast: '' ].

	"Subscribe to value's argument topics : here topicReceiver. Can only receive messages beginning by said values"
	1 to: topicReceiver size do: [ :e |
		self socketReceiver
			optionKey: ZMQ_SUBSCRIBE
			optValue: (topicReceiver at: e) ].

	self startThreadRcvBuffer
]

{ #category : #'accessing - children' }
ZMQSampleServerPUBSUBRcvBuff >> processName [

	^ 'ZMQ Server recv Buffer'
]
