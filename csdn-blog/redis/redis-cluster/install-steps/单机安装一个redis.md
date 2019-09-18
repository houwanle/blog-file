# 单机安装一个redis
## 1. 安装：redis采用升级方式安装:
- CentOS6,以root身份执行下列命令升级安装redis:
```bash
rpm -Uvh jemalloc-3.6.0-1.el6.x86_64.rpm
rpm -Uvh redis-3.2.12-2.el6.x86_64.rpm
```
- CentOS7,以root身份执行下列命令安装redis:
```bash
rpm -Uvh jemalloc-3.6.0-1.el7.x86_64.rpm
rpm -Uvh redis-3.2.12-2.el7.x86_64.rpm
```

## 2. 配置
安装成功后，redis的配置文件为/etc/redis.conf

## 3. 管理
安装成功后，redis的服务端程序redis-server将以服务的形式运行，采用管理服务的方式进行管理(start,stop,restart,status)
- 启动服务
```bash
service redis start
```
- 停止服务
```bash
service redis stop
```

注：CentOS6中service redis stop命令无效

## 4. 开机自动启动
以root身份执行下列命令来确保redis-server开机自动启动：
```bash
chkconfig redis on
```

注：也可以运行ntsysv程序在图形界面中进行设置
