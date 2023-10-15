#!/bin/bash
# Docker容器名称
CONTAINER1="hadoop1"
CONTAINER2="hadoop2"
CONTAINER3="hadoop3"
CONTAINER4="ambari-server"


#针对ambari-server容器的特殊操作
specify_ambari_server() {
  docker exec -it ambari-server  /bin/bash -c 'echo "Port 222" >> /etc/ssh/sshd_config'
}

# 生成SSH密钥对并将公钥复制到上下文环境
generate_ssh_key() {
  docker exec -it $1 rm -rf /root/.ssh/id_rsa*
  docker exec -it $1 ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ""
}

#copy出密钥并且追加到上下文环境中的authorized_keys
operate_ssh_key() {
  docker cp $1:/root/.ssh/id_rsa.pub ./id_rsa.pub
  cat ./id_rsa.pub >> ./authorized_keys
  rm ./id_rsa.pub
}
# 复制上下文环境的SSH公钥集合到容器
copy_ssh_keys_to_container() {
  docker cp ./authorized_keys $1:/root/.ssh/authorized_keys
}

#禁止ssh严格主机检查
foribidden_StrictHostKeyChecking() {
  docker exec -it $1 /bin/bash -c 'echo StrictHostKeyChecking no >> /etc/ssh/ssh_config'
  #如果$1的值是ambari-server
  if [ $1 = "ambari-server" ]; then
    specify_ambari_server
  fi
  #重启ssh服务
  docker exec -it $1 systemctl restart sshd
}

# 设置SSH免密登录
setup_ssh_key_for_container() {
  echo "Setting up SSH key for $1"
  generate_ssh_key $1
  operate_ssh_key $1
}

#回写密钥到各个容器
set_ssh_keys_to_container() {
  copy_ssh_keys_to_container $1
  docker exec -it $1 chmod 600 ~/.ssh/authorized_keys
}

# 声明容器列表
containers=("$CONTAINER1" "$CONTAINER2" "$CONTAINER3" "$CONTAINER4")

# 循环遍历容器列表并为每个容器设置SSH免密登录
for container in "${containers[@]}"; do
    setup_ssh_key_for_container "$container"
done


# 将SSH公钥集合回写到各个容器,并禁止ssh严格主机检查后重启ssh服务
for container in "${containers[@]}"; do
    set_ssh_keys_to_container "$container"
    foribidden_StrictHostKeyChecking "$container"
done

echo "SSH setup completed for all containers."