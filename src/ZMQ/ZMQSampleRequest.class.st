"
This class is a ZMQ Client with a Request pattern for its socket.

Once connected to a server in Reply pattern, I can send messages to it and wait for its response. I'm connected to the same port as the server's Reply. I can't send 2 messages in a row, I have to wait for a reply from my Server.
Collaborators Part: I mainly rely on ZMQ-Core and ZMQSampleAbstract
I can't subscribe to any topic, I  will receive every message sent to my url.

   Example to initialize one of my instances :
client := ZMQSampleRequest new.
client connectREQ.
client send: 'Hello World'.
client cleanUp.


    Instance Variables
socketREQ:		<aZMQSocket>, type Request accessible through socketReceiver and socketSender
"
Class {
	#name : #ZMQSampleRequest,
	#superclass : #ZMQSampleAbstract,
	#instVars : [
		'socketREQ'
	],
	#category : #'ZMQ-Samples'
}

{ #category : #'accessing - defaults' }
ZMQSampleRequest class >> defaultPortREQ [

	^ 31002
]

{ #category : #connecting }
ZMQSampleRequest >> connectRequest [
	"Socket connection as a client to a reply server"

	self socketSender: (ZMQSocket new: ZMQ_REQ).
	self socketSender connect: 'tcp://' , self class defaultIP , ':'
		, self class defaultPortREQ printString.


	self threaded
		ifFalse: [ self startThread ]
		ifTrue: [ self startThreadWorker ]
]

{ #category : #accessing }
ZMQSampleRequest >> processName [
^ 'ZMQ Request'
]

{ #category : #accessing }
ZMQSampleRequest >> socketReceiver [

	^ socketREQ 
]

{ #category : #accessing }
ZMQSampleRequest >> socketReceiver: aSocketValue [

	socketREQ := aSocketValue
]

{ #category : #accessing }
ZMQSampleRequest >> socketSender [

	^ socketREQ
]

{ #category : #action }
ZMQSampleRequest >> socketSender: aSocketValue [

	socketREQ := aSocketValue
]
