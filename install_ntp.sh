#!/bin/bash

server=""
client=""
netmask=""
system=""

# get system type
getsys() {
	if [ ! -f "/etc/redhat-release" ]; then
		system="ubuntu"
	else
		system="centos"
	fi
	echo $system
}

# centos config ntp
centos() {
	if [ `yum list installed |grep ntpd |wc -l` == '0' ]; then
		yum -y install ntp
	fi
	sed -i "s/server/# server/g" /etc/ntp.conf
	echo "server $1 iburst" >> /etc/ntp.conf
	echo "restrict $2 mask $3 nomodify" >> /etc/ntp.conf
	systemctl restart ntpd
}

# ubuntu config ntp
ubuntu() {
	if [ `dpkg -l |grep ntpd |wc -l` == '0' ]; then
		apt -y install ntp
	fi
	sed -i "s/server/# server/g" /etc/ntp.conf
	echo "server $1 iburst" >> /etc/ntp.conf
	echo "restrict $2 mask $3 nomodify" >> /etc/ntp.conf
	/etc/init.d/ntp restart
}

# main
# get user input
while getopts "s:c:n:h" opt
do
	case $opt in
	h)
		echo ""
		echo "NTP Server config"
		echo "v1.0.0"
		echo ""
		echo "	-h help"
		echo "	-s NTP-Server"
		echo "		eg: 120.25.115.20 or ntp1.aliyun.com"
		echo "	-c NTP-Client CIDR ip"
		echo "		eg: 192.168.1.0"
		echo "	-n NTP-Client CIDR netmask"
		echo "		eg: 255.255.255.0"
		echo ""
		echo "	eg: ./install_ntp.sh -s ntp1.aliyun.com -c 192.168.1.0 -n 255.255.255.0"
		echo ""
		exit 0;
		;;
	s)
		server=$OPTARG
		;;
	c)
		client=$OPTARG
		;;
	n)
		netmask=$OPTARG
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
if [ "$client" == "" ]; then
	echo "NTP-Client CIDR IP is needed"
	exit 1;
fi
if [ "$netmask" == "" ]; then
	echo "NTP-Client CIDR netmask is needed"
	exit 1;
fi

# change time zone
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# config NTP-Server
if [ "$system" == "centos" ]; then
	centos $server $client $netmask
else
	ubuntu $serevr $client $netmask
fi

