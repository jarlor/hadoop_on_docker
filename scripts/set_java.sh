#!/bin/bash

# Docker容器名称
CONTAINER1="hadoop1"
CONTAINER2="hadoop2"
CONTAINER3="hadoop3"

# 安装Java的目标目录
INSTALL_DIR="/opt/apache"

# Java安装包的本地路径
JAVA_TAR_PATH=${jdk_file_path}
#Java安装包名
JAVA_TAR_NAME=${jdk_file_name}
# 解压后的Java目录名
JAVA_DIR_NAME='jdk1.8.0_212'

# 安装Java函数
install_java() {
  echo "Installing Java on $1"
  # docker exec -it "$1" mkdir -p "$INSTALL_DIR"
  docker cp "$JAVA_TAR_PATH" "$1:/"
  docker exec -it "$1" mkdir -p $INSTALL_DIR/$JAVA_DIR_NAME
  docker exec -it "$1" tar -xzf "/$JAVA_TAR_NAME" -C "$INSTALL_DIR/$JAVA_DIR_NAME" --strip-components 1
  # 设置Java环境变量
  docker exec -it "$1" sh -c "echo 'export JAVA_HOME=$INSTALL_DIR/$JAVA_DIR_NAME' >> /root/.bashrc"
  docker exec -it "$1" sh -c "echo 'export PATH=\$PATH:\$JAVA_HOME/bin' >> /root/.bashrc"
  docker exec -it "$1" sh -c "source /root/.bashrc"
  echo "Java installed on $1"
}


# 声明容器列表
containers=("$CONTAINER1" "$CONTAINER2" "$CONTAINER3")

# 循环遍历容器列表并安装Java
for container in "${containers[@]}"; do
  install_java "$container"
done

echo "Java installation completed on all containers."
