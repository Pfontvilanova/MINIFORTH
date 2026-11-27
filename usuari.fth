\ Biblioteca de l'usuari. Escriu les teves definicions a sota.
\ El carregador afegeix abans les llibreries basiques que faltin.
\ Exemple: : quadrat dup * ;
." you need to fill this file"
7 3 /mod . .
7 3 / .
7 3 mod .
-7 3 /mod . .
5 9 max .
5 9 min .
1 2 3 rot . . .

: tres 3 for 42 . next ;
tres

: buit 0 for 999 . next 7 . ;
buit

: imbricats 2 for 3 for 1 . next next ;
imbricats

: primer 3 for 77 . exit next 999 . ;
primer

: interior 7 . exit 999 . ;
: exterior 2 for interior next 9 . ;
exterior

: un-sol 3 for 77 . leave 999 . next 88 . ;
un-sol

: surt-interior 2 for 3 for 11 . leave next 22 . next 33 . ;
surt-interior
: tria if 111 else 222 then ;
0 tria .
1 tria .

: enrere begin 1 - dup dup . 0= until ;
4 enrere 

: imbricat if if 11 else 12 then else 22 then ;
0 imbricat .
0 1 imbricat .
1 1 imbricat .

: deixa-dada 77 ;
immediate
: amb-immediate if deixa-dada 10 else 20 then ;
0 amb-immediate .
1 amb-immediate .
