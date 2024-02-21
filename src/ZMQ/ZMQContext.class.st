"
A ZMQ context is a container for all sockets in a single process. You should create and use exactly one context in your process, if you create 2, these will be like separate ZMQ instances. 

Instance Variables :
pointer : <aPointer>, points to a ZMQ Context
"
Class {
	#name : #ZMQContext,
	#superclass : #Object,
	#instVars : [
		'pointer'
	],
	#pools : [
		'ZMQConstants'
	],
	#category : #'ZMQ-Core'
}

{ #category : #'instance creation' }
ZMQContext class >> new [
	"Modified: Oct 14 2013 11:25 ludovic; "

	^self new: 1
]

{ #category : #'instance creation' }
ZMQContext class >> new: intIoThreads [
	"Modified: Oct 14 2013 11:54 ludovic; "

	| context |
	context := super new.
	context pointer: (ZMQInterface default ctxInit: intIoThreads).
	^context
]

{ #category : #dependencies }
ZMQContext >> destroy [
	| ret |
	pointer ifNotNil: [ ret := ZMQInterface default ctxDestroy: pointer ].
	ret = -1 ifTrue: [
		self error: 'ZMQ Context Error, unsuccessful destruction' ].
	^ self
]

{ #category : #accessing }
ZMQContext >> pointer [
"ZMQ context pointer"
^pointer
]

{ #category : #accessing }
ZMQContext >> pointer: aValue [
pointer := aValue
]

{ #category : #dependencies }
ZMQContext >> release [

	self destroy
]
