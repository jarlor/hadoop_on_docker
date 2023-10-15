FROM registry.cn-hangzhou.aliyuncs.com/bigdata_cloudnative/ambari:2.7.5.0
#安装ssh
RUN yum -y install openssh-server --disablerepo=HDP-3.1.5.0 --disablerepo=HDP-UTILS-1.1.0.22 --disablerepo=ambari-2.7.5.0 && ssh-keygen -A

RUN echo 'root:root' | chpasswd
