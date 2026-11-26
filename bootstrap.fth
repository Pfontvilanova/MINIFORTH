( ================================================================== )
( CORRECCIO: compilar >r i r> com a codis directes 22 i 23. )
( CORRECCIO BYE: is-bye? consumeix addr en tots dos camins. )
( CONTROL DE PILA: comprovar dades abans d'executar cada operacio. )
( COMPILADOR: pila de control separada amb marcadors tipats. )
( Motor JS i 14 primitives originals sense canvis. )
( Cal equilibrar >r i r> dins de cada definicio del diccionari. )
( El bloc experimental final es conserva comentat: falten paraules. )
( MINIFORTH: BOOTSTRAP UNIFICAT TOTAL AMB IMEDIATE I NOMS ESTÀNDARD    )
( RAM=16384 | RP=500 | SP=0 | NEGATIVE LENGTH = IMMEDIATE FLAG       )
( ================================================================== )
\ : input 1500 @ emit key 1500 ! 1500 @ 13 = 0 ?branch 10 emit 101 emit 110 emit 100 emit 10 emit ;
: dup sp@ @ ; : invert dup nand ; : negate invert 1 + ; : - negate + ; : = - 0= ;
: swap 1500 ! 1501 ! 1500 @ 1501 @ ; : over sp@ 1 - @ ;
: 10* ( n -- n*10 )
dup + dup 1510 ! dup + dup + 1510 @ + ;
: and nand invert ;
: < - -2147483648 and 0= 0= ;
: > swap < ;
: abs ( n -- |n| )
  dup 0 < 8 ?branch
  0 swap -
;

   ( • 1450: acumulador del resultat 0 )
   ( • 1451: primer factor abs a )
   ( • 1452: segon factor / comptador abs b )
   ( • 1453: flag de signe 0 si positiu, 1 si negatiu )


: * ( a b -- a*b )
  0 1450 ! 0 1453 !
  dup 0 < 26 ?branch
    negate
   1453 @ 0 = 23 ?branch 
      1 1453 ! 26 branch
      0 1453 !
  1452 !
  dup 0 < 48 ?branch
    negate
    1453 @ 0 = 45 ?branch
      1 1453 ! 48 branch
      0 1453 !
  1451 !
  1452 @ 69 ?branch
    1450 @ 1451 @ + 1450 !
    1452 @ 1 - 1452 !
    50 branch
  1450 @
  1453 @ 76 ?branch
    negate
;





2040 1000 ! ( 1000: HERE ) 0 1004 ! ( 1004: LATEST ) 0 1005 ! ( 1005: STATE )
0 1006 ! ( 1006: IP ) 500 1007 ! ( 1007: RP ) 0 1008 ! ( 1008: LAST-XT )
0 1009 ! ( crides de do-call )

: here 1000 @ ; : allot here + 1000 ! ; : , here ! 1 allot ; : latest 1004 @ ; : state 1005 @ ; : rp@ 1007 @ ;
: >r rp@ ! rp@ 1 + 1007 ! ; : r> rp@ 1 - 1007 ! rp@ @ ; : r@ rp@ 1 - @ ;
: rot >r swap r> swap ;

: start-header latest , here 1 - 1004 ! , ;

( --- Capçaleres del nucli --- )
1 start-header 43 , 1 , 0 ,                                          ( + )
4 start-header 110 , 97 , 110 , 100 , 2 , 0 ,                        ( nand )
1 start-header 64 , 3 , 0 ,                                          ( @ )
1 start-header 33 , 4 , 0 ,                                          ( ! )
4 start-header 100 , 114 , 111 , 112 , 5 , 0 ,                       ( drop )
2 start-header 48 , 61 , 6 , 0 ,                                     ( 0= )
3 start-header 115 , 112 , 64 , 7 , 0 ,                              ( sp@ )
4 start-header 101 , 109 , 105 , 116 , 8 , 0 ,                       ( emit )
1 start-header 46 , 9 , 0 ,                                          ( . )
3 start-header 107 , 101 , 121 , 11 , 0 ,                            ( key )
4 start-header 107 , 101 , 121 , 63 , 12 , 0 ,                       ( key? )

( --- Capçaleres de pila, lògica i aritmètica --- )
3 start-header 100 , 117 , 112 , 15 , 0 ,                            ( dup )
4 start-header 115 , 119 , 97 , 112 , 16 , 0 ,                       ( swap )
3 start-header 114 , 111 , 116 , 17 , 0 ,                            ( rot )
1 start-header 45 , 18 , 0 ,                                         ( - )
1 start-header 42 , 19 , 0 ,                                         ( * )
1 start-header 61 , 20 , 0 ,                                         ( = )
1 start-header 60 , 21 , 0 ,                                         ( < )
2 start-header 62 , 114 , 22 , 0 ,                                   ( >r )
here 2 - 1460 ! ( XT exacte del >r del nucli )
2 start-header 114 , 62 , 23 , 0 ,                                   ( r> )
here 2 - 1461 ! ( XT exacte del r> del nucli )

( --- Capçaleres del diccionari i compilador --- )
4 start-header 104 , 101 , 114 , 101 , 24 , 0 ,                      ( here )
5 start-header 97 , 108 , 108 , 111 , 116 , 25 , 0 ,                 ( allot )
1 start-header 44 , 26 , 0 ,                                         ( , )
6 start-header 108 , 97 , 116 , 101 , 115 , 116 , 27 , 0 ,           ( latest )
4 start-header 119 , 111 , 114 , 100 , 28 , 0 ,                      ( word )
-1 start-header 58 , 29 , 0 ,                                        ( : -> IMMEDIATE )
-1 start-header 59 , 30 , 0 ,                                        ( ; -> IMMEDIATE! )
5 start-header 115 , 116 , 97 , 116 , 101 , 31 , 0 ,                 ( state )
7 start-header 99 , 111 , 109 , 112 , 97 , 114 , 97 , 32 , 0 ,       ( compara )
4 start-header 102 , 105 , 110 , 100 , 33 , 0 ,                      ( find )
7 start-header 110 , 117 , 109 , 98 , 101 , 114 , 63 , 34 , 0 ,      ( number? )
2 start-header 109 , 115 , 35 , 0 ,                                  ( ms )

( Paraules Forth de compilacio: nous codis del diccionari, no de JS. )
-2 start-header 105 , 102 , 36 , 0 ,                                ( if )
-4 start-header 101 , 108 , 115 , 101 , 37 , 0 ,                     ( else )
-4 start-header 116 , 104 , 101 , 110 , 38 , 0 ,                     ( then )
-5 start-header 98 , 101 , 103 , 105 , 110 , 39 , 0 ,                ( begin )
-5 start-header 117 , 110 , 116 , 105 , 108 , 40 , 0 ,               ( until )
-5 start-header 97 , 103 , 97 , 105 , 110 , 41 , 0 ,                 ( again )
-9 start-header 105 , 109 , 109 , 101 , 100 , 105 , 97 , 116 , 101 , 42 , 0 ,
7 start-header 98 , 114 , 97 , 110 , 99 , 104 , 44 , 43 , 0 ,        ( branch, )
8 start-header 113 , 98 , 114 , 97 , 110 , 99 , 104 , 44 , 44 , 0 ,  ( qbranch, )

( Entrada de linies: 1021=>IN, 1022=#TIB, 1023=desbordament. )
( TIB ocupa 1024..1399: 375 caracters mes el CR final. )
0 1021 ! 0 1022 ! 0 1023 !
3 start-header 116 , 105 , 98 , 10 , 1024 , 0 ,                    ( tib )
3 start-header 62 , 105 , 110 , 10 , 1021 , 0 ,                    ( >in )
4 start-header 35 , 116 , 105 , 98 , 10 , 1022 , 0 ,               ( #tib )
6 start-header 114 , 101 , 102 , 105 , 108 , 108 , 45 , 0 ,        ( refill )
10 start-header 115 , 111 , 117 , 114 , 99 , 101 , 45 , 107 , 101 , 121 , 46 , 0 ,

( 1012: profunditat CS. 1013/1014: HERE/LATEST abans de la definicio. )
( 1016: ignorar fins a ; despres d'avortar. 1017: darrer error. )
( 1018/1019: temporals. CS: 32 parelles tipus/adreca a 1700..1763. )
( Tipus: 1=if pendent; 2=else pendent; 3=begin. )
0 1012 ! 0 1013 ! 0 1014 ! 0 1016 ! 0 1017 !


: ip@ 1006 @ ; : ip! 1006 ! ; : next-token ip@ @ ; : advance-ip ip@ 1 + ip! ;
: do-literal advance-ip next-token advance-ip ; : do-branch advance-ip next-token ip! ;

: do-qbranch ( -- )
  0= 8 ?branch          ( [0..3] Si el flag NO era 0 [era cert], salta a l'índex 8 )
  advance-ip            ( [4] Flag era 0: apuntem a l'adreça de salt )
  next-token ip!        ( [5..6] Carreguem l'adreça a l'IP )
  10 branch             ( [7] Saltem al final de la paraula )
  advance-ip            ( [8] Branca falsa: saltem el literal de l'adreça )
  advance-ip            ( [9] Avancem a la següent instrucció )
;

: do-call
  ip@ 1 + >r
  1009 @ 1 + 1009 !
  ip!
;

: is-bye? ( addr -- flag )
  dup @ 3 = 34 ?branch
  dup 1 + @ 98 = 34 ?branch
  dup 2 + @ 121 = 34 ?branch
  dup 3 + @ 101 = 34 ?branch
  drop 1 36 branch
  drop 0
;

: bl 32 ;

: tib 1024 ;
: >in 1021 ;
: #tib 1022 ;

( REFILL usa KEY sense modificar-lo; l'HTML confirma nomes aquestes linies. )
( Retorna -1 si hi caben, 0 si s'ha descartat una linia massa llarga. )
: refill ( -- flag )
  0 >in ! 0 #tib ! 0 1023 !
  key #tib @ 376 < 30 ?branch
  dup tib #tib @ + ! #tib @ 1 + #tib !
  33 branch
  1 1023 !
  13 = 9 ?branch
  1023 @ 0= 45 ?branch
  -1 49 branch
  0 #tib ! 0
;

: source-key ( -- c )
  >in @ #tib @ < 20 ?branch
  tib >in @ + @ >in @ 1 + >in !
  24 branch
  refill drop 0 branch
;

: word ( -- addr )
  0 1447 ! ( 1447 es enter, 0 no 1 si )
  here >r 0 , 0 >r
  source-key dup emit
  dup bl = 20 ?branch
  drop 38 branch
  dup 13 = 31 ?branch
  1 1447 ! drop 38 branch
  , r> 1 + >r
  9 branch
  r> r@ ! r>
;


: compara ( addr-word addr-dict -- flag )
  1411 ! 1410 !
  1410 @ @ 1411 @ @ abs = 58 ?branch
  1410 @ @ 1412 ! 1 1413 !
  1412 @ 55 ?branch
  1410 @ 1413 @ + @ 1411 @ 1413 @ + @ = 58 ?branch
  1413 @ 1 + 1413 ! 1412 @ 1 - 1412 !
  22 branch
  1 59 branch
  0
;

: find ( addr-word -- xt imm 1 | 0 )
  1420 ! latest 1421 !
  1421 @ 46 ?branch
  1420 @ 1421 @ 1 + compara 39 ?branch
  1421 @ 2 + 1421 @ 1 + @ abs +
  1421 @ 1 + @ 0 <
  1 47 branch
  1421 @ @ 1421 !
  5 branch
  0
; 

: es-numero? ( addr-word -- n 1 | 0 )
  1 + @ dup 47 > 18 ?branch
  dup 58 < 18 ?branch
  48 - 1 20 branch
  drop 0
;

: number? ( addr-word -- n 1 | 0 )
  dup @ 1430 !
  1 + 1431 !
  0 1432 !
  0 1433 !
  1430 @ 0= 0= 106 ?branch
  1431 @ @ 45 = 49 ?branch
  1430 @ 1 = 0= 106 ?branch
  1 1433 !
  1431 @ 1 + 1431 !
  1430 @ 1 - 1430 !
  1430 @ 0= 0= 96 ?branch
  1431 @ @ 1434 !
  1434 @ 47 > 106 ?branch
  1434 @ 58 < 106 ?branch
  1432 @ 10* 1434 @ 48 - + 1432 !
  1431 @ 1 + 1431 !
  1430 @ 1 - 1430 !
  49 branch
  1432 @
  1433 @ 103 ?branch
  negate
  1 107 branch
  0
;


( Restaura nomes la definicio oberta; no toca la pila de dades. )
: abort-definition ( -- )
  1013 @ 1000 ! 1014 @ 1004 ! 0 1005 ! 0 1012 !
;

( Errors: 1=fora de compilacio; 2=marcador incorrecte o absent; )
( 3=CS plena; 4=estructures obertes a ; 5=: imbricat; )
( 6=paraula desconeguda compilant; 7=bye amb definicio oberta. )
: compile-error ( codi -- )
  1017 ! 1 1010 !
  10 emit 69 emit 82 emit 82 emit 79 emit 82 emit 58 emit 32 emit
  99 emit 111 emit 109 emit 112 emit 105 emit 108 emit
  97 emit 99 emit 105 emit 111 emit 32 emit
  1017 @ . 10 emit
  state 55 ?branch
    abort-definition 1 1016 !
;

: require-compiling ( -- flag )
  state 6 ?branch
    1 9 branch
  1 compile-error 0
;

: require-room ( -- flag )
  require-compiling 14 ?branch
  1012 @ 32 < 12 ?branch
    1 15 branch
  3 compile-error
  0
;

( Helpers interns: els controladors comproven estat, limits i tipus. )
: cs-push ( adreca tipus -- )
  1012 @ dup + 1700 + ! 1012 @ dup + 1701 + !
  1012 @ 1 + 1012 !
;
: cs-kind 1012 @ 1 - dup + 1700 + @ ;
: cs-addr 1012 @ 1 - dup + 1701 + @ ;
: cs-pop-addr cs-addr 1012 @ 1 - 1012 ! ;
: cs-set-kind 1012 @ 1 - dup + 1700 + ! ;
: cs-set-addr 1012 @ 1 - dup + 1701 + ! ;

: cs-expect ( tipus -- flag )
  1018 ! require-compiling 20 ?branch
  1012 @ 18 ?branch
  cs-kind 1018 @ = 18 ?branch
    1 21 branch
  2 compile-error
  0
;

: require-forward ( -- flag )
  require-compiling 17 ?branch
  1012 @ 15 ?branch
  cs-kind 3 < 15 ?branch
    1 18 branch
  2 compile-error
  0
;

: control-if ( -- )
  require-room 10 ?branch
    14 , here 1 cs-push 0 ,
;

: control-else ( -- )
  1 cs-expect 19 ?branch
    13 , cs-addr 1019 ! here cs-set-addr 0 ,
    here 1019 @ ! 2 cs-set-kind
;

: control-then ( -- )
  require-forward 6 ?branch
    here cs-pop-addr !
;

: control-begin ( -- )
  require-room 6 ?branch
    here 3 cs-push
;

: control-until ( -- )
  3 cs-expect 8 ?branch
    14 , cs-pop-addr ,
;

: control-again ( -- )
  3 cs-expect 8 ?branch
    13 , cs-pop-addr ,
;

( Idempotent: immediate dos cops no desmarca la paraula. )
( El seu header es immediate per detectar-ne l'us mentre es compila. )
: control-immediate ( -- )
  state 7 ?branch
    1 compile-error 19 branch
  latest 19 ?branch
  latest 1 + dup @ abs negate swap !
;

: control-branch, ( -- )
  require-compiling 5 ?branch
    13 ,
;

: control-qbranch, ( -- )
  require-compiling 5 ?branch
    14 ,
;

: meta-colon ( -- )
  state 7 ?branch
    5 compile-error 27 branch
  here 1013 ! latest 1014 ! 0 1012 !
  latest , word drop 1013 @ 1004 ! 1 1005 !
;

: meta-semicolon ( -- )
  require-compiling 19 ?branch
  1012 @ 14 ?branch
    4 compile-error 0 1016 ! 19 branch
  0 , 0 1005 !
;

( 1010: error de pila; 1011: RP a l'entrada d'execute-tokens. )
( 1600..1646: minim de dades necessari per codi del diccionari. )
( Els codis 10, 13 i 14 els tracta execute-tokens separadament. )
0 1010 ! 0 1011 !
0 1600 ! 2 1601 ! 2 1602 ! 1 1603 ! 2 1604 ! 1 1605 !
1 1606 ! 0 1607 ! 1 1608 ! 1 1609 ! 0 1610 ! 0 1611 !
0 1612 ! 0 1613 ! 1 1614 ! 1 1615 ! 2 1616 ! 3 1617 !
2 1618 ! 2 1619 ! 2 1620 ! 2 1621 ! 1 1622 ! 0 1623 !
0 1624 ! 1 1625 ! 1 1626 ! 0 1627 ! 0 1628 ! 0 1629 !
0 1630 ! 0 1631 ! 2 1632 ! 1 1633 ! 1 1634 ! 1 1635 !
0 1636 ! 0 1637 ! 0 1638 ! 0 1639 ! 0 1640 !
0 1641 ! 0 1642 ! 0 1643 ! 0 1644 ! 0 1645 ! 0 1646 !

( n es temporal: sp@ torna exactament la profunditat anterior a n. )
: enough? ( dades... n -- dades... flag )
  sp@ swap < 0=
;

: stack-error ( -- )
  1 1010 !
  10 emit
  69 emit 82 emit 82 emit 79 emit 82 emit 58 emit 32 emit
  102 emit 97 emit 108 emit 116 emit 101 emit 110 emit 32 emit
  100 emit 97 emit 100 emit 101 emit 115 emit 10 emit
;

( Aquest despatxador nomes es crida despres de validar la pila. )
( Es conserva la llargada original per no desplacar els salts. )
: executa-primitiva-sense-control ( codi -- )
  900 !
  900 @ 1 = 11 ?branch + 288 branch                    ( [1..8] )
  900 @ 2 = 20 ?branch nand 288 branch                ( [9..16] )
  900 @ 3 = 29 ?branch @ 288 branch                   ( [17..24] )
  900 @ 4 = 38 ?branch ! 288 branch                   ( [25..32] )
  900 @ 5 = 47 ?branch drop 288 branch                ( [33..40] )
  900 @ 6 = 56 ?branch 0= 288 branch                  ( [41..48] )
  900 @ 7 = 65 ?branch sp@ 288 branch                 ( [49..56] )
  900 @ 8 = 74 ?branch emit 288 branch                ( [57..64] )
  900 @ 9 = 83 ?branch . 288 branch                   ( [65..72] )
  900 @ 11 = 92 ?branch key 288 branch                ( [73..80] )
  900 @ 12 = 101 ?branch key? 288 branch               ( [81..88] )
  900 @ 15 = 110 ?branch dup 288 branch                ( [89..96] )
  900 @ 16 = 119 ?branch swap 288 branch              ( [97..104] )
  900 @ 17 = 128 ?branch rot 288 branch               ( [105..112] )
  900 @ 18 = 137 ?branch - 288 branch                 ( [113..120] )
  900 @ 19 = 146 ?branch * 288 branch                 ( [121..128] )
  900 @ 20 = 155 ?branch = 288 branch                 ( [129..136] )
  900 @ 21 = 164 ?branch < 288 branch                 ( [137..144] )
  900 @ 22 = 173 ?branch >r 288 branch                ( [145..152] )
  900 @ 23 = 182 ?branch r> 288 branch                ( [153..160] )
  900 @ 24 = 191 ?branch here 288 branch              ( [161..168] )
  900 @ 25 = 200 ?branch allot 288 branch             ( [169..176] )
  900 @ 26 = 209 ?branch , 288 branch                 ( [177..184] )
  900 @ 27 = 218 ?branch latest 288 branch            ( [185..192] )
  900 @ 28 = 227 ?branch word 288 branch              ( [193..200] )
  900 @ 29 = 236 ?branch meta-colon 288 branch        ( [201..208] )
  900 @ 30 = 245 ?branch meta-semicolon 288 branch    ( [209..216] )
  900 @ 31 = 254 ?branch state 288 branch             ( [217..224] )
  900 @ 32 = 263 ?branch compara 288 branch           ( [225..232] )
  900 @ 33 = 272 ?branch find 288 branch              ( [233..240] )
  900 @ 34 = 281 ?branch number? 288 branch           ( [241..248] )
  900 @ 35 = 288 ?branch ms ;

( Les operacions de compilacio tambe son escrites nomes en Forth. )
: executa-compilador ( codi -- )
  drop
  900 @ 36 = 10 ?branch control-if 74 branch
  900 @ 37 = 19 ?branch control-else 74 branch
  900 @ 38 = 28 ?branch control-then 74 branch
  900 @ 39 = 37 ?branch control-begin 74 branch
  900 @ 40 = 46 ?branch control-until 74 branch
  900 @ 41 = 55 ?branch control-again 74 branch
  900 @ 42 = 64 ?branch control-immediate 74 branch
  900 @ 43 = 73 ?branch control-branch, 74 branch
  control-qbranch,
;

: dispatch-core ( codi -- )
  dup 36 < 8 ?branch
    executa-primitiva-sense-control 9 branch
  executa-compilador
;

( Codis Forth d'entrada, sense afegir primitives JavaScript. )
: dispatch-op ( codi -- )
  dup 45 = 9 ?branch drop refill 19 branch
  dup 46 = 18 ?branch drop source-key 19 branch
  dispatch-core
;

( Un unic punt de control cobreix tots els casos del despatxador. )
( Primer es retira codi: no s'ha de comptar com a dada de l'usuari. )
: executa-primitiva ( codi -- )
  900 !
  900 @ 1600 + @ enough? 15 ?branch
    900 @ dispatch-op 16 branch
  stack-error
;

( ?branch consumeix un flag encara que no passi pel despatxador. )
: checked-qbranch ( -- )
  1 enough? 7 ?branch
    do-qbranch 8 branch
  stack-error
;

( Un error d'una paraula immediate tambe invalida la definicio oberta. )
: recover-execution ( -- )
  1011 @ 1007 ! 0 1009 ! 0 ip!
  state 16 ?branch
    abort-definition 1 1016 !
;

: execute-tokens ( xt -- )
  ip! rp@ 1011 ! 0 1010 !
  1010 @ 14 ?branch                         ( 7: bucle; 14: executar )
    recover-execution 70 branch
  next-token 0= 32 ?branch
    1009 @ 70 ?branch
    1009 @ 1 - 1009 !
    r> ip! 7 branch
  next-token 10 = 40 ?branch
    do-literal 7 branch
  next-token 13 = 48 ?branch
    do-branch 7 branch
  next-token 14 = 56 ?branch
    checked-qbranch 7 branch
  next-token 47 < 66 ?branch
    next-token executa-primitiva advance-ip 7 branch
  next-token do-call
  7 branch
;                       ( Sortida: 70 )



: check-ok ( -- )
  1447 @ 16 ?branch                              ( 0..3   Si 1447 == 0 -> salta al final )
  state 0= 16 ?branch                            ( 4..8   Si compilant -> salta al final )
  32 emit 111 emit 107 emit 10 emit              ( 9..16  Imprimeix " ok )
;


                                       

( Un XT normal es compila com a crida. Les dues operacions de retorn )
( es compilen directament per no afegir una adreca de retorn extra. )
( Es compara l'XT exacte, no el primer codi de qualsevol definicio. )
( Indexs del helper: 0..9 primer cas, 10..19 segon, 20 fallback. )
: compile-xt ( xt -- )
  dup 1460 @ = 10 ?branch
    @ , 21 branch
  dup 1461 @ = 20 ?branch
    @ , 21 branch
  ,
;

: is-semicolon? ( adreca -- flag )
  dup @ 1 = 13 ?branch
    1 + @ 59 = 15 branch
  drop 0
;

: skip-token ( adreca -- )
  is-semicolon? 6 ?branch
    0 1016 !
;

: unknown-token ( -- )
  state 7 ?branch
    6 compile-error 11 branch
  63 emit 10 emit
;

: finish-repl ( -- )
  state 5 ?branch
    7 compile-error
  0 1016 !
;

: init-repl ( -- )
  0 1005 ! 0 1012 ! 0 1016 ! 0 1010 !
  0 >in ! 0 #tib !
;

: repl ( -- )
  init-repl
  check-ok here 1445 ! word 1445 @ 1000 !           ( 1: bucle )
  dup @ 0= 18 ?branch
    drop 1 branch
  dup is-bye? 26 ?branch                         ( 18 )
    drop finish-repl 76 branch
  1016 @ 33 ?branch                              ( 26 )
    skip-token 1 branch
  dup 1446 ! find 57 ?branch                      ( 33 )
  dup 46 ?branch
    drop execute-tokens 1 branch
  drop state 0= 54 ?branch                       ( 46 )
    execute-tokens 1 branch
  compile-xt 1 branch                            ( 54 )
  1446 @ number? 73 ?branch                       ( 57 )
  state 0= 68 ?branch
    1 branch
  10 , , 1 branch                                ( 68 )
  unknown-token 1 branch                          ( 73 )
;                                                ( 76 )

: immediate control-immediate ;

\ BLOC EXPERIMENTAL ORIGINAL: desactivat, no corregit en aquesta versio.
\ Falten begin, if, else, then i until al compilador pre-REPL.
\ : create word dup @ start-header dup >r 0 >r begin r@ r@ 2 + @ = if 1 else r@ r@ 2 + + 1 + @ , r> 1 + >r 0 then until r> drop r> drop drop here 1008 ! 10 , here 2 + , 0 , ;
\ : does> 13 1008 @ ! here 1008 @ 1 + ! ;

\ EXEMPLES

\ : enter key dup emit 13 = 0 ?branch 10 emit ;
\ : for >r ;
\ : next r> 1 - dup >r 0= ;
\ : test for 42 emit 10 emit next 1 ?branch ;
\ : bucle for r@ next 1 ?branch 10 emit ;
\ : i r@ ;
\ : suma for i + next 1 ?branch . ;
\ : testif
\    dup 0=
\    if
\       111 .
\    then
\ ;



