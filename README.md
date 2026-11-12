# MINIFORTH
A 14 words forth in html-java. 
You can add a bootstrap to make a pure forth model.
you can define words with : and ;

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
