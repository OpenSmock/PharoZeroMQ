"
I am an Abstract class that gathers common accessors of the different sockets owned by Client and Server in a PUB-SUB pattern.
There is no use in creating an instance of myself. For an example, look at my subclasses.

Instance Variables
socketP:		<aZMQSocket> of type Publisher, accessible through socketSender
socketS:		<aZMQSocket> of type Subscriber, accessible through socketReceiver

"
Class {
	#name : #ZMQSampleAbstractPUBSUB,
	#superclass : #ZMQSampleAbstract,
	#instVars : [
		'socketP',
		'socketS'
	],
	#pools : [
		'ZMQConstants'
	],
	#category : #'ZMQ-Samples'
}

{ #category : #connecting }
ZMQSampleAbstractPUBSUB >> connectPublisher [
	^ self subclassResponsibility
]

{ #category : #'accessing - children' }
ZMQSampleAbstractPUBSUB >> processName [

	^ self subclassResponsibility
]

{ #category : #accessing }
ZMQSampleAbstractPUBSUB >> socketReceiver [
^socketS
]

{ #category : #accessing }
ZMQSampleAbstractPUBSUB >> socketReceiver: aSocketValue [

	socketS := aSocketValue
	
]

{ #category : #accessing }
ZMQSampleAbstractPUBSUB >> socketSender [

	^ socketP
]

{ #category : #accessing }
ZMQSampleAbstractPUBSUB >> socketSender: aSocketValue [

	socketP := aSocketValue
]
