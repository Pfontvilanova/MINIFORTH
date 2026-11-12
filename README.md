# MINIFORTH
A 14 words forth in html-java. 
You can add a bootstrap to make a pure forth model.
you can define words with : and ;
?branch and branch make an absolute jump, ex:
: test key? 0 ?branch 1 . 11 branch 1 . 2 . 3 . 4 . ;
show 1 3 4.
key?=0 0 = 1 ?branch=2 1=3 .=4 11=5 branch=6 1=7 .=8 2=9 .=10 3=11 .=12 4=13 .=14 ;=15
