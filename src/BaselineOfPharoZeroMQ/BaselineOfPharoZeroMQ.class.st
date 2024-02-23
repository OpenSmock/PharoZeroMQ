Class {
	#name : #BaselineOfPharoZeroMQ,
	#superclass : #Object,
	#category : #BaselineOfPharoZeroMQ
}

{ #category : #baselines }
BaselineOfPharoZeroMQ >> baseline: spec [

	<baseline>
	spec for: #common do: [

		"Packages"
		spec package: 'ZMQ' ]
]
