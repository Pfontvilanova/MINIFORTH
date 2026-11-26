: st-variable create 0 , ;

st-variable st-base
st-variable st-size
st-variable st-limit
st-variable st-code
st-variable st-start
st-variable st-buffer
st-variable st-type-xt
create st-buffers 256 allot

: st-error
  10 emit 69 emit 82 emit 82 emit 79 emit 82 emit 58 emit 32 emit
  115 emit 116 emit 114 emit 105 emit 110 emit 103 emit 115 emit 32 emit
  . 10 emit 1 1010 !
;

: st-need
  sp@ swap < if 1 st-error then
;

: st-over
  sp@ 1 - @
;

: type
  2 st-need
  dup 0 < if 5 st-error then
  st-over 0 < if 5 st-error then
  st-over 16384 swap < if 5 st-error then
  st-over 16384 swap - st-over < if 5 st-error then
  begin
    dup if
      >r dup @ emit 1 + r> 1 - 0
    else
      drop drop 1
    then
  until
;
latest dup 1 + @ + 2 + st-type-xt !

: st-line-end?
  dup 13 = if drop 1 else 10 = then
;

: st-store
  1794 @ 256 < 0= if 4 st-code ! then
  1794 @ 32 < if
    1794 @ 9 = 0= if 4 st-code ! then
  then
  st-code @ 0= if
    st-size @ st-limit @ < if
      1794 @ st-base @ st-size @ + !
      st-size @ 1 + st-size !
    else
      2 st-code !
    then
  then
;

: st-read
  0 st-size ! 0 st-code !
  begin
    cd-char
    1794 @ 34 = if
      1
    else
      1794 @ st-line-end? if
        st-code @ 0= if 3 st-code ! then
        1
      else
        st-code @ 0= if st-store then
        0
      then
    then
  until
;

: st-string
  here st-start !
  state if
    0 st-limit !
    here st-base !
    here 16367 < if
      13 , 0 ,
      here st-base !
      16368 here - st-limit !
    then
    st-read
    st-start @ 16367 < 0= if 2 st-code ! then
    st-code @ if
      st-start @ 1000 ! st-code @ st-error
    then
    st-size @ allot
    here st-start @ 1 + !
    10 , st-base @ , 10 , st-size @ ,
  else
    st-buffer @ 0= if 128 else 0 then st-buffer !
    st-buffers st-buffer @ + st-base !
    128 st-limit !
    st-read
    st-code @ if st-code @ st-error then
    st-base @ st-size @
  then
;

: s" st-string ;
immediate

: ." st-string state if st-type-xt @ , else type then ;
immediate
