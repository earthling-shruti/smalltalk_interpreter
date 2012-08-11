"
Author: shruti
Usage: At the shell prompt, enter gst-
>FileStream fileIn:'Dplx.st'
>Smalltalk at:#interpret put:(Dplx new)
>interpret initWithFile:filename
>interpret execute
"

Object subclass: #Dplx
  instanceVariableNames: 'operands instructions operation_stack'
  classVariableNames: ''
  poolDictionaries: ''
  category: nil !

!Dplx class methodsFor: 'instance creation' !
new 
  | r |
  r := super new.
  'created an instance of Dplx' printNl.
  ^ r
!!

!Dplx methodsFor: 'instance initialization' !
initWithFile: filename
| dplxFile i|
i := 1.
instructions := (Array new: 100).
operation_stack := (Array new: 10).
operands := (Dictionary new).
 dplxFile := (FileStream open:filename mode: 'r').
 dplxFile position: 0.
 [ dplxFile atEnd ] whileFalse: [
    instructions at:i put:(dplxFile nextLine).
    i := i + 1.
  ].
 dplxFile close.
 "instructions printNl."
!!

!Dplx methodsFor: 'execute Dplx program' !
execute
| j stack_top result x y temp1 temp2 |
j := 1.
stack_top := 0.
result := 0.
[(instructions at:j) = nil] whileFalse:[
"iterate until instructions at: j is not end"
	       x := (((instructions at:j) tokenize:' ') at:1).
	       x printNl.
	       "if condition on the first token"
	       (x = 'read') ifTrue:[
	       	  stack_top := stack_top + 1.
		  stdout nextPutAll: 'prompt>'.
		  operation_stack at:stack_top put:(stdin nextLine).
		  operation_stack printNl.
		  j := j+1.
	       ].

	       (x = 'store') ifTrue:[
	       	   y := (((instructions at:j) tokenize:' ') at:2).
	       	   y printNl.
		   operands at:y put:(operation_stack at:stack_top).
		   operation_stack at:stack_top put:nil.
		   stack_top := stack_top - 1.
		   operands printNl.
		   j := j+1.
	       	   ].
	
	      (x = 'push') ifTrue:[
	      	   y := (((instructions at:j) tokenize:' ') at:2).
	       	   y printNl.
	      	   (operands includesKey:y) ifTrue:[
    		       stack_top := stack_top + 1.
		       operation_stack at:stack_top put:(operands at:y).
		       ]
		       ifFalse:[
		       stack_top := stack_top + 1.
		       operation_stack at:stack_top put: y.
		       ].
		       j := j + 1.
	      	   ].

	      (x = 'print') ifTrue:[
	      	   y := (operation_stack at:stack_top).
		   y printNl.
		   operation_stack at:stack_top put:nil.
		   stack_top := stack_top - 1.
		   j := j + 1.
	      	   ].

	      (x = 'testtgoto') ifTrue:[
	      	   temp1 := (operation_stack at:stack_top).
		   stack_top := stack_top - 1.
		   (temp1 ~= 0.0)ifTrue:[
	       	   	  y := (((instructions at:j) tokenize:' ') at:2).
	       	   	  y printNl.
		   	  j := (y asNumber).]
		   	  ifFalse:[ j := j + 1.].
	       	   ].

	      (x = 'testfgoto') ifTrue:[
	      	   temp1 := (operation_stack at:stack_top).
		   stack_top := stack_top - 1.
		   (temp1 = 0.0)ifTrue:[
	       	   	  y := (((instructions at:j) tokenize:' ') at:2).
	       	   	  y printNl.
		   	  j := (y asNumber).]
		   	  ifFalse:[ j := j + 1.].
	       	   ].

	      (x = 'end') ifTrue:[
	      	   j := j + 1.
		   ].
	       
	      (x = 'greater') ifTrue:[
	      stack_top printNl.
	      temp1 := ((operation_stack at:stack_top) asNumber).
	      temp2 := ((operation_stack at:(stack_top - 1)) asNumber).
	      operation_stack at:stack_top put:nil.
	      operation_stack at:(stack_top - 1) put:nil.
	      stack_top := stack_top - 1.
	      (temp2 > temp1) ifTrue:[operation_stack at:stack_top put:1.0] 
	      	       	      ifFalse:[operation_stack at:stack_top put:0.0].
	      j := j + 1.
	      ].
	      
	      (x = 'less') ifTrue:[
 	      temp1 := ((operation_stack at:stack_top) asNumber).
	      temp2 := ((operation_stack at:(stack_top - 1)) asNumber).
	      operation_stack at:stack_top put: nil.
	      operation_stack at:(stack_top - 1) put: nil.
	      stack_top := stack_top - 1.
	      (temp2 < temp1) ifTrue:[operation_stack at:stack_top put:1.0] 
	      	       	      ifFalse:[operation_stack at:stack_top put:0.0].
	      j := j + 1.
	      ].

	      (x = 'equal') ifTrue:[
 	      temp1 := ((operation_stack at:stack_top) asNumber).
	      temp2 := ((operation_stack at:(stack_top - 1)) asNumber).
	      operation_stack at:stack_top put: nil.
	      operation_stack at:(stack_top - 1) put: nil.
	      stack_top := stack_top - 1.
	      (temp2 = temp1) ifTrue:[operation_stack at:stack_top put:1.0] 
	      	       	      ifFalse:[operation_stack at:stack_top put:0.0].
	      j := j + 1.
	      ].

	      (x = 'plus') ifTrue:[
	      temp1 := ((operation_stack at:stack_top) asNumber).
	      temp2 := ((operation_stack at:(stack_top - 1)) asNumber).
	      operation_stack at:stack_top put: nil.
	      operation_stack at:(stack_top - 1) put: nil.
	      stack_top := stack_top - 1.
	      result := temp1 + temp2.
	      operation_stack at:stack_top put:result.
	      j := j + 1.
	      ].

	      (x = 'minus') ifTrue:[
	      temp1 := ((operation_stack at:stack_top) asNumber).
	      temp2 := ((operation_stack at:(stack_top - 1)) asNumber).
	      operation_stack at:stack_top put: nil.
	      operation_stack at:(stack_top - 1) put: nil.
	      stack_top := stack_top - 1.
	      result := temp2 - temp1.
	      operation_stack at:stack_top put:result.
	      j := j + 1.
	      ].
	      (x = 'multiply') ifTrue:[
	      temp1 := ((operation_stack at:stack_top) asNumber).
	      temp2 := ((operation_stack at:(stack_top - 1)) asNumber).
	      operation_stack at:stack_top put: nil.
	      operation_stack at:(stack_top - 1) put: nil.
	      stack_top := stack_top - 1.
	      result := temp2 * temp1.
	      operation_stack at:stack_top put:result.
	      j := j + 1.
	      ].
	      (x = 'divide') ifTrue:[
	      temp1 := ((operation_stack at:stack_top) asNumber).
	      temp2 := ((operation_stack at:(stack_top - 1)) asNumber).
	      operation_stack at:stack_top put: nil.
	      operation_stack at:(stack_top - 1) put: nil.
	      stack_top := stack_top - 1.
	      result := temp2 / temp1.
	      operation_stack at:stack_top put:result.
	      j := j + 1.
	      ].
].

!!
