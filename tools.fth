: mt-var create 0 , ;
mt-var mt-key
mt-var mt-tail
mt-var mt-pc
mt-var mt-end
mt-var mt-op
mt-var mt-str

: mt-error
  10 emit ." ERROR: tools " . 10 emit
  0 1773 ! 1 1010 !
;

: mt-need
  sp@ swap < if 1 mt-error then
;

: mt-abs dup 0 < if 0 swap - then ;
: mt-over sp@ 1 - @ ;
: mt-xt dup 1 + @ mt-abs + 2 + ;
: mt-name dup 1 + @ mt-abs swap 2 + swap type ;

: mt-header
  mt-key ! latest
  begin
    dup if
      dup mt-xt mt-key @ = if 1 else @ 0 then
    else 1 then
  until
;

: mt-valid
  dup mt-header 0= if drop 2 mt-error then
;

: execute
  1 mt-need mt-valid
  dup 1460 @ = if
    drop 1 mt-need
    1009 @ 1 = if >r else r> swap >r >r then
  else
    dup 1461 @ = if
      drop
      1007 @ 1009 @ - 501 < if 8 mt-error then
      1009 @ 1 = if r> else r> r> swap >r then
    else
      1 - 1006 !
    then
  then
;

: mt-unbound 3 mt-error ;

: defer
  here >r latest >r
  create
  here 16376 < if
    ['] mt-unbound , r> drop r> drop
  else
    r> 1004 ! r> 1000 ! 7 mt-error
  then
  does> @ execute
;
here 3 - mt-tail !

: mt-created?
  dup @ 10 = if
    dup 1 + @ mt-over 5 + = if
      dup 2 + @ 13 = if 4 + @ 0= else drop 0 then
    else drop 0 then
  else drop 0 then
;

: mt-cell
  mt-valid
  dup mt-created? 0= if drop 4 mt-error then
  dup 3 + @ mt-tail @ = 0= if drop 4 mt-error then
  5 +
;

: defer@
  1 mt-need mt-cell @
;

: defer!
  2 mt-need
  mt-cell >r mt-valid
  dup 1460 @ = mt-over 1461 @ = + if 9 mt-error then
  r> !
;

: mt-room
  here + 16383 < 0= if 7 mt-error then
;

: is
  '
  state if
    dup mt-cell drop
    5 mt-room
    10 , , ['] defer! ,
  else
    defer!
  then
;
immediate

: mt-compiling
  state 0= if 5 mt-error then
;

: mt-compile
  mt-compiling 1 mt-room
  dup 1460 @ = if @ else
    dup 1461 @ = if @ then
  then
  ,
;

: postpone
  mt-compiling '
  dup mt-header 1 + @ 0 < if
    1 mt-room ,
  else
    3 mt-room
    10 , , ['] mt-compile ,
  then
;
immediate

: mt-limit
  mt-key ! here mt-end ! latest
  begin
    dup if
      dup mt-key @ swap < if
        dup mt-end ! @ 0
      else drop 1 then
    else drop 1 then
  until
;

: mt-primitive
  mt-key ! latest
  begin
    dup if
      dup mt-xt dup @ mt-key @ =
      swap 1 + @ 0= nand 0= if 1 else @ 0 then
    else 1 then
  until
;

: mt-symbol
  dup dup 47 < if mt-primitive else mt-header then
  dup if swap drop mt-name 32 emit else drop . then
;

: mt-string?
  mt-pc @ 1 + @ mt-str !
  mt-str @ mt-pc @ 2 + < if 0 else
    mt-end @ 4 - mt-str @ < if 0 else
      mt-str @ @ 10 = if
        mt-str @ 1 + @ mt-pc @ 2 + = if
          mt-str @ 2 + @ 10 = if
            mt-str @ 3 + @ mt-str @ mt-pc @ 2 + - =
          else 0 then
        else 0 then
      else 0 then
    then
  then
;

: mt-step
  mt-pc @ . 58 emit 32 emit
  mt-pc @ @ mt-op !
  mt-op @ 13 = if
    mt-pc @ 1 + mt-end @ < 0= if 6 mt-error then
    mt-string? if
      ." s" 34 emit 32 emit
      mt-pc @ 2 + mt-str @ mt-pc @ 2 + - type
      34 emit mt-str @ 4 + mt-pc ! 0
    else
      ." branch " mt-pc @ 1 + @ . 2
    then
  else
    mt-op @ 10 = mt-op @ 14 = + if
      mt-pc @ 1 + mt-end @ < 0= if 6 mt-error then
      mt-op @ 10 = if ." lit " else ." ?branch " then
      mt-pc @ 1 + @ . 2
    else
      mt-op @ 0= if ." return" else mt-op @ mt-symbol then
      1
    then
  then
  mt-pc @ + mt-pc ! 10 emit
;

: see
  '
  dup mt-limit
  10 emit ." : " dup mt-header mt-name
  dup mt-header 1 + @ 0 < if ."  immediate" then
  10 emit
  dup mt-created? if
    ." does> " dup 3 + @ . ." data " 5 + mt-pc !
    begin
      mt-pc @ mt-end @ < if
        mt-pc @ @ . mt-pc @ 1 + mt-pc ! 0
      else 1 then
    until
    10 emit
  else
    mt-pc !
    begin
      mt-pc @ mt-end @ < if mt-step 0 else 1 then
    until
  then
  ." ;" 10 emit
;
