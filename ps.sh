#!/bin/sh

#  +=====================================+
#  |                                     |
#  |            Ping Site v1.1           |
#  |             Angus Young             |
#  |                                     |
#  +=====================================+

# GREP_COLOR LIST
# 1;30 gray		灰色
# 1;31 red		红色
# 1;32 green	绿色
# 1;33 yellow	黄色
# 1;34 blue		蓝色
# 1;35 pink		粉红
# 1;36 cyan		青色
# 1;37 white	白色

count=0
total=1
max=0
min=9999999
all=0
average=0

echo '\n[PingSite] Ping '$1'\n'

function echoTotal(){
	average=`echo $all $count | awk '{ print $1/$2 }'`
	echo '---------------------------------------------------------------'
	echo 'Count:'$count'\tMin:'$min's\tMax:'$max's\tAverage:'$average's' | GREP_COLOR='1;36' egrep --color '\d+\.\d+s|\d+'
	echo ''
}

trap 'echo ""; echoTotal; exit' 2

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
	cmd=`curl -o /dev/null -s -w \
		'['$num'] Connection:%{time_connect}s Response:%{time_starttransfer}s Total:%{time_total}s' \
		$1 --user-agent 'compatible; PS Robot/1.1;'`
	timeNum=`echo $cmd | awk -F '[:s]' '{ print $8 }'`

	# 比较获取最大的时间数
	max=`echo $timeNum $max | awk '{ if ($1>$2) { print $1 } else { print $2 } }'`
	
	# 比较获取最小的时间数
	min=`echo $timeNum $min | awk '{ if ($1<$2) { print $1 } else { print $2 } }'`

	# 平均时间
	all=`echo $all $timeNum | awk '{ print $1+$2 }'`

	# 输出正常结果
	echo $cmd | awk -F ' ' '{ print $1,$2,$3,$4 }' OFS='  ' | GREP_COLOR='1;33' egrep --color=always '0\.\d+s' | GREP_COLOR='1;31' egrep --color '[1-9]+\.\d+s| '
	let count++
done

echoTotal