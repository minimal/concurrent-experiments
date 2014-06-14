require tasker.fs
create result 64 chars allot \ buffer for result string

: wait begin pause single-tasking? until ;
: get ( a-addr -- n )
  begin dup @ false = while pause repeat
  dup off cell+ @ ;
: put ( a-addr n -- )
  begin dup @ while pause repeat
  dup rot swap cell+ ! on ;
: addnum ( n c-addr u -- )
  rot 0 <# #s #> pad +place pad +place ;
: proc ( -- a-addr )
  s" " pad place \ clear out the string scratchpad
  2 cells allocate throw dup off dup
  64 udp * NewTask 1 swap pass
  dup get dup s"  + " addnum 
  swap dup get dup s"  + " addnum
  swap get dup s"  = " addnum
  + + s" " addnum
  pad count char+ pad result rot cmove ;
: supply ( a-addr c-addr u -- )
  64 udp * NewTask 3 swap pass
  evaluate swap put ;

proc
dup s" 2 10 *" supply
dup s" 2 20 *" supply
dup s" 30 40 +" supply
wait
result count type cr
bye