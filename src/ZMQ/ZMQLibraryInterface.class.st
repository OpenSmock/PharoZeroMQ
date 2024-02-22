"
Accessing interface to ZMQ's functions. The C functions are called with FFI and TFFI. ZMQInterface ensues form this class. 
"
Class {
	#name : #ZMQLibraryInterface,
	#superclass : #Object,
	#pools : [
		'ZMQConstants'
	],
	#category : #'ZMQ-Core'
}

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> cleanUp [

]

{ #category : #'library path' }
ZMQLibraryInterface class >> ffiLibraryName [
	^ LibZMQ 
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> version [

	| tmp1 tmp2 tmp3 tmp4 tmp5 |
	tmp1 := 0 pointer.
	tmp2 := tmp1 size.
	tmp3 := 0 pointer.
	tmp4 := 0 pointer.
	self zmq_version: tmp1 with: tmp3 with: tmp4.
	tmp5 := String new writeStream.
	tmp5
		nextPutAll: (tmp1 integerAt: 1 size: tmp2 signed: true) printString;
		nextPut: $.;
		nextPutAll: (tmp3 integerAt: 1 size: tmp2 signed: true) printString;
		nextPut: $.;
		nextPutAll: (tmp4 integerAt: 1 size: tmp2 signed: true) printString.
	^ tmp5 contents
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_bind: s with: addr [
	^self ffiCall: #(int zmq_bind(void *s, const char *addr)) module: LibZMQ 
	
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_close: s [

	^ self
		  ffiCall: #( int zmq_close #( void * s ) )
		  module: LibZMQ
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_connect: aSocket with: anAddress [

	^ self
		  ffiCall: #( int zmq_connect #( void * aSocket , const char * anAddress ) )
		  module: LibZMQ
		
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_disconnect: s with: addr [
	^self ffiCall: #(zmq_disconnect (void *s, const char *addr)) module: LibZMQ 
	
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_errno [
	^self ffiCall: #(int zmq_errno (void))  module: LibZMQ 
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_getsockopt: s with: option with: optval with: optvallen [

	^ self
		  ffiCall:
			  #( int zmq_getsockopt #( void * s , int option , void * optval
			        , size_t * optvallen ) )
		  module: LibZMQ
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_init: io_threads [
	^self ffiCall: #(void *zmq_init (int io_threads)) module: LibZMQ 
	
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_msg_close: msg [
	^self ffiCall: #(int zmq_msg_close(ZMQ_msg_t * msg)) module: LibZMQ 
	
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_msg_data: msg [
	^self ffiCall: #( void * zmq_msg_data(ZMQ_msg_t * msg)) module: LibZMQ 
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_msg_init: msg [
	^self ffiCall: #( int zmq_msg_init(ZMQ_msg_t * msg))  module: LibZMQ 
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_msg_init: s msg: msg with: flags [
	^self zmq_msg_init: msg
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_msg_more: message [
	^self ffiCall: #( int zmq_msg_more (ZMQ_msg_t *message)) module: LibZMQ 
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_msg_size: msg [
	^self ffiCall: #( size_t zmq_msg_size(ZMQ_msg_t * msg)) module: LibZMQ 
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_recv: socket with: buffer with: len with: flags [

	| lib |
	lib := LibZMQ.
	flags == ZMQ_WAIT  ifTrue: [ lib := LibZMQThreaded ].

	^ self
		  ffiCall:
			  #( int zmq_recv #( void * socket , void * buffer , size_t len , int
			        flags ) )
		  module: LibZMQ
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_recvmsg: s msg: msg with: flags [

	| lib |
	lib := LibZMQ.
	flags == ZMQ_WAIT ifTrue: [ lib := LibZMQThreaded ].
	^ self
		  ffiCall:
		  #( int zmq_recvmsg #( void * s , ZMQ_msg_t * msg , int flags ) )
		  module: lib
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_send: socket with: buffer with: len with: flags [
	^self ffiCall: #( int zmq_send(void * socket, const void * buffer, size_t len, int flags)) module: LibZMQ 
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_setsockopt: s with: option with: optval with: optvallen [
	^self ffiCall: #(int zmq_setsockopt (void *s, int option, const void *optval, size_t optvallen)) module: LibZMQ 
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_socket: context type: type [
	^self ffiCall: #(void *zmq_socket (void *context, int type)) module: LibZMQ 
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_strerror: errnum [
	^self ffiCall: #(const char *zmq_strerror (int errnum))  module: LibZMQ 
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_term: context [
	^self ffiCall: #(int zmq_term (void *context)) module: LibZMQ 
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_unbind: s with: addr [
	^self ffiCall: #(int zmq_unbind(void *s, const char *addr)) module: LibZMQ 
	
]

{ #category : #'procedures-zmq' }
ZMQLibraryInterface class >> zmq_version: major with: minor with: patch [
	^self ffiCall: #(void zmq_version (int *major, int *minor, int *patch)) module: LibZMQ 
]

{ #category : #accessing }
ZMQLibraryInterface >> ffiLibraryName [
	^ self class ffiLibraryName
]
