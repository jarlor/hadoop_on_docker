#!/bin/bash

# 安装 Apache2
sudo apt update
sudo apt install apache2 -y

# 配置 Apache2 监听端口
echo "Listen 18080" | sudo tee -a /etc/apache2/ports.conf

# 重启 Apache2 以应用更改
sudo systemctl restart apache2
#设置开机自启动
sudo systemctl enable apache2


#建立离线文件到 Apache2 的根目录的软链接
ln -s ./software/ambari/ambari /var/www/html/
ln -s ./software/ambari/HDP /var/www/html/
ln -s ./software/ambari/HDP-GPL /var/www/html/
ln -s ./software/ambari/HDP-UTILS /var/www/html/



# 输出配置信息
echo "Apache2 has been installed and configured to listen on ports 80 and 18080."
