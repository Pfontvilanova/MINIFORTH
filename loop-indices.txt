sf-variable li-tag
sf-variable li-scan
sf-variable li-left
sf-variable li-code

0 here - li-tag !

: li-redirect
  dup 13 swap ! 1 + !
;

: li-start
  1 sf-need
  dup 0 < if 4 sf-error then
  dup 0= if
    drop 0
  else
    1007 @ 878 < 0= if 5 sf-error then
    r> sf-return !
    1007 @ 1 - li-tag @ >r >r >r
    sf-return @ >r 1
  then
;
latest dup 1 + @ + 2 + sf-start-xt @ li-redirect

: li-step
  r> sf-return ! r> 1 -
  dup 0= if
    drop r> drop r> drop sf-return @ >r 1
  else
    >r sf-return @ >r 0
  then
;
latest dup 1 + @ + 2 + sf-step-xt @ li-redirect

: li-drop
  r> sf-return ! r> drop r> drop r> drop sf-return @ >r
;
latest dup 1 + @ + 2 + sf-drop-xt @ li-redirect

: li-frame?
  li-scan @ @ li-tag @ = if
    li-scan @ 1 + @ li-scan @ = if
      0 li-scan @ 2 + @ <
    else 0 then
  else 0 then
;

: li-index
  dup 14 + li-code ! li-left !
  1007 @ 3 - li-scan !
  begin
    li-scan @ 1011 @ < if li-code @ sf-error then
    li-frame? if
      li-left @ 1 - li-left !
    then
    li-left @ 0= if
      1
    else
      li-scan @ 1 - li-scan ! 0
    then
  until
  li-scan @ 2 + @
;

: i 1 li-index ;
: j 2 li-index ;
