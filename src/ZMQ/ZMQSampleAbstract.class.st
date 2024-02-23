"
ZMQSampleAbstract contains all the common methods to the different messaging patterns that you'll find as its subclasses.

Responsibility part: I can send and receive messages from a server connected on the same IP/port address as I am.

Collaborators Part: I mainly rely on ZMQ-Core .

Thank's to me, my subclasses can send and receive messages. They receive them via threads. Also, they can clean themselves up so that a socket can be destroyed.
I am in charge of initializing ZMQConstants if it isn't done prior to me.

As I am an Abstract method, there is no use to create a instance of myself. You can still check the comments and methods of my subclasses if you want to understand how you can use me.

	Instance Variables:
thread: <aProcess>, used to receive messages
currentMsg: <aByteString>, gives the last message received/sent
threadIsWorking: <aBoolean>, is there a normal thread working
threadWorker: <aTFWorker>, Used if a blocking function is in used, nil otherwise
threaded: <aBoolean>, true if you use a Worker but false by default.
topic: <anOrderedCollection>, contains topics to which the class subscribes, '' if not told otherwise.
"
Class {
	#name : #ZMQSampleAbstract,
	#superclass : #Object,
	#instVars : [
		'thread',
		'currentMsg',
		'threadIsWorking',
		'threadWorker',
		'threaded',
		'topicSender',
		'topicReceiver'
	],
	#pools : [
		'ZMQConstants'
	],
	#category : #'ZMQ-Samples'
}

