#!/bin/bash

#设置集群环境变量

echo "Setting up cluster environment variables"

# Docker容器名称
CONTAINER1="hadoop1"
CONTAINER2="hadoop2"
CONTAINER3="hadoop3"

HOST_IP=${host_ip}

#设置yum源
set_yum_repo() {
  docker exec -it ambari-server scp /etc/yum.repos.d/hdp.repo $1:/etc/yum.repos.d/
}

set_httpd_host(){
    docker exec -it $1 /bin/bash -c "echo \"$HOST_IP httpd\" >> /etc/hosts"
    docker exec -it $1 /bin/bash -c "echo \"$HOST_IP ambari-server\" >> /etc/hosts"
}

# 声明容器列表
containers=("$CONTAINER1" "$CONTAINER2" "$CONTAINER3")

# 循环遍历容器列表并安装Java
for container in "${containers[@]}"; do
    set_yum_repo "$container"
    set_httpd_host "$container"
done

echo "Cluster environment variables set up on all containers."