# 1.2 Hibernate的一对多关联映射
## 1.2.1 数据库表与表之间的关系
### 1.2.1.1 一对多关系
**什么样关系属于一对多？**
一个部门对应多个员工，一个员工只能属于某一个部门。
一个客户对应多个联系人，一个联系人只能属于某一个客户。
**一对多的建表原则**
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315084208793.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
### 1.2.1.2 多对多关系
**什么样关系属于多对多？**
一个学生可以选择多门课程，一门课程也可以被多个学生选择。
一个用户可以选择多个角色，一个角色也可以被多个用户选择。
**多对多的建表原则**
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315084349349.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
### 1.2.1.3 一对一关系
**什么样关系属于一对一？**
一个公司只能有一个注册地址，一个注册地址只能被一个公司注册。
**一对一的建表原则**
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315084431993.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
## 1.2.2 Hibernate一对多的关系配置
### 1.2.2.1 创建一个项目，引入相应jar包
### 1.2.2.2 创建数据库和表
```sql
CREATE TABLE `cst_customer` (
  `cust_id` bigint(32) NOT NULL AUTO_INCREMENT COMMENT '客户编号(主键)',
  `cust_name` varchar(32) NOT NULL COMMENT '客户名称(公司名称)',
  `cust_source` varchar(32) DEFAULT NULL COMMENT '客户信息来源',
  `cust_industry` varchar(32) DEFAULT NULL COMMENT '客户所属行业',
  `cust_level` varchar(32) DEFAULT NULL COMMENT '客户级别',
  `cust_phone` varchar(64) DEFAULT NULL COMMENT '固定电话',
  `cust_mobile` varchar(16) DEFAULT NULL COMMENT '移动电话',
  PRIMARY KEY (`cust_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
