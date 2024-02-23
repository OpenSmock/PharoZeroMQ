"
A ZMQ context is a container for all sockets in a single process. You should create and use exactly one context in your process, if you create 2, these will be like separate ZMQ instances. 

Instance Variables :
pointer : <aPointer>, points to a ZMQ Context
"
Class {
	#name : #ZMQContext,
	#superclass : #FFIExternalObject,
	#pools : [
		'ZMQConstants'
	],
	#category : #'ZMQ-Core'
}

{ #category : #'instance creation' }
ZMQContext class >> new [

	^ self new: 1
]

{ #category : #'instance creation' }
ZMQContext class >> new: intIoThreads [

	| context |
	context := (ZMQInterface default ctxInit: intIoThreads).
	^ context
]

{ #category : #dependencies }
ZMQContext >> destroy [

	| ret |
	handle ifNotNil: [ ret := ZMQInterface default ctxDestroy: handle ].
	ret = -1 ifTrue: [
		self error: 'ZMQ Context Error, unsuccessful destruction' ].
	^ self
]

{ #category : #dependencies }
ZMQContext >> release [

	self destroy
]
