Class {
	#name : #ZMQSampleClientPUBSUBGetOption,
	#superclass : #ZMQSampleAbstractPUBSUB,
	#pools : [
		'ZMQConstants'
	],
	#category : #'ZMQ-Samples'
}

{ #category : #'accessing - defaults' }
ZMQSampleClientPUBSUBGetOption class >> defaultPortPUB [

	^ 31002
]

{ #category : #'accessing - defaults' }
ZMQSampleClientPUBSUBGetOption class >> defaultPortSUB [

	^ 31001
]

{ #category : #connecting }
ZMQSampleClientPUBSUBGetOption >> connectPublisher [
	"Socket connection as a Publisher"

	self socketSender: (ZMQSocket new: ZMQ_PUB).
	self socketSender connect: 'tcp://' , self class defaultIP , ':'
		, self class defaultPortPUB printString
]

{ #category : #connecting }
ZMQSampleClientPUBSUBGetOption >> connectSubscriber [
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


	self threaded
		ifFalse: [ self startThread ]
		ifTrue: [ self startThreadWorker ]
]

{ #category : #connecting }
ZMQSampleClientPUBSUBGetOption >> getOptNumber: anOptionNumber [
	"Socket connection as a Subscriber"
^ self socketSender optionKey: 19.
]

{ #category : #accessing }
ZMQSampleClientPUBSUBGetOption >> processName [
^'ZMQ Client'
]
