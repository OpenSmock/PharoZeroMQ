"
I am LibZMQ but with a Thread Worker. Warning, I do not support every socket type, being used with an non-thread safe socket might lead to undesired behavior regarding your image.
I am used in only a few methods, there is no point in calling me for short tasks.

To understand how you should use the TFWorker, please check TFTestLibraryUsingWorker. 
Collaborators : ZMQLibraryInterface interacts with me .


"
Class {
	#name : #LibZMQThreaded,
	#superclass : #LibZMQ,
	#classInstVars : [
		'tfWorker'
	],
	#category : #'ZMQ-Libs'
}

{ #category : #accessing }
LibZMQThreaded class >> tfWorker [

	^ tfWorker
]

{ #category : #accessing }
LibZMQThreaded class >> tfWorker: anObject [

	tfWorker := anObject
]

{ #category : #'accessing platform' }
LibZMQThreaded >> calloutAPIClass [

	^ TFCalloutAPI 
]

{ #category : #'accessing platform' }
LibZMQThreaded >> runner [

	^ self class tfWorker
]
