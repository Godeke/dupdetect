function ip_to_int()
{
  local IP="$1"
  local A=`echo $IP | cut -d. -f1`
  local B=`echo $IP | cut -d. -f2`
  local C=`echo $IP | cut -d. -f3`
  local D=`echo $IP | cut -d. -f4`
  local INT

  INT=`expr 256 "*" 256 "*" 256 "*" $A`
  INT=`expr 256 "*" 256 "*" $B + $INT`
  INT=`expr 256 "*" $C + $INT`
  INT=`expr $D + $INT`

  echo $INT
}

function int_to_ip()
{
  local INT="$1"

  local D=`expr $INT % 256`
  local C=`expr '(' $INT - $D ')' / 256 % 256`
  local B=`expr '(' $INT - $C - $D ')' / 65536 % 256`
  local A=`expr '(' $INT - $B - $C - $D ')' / 16777216 % 256`

  echo "$A.$B.$C.$D"
}

S=`ip_to_int 192.168.0.1`
E=`ip_to_int 192.168.0.254`

for INT in `seq $S 1 $E`
do
  IP=`int_to_ip $INT`
  echo $IP # do something with $IP here

  sudo arping -d -D -I eth0 -c 2 $IP;
  rc=$?
  if [ "$rc" = "1" ] #arping exits with code 1 if duplicate found when using flag -d
  then
    echo $IP DUPLICATED!
  fi
done

