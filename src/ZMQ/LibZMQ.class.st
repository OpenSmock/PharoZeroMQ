"
ZMQ Library contains the name of the file that has the library. 
Exclusively called in ZMQLibraryInterface. To know the version of this lib, you can find out by doing: 
ZMQLibraryInterface version.

This library uses UFFI calls. 
"
Class {
	#name : #LibZMQ,
	#superclass : #FFILibrary,
	#category : #'ZMQ-Libs'
}

{ #category : #accessing }
LibZMQ class >> repositoryDirectory [

	| expectedName myRepository |
	expectedName := 'pharozeromq'.

	myRepository := IceRepository registry
		                detect: [ :each |
		                each name asLowercase = expectedName ]
		                ifNone: [
			                self error:
				                ('Did not find any repository named ''{1}'' in Git repository (case insensitive). ZMQ tests require it to access resources.'
					                 format: { expectedName }) ].
	^ myRepository location
]

{ #category : #'accessing platform' }

LibZMQ >> macLibraryName [

	^ (self class repositoryDirectory / 'include' / 'libzmq.dylib')  asFileReference pathString
]

{ #category : #'accessing platform' }
LibZMQ >> unixLibraryName [

	^ (self class repositoryDirectory / 'include' / 'libzmq.so')  asFileReference pathString
]

{ #category : #'accessing platform' }
LibZMQ >> win32LibraryName [

	^ (self class repositoryDirectory / 'include' / 'zmq.dll') asFileReference pathString
]
