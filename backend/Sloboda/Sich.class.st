Class {
	#name : #Sich,
	#superclass : #Object,
	#instVars : [
		'cossacks',
		'money',
		'registry'
	],
	#category : #Sloboda
}

{ #category : #accessing }
Sich class >> neoJsonMapping: mapper [
mapper for: self do: [ :mapping | mapping mapInstVars: #(cossacks money) ]
]

{ #category : #server }
Sich class >> startServer [
| sloboda teapot |
 sloboda := self new.
 teapot := Teapot allInstances last.
 teapot ifNil: [ teapot := Teapot  ].
 teapot stop.
 teapot := Teapot configure: {
 #defaultOutput -> #json. #port -> 9090. #debugMode -> true
}.
teapot
	GET: '/sichStats' -> sloboda;
	PUT: '/sendSupport/<sloboda_id>/money/<value>' -> [:req | sloboda addMoney: ((req at: #value) asInteger)];
	PUT: '/sendSupport/<sloboda_id>/cossacks/<value>' -> [:req | sloboda addCossacks: ((req at: #value) asInteger)].
	
	teapot start.
	^ teapot
 
]

{ #category : #accessing }
Sich >> addCossacks: aNumber [
cossacks := cossacks + (aNumber asNumber)
]

{ #category : #accessing }
Sich >> addMoney: aNumber [
money := money + (aNumber asNumber)
]

{ #category : #accessing }
Sich >> addMoney: aNumber fromSloboda: aSloboda [
|sloboda|
money := money + (aNumber asNumber).
sloboda := (registry at: aSloboda ifAbsentPut: (Sloboda withName: aSloboda withMoney: 0 withCossacks: 0 )).
sloboda addMoney: aNumber.
sloboda
  
]

{ #category : #accessing }
Sich >> cossacks [
	^ cossacks
]

{ #category : #accessing }
Sich >> gtPreviewFor: aView [ 
<gtView>
^ aView textEditor
  text: 'Money: ', self money asString, '  |  ', 'Cossacks: ', self cossacks asString;
  title: 'Sloboda Stats'

]

{ #category : #accessing }
Sich >> initialize [
money := 0.
cossacks := 0.
registry := Dictionary new

]

{ #category : #accessing }
Sich >> money [
	^ money
]
