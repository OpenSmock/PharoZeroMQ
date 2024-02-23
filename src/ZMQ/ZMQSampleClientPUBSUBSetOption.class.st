Class {
	#name : #ZMQSampleClientPUBSUBSetOption,
	#superclass : #ZMQSampleAbstractPUBSUB,
	#pools : [
		'ZMQConstants'
	],
	#category : #'ZMQ-Samples'
}

{ #category : #'accessing - defaults' }
ZMQSampleClientPUBSUBSetOption class >> defaultPortPUB [

	^ 31002
]

{ #category : #'accessing - defaults' }
ZMQSampleClientPUBSUBSetOption class >> defaultPortSUB [

	^ 31001
]

{ #category : #connecting }
ZMQSampleClientPUBSUBSetOption >> connectPublisher [
	"Socket connection as a Publisher"

	self socketSender: (ZMQSocket new: ZMQ_PUB).
	self socketSender connect: 'tcp://' , self class defaultIP , ':'
		, self class defaultPortPUB printString
]

{ #category : #connecting }
ZMQSampleClientPUBSUBSetOption >> connectSubscriber [
	"Socket connection as a Subscriber"

	| bytes |
	self socketReceiver: (ZMQSocket new: ZMQ_SUB).
	self socketReceiver connect: 'tcp://' , self class defaultIP , ':'
		, self class defaultPortSUB printString.

	topicReceiver ifEmpty: [ topicReceiver addLast: '' ].

	"Subscribe to value's argument topics. Can only receive messages beginning by said values"
	1 to: topicReceiver size do: [ :e |
		self socketReceiver
			optionKey: ZMQ_SUBSCRIBE
			optValue: (topicReceiver at: e) ].
	bytes := (FFITypeArray ofType: 'int' size: 1) new.
	bytes at: 1 put: 100.
	self socketReceiver optionKey: ZMQ_BACKLOG optValue: bytes.

	self threaded
		ifFalse: [ self startThread ]
		ifTrue: [ self startThreadWorker ]
]

{ #category : #accessing }
ZMQSampleClientPUBSUBSetOption >> processName [
^'ZMQ Client'
]
