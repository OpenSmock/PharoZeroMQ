Class {
	#name : #ZMQSampleAbstractTest,
	#superclass : #TestCase,
	#instVars : [
		'serverOrClient'
	],
	#category : #'ZMQ-Tests'
}

{ #category : #running }
ZMQSampleAbstractTest >> setUp [

	super setUp.
	serverOrClient := ZMQSampleAbstract new.
	ZMQConstants initConstants
]

{ #category : #running }
ZMQSampleAbstractTest >> tearDown [

	serverOrClient := nil.
	super tearDown
]

{ #category : #tests }
ZMQSampleAbstractTest >> testSampleInitialize [

	self assert: serverOrClient thread equals: nil.
	self assert: serverOrClient started equals: false
]

{ #category : #tests }
ZMQSampleAbstractTest >> testSampleTopics [

	| topics |
	topics := OrderedCollection new.
	1 to: (Random new nextInteger: 10) do: [ :c |
	topics addLast: (Random new nextInteger: 1000) asString ].

	serverOrClient addTopicsReceiver: topics .
	self assert: serverOrClient topicReceiver equals: topics.
	topics := Random new nextInteger: 1000 .
	serverOrClient topicReceiver: topics.
	self
		assert: serverOrClient topicReceiver
		equals: (OrderedCollection new add: topics asString ; yourself)
]
