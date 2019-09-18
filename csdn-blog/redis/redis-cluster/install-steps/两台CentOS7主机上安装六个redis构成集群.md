## 1.检查软件包
在开始安装redis之前，请确认已经获得以下软件包，若没有，下载地址为（包含配置文件和安装包）：https://github.com/houwanle/blog-file/tree/master/csdn-blog/redis/redis-cluster
- jemalloc-3.6.0-1.el7.x86_64.rpm
- redis-3.2.12-2.el7.x86_64.rpm
- openssl-libs-1.0.2k-12.el7.x86_64.rpm
- openssl-1.0.2k-12.el7.x86_64.rpm
- ruby-libs-2.0.0.648-35.el7_6.x86_64.rpm
- rubygems-2.0.14.1-35.el7_6.noarch.rpm
- rubygem-bigdecimal-1.2.0-35.el7_6.x86_64.rpm
- ruby-2.0.0.648-35.el7_6.x86_64.rpm
- rubygem-redis-3.2.1-2.el7.noarch.rpm
- redis-trib-3.2.12-2.el7.noarch.rpm

## 2.查看防火墙状态
运行命令：
```bash
/bin/systemctl status firewalld.service
```
查看防火墙是否关闭，如下图所示（白色为关闭，绿色为打开）：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190917160552784.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
或
![在这里插入图片描述](https://img-blog.csdnimg.cn/2019091716064057.png)
关闭防火墙，并把 `/etc/sysconfig/selinux` 中的 SELINUX 设置为 disabled 然后重启虚拟机（注意重启后firewalld也会重启），关闭防火墙就可以了。

## 3.安装
redis采用升级方式安装(假设redis集群所用端口为6379，6380，6381，确保这三个端口没有被其他程序占用)。
进入安装包所在目录，以root身份执行下列命令安装redis(两台机器都要执行）:
```bash
rpm -Uvh jemalloc-3.6.0-1.el7.x86_64.rpm
rpm -Uvh redis-3.2.12-2.el7.x86_64.rpm
rpm -Uvh openssl-libs-1.0.2k-12.el7.x86_64.rpm --nodeps
rpm -Uvh openssl-1.0.2k-12.el7.x86_64.rpm
rpm -Uvh ruby-libs-2.0.0.648-35.el7_6.x86_64.rpm
rpm -Uvh rubygems-2.0.14.1-35.el7_6.noarch.rpm --nodeps
rpm -Uvh rubygem-bigdecimal-1.2.0-35.el7_6.x86_64.rpm
rpm -Uvh ruby-2.0.0.648-35.el7_6.x86_64.rpm
rpm -Uvh rubygem-redis-3.2.1-2.el7.noarch.rpm
rpm -Uvh redis-trib-3.2.12-2.el7.noarch.rpm
```

## 4.配置
安装成功后，redis的配置文件为`/etc/redis.conf`，默认的端口为6379，修改/etc/redis.conf的相关内容为：
```
bind 0.0.0.0

port 6379

pidfile /var/run/redis_6379.pid

logfile /var/log/redis/redis1.log

dir /var/lib/redis/redis1

masterauth 123456

requirepass 123456

maxmemory-policy volatile-ttl

cluster-enabled yes

cluster-config-file nodes-6379.conf

cluster-node-timeout 15000
```

## 5.服务
修改redis.service(文件为：/lib/systemd/system/redis.service)中的[Service]相关内容为：
```
[Service]
ExecStop=/usr/libexec/redis-shutdown redis
ExecStartPre=/usr/bin/mkdir -p /var/lib/redis/redis1
```
然后执行命令：
```bash
systemctl daemon-reload
```

## 6.管理
安装成功后，redis的服务端程序redis-server将以服务的形式运行，采用管理服务的方式进行管理(start,stop,restart,status)
- 启动服务（防火墙设置）
```bash
service redis start
```
- 停止服务
```bash
service redis stop
```

## 7.开机自动启动
以root身份执行下列命令来确保redis-server开机自动启动：
```bash
chkconfig redis on
```
注：也可以运行ntsysv程序在图形界面中进行设置

## 8.安装第二个redis
### 8.1 配置
复制/etc/redis.conf文件为`/etc/redis2.conf`确保文件的权限执行命令：
```bash
chown redis:root /etc/redis2.conf
```
修改redis2.conf中的相关内容为：
```
port 6380

pidfile /var/run/redis_6380.pid

logfile /var/log/redis/redis2.log

dir /var/lib/redis/redis2

cluster-config-file nodes-6380.conf
```

### 8.2 服务
复制`/usr/lib/systemd/system/redis.service`文件为`/usr/lib/systemd/system/redis2.service`，redis2.service中的[Service]相关内容为：
```
[Service]
ExecStart=/usr/bin/redis-server /etc/redis2.conf --supervised systemd
ExecStop=/usr/libexec/redis-shutdown redis2
ExecStartPre=/usr/bin/mkdir -p /var/lib/redis/redis2
```
然后执行命令：
```bash
systemctl daemon-reload
```

### 8.3 管理
安装成功后，redis2将以服务的形式运行，采用管理服务的方式进行管理(start,stop,restart,status)
- 启动服务
```bash
service redis2 start
```
- 停止服务
```bash
service redis2 stop
```

### 8.4 开机自动启动
以root身份执行下列命令来确保mongod2开机自动启动：
```bash
chkconfig redis2 on
```
注：也可以运行ntsysv程序在图形界面中进行设置

## 9. 安装第三个redis
重复步骤8，将其中的redis2对应修改为redis3，将6380修改为6381

## 10. 在第二台机器上按照上述步骤安装好三个redis

## 11. 配置redis集群
在两台机器上修改文件/usr/share/gems/gems/redis-3.2.1/lib/redis/client.rb如下(设置访问redis的密码)：
```
password => "123456"
```
先启动所有的redis，然后以root身份执行下列命令(假如两台机器的ip地址分别为host1和host2，安装的redis所用的端口分别为6379，6380，6381):
```bash
redis-trib create --replicas 1 host1:6379 host1:6380 host1:6381 host2:6379 host2:6380 host2:6381
```
给出提示时输入yes然后回车键确认，如下所示:
```
Can I set the above configuration? (type 'yes' to accept): yes
```
成功的话应该会看到包含有下列信息：
```
[OK] All nodes agree about slots configuration.
```

**三台主机CentOS7上安装九个redis构成集群的安装步骤也适用**
