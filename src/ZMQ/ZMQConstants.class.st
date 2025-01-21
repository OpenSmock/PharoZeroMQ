"
This class initializes the option values for sockets. This pool is shared among each class of ZMQ-Core, Libs and Samples. It is initialized in the new: instance method of ZMQSocket.


"
Class {
	#name : #ZMQConstants,
	#superclass : #SharedPool,
	#classVars : [
		'ZMQ_BACKLOG',
		'ZMQ_DONTWAIT',
		'ZMQ_IMMEDIATE',
		'ZMQ_LAST_ENDPOINT',
		'ZMQ_PUB',
		'ZMQ_RCVMORE',
		'ZMQ_REP',
		'ZMQ_REQ',
		'ZMQ_REQ_RELAXED',
		'ZMQ_ROUTING_ID',
		'ZMQ_SUB',
		'ZMQ_SUBSCRIBE',
		'ZMQ_UNSUBSCRIBE',
		'ZMQ_WAIT'
	],
	#category : #'ZMQ-Core'
}

{ #category : #'private - initialization' }
ZMQConstants class >> initialize [
	"Available socket types"

	ZMQ_PUB := 1.
	ZMQ_REP := 4.
	ZMQ_REQ := 3.
	ZMQ_SUB := 2.

	"Socket options, see zmq.h Socket option list"
	ZMQ_SUBSCRIBE := 6.
	ZMQ_UNSUBSCRIBE := 7.
	ZMQ_LAST_ENDPOINT := 32.
	ZMQ_BACKLOG := 19.
	ZMQ_REQ_RELAXED := 53.
	ZMQ_IMMEDIATE := 39.
	ZMQ_RCVMORE := 13.
	 ZMQ_ROUTING_ID := 5.

	"Flags "
	ZMQ_DONTWAIT := 1.
	ZMQ_WAIT := 0
]
