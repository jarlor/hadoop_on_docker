#!/bin/bash

#配置主机hosts
echo "Add hosts to /etc/hosts"

echo "${ip_hadoop1} hadoop1" >> /etc/hosts
echo "${ip_hadoop2} hadoop2" >> /etc/hosts
echo "${ip_hadoop3} hadoop3" >> /etc/hosts

echo "127.0.0.1 mysql-test" >> /etc/hosts
echo "127.0.0.1 httpd" >> /etc/hosts
