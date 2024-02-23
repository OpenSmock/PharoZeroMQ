Class {
	#name : #ZMQSampleClientPUBSUBTest,
	#superclass : #TestCase,
	#instVars : [
		'client'
	],
	#category : #'ZMQ-Tests'
}

{ #category : #running }
ZMQSampleClientPUBSUBTest >> setUp [
	super setUp.
	client := ZMQSampleClientPUBSUB new.
	ZMQConstants initConstants .
]

{ #category : #running }
ZMQSampleClientPUBSUBTest >> tearDown [
client cleanUp.
	client := nil.
	super tearDown
]

{ #category : #running }
ZMQSampleClientPUBSUBTest >> testClientConnectPublisher [

	client connectPublisher.
	self deny: client socketSender equals: nil.
	self assert: client socketSender url equals: 'tcp://127.0.0.1:31002'
]

{ #category : #running }
ZMQSampleClientPUBSUBTest >> testClientConnectSubscriber [

	client connectSubscriber.
	self deny: client socketReceiver equals: nil.
	self assert: client socketReceiver  url equals: 'tcp://127.0.0.1:31001'
]

{ #category : #running }
ZMQSampleClientPUBSUBTest >> testServerCleanUp [

	client connectPublisher.
	client connectSubscriber.
	client cleanUp.

	self assert: client socketReceiver equals: nil.
	self assert: client socketSender equals: nil
]