{ #category : #'accessing - defaults' }
ZMQSampleAbstract class >> defaultIP [

	^ '127.0.0.1'
]

{ #category : #accessing }
ZMQSampleAbstract >> addTopicReceiver: aString [

	topicReceiver addLast: aString asString
]

{ #category : #accessing }
ZMQSampleAbstract >> addTopicsReceiver: aCollection [
aCollection do: [ :e| self addTopicReceiver: e ]
]

{ #category : #cleanup }
ZMQSampleAbstract >> cleanUp [
"Empties a socket when it's not nil"
	self stopThreadAndWorker.
	self socketReceiver ifNotNil: [
		self socketReceiver release.
		self socketReceiver: nil ].
	self socketSender ifNotNil: [
		self socketSender release.
		self socketSender: nil ].
	^ self
]

{ #category : #accessing }
ZMQSampleAbstract >> currentMsg [

	^ currentMsg
]

{ #category : #accessing }
ZMQSampleAbstract >> currentMsg: anObject [

	currentMsg := anObject
]

{ #category : #'start-stop' }
ZMQSampleAbstract >> initialize [
	"Initializes variables"

	threadIsWorking := false.
	thread := nil.
	topicSender := String new.
	topicReceiver := OrderedCollection new.
	ZMQConstants initConstants
]

{ #category : #accessing }
ZMQSampleAbstract >> msgDontWait [
	"Non-blocking method to receive messages"

	^ self socketReceiver receiveMsgDontWait
]

{ #category : #accessing }
ZMQSampleAbstract >> msgWait [
"Blocking method to receive messages"
	^ self socketReceiver receiveMsg
]

{ #category : #'accessing - children' }
ZMQSampleAbstract >> processName [

	^ self subclassResponsibility
]

{ #category : #accessing }
ZMQSampleAbstract >> pushMessage: aText [
	"Puts a given aText in the Transcript"

	Transcript
		show: aText;
		show: String cr.
	^ self
]

{ #category : #accessing }
ZMQSampleAbstract >> rcvDontWait [
	"Non-blocking method to receive messages"

	| lastText cmsg actual_topic aSize |
	aSize := 100.
	lastText := self socketReceiver recv: aSize flags: ZMQ_DONTWAIT.
	lastText = (ByteArray new: aSize withAll: 0) ifTrue: [^self].
	cmsg := lastText asString.
	cmsg == '' ifTrue: [ ^ self ].

	1 to: topicReceiver size do: [ :e |
		actual_topic := topicReceiver at: e.
		(actual_topic , '*' match: cmsg) ifTrue: [
			cmsg := cmsg allButFirst: actual_topic size.
			currentMsg := actual_topic -> cmsg.
			self pushMessage:
				'Correspondant ' , currentMsg key , ' - ' , currentMsg value.
			^ self ] ]
]

{ #category : #accessing }
ZMQSampleAbstract >> receiveData [
	"Receive data in a non-blocking way"

	| lastText cmsg  actual_topic |
	lastText := self msgDontWait.
	lastText size = 1 ifFalse: [ ^ self ].
	cmsg := lastText first.
	cmsg := cmsg asString.
	cmsg isEmpty ifTrue: [ ^ self ].
	topicReceiver ifEmpty: [ topicReceiver addLast: '' ].

	1 to: topicReceiver size do: [ :e |
		actual_topic := topicReceiver at: e.
		(actual_topic , '*' match: cmsg) ifTrue: [
			cmsg := cmsg allButFirst: actual_topic size.
			currentMsg := actual_topic -> cmsg.
			self pushMessage:
				'Correspondant ' , currentMsg key , ' - ' , currentMsg value.
			^ self ] ]
]

{ #category : #accessing }
ZMQSampleAbstract >> receiveDataWithWorker [
	"Receive data in a blocking way using a Worker Thread"

	| lastText cmsg |
	lastText := self msgWait.
	lastText size = 1 ifFalse: [ ^ self ].
	cmsg := lastText first.
	cmsg := cmsg asString.
	cmsg isEmpty ifFalse: [ self pushMessage: cmsg ]
]

{ #category : #accessing }
ZMQSampleAbstract >> send: aMessage [
	" send aMessage from a socket sender to a socket receiver"

	topicSender ifNil: [ topicSender := '' ].
	currentMsg := topicSender -> aMessage.
	self socketSender send: topicSender , aMessage.
	self pushMessage: 'You ' , currentMsg key , ' - ' , currentMsg value.
	^ self
]

{ #category : #'accessing - children' }
ZMQSampleAbstract >> socketReceiver [

	^ self subclassResponsibility
]

{ #category : #'accessing - children' }
ZMQSampleAbstract >> socketReceiver:aSocket [

	^ self subclassResponsibility
]

{ #category : #'accessing - children' }
ZMQSampleAbstract >> socketSender [

	^ self subclassResponsibility
]

{ #category : #'accessing - children' }
ZMQSampleAbstract >> socketSender: aSocket [

	^ self subclassResponsibility
]

{ #category : #'start-stop' }
ZMQSampleAbstract >> startThread [
" Used to receive messages in a non-blocking way"
	| startedBloc |
	self stopThread.

	threadIsWorking := true.
	startedBloc := [
	               [ threadIsWorking ] whileTrue: [
		               self receiveData.
		               100 milliSeconds wait ] ].
	thread := startedBloc
		          forkAt: Processor userBackgroundPriority
		          named: self processName , ' thread'
]

{ #category : #'start-stop' }
ZMQSampleAbstract >> startThreadRcvBuffer [
	" Used to receive messages in a non-blocking way with a buffer"

	| startedBloc |
	self stopThread.
	threadIsWorking := true.
	startedBloc := [
	               [ threadIsWorking ] whileTrue: [
		               self rcvDontWait.
		               100 milliSeconds wait ] ].
	thread := startedBloc
		          forkAt: Processor userBackgroundPriority
		          named: self processName , ' RcvBuffer'
]

{ #category : #'start-stop' }
ZMQSampleAbstract >> startThreadWorker [
" Used to receive messages in a blocking way in a TFWorker"
	| startedBloc |
	self stopThreadAndWorker.
	threadWorker := TFWorker named: 'ZMQ'.
	threadWorker doInitialize.
	LibZMQThreaded tfWorker: threadWorker.
	threadIsWorking := true.
	startedBloc := [
	               [ threadIsWorking ] whileTrue: [
		               self receiveDataWithWorker.
		               100 milliSeconds wait ] ].
	thread := startedBloc
		          forkAt: Processor userBackgroundPriority
		          named: self processName , ' worker'
]

{ #category : #accessing }
ZMQSampleAbstract >> started [

	^ threadIsWorking
]

{ #category : #accessing }
ZMQSampleAbstract >> started: anObject [

	threadIsWorking := anObject
]

{ #category : #'start-stop' }
ZMQSampleAbstract >> stopThread [
"Stops a thread"
	threadIsWorking := false.

	thread ifNotNil: [
		thread terminate.
		thread := nil ]
]

{ #category : #'start-stop' }
ZMQSampleAbstract >> stopThreadAndWorker [
" Stops a Worker if it exists, and the normal thread"
	self stopThread.
	threadWorker ifNotNil: [
		threadWorker release.
		threadWorker := nil ]
]

{ #category : #accessing }
ZMQSampleAbstract >> thread [

	^ thread
]

{ #category : #accessing }
ZMQSampleAbstract >> thread: anObject [

	thread := anObject
]

{ #category : #accessing }
ZMQSampleAbstract >> threaded [
threaded ifNil: [ threaded := false ].
	^ threaded
]

{ #category : #accessing }
ZMQSampleAbstract >> threaded: anObject [

	threaded := anObject
]

{ #category : #accessing }
ZMQSampleAbstract >> topicReceiver [

	^ topicReceiver
]

{ #category : #accessing }
ZMQSampleAbstract >> topicReceiver: aString [
	"Discards all current existing topics to replace them with aString"

	topicReceiver := OrderedCollection new
		                 add: aString asString;
		                 yourself
]

{ #category : #accessing }
ZMQSampleAbstract >> topicSender [

	^topicSender 
]

{ #category : #accessing }
ZMQSampleAbstract >> topicSender: aString [

	topicSender := aString
]

{ #category : #accessing }
ZMQSampleAbstract >> topicsReceiver: aCollection [

topicReceiver := aCollection.
]
