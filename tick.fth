: tk-error
  10 emit 69 emit 82 emit 82 emit 79 emit 82 emit 58 emit 32 emit
  116 emit 105 emit 99 emit 107 emit 32 emit . 10 emit
  1 1010 !
;

: '
  here >r
  cd-name if
    r> dup 1000 ! find if
      drop
    else
      1 tk-error
    then
  else
    r> 1000 ! 2 tk-error
  then
;

: [']
  state 0= if 3 tk-error then
  '
  here 16382 < 0= if drop 4 tk-error then
  10 , ,
;
immediate
