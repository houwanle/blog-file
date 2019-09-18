# 两台主机CentOS6上安装六个redis构成集群

## 1. 安装
redis采用升级方式安装(假设redis集群所用端口为6379，6380，6381，确保这三个端口没有被其他程序占用):

以root身份执行下列命令安装redis:
```bash
rpm -Uvh jemalloc-3.6.0-1.el6.x86_64.rpm
rpm -Uvh redis-3.2.12-2.el6.x86_64.rpm
rpm -Uvh openssl-1.0.1e-57.el6.x86_64.rpm
rpm -Uvh zlib-1.2.3-29.el6.x86_64.rpm
rpm -Uvh libyaml-0.1.3-4.el6_6.x86_64.rpm
rpm -Uvh ruby-2.4.3-1.2.x86_64.rpm

gem install -l redis-4.1.2.gem
cp redis-trib.rb /usr/bin
chmod a+x /usr/bin/redis-trib.rb
```

## 2. 配置
安装成功后，redis的配置文件为/etc/redis.conf
默认的端口为6379，修改/etc/redis.conf的相关内容为：
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

## 3. 服务
修改redis(文件为：/etc/init.d/redis)中的相关内容为：
```
shut="/usr/libexec/redis-shutdown redis"
pidfile="/var/run/redis/redis1.pid"
ExecStartPre=/usr/bin/mkdir -p /var/lib/redis/redis1

mkdir -p /var/lib/redis/redis1
chown redis:redis /var/lib/redis/redis1
  
lockfile=/var/lock/subsys/redis1
```

## 4. 管理
安装成功后，redis的服务端程序redis-server将以服务的形式运行，采用管理服务的方式进行管理(start,stop,restart,status)
- 启动服务
```bash
service redis start
```
- 停止服务
```bash
service redis stop
```

## 5. 开机自动启动
以root身份执行下列命令来确保redis-server开机自动启动
```bash
chkconfig redis on
```

注：也可以运行ntsysv程序在图形界面中进行设置

## 6. 安装第二个redis
### 6.1 配置
复制/etc/redis.conf文件为/etc/redis2.conf
确保文件的权限,执行命令：
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

### 6.2 服务
复制/etc/init.d/redis文件为/etc/init.d/redis2
redis2中的相关内容为：
```
shut="/usr/libexec/redis-shutdown redis2"
pidfile="/var/run/redis/redis2.pid"
ExecStartPre=/usr/bin/mkdir -p /var/lib/redis/redis2

mkdir -p /var/lib/redis/redis2
chown redis:redis /var/lib/redis/redis2
  
lockfile=/var/lock/subsys/redis2
```

### 6.3 管理
安装成功后，redis2将以服务的形式运行，采用管理服务的方式进行管理(start,stop,restart,status)

- 启动服务
```bash
service redis2 start
```
- 停止服务
```bash
service redis2 stop
```

### 6.4 开机自动启动
以root身份执行下列命令来确保redis2开机自动启动
```bash
chkconfig redis2 on
```

注：也可以运行ntsysv程序在图形界面中进行设置

## 7. 安装第三个redis
重复步骤6，将其中的redis2对应修改为redis3，将6380修改为6381

## 8. 在第二台机器上按照上述步骤安装好三个redis
## 9. 配置redis集群
在两台机器上修改文件/usr/lib64/ruby/gems/2.4.0/gems/redis-4.1.2/lib/redis/client.rb如下(设置访问redis的密码)：
```
password => "123456"
```
以root身份执行下列命令(假如两台机器的ip地址分别为host1和host2，安装的redis所用的端口分别为6379，6380，6381)
```bash
redis-trib.rb create --replicas 1 host1:6379 host1:6380 host1:6381 host2:6379 host2:6380 host2:6381
```

给出提示时输入yes然后回车键确认，如下所示
```
Can I set the above configuration? (type 'yes' to accept): yes
```

成功的话应该会看到包含有下列信息：
```
[OK] All nodes agree about slots configuration.
```

三台主机CentOS6上安装九个redis构成集群也适用。