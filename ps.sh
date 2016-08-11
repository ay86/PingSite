echo '+=====================================+'
echo '|                                     |'
echo '|            Ping Site v1.0           |'
echo '|             Angus Young             |'
echo '|                                     |'
echo '+=====================================+'
echo '\nPing URL: '$1'\n'

count=0
total=1

if [ $2 ] && ( [ $2 = '-t' ] || [ $2 = '-T' ] ); then
	total=$3

	if [ ! $total ]; then
		total=0
	fi
fi

while ([ $count -lt $total ] || [ $total = 0 ])
do
	num=`expr $count + 1`
	if [ $num -lt 10 ]; then
		num='0'$num
	fi
	curl -o /dev/null -s -w \
		$num'    Connection: %{time_connect}s	Response: %{time_starttransfer}s	Total: %{time_total}s\n' \
		$1 --user-agent "compatible; PS Robot/1.0;" | GREP_COLOR="1;33" egrep --color=always '0\.\d+s' | GREP_COLOR="1;31" egrep --color '[1-9]+\.\d+s| '
	let count++
done

echo '\nEnd, Count: '$count'\n'