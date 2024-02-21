Class {
	#name : #ZMQSampleServerPUBSUBTest,
	#superclass : #TestCase,
	#instVars : [
		'server'
	],
	#category : #'ZMQ-Tests'
}

{ #category : #running }
ZMQSampleServerPUBSUBTest >> setUp [

	super setUp.
	server := ZMQSampleServerPUBSUB new.
	ZMQConstants initConstants .
	
]

{ #category : #running }
ZMQSampleServerPUBSUBTest >> tearDown [
	server cleanUp.
	server := nil.
	super tearDown
]

{ #category : #'test server' }
ZMQSampleServerPUBSUBTest >> testServerCleanUp [

	server connectPublisher.
	server connectSubscriber.
	server cleanUp.

	self assert: server socketReceiver  equals: nil.
	self assert: server socketSender equals: nil
]

{ #category : #'test server' }
ZMQSampleServerPUBSUBTest >> testServerConnectPublisher [

	server connectPublisher.
	self deny: server socketSender equals: nil.
	self assert: server socketSender url equals: 'tcp://127.0.0.1:31001'
]

{ #category : #'test server' }
ZMQSampleServerPUBSUBTest >> testServerConnectSubscriber [

	server connectSubscriber.
	self deny: server socketReceiver equals: nil.
	self assert: server socketReceiver url equals: 'tcp://127.0.0.1:31002'
]
