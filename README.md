# NTP-Server-Setup
一键设置 NTP 服务器脚本

```shell
[root@localhost opt]# ./install_ntp.sh -h

NTP Server config
v1.0.0

	-h help
	-s NTP-Server
		eg: 120.25.115.20 or ntp1.aliyun.com
	-c NTP-Client CIDR ip
		eg: 192.168.1.0
	-n NTP-Client CIDR netmask
		eg: 255.255.255.0

	eg: ./install_ntp.sh -s ntp1.aliyun.com -c 192.168.1.0 -n 255.255.255.0

```
一键设置 NTP 客户端脚本

```shell
[root@localhost opt]# ./install_ntpdate.sh -h

NTP Client config
v1.0.0

	-h help
	-s NTP-Server
		eg: 120.25.115.20 or ntp1.aliyun.com

	eg: ./install_ntpdate.sh -s ntp1.aliyun.com
```
