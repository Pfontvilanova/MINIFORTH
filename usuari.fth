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
