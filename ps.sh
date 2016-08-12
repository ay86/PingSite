#!/bin/sh

#  +=====================================+
#  |                                     |
#  |            Ping Site v1.2           |
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
seqLen=4

echo '\n[PingSite] Ping '$1'\n'

function echoTotal(){
	average=`echo ${all} ${count} | awk '{ print $1/$2 }'`
	printf %70s | tr ' ' '-'
	echo ''
	echo 'Count:'${count}'\tMin:'${min}'s\tMax:'${max}'s\tAverage:'${average}'s' | \
			GREP_COLOR='1;36' egrep --color '\d+\.\d+s|\d+'
	echo ''
}

trap 'echo ""; echoTotal; exit' 2

# 判断是否带有 T 参数，不区分大小写
if [ $2 ] && ( [ $2 = '-t' ] || [ $2 = '-T' ] ); then
	total=$3

	if [ ! ${total} ]; then
		total=0
	fi
fi

# total 为 0 代表无限循环，只能手动结束
while ([ ${count} -lt ${total} ] || [ ${total} = 0 ])
do
	seq=`expr ${count} + 1`
	seqPre=`printf '%*s' $(expr ${seqLen} - ${#seq}) | tr ' ' '='`

	cmd=`curl -o /dev/null -s -w \
		'Seq:'${seq}${seqPre}'\tConnection:%{time_connect}s\tResponse:%{time_starttransfer}s\tTotal:%{time_total}s' \
		$1 --user-agent 'compatible; PS Robot/1.2 (PingSite);'`

	# 获取本次 curl 命令的 total 时间
	timeNum=`echo ${cmd} | awk -F '[:s]' '{ print $9 }'`

	# 比较获取最大的时间数
	max=`echo ${timeNum} ${max} | awk '{ if ($1>$2) { print $1 } else { print $2 } }'`
	
	# 比较获取最小的时间数
	min=`echo ${timeNum} ${min} | awk '{ if ($1<$2) { print $1 } else { print $2 } }'`

	# 累计时间
	all=`echo ${all} ${timeNum} | awk '{ print $1+$2 }'`

	# 输出本次结果
#	echo "${cmd}"
	echo "${cmd}" | tr '=' ' ' | \
			awk -F '\t' '{ print $1,$2,$3,$4 }' OFS='  ' | \
			GREP_COLOR='1;34' egrep --color=always '0\.\d+s|\d+ ' | \
			GREP_COLOR='1;31' egrep --color '[1-9]+\.\d+s| '

	let count++

	# 为了不给目标造成太大访问压力，适当延时
	sleep 0.7
done

echoTotal