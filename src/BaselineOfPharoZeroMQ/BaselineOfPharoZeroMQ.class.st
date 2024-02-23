Class {
	#name : #BaselineOfPharoZeroMQ,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoZeroMQ
}

{ #category : #baselines }
BaselineOfPharoZeroMQ >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Packages" spec package: 'ZMQ' ]
]
