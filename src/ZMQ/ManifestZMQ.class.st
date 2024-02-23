"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestZMQ,
	#superclass : #PackageManifest,
	#category : #'ZMQ-Manifest'
}

{ #category : #'meta-data' }
ManifestZMQ class >> description [

	^ 'ZMQ port from SMOCK.
	ZMQ is a library that lets you discuss between 2 interfaces. With Pharo, you can send and receive messages with 2 different images. To do that, it uses a socket system, here is implemented a PUB-SUB  and a REQ-REP pattern. 
	For more information on the library and the use of its functions, visit : 
	https://zguide.zeromq.org/ '
]
