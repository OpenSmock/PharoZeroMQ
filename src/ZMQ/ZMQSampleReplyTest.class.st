Class {
	#name : #ZMQSampleReplyTest,
	#superclass : #TestCase,
	#instVars : [
		'reply'
	],
	#category : #'ZMQ-Tests'
}

{ #category : #running }
ZMQSampleReplyTest >> setUp [

	super setUp.
	reply := ZMQSampleReply new.
	ZMQConstants initConstants
]

{ #category : #running }
ZMQSampleReplyTest >> tearDown [
reply cleanUp.
	reply := nil.
	super tearDown
]

{ #category : #tests }
ZMQSampleReplyTest >> testServerCleanUp [

	reply connectReply.
	reply cleanUp.

	self assert: reply socketReceiver equals: nil
]

{ #category : #tests }
ZMQSampleReplyTest >> testServerConnectReply [

	reply connectReply.
	self deny: reply socketReceiver equals: nil.
	self assert: reply socketReceiver url equals: 'tcp://127.0.0.1:31002'
]