```
```sql
CREATE TABLE `cst_linkman` (
  `lkm_id` bigint(32) NOT NULL AUTO_INCREMENT COMMENT '联系人编号(主键)',
  `lkm_name` varchar(16) DEFAULT NULL COMMENT '联系人姓名',
  `lkm_cust_id` bigint(32) DEFAULT NULL COMMENT '客户id',
  `lkm_gender` char(1) DEFAULT NULL COMMENT '联系人性别',
  `lkm_phone` varchar(16) DEFAULT NULL COMMENT '联系人办公电话',
  `lkm_mobile` varchar(16) DEFAULT NULL COMMENT '联系人手机',
  `lkm_email` varchar(64) DEFAULT NULL COMMENT '联系人邮箱',
  `lkm_qq` varchar(16) DEFAULT NULL COMMENT '联系人qq',
  `lkm_position` varchar(16) DEFAULT NULL COMMENT '联系人职位',
  `lkm_memo` varchar(512) DEFAULT NULL COMMENT '联系人备注',
  PRIMARY KEY (`lkm_id`),
  KEY `FK_cst_linkman_lkm_cust_id` (`lkm_cust_id`),
  CONSTRAINT `FK_cst_linkman_lkm_cust_id` FOREIGN KEY (`lkm_cust_id`) REFERENCES `cst_customer` (`cust_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315085027718.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
### 1.2.2.3 创建实体
- 一的一方的实体
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315085113952.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
-  多的一方的实体
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315085140542.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
### 1.2.2.4 创建映射文件
- 一的一方的映射的创建
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315085217626.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
- 多的一方的映射的创建
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315085248567.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
### 1.2.2.5 创建核心配置文件
- hibernate.cfg.xml中增加
```html
<!-- 引入映射 -->
<mapping resource="com/itheima/hibernate/domain/Customer.hbm.xml"/>
<mapping resource="com/itheima/hibernate/domain/LinkMan.hbm.xml"/>
```
- log4j.properties
```
### direct log messages to stdout ###
log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.Target=System.err
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%d{ABSOLUTE} %5p %c{1}:%L - %m%n

### direct messages to file mylog.log ###
log4j.appender.file=org.apache.log4j.FileAppender
log4j.appender.file.File=c\:mylog.log
log4j.appender.file.layout=org.apache.log4j.PatternLayout
log4j.appender.file.layout.ConversionPattern=%d{ABSOLUTE} %5p %c{1}:%L - %m%n

### set log levels - for more verbose logging change 'info' to 'debug' ###
# error warn info debug trace
log4j.rootLogger= info, stdout
```
### 1.2.2.6 引入工具类 
```java
package com.itheima.hibernate.utils;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

/**
 * Hibernate的工具类
 * @author jt
 *
 */
public class HibernateUtils {

	public static final Configuration cfg;
	public static final SessionFactory sf;
	
	static{
		cfg = new Configuration().configure();
		sf = cfg.buildSessionFactory();
	}
	
	public static Session openSession(){
		return sf.openSession();
	}
	
	public static Session getCurrentSession(){
		return sf.getCurrentSession();
	}
}
```
### 1.2.2.7 编写测试类 
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315085825765.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
## 1.2.3 Hibernate的一对多相关操作
### 1.2.3.1 一对多关系只保存一边是否可以
![在这里插入图片描述](https://img-blog.csdnimg.cn/2019031509011692.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
### 1.2.3.2 一对多的级联操作
- 什么叫做级联
级联指的是，操作一个对象的时候，是否会同时操作其关联的对象。
- 级联是有方向性
操作一的一方的时候，是否操作到多的一方
操作多的一方的时候，是否操作到一的一方
### 1.2.3.3 级联保存或更新
- 保存客户级联联系人
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315090203650.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
- 保存联系人级联客户
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315090247111.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
### 1.2.3.4 测试对象的导航
测试对象的导航
前提：一对多的双方都设置cascade="save-update"
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315090320584.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
### 1.2.3.5 级联删除
- 级联删除
删除一边的时候，同时将另一方的数据也一并删除。
- 删除客户级联删除联系人
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315090412260.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
- 删除联系人级联删除客户（基本不用）
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315090507588.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
### 1.2.3.6 一对多设置了双向关联产生多余的SQL语句
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315090539407.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
 **解决多余的SQL语句**

单向维护

使一方放弃外键维护权

    一的一方放弃。在set上配置inverse=”true”

一对多的关联查询的修改的时候。（CRM练习--）

### 1.2.3.7 区分cascade和inverse
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315090643494.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
# 1.3 Hibernate的多对多的关联映射
## 1.3.1 Hibernate 多对多关系的配置
### 1.3.1.1 创建表
- 用户表
```sql
CREATE TABLE `sys_user` (
  `user_id` bigint(32) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `user_code` varchar(32) NOT NULL COMMENT '用户账号',
  `user_name` varchar(64) NOT NULL COMMENT '用户名称',
  `user_password` varchar(32) NOT NULL COMMENT '用户密码',
  `user_state` char(1) NOT NULL COMMENT '1:正常,0:暂停',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
```
-  角色表
```sql
CREATE TABLE `sys_role` (
  `role_id` bigint(32) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(32) NOT NULL COMMENT '角色名称',
  `role_memo` varchar(128) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
```
- 中间表
```sql
CREATE TABLE `sys_user_role` (
  `role_id` bigint(32) NOT NULL COMMENT '角色id',
  `user_id` bigint(32) NOT NULL COMMENT '用户id',
  PRIMARY KEY (`role_id`,`user_id`),
  KEY `FK_user_role_user_id` (`user_id`),
  CONSTRAINT `FK_user_role_role_id` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`role_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_user_role_user_id` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```
### 1.3.1.2 创建实体
- 用户的实体
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315090905829.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
-  角色的实体
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315090936167.png)
### 1.3.1.3 创建映射
- 用户的映射
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315091000613.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
- 角色的映射
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315091026301.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
### 1.3.1.4 编写测试类
- hibernate.cfg.xml中添加
```html
<mapping resource="com/itheima/hibernate/domain/User.hbm.xml"/>
<mapping resource="com/itheima/hibernate/domain/Role.hbm.xml"/>
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315091118915.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
## 1.3.2 Hibernate的多对多的操作
### 1.3.2.1 只保存一边是否可以
不可以
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315091222897.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
### 1.3.2.2 多对多的级联保存或更新 
**保存用户级联保存角色**
多对多级联保存
保存用户级联保存角色。在用户的映射文件中配置
在User.hbm.xml中的set上配置cascade="save-update"
![在这里插入图片描述](https://img-blog.csdnimg.cn/2019031509130512.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
- 保存角色级联保存用户
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315091354785.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
### 1.3.2.3 多对多的级联删除（基本用不上）
- 删除用户级联删除角色
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315091421412.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
- 删除角色级联删除用户
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315091443588.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
### 1.3.2.4 多对多的其他的操作
- 给用户选择角色
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315091509919.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
- 给用户改选角色
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315091533975.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
- 给用户删除角色
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315091552717.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190315091614630.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
