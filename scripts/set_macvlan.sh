#将容器的IP地址添加到宿主机的路由表中

#!/bin/bash
echo "Setting up macvlan for Host"

#开启网卡混杂模式
ip link set ${netcard_name} promisc on
#通过 macvlan 添加一块虚拟网口macvlan0-host来实现容器与宿主机互通
ip link add link ${netcard_name} macvlan0-host type macvlan mode bridge
#开启macvlan0-host
ip link set dev macvlan0-host up

#指定路由
ip route add ${ip_hadoop1} dev macvlan0-host
ip route add ${ip_hadoop2} dev macvlan0-host
ip route add ${ip_hadoop3} dev macvlan0-host