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

{ #category : #'accessing platform' }
LibZMQ >> macModuleName [
	^ 'libzmq.dylib'
]

{ #category : #'accessing platform' }
LibZMQ >> unixModuleName [
	^ 'libzmq.so'
]

{ #category : #'accessing platform' }
LibZMQ >> win32ModuleName [
	"While this is not a 'libc' properly, msvcrt has the functions we are defining here"
	^ 'zmq.dll'
]
