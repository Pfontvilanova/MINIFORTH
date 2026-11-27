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
create dada
55 ,
dada @ .

: variable create 0 , ;
variable comptador
99 comptador !
comptador @ .

: constant create , does> @ ;
42 constant resposta
7 constant setmana
resposta .
setmana .

: mes create , does> @ + ;
10 mes mes10
32 mes10 .

: parell create , , does> dup @ swap 1 + @ + ;
7 5 parell p
p .
: compte 3 for i . next ;
compte
: parella i . j . ;
: graella 2 for 3 for parella next next ;
graella
: consulta 42 >r i . r> . ;
: retorns 2 for consulta next ;
retorns
: buit 0 for i . j . next 7 . ;
buit
: aviat 3 for i . exit next 999 . ;
: exterior 2 for aviat i . next ;
exterior
." Hola!" 10 emit
s" Bon dia" type 10 emit

: salutacio ." Hola, mon!" ;
salutacio 10 emit

: missatge s" cafè amb llet" ;
missatge type 10 emit

: tria if ." si" else ." no" then ;
1 tria 10 emit
0 tria 10 emit
7 ' dup execute . .

: doble dup + ;
9 ' doble execute .
see doble

defer accio
: saluda ." Hola!" ;
' saluda is accio
accio 10 emit

: adeu ." Adeu!" ;
: canvia ['] adeu is accio ;
canvia
accio 10 emit

: unless postpone 0= postpone if ;
immediate
: tria unless 111 . else 222 . then ;
0 tria
1 tria
