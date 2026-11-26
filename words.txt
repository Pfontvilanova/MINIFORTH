: wd-name
  dup 1 + @
  dup 0 < if 0 swap - then
  swap 2 + swap
  begin
    dup if
      >r dup @ emit 1 + r> 1 - 0
    else
      drop drop 1
    then
  until
;

: words
  10 emit latest
  begin
    dup if
      dup wd-name 32 emit @ 0
    else
      drop 1
    then
  until
  10 emit
;
