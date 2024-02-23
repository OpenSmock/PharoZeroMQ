"
This class is a ZMQ Server with a Reply pattern for its socket.

Once connected to a client in Request pattern, I can wait for its response and when received, send messages to it. I'm connected to the same port as the server's Request. I can't send 2 messages in a row, I have to wait for a reply from my Client.
I can't subscribe to any topic, I  will receive every message sent to my url.

Collaborators Part: I mainly rely on ZMQ-Core and ZMQSampleAbstract

Example to initialize one of my instances :
server := ZMQSampleReply new.
server connectREP.
server send: 'Hello World'.
server cleanUp.

Instance Variables
socketREP:		<aZMQSocket>, type Reply accessible through socketReceiver and socketSender
"
Class {
	#name : #ZMQSampleReply,
	#superclass : #ZMQSampleAbstract,
	#instVars : [
		'socketREP'
	],
	#category : #'ZMQ-Samples'
}

{ #category : #'accessing - defaults' }
ZMQSampleReply class >> defaultPortREP [

	^ 31002
]

{ #category : #connecting }
ZMQSampleReply >> connectReply [
	"Socket connectionas a server to a request client"

	self socketSender: (ZMQSocket new: ZMQ_REP).
	self socketSender bind: 'tcp://' , self class defaultIP , ':'
		, self class defaultPortREP printString.
	self threaded
		ifFalse: [ self startThread ]
		ifTrue: [ self startThreadWorker ]
]

{ #category : #accessing }
ZMQSampleReply >> processName [

	^ 'ZMQ Reply'
]

{ #category : #accessing }
ZMQSampleReply >> socketReceiver [


	^ socketREP
]

{ #category : #accessing }
ZMQSampleReply >> socketReceiver: aSocketValue [

	 socketREP := aSocketValue
]

{ #category : #accessing }
ZMQSampleReply >> socketSender [

	^ socketREP
]

{ #category : #accessing }
ZMQSampleReply >> socketSender: aSocketValue [

	 socketREP := aSocketValue
]
