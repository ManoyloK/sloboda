Class {
	#name : #Sloboda,
	#superclass : #Object,
	#instVars : [
		'cossacks',
		'money'
	],
	#category : #Sloboda
}

{ #category : #accessing }
Sloboda class >> neoJsonMapping: mapper [
mapper for: self do: [ :mapping | mapping mapInstVars: #(cossacks money) ]
]

{ #category : #server }
Sloboda class >> startServer [
| sloboda teapot |

sloboda := Sloboda new.

teapot := Teapot allInstances last.
teapot ifNil: [ teapot := Teapot  ].
teapot stop.

teapot := Teapot configure: {
	#defaultOutput -> #json. #port -> 9090. #debugMode -> true
}.

teapot GET: '/welcome' -> 'Welcome to sloboda server';
       PUT: '/sendSupport/money/<value>' -> [ : req | sloboda addMoney: ((req at: #value) asNumber)];
	    PUT: '/sendSupport/cossacks/<value>' -> [ : req | sloboda addCossacks: ((req at: #value) asNumber) ];
	    GET: '/sichStats' -> sloboda.

teapot start
]

{ #category : #accessing }
Sloboda >> addCossacks: aNumber [
cossacks := cossacks + (aNumber asNumber)
]

{ #category : #accessing }
Sloboda >> addMoney: aNumber [
money := money + (aNumber asNumber)
]

{ #category : #accessing }
Sloboda >> cossacks [
	^ cossacks
]

{ #category : #accessing }
Sloboda >> gtPreviewFor: aView [ 
<gtView>
^ aView textEditor
  text: 'Money: ', self money asString, '  |  ', 'Cossacks: ', self cossacks asString;
  title: 'Sloboda Stats'

]

{ #category : #accessing }
Sloboda >> initialize [
money := 0.
cossacks := 0
]

{ #category : #accessing }
Sloboda >> money [
	^ money
]
