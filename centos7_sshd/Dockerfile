FROM couchbase/centos7-systemd
#安装ssh
RUN yum -y update && yum -y install openssh-server && ssh-keygen -A
#设置root密码
RUN echo 'root:root' | chpasswd
# 暴露 SSH 服务端口
EXPOSE 22

# # 启动 SSH 服务器
# CMD ["/usr/sbin/sshd", "-D"]