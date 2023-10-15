#!/bin/bash

# 检查是否存在主机名映射并添加
add_host_if_not_exists() {
    if ! grep -q "$1" /etc/hosts; then
        echo "$1" >> /etc/hosts
    fi
}

# 添加主机名映射（如果不存在）
add_host_if_not_exists "${ip_hadoop1} hadoop1"
add_host_if_not_exists "${ip_hadoop2} hadoop2"
add_host_if_not_exists "${ip_hadoop3} hadoop3"
add_host_if_not_exists "127.0.0.1 mysql-test"
add_host_if_not_exists "127.0.0.1 httpd"

echo "Hosts configuration has been updated."