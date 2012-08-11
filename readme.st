"Assign4: Creating an Intermediate Language Interpreter in Smalltalk "

"Author: shruti 
Submission Date: 4/2/2012
Operating System: Ubuntu 11.10"

"Usage: At the shell prompt, enter 'gst' -
>FileStream fileIn:'Dplx.st'
>Smalltalk at:#interpret put:(Dplx new)
>interpret initWithFile:filename
>interpret execute"

"Files with dpl code:
1. Factorial.dpl.int
2. Power.dpl.int
3. Summation.dpl.int
4. SummationIterate.dpl.int
5. TestMathExp.dpl.int
6. TestNest.dpl.int"

"Sample dpl code:
read
store x
push x
store i
push 1.0
store fact
push i
push 1.0
greater
testfgoto 21
push fact
push i
multiply
store fact
push i
push 1.0
minus
store i
push 1.0
testtgoto 7
push fact
print
end"


