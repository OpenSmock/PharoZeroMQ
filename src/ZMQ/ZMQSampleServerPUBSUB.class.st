"
ZMQSamplServer provides an example on how to use ZMQ, on the server side, using a SUB/PUB patterns. 

Responsibility part: I can send and receive messages from clients connected on the same IP/port address as I am.

Collaborators Part: I mainly rely on ZMQ-Core and ZMQSampleAbstract 


	Here is an example on how to use this class : 
serv := ZMQSampleServerPUBSUB new. ""Creates instance""
serv connectSubscriber. ""Connects sockets""
serv connectPublisher.
serv send: 'Hello World'. ""Sends message to clients who subscribe to this subject or to none.""
serv  cleanUp. ""Destroys the socket""


    Instance Variables
socketP:		<aZMQSocket> of type Publisher, accessible through socketSender
socketS:		<aZMQSocket> of type Subscriber, accessible through socketReceiver



"
Class {
	#name : #ZMQSampleServerPUBSUB,
	#superclass : #ZMQSampleAbstractPUBSUB,
	#pools : [
		'ZMQConstants'
	],
	#category : #'ZMQ-Samples'
}

{ #category : #'accessing - defaults' }
ZMQSampleServerPUBSUB class >> defaultPortPUB [

	^ 31001
]

{ #category : #'accessing - defaults' }
ZMQSampleServerPUBSUB class >> defaultPortSUB [

	^ 31002
]

{ #category : #connecting }
ZMQSampleServerPUBSUB >> connectPublisher [
	"Socket connection as Publisher"

	self socketSender: (ZMQSocket new: ZMQ_PUB).
	self socketSender bind: 'tcp://' , self class defaultIP , ':'
		, self class defaultPortPUB printString
]

{ #category : #connecting }
ZMQSampleServerPUBSUB >> connectSubscriber [
	"Socket connection as Subscriber"

	self socketReceiver: (ZMQSocket new: ZMQ_SUB).
	self socketReceiver bind: 'tcp://' , self class defaultIP , ':'
		, self class defaultPortSUB printString.

	topicReceiver ifEmpty: [ topicReceiver addLast: '' ].
	
	"Subscribe to value's argument topics. Can only receive messages beginning by said values"
	1 to: topicReceiver size do: [ :e |
		self socketReceiver
			optionKey: ZMQ_SUBSCRIBE
			optValue: (topicReceiver at: e) ].

	self threaded
		ifFalse: [ self startThread ]
		ifTrue: [ self startThreadWorker ]
]

{ #category : #accessing }
ZMQSampleServerPUBSUB >> processName [

	^ 'ZMQ Server'
]
