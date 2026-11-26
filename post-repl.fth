0 1770 ! 0 1771 ! 0 1772 ! 0 1773 ! 0 1774 !

: cd-error
  1774 !
  10 emit 69 emit 82 emit 82 emit 79 emit 82 emit 58 emit 32 emit
  99 emit 114 emit 101 emit 97 emit 116 emit 101 emit 47 emit
  100 emit 111 emit 101 emit 115 emit 62 emit 32 emit
  1774 @ . 10 emit
  state if
    1013 @ 1000 ! 1014 @ 1004 ! 0 1005 ! 0 1012 ! 1 1016 !
  then
  0 1773 ! 1 1010 !
;

: cd-top
  1773 @ 1 - dup + dup + dup + 1800 +
;

: cd-next
  1773 @ dup + dup + dup + 1800 +
;

: cd-pop
  1773 @ 1 - 1773 !
;

: cd-trim
  1778 !
  begin
    1773 @ if
      cd-top 3 + @ 1445 @ = if
        cd-top @ 1778 @ < if 1 else cd-pop 0 then
      else
        cd-pop 0
      then
    else
      1
    then
  until
;

: cd-enter
  1777 ! 1776 !
  1009 @ 2 - cd-trim
  1773 @ 16 < if
    1009 @ 2 - cd-next !
    1776 @ cd-next 1 + !
    0 cd-next 2 + !
    1445 @ cd-next 3 + !
    1777 @ cd-next 4 + !
    1773 @ 1 + 1773 !
  else
    5 cd-error
  then
;
latest dup 1 + @ + 2 + 1771 !

: cd-leave
  1009 @ 2 - cd-trim
;
latest dup 1 + @ + 2 + 1772 !

: cd-space?
  dup 32 = if drop 1 else
    dup 13 = if drop 1 else
      dup 10 = if drop 1 else
        9 =
      then
    then
  then
;

: cd-char
  0 1447 !
  key dup emit
  dup 13 = if 1 1447 ! then
  1794 !
;

: cd-name
  here 1796 ! 0 , 0 1795 ! 0 1797 !
  begin cd-char 1794 @ cd-space? 0= until
  begin
    1795 @ 0= if
      here 16378 < if
        1794 @ , 1797 @ 1 + 1797 !
      else
        1 1795 !
      then
    then
    cd-char 1794 @ cd-space?
  until
  1795 @ 0= if 1797 @ 1796 @ ! 1 else 0 then
;

: create
  state if 1 cd-error else
    1009 @ 1 - cd-trim
    here 2040 < if 8 cd-error else
      here 16374 < if
        here 1780 ! latest 1781 ! 0 1008 !
        latest ,
        cd-name if
          1780 @ 1004 ! here 1783 ! here 1008 !
          10 , here 4 + , 13 , here 1 + , 0 ,
          1773 @ if 1783 @ cd-top 2 + ! then
        else
          1780 @ 1000 ! 1781 @ 1004 ! 8 cd-error
        then
      else
        8 cd-error
      then
    then
  then
;

: cd-valid-child?
  1791 @ 2040 < if 0 else
    1791 @ 16379 < if
      1791 @ @ 10 = if
        1791 @ 1 + @ 1791 @ 5 + = if
          1791 @ 2 + @ 13 = if
            1791 @ 3 + @ 1791 @ 4 + = if
              1791 @ 4 + @ 0=
            else 0 then
          else 0 then
        else 0 then
      else 0 then
    else 0 then
  then
;

: cd-runtime
  1009 @ 1 - 0= if 4 cd-error else
    r> 1775 ! 1775 @ >r
    1009 @ 1 - cd-trim
    1773 @ if
      cd-top 4 + @ 1775 @ = if
        cd-top 2 + @ 1791 !
        cd-valid-child? if
          1775 @ 1 + @ 1791 @ 3 + !
          0 cd-top 2 + !
        else
          4 cd-error
        then
      else
        4 cd-error
      then
    else
      4 cd-error
    then
  then
;
latest dup 1 + @ + 2 + 1770 !

: cd-copy-name
  1784 @ 1 + @ , 0 1790 !
  begin
    1790 @ 1784 @ 1 + @ < if
      1784 @ 2 + 1790 @ + @ ,
      1790 @ 1 + 1790 !
      0
    else
      1
    then
  until
;

: cd-rebind
  1785 @ 1792 !
  begin
    1792 @ 1786 @ 1 - < if
      1792 @ @ 1793 !
      1793 @ 10 = if 2 else
        1793 @ 13 = if 2 else
          1793 @ 14 = if 2 else
            1793 @ 1785 @ = if 1789 @ 1792 @ ! then
            1
          then
        then
      then
      1792 @ + 1792 !
      0
    else
      1
    then
  until
;

: cd-install
  1013 @ 1784 !
  1784 @ dup 1 + @ + 2 + 1785 !
  here 1 + 1786 !
  1770 @ , 0 , here 1787 ! 0 ,
  here 1788 ! latest , cd-copy-name
  1788 @ 1004 !
  here 1789 !
  10 , 1785 @ ,
  10 , 1786 @ ,
  1771 @ , 1785 @ , 1772 @ , 0 ,
  here 1787 @ !
  cd-rebind
;

: does>
  state 0= if 1 cd-error else
    1012 @ if 2 cd-error else
      latest 1013 @ = if
        here latest 1 + @ + 13 + 16384 < if
          cd-install
        else
          8 cd-error
        then
      else
        3 cd-error
      then
    then
  then
;
immediate
