: sf-variable create 0 , ;

sf-variable sf-code
sf-variable sf-a
sf-variable sf-b
sf-variable sf-rem
sf-variable sf-quot
sf-variable sf-chunk
sf-variable sf-weight
sf-variable sf-used
sf-variable sf-index
sf-variable sf-return
sf-variable sf-start-xt
sf-variable sf-step-xt
sf-variable sf-drop-xt

create sf-div-table 64 allot

: sf-error
  sf-code !
  10 emit 69 emit 82 emit 82 emit 79 emit 82 emit 58 emit 32 emit
  98 emit 97 emit 115 emit 105 emit 99 emit 115 emit 32 emit
  sf-code @ . 10 emit
  1 1010 !
;

: sf-need
  sp@ swap < if 1 sf-error then
;

: sf-over
  sp@ 1 - @
;

: .s
  sp@ 1 +
  60 emit 32 emit dup . 62 emit 32 emit
  dup if
    0
    begin
      dup @ . 1 +
      sf-over sf-over =
    until
    drop
  then
  drop
;

: sf<
  dup 0 < if
    swap dup 0 < if swap < else drop drop 0 then
  else
    swap dup 0 < if drop drop 1 else swap < then
  then
;

: max
  2 sf-need
  sf-over sf-over sf< if swap then drop
;

: min
  2 sf-need
  sf-over sf-over sf< 0= if swap then drop
;

: sf-table-slot
  dup + sf-div-table +
;

: sf-div-build
  0 sf-used !
  begin
    sf-chunk @ sf-used @ sf-table-slot !
    sf-weight @ sf-used @ sf-table-slot 1 + !
    sf-used @ 1 + sf-used !
    sf-chunk @ -1073741824 sf< if
      1
    else
      sf-chunk @ dup + sf-rem @ sf< if
        1
      else
        sf-chunk @ dup + sf-chunk !
        sf-weight @ dup + sf-weight !
        0
      then
    then
  until
;

: sf-div-apply
  begin
    sf-used @ if
      sf-used @ 1 - sf-used !
      sf-used @ sf-table-slot @ sf-chunk !
      sf-chunk @ sf-rem @ sf< 0= if
        sf-rem @ sf-chunk @ - sf-rem !
        sf-quot @ sf-used @ sf-table-slot 1 + @ + sf-quot !
      then
      0
    else
      1
    then
  until
;

: /mod
  2 sf-need
  dup 0= if 2 sf-error then
  sf-over -2147483648 = if
    dup -1 = if 3 sf-error then
  then
  sf-b ! sf-a !
  sf-a @ dup 0 < 0= if 0 swap - then sf-rem !
  sf-b @ dup 0 < 0= if 0 swap - then sf-chunk !
  0 sf-quot ! -1 sf-weight !
  sf-div-build sf-div-apply
  sf-a @ 0 < if sf-rem @ else 0 sf-rem @ - then
  sf-a @ 0 < sf-b @ 0 < = if
    0 sf-quot @ -
  else
    sf-quot @
  then
;

: / /mod swap drop ;
: mod /mod drop ;

: sf-for-start
  1 sf-need
  dup 0 < if 4 sf-error then
  dup 0= if
    drop 0
  else
    1007 @ 880 < 0= if 5 sf-error then
    r> sf-return ! >r sf-return @ >r 1
  then
;
latest dup 1 + @ + 2 + sf-start-xt !

: sf-for-step
  r> sf-return ! r> 1 -
  dup 0= if
    drop sf-return @ >r 1
  else
    >r sf-return @ >r 0
  then
;
latest dup 1 + @ + 2 + sf-step-xt !

: sf-for-drop
  r> sf-return ! r> drop sf-return @ >r
;
latest dup 1 + @ + 2 + sf-drop-xt !

: sf-compiling
  state 0= if 10 sf-error then
;

: sf-cs-push
  1012 @ dup + 1700 + ! 1012 @ dup + 1701 + !
  1012 @ 1 + 1012 !
;

: sf-cs-kind
  1012 @ 1 - dup + 1700 + @
;

: sf-cs-addr
  1012 @ 1 - dup + 1701 + @
;

: for
  sf-compiling
  1012 @ 32 < 0= if 12 sf-error then
  here 16381 < 0= if 13 sf-error then
  sf-start-xt @ , 14 , 0 ,
  here 4 sf-cs-push
;
immediate

: next
  sf-compiling
  1012 @ 0= if 11 sf-error then
  sf-cs-kind 4 = 0= if 11 sf-error then
  here 16381 < 0= if 13 sf-error then
  sf-step-xt @ , 14 , sf-cs-addr ,
  sf-cs-addr 1 -
  begin
    dup @ swap here swap ! dup 0=
  until
  drop
  1012 @ 1 - 1012 !
;
immediate

: sf-loop-slot
  1012 @ sf-index !
  begin
    sf-index @ 0= if 14 sf-error then
    sf-index @ 1 - sf-index !
    sf-index @ dup + 1700 + @ 4 =
  until
  sf-index @ dup + 1701 + @ 1 -
;

: sf-paren-comment
  begin
    source-key dup emit 41 =
  until
;
: ( sf-paren-comment ; immediate

: sf-line-comment
  begin
    source-key dup emit 13 =
  until
;
: \ sf-line-comment ; immediate

: leave
  sf-compiling
  here 16381 < 0= if 13 sf-error then
  sf-loop-slot
  sf-drop-xt @ , 13 ,
  dup @ , here 1 - swap !
;
immediate

: exit
  sf-compiling
  0 sf-index ! 0 sf-used !
  begin
    sf-index @ 1012 @ < if
      sf-index @ dup + 1700 + @ 4 = if
        sf-used @ 1 + sf-used !
      then
      sf-index @ 1 + sf-index !
      0
    else
      1
    then
  until
  here sf-used @ + 16384 < 0= if 13 sf-error then
  begin
    sf-used @ if
      sf-drop-xt @ , sf-used @ 1 - sf-used ! 0
    else
      1
    then
  until
  0 ,
;
immediate
