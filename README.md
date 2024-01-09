# HADOOP ON DOCKER
## 序言
在大数据领域，[Hadoop](https://hadoop.apache.org/)生态系统是目前最受欢迎的大数据处理框架，它包括Hadoop、Hive、HBase、Spark、Flink等多个关键组件，这些组件可以协同工作，建立出一个全面的大数据处理系统。
但是，这些组件的安装和配置(完全分布式集群)是一件非常繁琐的事情。对于想入门大数据，创建一个学习用的大数据环境的同学来说，无疑是一道难以逾越的鸿沟。
本文将介绍如何使用[Docker](https://www.docker.com/)和[Ambari](https://ambari.apache.org/)，在一台主机上快速搭建Hadoop生态集群。

## 特别提醒

**本环境搭建下的hadoop生态集群供学习使用，为降低搭建难度，作者刻意弱化了集群安全性部署，故该集群不适用于生产环境。**

## 前置准备

一台Ubuntu系统的Linux宿主机(支持虚拟机)

1. 最低内存 6 G。
2. 最低存储 50 G。
3. 已经安装并配置好 docker。
4. 已经安装并配置好git。
5. 已配置好静态IP。
6. 可联网(最好可连外网)。

克隆[Github仓库](https://github.com/jarlor/hadoop_on_docker)到Linux宿主机
1. 这里提供github仓库地址:https://github.com/jarlor/hadoop_on_docker.git
1. **下文的一切操作都将基于克隆下来的仓库所在目录**

下载相关离线软件(资源比较多)

1. 这里提供百度网盘链接:https://pan.baidu.com/s/1xtXh3kLzaUQglH7OkR9Glw?pwd=o4a6
2. 请将文件下载到上一步克隆下来的仓库目录下的software/文件夹下。举例如下图:

![](https://jarlor.github.io/images/image-20231015214723532.png)

## Ambari配置与安装

### 编辑全局环境配置

本小节的目的是配置脚本运行环境必要的参数，涉及到的文件是 [hadoop_on_docker/cluster_config](https://github.com/jarlor/hadoop_on_docker/blob/main/cluster_config)。

请根据注释填写相关配置项。

```bash
#集群参数配置


#本机ip
export host_ip='192.168.100.100'
#网卡名
export netcard_name='ens33'
#网关
export host_gateway='192.168.100.2' 
#网段
export host_subnet='192.168.100.0/24'
#自定义节点ip
export ip_hadoop1='192.168.100.101'
export ip_hadoop2='192.168.100.102'
export ip_hadoop3='192.168.100.103'

#jdk文件路径
export jdk_file_path='./software/jdk-8u212-linux-x64.tar.gz'
export jdk_file_name='jdk-8u212-linux-x64.tar.gz'
```

**注:`jdk文件路径`参数暂不支持修改(当前版本暂不支持自定义jdk路径，后期计划支持)**

### 提高待运行脚本权限

本小节的目的是赋予脚本[hadoop_on_docker/cluster-control](https://github.com/jarlor/hadoop_on_docker/blob/main/cluster-control)可执行权限。相关操作如下:

```bash
chmod +x ./cluster-control
```

### 部署Ambari集群

本小节的目的是开始部署hadoop生态集群，将执行脚本[hadoop_on_docker/cluster-control](https://github.com/jarlor/hadoop_on_docker/blob/main/cluster-control)。相关操作如下:

```bash
./cluster-control build
```

注:该脚本支持多种操作，baokuo

出现以下截图内容视为启动成功:

![集群部署成功标识](https://jarlor.github.io/images/image-20231015230011968.png)

**注:如果找不到截图中的内容，大概率是日志输出太多被刷上去了。脚本未报错退出也可视为部署成功。**

### 配置与安装Ambari

本小节的目的是配置Ambari-大数据集群管理系统，后续的大数据组件(DHFS，Zookeeper等)都可经Ambari一键安装。

1.打开浏览器，进入`ambari web`端页面(如下图所示)。地址格式为**http://<Linux宿主机本机ip地址>:8080**。

> 例:我的Linux宿主机本机ip地址为`192.168.100.100`,即地址为 http://192.168.100.100:8080

![ambri web端页面](https://jarlor.github.io/images/image-20231015231151885.png)

2.登录`ambari`(登录成功后页面如下图所示),`username`和`password`如下:

```bash
username:admin
password:admin	
```

![ambari登录成功页面](https://jarlor.github.io/images/image-20231015231733821.png)

3.点击`LAUNCH INSTALL WIZARD`并配置集群名称,此处名称可自定义(如下图所示)。

![配置集群名称](https://jarlor.github.io/images/image-20231015232048711.png)

4.配置自定义软件源.并在下图红框标识处填下以下信息:

```bash
http://httpd:18080/HDP/centos7/3.1.5.0-152/
http://httpd:18080/HDP-GPL/centos7/3.1.5.0-152/
http://httpd:18080/HDP-UTILS/centos7/1.1.0.22/
```

![配置自定义软件源](https://jarlor.github.io/images/image-20231015233104611.png)

5.在指定位置填写集群节点目标主机(如下图红框所示).填写内容如下:

```
hadoop1
hadoop2
hadoop3
```

**注:此处填写内容为一行一个主机名,注意换行,注意空格。**

![集群节点目标主机填写](https://jarlor.github.io/images/image-20231015233453377.png)

6.还是在这个页面,填写ambari-server的ssh私钥.**请重写打开一个终端**,并输入以下命令获取ambari-server私钥:

```bash
docker exec -it ambari-server cat ~/.ssh/id_rsa
```

将上方命令返回的结果完整复制并完整粘贴到下图所示位置:

![配置Ambari客户端ssh私钥](https://jarlor.github.io/images/image-20231015234015525.png)

**注释:此处粘贴内容依旧要注意换行,注意空格。*

7.点击下一步,若弹出`Warning`则选择 `CONTINUE`。

8.进入集群节点的ambari-agent安装界面，等待安装成功即可点击`NEXT`(成功界面入下图所示)。

弹出`Host Check Warning`选择`OK`。

![集群节点ambari-agent安装成功界面](https://jarlor.github.io/images/image-20231015234802076.png)

## 安装大数据组件

前一章已经完成ambari-server和ambari-agent的配置与安装，为本章安装大数据组件提供了十分高效的环境。

本章将承接上一章的安装进度,继续安装常用的大数据组件:HDFS、YARN、MapReduce等。

### 勾选目标大数据组件

本小节的目的是选择我们要安装的大数据组件，如下图所示:

![要安装的大数据组件](https://jarlor.github.io/images/image-20231015235837102.png)

勾选完成后点击`NEXT`。弹出`Limited Functionality Warning`请选择`PROCEED ANYWAY`。

### 集群节点间分配组件

本小节的目的是在集群节点间分配组件，此处取ambari默认给出的分配结果即可(如下图所示)。

![ambari默认分配组件结果](https://jarlor.github.io/images/image-20231016000348606.png)

点击`NEXT`。

### 集群节点间配置主从关系

本小节的目的是在集群节点间配置部分组件的主从关系。此处**不取**ambari默认给出的配置结果。调整配置结果如下图所示:

![集群节点间主从关系配置](https://jarlor.github.io/images/image-20231016000752830.png)

点击`NEXT`。

### 配置部分组件账号密码

本小节的目的在于配置`Grafana`和`HDFS`管理员账号和密码(如下图所示)。**建议密码都设置成admin**，方便记忆及后续管理。

 ![Grafana和HDFS账号密码配置](https://jarlor.github.io/images/image-20231016001214719.png)

输入完成后点击`NEXT`。

### 配置数据目录

本小节的目的在于配置集群的数据持久化目录。此处取ambari默认给出的目录地址即可(如下图所示)。

![ambari默认给出的数据目录](https://jarlor.github.io/images/image-20231016001450332.png)

点击`NEXT`。

### 配置各组件管理员账号

本小节的目的在于配置集群各组件的账号。此处取ambari默认给出的结果即可(如下图所示)。

![ambari默认给出的账号分配](https://jarlor.github.io/images/image-20231016001649302.png)

点击`NEXT`。

### 组件资源管理配置

本小节的目的在于配置集群各组件的资源消耗管理。此处取ambari默认给出的结果即可(如下图所示)。

![ambari默认给出的组件资源管理配置](https://jarlor.github.io/images/image-20231016001917507.png)

点击`NEXT`。

### 开始部署组件

本小节开始部署各组件。

在部署前ambari要求确认部署配置信息(如下图所示)。读者确认无误后可点击`DEPLOY`。

![确认部署配置信息界面](https://jarlor.github.io/images/image-20231016002126440.png)

点击`DEPLOY`后进入正式安装界面(如下图所示)。部署耗时很长，等着吧。

![各组件部署进度界面](https://jarlor.github.io/images/image-20231016002248259.png)

出现以下界面视为部署成功:

![组件部署成功页面](https://jarlor.github.io/images/image-20231016095714323.png)

点击`NEXT`，获取集群节点间组件分配概述(如下图所示)。

![集群节点间组件分配概述](https://jarlor.github.io/images/image-20231016095953950.png)

点击`COMPLETE`，跳转至Ambari资源看板(如下图所示)。

![AMbari资源看板](https://jarlor.github.io/images/image-20231016100630253.png)

**至此,COMPLETE!**
