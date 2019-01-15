#!/bin/bash

server=""

# get system type
getsys() {
	if [ ! -f "/etc/redhat-release" ]; then
		system="ubuntu"
	else
		system="centos"
	fi
	echo $system
}

# main
# get user input
while getopts "s:c:n:h" opt
do
	case $opt in
	h)
		echo ""
		echo "NTP Client config"
		echo "v1.0.0"
		echo ""
		echo "	-h help"
		echo "	-s NTP-Server"
		echo "		eg: 120.25.115.20 or ntp1.aliyun.com"
		echo ""
		echo "	eg: ./install_ntpdate.sh -s ntp1.aliyun.com"
		echo ""
		exit 0;
		;;
	s)
		server=$OPTARG
		;;
	esac
done

system=`getsys`

if [ "$system" == "" ]; then
	echo "unknown system type"
	exit 1;
fi
if [ "$server" == "" ]; then
	echo "NTP-Server is needed"
	exit 1;
fi

# change time zone
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# config NTP-Server
if [ "$system" == "centos" ]; then
	if [ `yum list installed |grep ntpd |wc -l` == '0' ]; then
		yum -y install ntpdate
	fi
	systemctl stop ntpd
else
	if [ `dpkg -l |grep ntpd |wc -l` == '0' ]; then
		apt -y install ntpdate
	fi
	/etc/init.d/ntp stop
fi

/usr/sbin/ntpdate $server
echo "0 0 * * * /usr/sbin/ntpdate $server" >> /etc/crontab
