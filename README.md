# MINIFORTH
A 14 words forth in html-java. 
You can add a bootstrap to make a pure forth model.
you can define words with : and ; The memory ( and stack) starts at 0. and finish at 16000.

?branch and branch make an absolute jump, ex:

: test key? 0 ?branch 1 . 11 branch 1 . 2 . 3 . 4 . ;

show 1 3 4.

key?=0 0 = 1 ?branch=2 1=3 .=4 11=5 branch=6 1=7 .=8 2=9 .=10 3=11 .=12 4=13 .=14 ;=15

: dup sp@ @ ; : invert dup nand ; : negate invert 1 + ; : - negate + ; : = - 0= ;
: swap 1500 ! 1501 ! 1500 @ 1501 @ ; : over sp@ 1 - @ ;
: < - 2147483647 and 0= 0= ;
: > swap < ;
: and nand invert ;

2040 1000 ! ( 1000: HERE ) 0 1004 ! ( 1004: LATEST ) 0 1005 ! ( 1005: STATE )
0 1006 ! ( 1006: IP ) 500 1007 ! ( 1007: RP ) 0 1008 ! ( 1008: LAST-XT )

: here 1000 @ ; : allot here + 1000 ! ; : , here ! 1 allot ; : latest 1004 @ ; : state 1005 @ ; : rp@ 1007 @ ;
: >r rp@ ! rp@ 1 + 1007 ! ; : r> rp@ 1 - 1007 ! rp@ @ ; : r@ rp@ 1 - @ ;

MiniForth is divided into three sections:
The first section consists of the Java core, 14 primitives (implemented in JS), 16,000 32-bit memory cells, and an interpreter (handling `:` and `;`).
If a primitive is entered, it is executed immediately; if a word is defined, a list of words is created, ending with `;`. When that word is subsequently executed, the list is processed one item at a time. Data is read from and written to memory, starting at address 0.
Section 2 is built upon these initial words:
The dictionary and internal variables are manually constructed, memory locations are defined, and the structure for words is established. A set of approximately 35–40 words—ranging from `dup`, `if`, `then`, and `begin` to `word` and `find`—is created; these are written in Forth but run on the Java engine. The `:` and `;` operators are also redefined to function within the Forth dictionary.
Section 3:
From the REPL onward, all words belong to the Forth dictionary, and both the internal and external interpreters operate in pure Forth. Additional words—such as `for`, `next`, `postpone`, `defer`, `create`, and `does>`—are added, allowing for unlimited expansion.
The goal was to have a Forth written entirely in Forth, except for a core of 14 primitives written in JS.

You can use MiniForth directly from your browser via this link:
https://pfontvilanova.github.io/MINIFORTH
Alternatively, you can download the main files and open `index.html`. From there, you can begin programming in Forth using the 14 primitives.
To enter the full Forth REPL mode, you can load the "bootstrap" file; this enables programming using the native Forth interpreter. For the complete system, simply copy and paste all the `.fth` files.
The `usuari` (user) file is provided for storing your own custom words; it currently contains a set of test words for verification purposes.
Further details can be found in the `miniforth-users-guide` file.
