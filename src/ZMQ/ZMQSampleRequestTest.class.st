Class {
	#name : #ZMQSampleRequestTest,
	#superclass : #TestCase,
	#instVars : [
		'request'
	],
	#category : #'ZMQ-Tests'
}

{ #category : #running }
ZMQSampleRequestTest >> setUp [

	super setUp.
	request := ZMQSampleRequest new.
	ZMQConstants initConstants
]

{ #category : #running }
ZMQSampleRequestTest >> tearDown [

request cleanUp.
	request := nil.
	super tearDown
]

{ #category : #running }
ZMQSampleRequestTest >> testSampleConnectRequest [

	request connectRequest.
	self deny: request socketSender equals: nil.
	self assert: request socketSender url equals: 'tcp://127.0.0.1:31002'
]

{ #category : #running }
ZMQSampleRequestTest >> testServerCleanUp [

	request connectRequest.
	request cleanUp.

	self assert: request socketSender equals: nil
]
