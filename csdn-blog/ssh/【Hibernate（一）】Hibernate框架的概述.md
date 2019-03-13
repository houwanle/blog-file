#  1. 框架的概述

## 1.1 什么是框架
框架：指的是软件的半成品，已经完成了部分功能。

## 1.2 Java EE的三层结构

### 1.2.1 Java EE的经典三层结构
![在这里插入图片描述](https://img-blog.csdn.net/20181019160713271?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 1.3 Hibernate概述

### 1.3.1 什么是Hibernate
![在这里插入图片描述](https://img-blog.csdn.net/2018102310342074?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
Hibernate：Hibernate是一个$\color{red}{持久层}$的$\color{red}{ORM}$框架。

### 1.3.2	什么是ORM
ORM：Object Relational Mapping（对象关系映射）。指的是将一个Java中的对象与关系型数据库中的表建立一种映射关系，从而操作对象就可以操作数据库中的表。
![在这里插入图片描述](https://img-blog.csdn.net/201810231038515?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

### 1.3.3	为什么要学习Hibernate
![在这里插入图片描述](https://img-blog.csdn.net/20181023104140431?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 1.4	Hibernate的入门

### 1.4.1	下载Hibernate的开发环境
Hibernate3.x  Hibernate4.x  Hibernate5.x
https://sourceforge.net/projects/hibernate/files/hibernate-orm/5.0.7.Final/

### 1.4.2	解压Hibernate
![在这里插入图片描述](https://img-blog.csdn.net/20181023104609893?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
- documentation	:Hibernate开发的文档
- lib					        :Hibernate开发包
    - required			:Hibernate开发的必须的依赖包
    - optional			:Hibernate开发的可选的jar包
- project		:Hibernate提供的项目

### 1.4.3	创建一个项目，引入jar包
- 数据库驱动包
- Hibernate开发的必须的jar包
- Hibernate引入日志记录包
![在这里插入图片描述](https://img-blog.csdn.net/20181023105311420?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

### 1.4.4	创建表
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

### 1.4.5	创建实体类
```java
public class Customer {
	private Long cust_id;
	private String cust_name;
	private String cust_source;
	private String cust_industry;
	private String cust_level;
	private String cust_phone;
	private String cust_mobile;
}
```

### 1.4.1.6	创建映射
映射需要通过XML的配置文件来完成，这个配置文件可以任意命名。尽量统一命名规范（类名.hbm.xml）
**Customer.hbm.xml文件配置（一般和实体类放在同一个包下）：**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE hibernate-mapping PUBLIC 
    "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
    "http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
<hibernate-mapping>
	<!-- 建立类与表的映射 -->
	<class name="com.itheima.hibernate.demo1.Customer" table="cst_customer">
		<!-- 建立类中的属性与表中的主键对应 -->
		<id name="cust_id" column="cust_id" >
			<generator class="native"/>
		</id>
		
		<!-- 建立类中的普通的属性和表的字段的对应 -->
		<property name="cust_name" column="cust_name" length="32" />
		<property name="cust_source" column="cust_source" length="32"/>
		<property name="cust_industry" column="cust_industry"/>
		<property name="cust_level" column="cust_level"/>
		<property name="cust_phone" column="cust_phone"/>
		<property name="cust_mobile" column="cust_mobile"/>
	</class>
</hibernate-mapping>
```

### 1.4.7	创建一个Hibernate的核心配置文件
Hibernate的核心配置文件的名称：hibernate.cfg.xml
**hibernate.cfg.xml文件配置（一般直接放到src下）**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE hibernate-configuration PUBLIC
	"-//Hibernate/Hibernate Configuration DTD 3.0//EN"
	"http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">
<hibernate-configuration>
	<session-factory>
		<!-- 连接数据库的基本参数 -->
		<property name="hibernate.connection.driver_class">com.mysql.jdbc.Driver</property>
		<property name="hibernate.connection.url">jdbc:mysql://localhost/hibernate_day01</property>
		<property name="hibernate.connection.username">root</property>
		<property name="hibernate.connection.password">abc</property>
		<!-- 配置Hibernate的方言 -->
		<property name="hibernate.dialect">org.hibernate.dialect.MySQLDialect</property>
		
		<!-- 可选配置================ -->
		<!-- 打印SQL -->
		<property name="hibernate.show_sql">true</property>
		<!-- 格式化SQL -->
		<property name="hibernate.format_sql">true</property>
		<!-- 自动创建表 -->
		<property name="hibernate.hbm2ddl.auto">update</property>
		
		<mapping resource="com/itheima/hibernate/demo1/Customer.hbm.xml"/>
	</session-factory>
</hibernate-configuration>
```
### 1.4.8	编写测试代码
```java
package com.itheima.hibernate.demo1;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.junit.Test;

/**
 * Hibernate的入门案例
 * @author jt
 *
 */
public class HibernateDemo1 {

	@Test
	// 保存客户的案例
	public void demo1(){
		// 1.加载Hibernate的核心配置文件
		Configuration configuration = new Configuration().configure();
		// 手动加载映射
		// configuration.addResource("com/itheima/hibernate/demo1/Customer.hbm.xml");
		// 2.创建一个SessionFactory对象：类似于JDBC中连接池
		SessionFactory sessionFactory = configuration.buildSessionFactory();
		// 3.通过SessionFactory获取到Session对象：类似于JDBC中Connection
		Session session = sessionFactory.openSession();
		// 4.手动开启事务：
		Transaction transaction = session.beginTransaction();
		// 5.编写代码
		
		Customer customer = new Customer();
		customer.setCust_name("王西");
		
		session.save(customer);
		
		// 6.事务提交
		transaction.commit();
		// 7.资源释放
		session.close();
		sessionFactory.close();
	}
}
```

## 1.5	Hibernate的常见配置

### 1.5.1	XML提示的配置

- **配置XML提示问题**
![在这里插入图片描述](https://img-blog.csdn.net/20181023144313905?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
![在这里插入图片描述](https://img-blog.csdn.net/20181023144710827?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

###  1.5.2	Hibernate的映射的配置

**映射的配置**
【class标签的配置】
- 标签用来建立类与表的映射关系
- 属性：
    - name:类的全路径
    - table:表名（类名与表名一致，table可以省略）
    - catalog:数据库名

【id标签的配置】
- 标签用来建立类中的属性与表中的主键的对应关系
- 属性：
    - name:类中的属性名
    - column:表中的字段名（类中的属性名和表中的字段名如果一致，column可以省略）
    - length:长度
    - type:类型

【property标签的配置】
- 标签用来建立类中的普通属性与表的字段的对应关系
- 属性：
    - name;类中的属性名
    - column:表中的字段名
    - length:长度
    - type:类型
    - not-null:设置非空
    - unique:设置唯一

### 1.5.3	Hibernate的核心的配置

**Hibernate的核心配置方式**
1. 一种方式:属性文件的方式
- hibernate.properties
    - hibernate.connection.driver_class=com.mysql.jdbc.Driver
    - …
    - hibernate.show_sql=true
- 属性文件的方式不能引入映射文件（手动编写代码加载映射文件）

2. 二种方式:XML文件的方式
- hibernate.cfg.xml

**核心的配置**
- 必须的配置
	- 连接数据库的基本的参数
		- 驱动类
		- url路径
		- 用户名
		- 密码
	- 方言
- 可选的配置
	- 显示SQL：hibernate.show_sql
	- 格式化SQL：hibernate.format_sql
	- 自动建表：hibernate.hbm2ddl.auto
		- none：不适用hibernate的自动建表
		- create：如果数据库中已经有表，删除原有表，重新创建，如果没有表，新建表。（测试）
		- create-drop：如果数据库中已经有表，删除原有表，执行操作，删除这个表。如果没有表，新建一个，使用完了删除该表。（测试）
		- update：如果数据库中有表，使用原有表，如果没有表，创建新表（更改新表结构）
		- validate：如果没有表，不会创建表。只会使用数据库中原有的表。（校验映射和表结构）
- 映射文件的引入
	- 引入映射文件的位置
```xml
<mapping resource="com/itheima/hibernate/demo1/Customer.hbm.xml"/>
```

## 1.6	Hibernate的核心API

### 1.6.1	Configuration：Hibernate的配置对象
![在这里插入图片描述](https://img-blog.csdn.net/20181023155840446?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
- 作用：
	- 加载核心配置文件
 1. hibernate.properties
```java
Configuration cfg = new Configuration();
```
2. hibernate.cfg.xml
```java
Configuration cfg = new Configuration().configure();
```
	
   - 加载映射文件
 
```java
// 手动加载映射
configuration.addResource("com/itheima/hibernate/demo1/Customer.hbm.xml");
```

### 1.6.2	SessionFactory：Session工厂
![在这里插入图片描述](https://img-blog.csdn.net/20181023161428281?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
SessionFactory内部维护了Hibernate的连接池和Hibernate的二级缓存（不讲）。是线程安全的对象。一个项目创建一个对象即可。

**配置连接池：（了解）**
引入C3P0的jar包，然后将以下内容粘贴到核心配置文件hibernate.cfg.xml中
```xml
<!-- 配置C3P0连接池 -->
		<property name="connection.provider_class">org.hibernate.connection.C3P0ConnectionProvider</property>
		<!--在连接池中可用的数据库连接的最少数目 -->
		<property name="c3p0.min_size">5</property>
		<!--在连接池中所有数据库连接的最大数目  -->
		<property name="c3p0.max_size">20</property>
		<!--设定数据库连接的过期时间,以秒为单位,
		如果连接池中的某个数据库连接处于空闲状态的时间超过了timeout时间,就会从连接池中清除 -->
		<property name="c3p0.timeout">120</property>
		 <!--每3000秒检查所有连接池中的空闲连接 以秒为单位-->
		<property name="c3p0.idle_test_period">3000</property>
```

**抽取工具类**
```java
public class HbernateUtils {
	
	public static final Configuration cfg;
	public static final SessionFactory sf;

	static {
		cfg = new Configuration().configure();
		sf = cfg.buildSessionFactory();
	}

	public static Session openSession(){
		return sf.openSession();
	}
}
```

**Hibernate工具类的测试**
```java
public class HibernateDemo2 {
	@Test
	//保存客户
	public void demo1(){
		Session session = HibernateUtils.openSession();
		Transaction tx = session.beginTransaction();

		Customer customer = new Customer();
		customer.setCust_name("王晓东");
		session.save(customer);
		
		tx.commit();
		session.close();
	}
}
```

### 1.6.3	Session：类似Connection对象是连接对象
![在这里插入图片描述](https://img-blog.csdn.net/2018102316445830?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
Session代表的是Hibernate与数据库的链接对象。不是线程安全的。与数据库交互桥梁。
![在这里插入图片描述](https://img-blog.csdn.net/20181023164615791?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
![在这里插入图片描述](https://img-blog.csdn.net/20181023164722284?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
![在这里插入图片描述](https://img-blog.csdn.net/20181023164819491?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
![在这里插入图片描述](https://img-blog.csdn.net/20181023164850172?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
![在这里插入图片描述](https://img-blog.csdn.net/20181023164945991?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
![在这里插入图片描述](https://img-blog.csdn.net/20181023165021519?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
![在这里插入图片描述](https://img-blog.csdn.net/20181023165114351?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
- 查询所有
![在这里插入图片描述](https://img-blog.csdn.net/20181023165231723?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

### 1.6.4	Transaction：事务对象
**Hibernate中管理事务的对象。**
- commit();
- rollback();

## 1.7 总结
![在这里插入图片描述](https://img-blog.csdn.net/20181023195227607?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
