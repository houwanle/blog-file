# 1.2 持久化类的编写规则
## 1.2.1 持久化类的概述
**什么是持久化类**
持久化：将内存中的一个对象持久化到数据库中过程。Hibernate框架就是用来进行持久化的框架。
持久化类：一个Java对象与数据库的表建立了映射关系，那么这个类在Hibernate中称为是持久化类。
持久化类 = Java类 + 映射文件
## 1.2.2 持久化类的编写规则
**持久化类的编写规则**
对持久化类提供一个无参的构造方法：Hibernate底层需要使用反射生成实例。
属性需要私有，对私有属性提供public的get和set方法：Hibernate中获取、设置对象的值。
对持久化类提供一个唯一标识OID与数据库的主键相对应：Java中通过对象的地址区分是否是同一个对象，数据库中通过主键确定是否是同一个记录，在Hibernate中通过持久化类的OID的属性区分是否是同一个对象。
持久化类中属性尽量使用包装类的类型：因为基本类型默认值是0，那么0就会有很多的歧义。包装类型默认值是null。
持久化类不要使用final进行修饰：延迟加载本身是hibernate一个优化的手段，返回的是一个代理对象（javassist可以对没有实现接口的类产生代理——使用了非常底层字节码增强技术，继承这个类进行代理）。如果不能被继承，不能产生代理对象，延迟加载也就失效。load方法和get方法一致。
# 1.3 主键生成策略
## 1.3.1 主键的分类
**自然主键**
自然主键：主键的本身就是表中的一个字段（实体中的一个具体的属性）。
创建一个人员表：人员都会有一个身份证号（唯一的不可重复的），使用了身份证号作为主键，这种主键称为是自然主键。

**代理主键**

代理主键：主键的本身不是表中必须的一个字段（不是实体中的某个具体的属性）。
创建一个人员表：没有使用人员中的身份证号，用了一个与这个表不相关的字段ID、（PNO），这种主键称为是代理主键。

在实际的开发当中，尽量使用代理主键。
      一旦自然主键参与到业务逻辑当中，后期有可能需要修改源代码。
      好的程序设计满足OCP原则，对程序的扩展是open的，对修改源码是close的。

## 1.3.2 主键的生成策略
**Hibernate的主键生成策略**
在实际的开发中一般不允许用户手动设置主键，一般将主键交给数据库，手动编写程序进行设置。在hibernate中为了减少程序编写，提供了很多中的主键的生成策略。
increment：hibernate中提供的自动增长机制，适用short、int、long类型的主键。在单线程程序中使用。
      首先先发送一条语句：select max(id) from 表；然后让id+1 作为下一条记录的主键。
identity：适用于short、int、long类型的主键，使用的是数据库底层的自动增长机制。适用于有自动增长机制的数据库（MySQL、MSSQL），但是Oracle是没有自动增长。
sequence：适用于short、int、long类型的主键，采用的是序列的方式。（Oracle支持序列）。像MYSQL就不能使用sequence。
- **uuid：** 适用于字符串类型的主键。使用hibernate中的随机方式生成字符串主键。
- **native：** 本地策略，可以在identity和sequence之间进行自动切换。
- **assigned：** hibernate放弃外键的管理，需要通过手动编写程序或者用户自己设置。
- **foreign：** 外部的。一对一的一种关联映射的情况下使用。（了解）

# 1.4 持久化类的三种状态
## 1.4.1 持久化类的三种状态
Hibernate是持久层框架，通过持久化类完成ORM操作，Hibernate为了更好的管理持久化类，将持久化类分成三种状态。
持久化类 = Java类 + 映射
- 瞬时态（transient）
这种对象没有唯一的标识OID，没有被session管理，称为是瞬时态对象。
- 持久态（persistent）
这种对象有唯一标识OID，被session管理，称为是持久态对象。
- 脱管态（detached）
这种对象有唯一标识OID，没有被session管理，称为脱管态对象。
- 区分三种状态对象
```java
public class HibernateDemo2 {
    @Test
    //三种状态的区分
    public void demo1(){
        Session = session = HibernateUtils.openSession;
        Transaction = transaction = session.beginTransaction();

        Customer customer = new Customer();//瞬时态对象：没有唯一标识OID，没有session管理
        customer.setCust_name("王东");

        Serializable id = session.save(customer);//持久态对象：有唯一标识OID，被session管理

        transaction.commit();
        session.close();

        System.out.println("客户名称："+ customer.getCust_name());//脱管对象：有唯一标识OID，没有被session管理
    }
}
```
## 1.4.2 持久化类的状态转换
- 三种状态的转换图
​​​​​​![在这里插入图片描述](https://img-blog.csdnimg.cn/2019031319342792.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)
- 瞬时态对象
**获得**
```java
Customer customer = new Customer();
```
**状态转换**
瞬时==》持久
      save()、saveOrUpdate(Object obj);
瞬时==》托管
      customer.setCust_id(1l);
- 持久态对象
**获得**
      get()、load(）、find()、iterate()
      Customer customer = session.get(Customer.class,1l);
**状态的转换**
持久==》瞬时
      delete()
持久==》脱管
      close()、clear()、evict(Object obj);
- 脱管态的对象
**获得**
```java
Customer customer = new Customer();
customer.setCust_id(1l);
```
**状态的转换**
脱管==》持久
      update()、saveOrUpdate()
脱管==》瞬时
```java
customer.setCust_id(null);
```
## 1.4.3 持久态对象特性
- 持久化类持久态对象自动更新数据库
```java
@Test
//持久态对象自动更新数据库
public void demo2(){
    Session session = HibernateUtils.openSession();
    Transaction transaction = session.beginTransaction();
    
    //获得持久态对象
    Customer customer = session.get(Customer.class,1l);
    customer.setCust_name("王西");
    //session.update(customer);

    transaction.commit();
    session.close();
}
```
# 1.5 Hibernate的一级缓存
## 1.5.1 缓存的概述
- 什么是缓存
缓存：是一种优化的方式，将数据存入到内存中，使用的时候直接从缓存中获取，不用通过存储源。
## 1.5.2 Hibernate的缓存
- HIbernate的一级缓存
HIbernate框架中提供了优化手段，缓存、抓取策略。Hibernate中提供了两种缓存机制：一级缓存、二级缓存。
Hibernate的一级缓存：称为是session级别的缓存，一级缓存生命周期与session一致（一级缓存是由session中的一系列的Java集合构成）。一级缓存是自带的不可卸载的。（Hibernate的二级缓存是SessionFactory级别的缓存，需要配置的缓存）。
- 证明一级缓存存在
```java 
public class HibernateDemo3 {
    @Test
    //证明一级缓存的存在
    public void demo1(){
        Session session = HibernateUtils.openSession();
        Transaction tx = session.beginTransaction();
        
        Customer customer1 = session.get(Customer.class,1l);//发送SQL语句
        System.out.println(customer1);

        Customer customer2 = session.get(Customer.class,1l);//不发送SQL语句
        System.out.println(customer2);

        System.out.println(customer1 == customer2);
        tx.commit();
        session.close();
    }
}
```
## 1.5.3 Hibernate的一级缓存的结构
- 一级缓存中的特殊区域：快照区
```java
@Test
//一级缓存的快照区
public void demo2(){
    Session session = new HibernateUtils.openSession();
    Transaction tx = session.beginTransaction();

    Customer customer = session.get(Customer.class,1l);//发送SQL语句查询，同时放入到缓存中
    customer.setCust_name("王凤");

    tx.commit();
    session.close();
}
```
- 一级缓存的清空
```java
@Test
//一级缓存的快照区
public void demo3(){
    Session session = new HibernateUtils.openSession();
    Transaction tx = session.beginTransaction();

    Customer customer1 = session.get(Customer.class,1l);//发送SQL语句查询，同时放入到缓存中
   
    session.clear();//清空所有
    //session.evict(customer1);

    Customer customer2 = session.get(Customer.class,1l);//发送SQL语句查询，同时放入到缓存中
    System.out.println(customer1);
    System.out.println(customer2);

    tx.commit();
    session.close();
}
```
# 1.6 HIbernate的事务管理
## 1.6.1 事务的回顾
**什么是事务**
事务：事务指的是逻辑上的一组操作，组成这组操作的各个逻辑单元要么全部成功，要么全部失败。
**事务特性**
- 原子性：代表事务不可分割。
- 一致性：代表事务执行的前后，数据的完整性保持一致。
- 隔离性：代表一事务执行的过程中，不应该受到其他事物的干扰。
- 持久性：代表事务执行完成后，数据就持久到数据库中。

### 如果不考虑隔离性，引发安全性问题
**读问题**
- 脏读：一个事务读到另一个事务未提交的数据。
- 不可重复读：一个事务读到另一个事物已经提交的update数据，导致在前一个事务多次查询结果不一致。
- 虚读：一个事务读到另一个事务已经提交的insert数据，导致在前一个事务多次查询结果不一致。
**写问题**
引发两类丢失更新
**读问题的解决**
设置事务的隔离级别
- read uncommited：以上的读问题都会发生    1
- read commiited：解决脏读，但是不可重复读和虚读有可能发生    2
- repeatable read：解决脏读和不可重复读，但是虚读有可能发生    4
- serializable：解决所有读问题    8
## 1.6.2 HIbernate中设置事务隔离级别
```html
<!-- 核心配置文件 设置事务隔离级别 -->
<property name="hibernate.connection.isolation">4</property>
```
## 1.6.3 Service层事务
### Hibernate解决Service的事务管理
- 改写工具类
```java
public class HibernateUtils {
    public static final Configuration cfg;
    public static final SessionFaction sf;

    static {
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
- 配置完成
```html
<!-- hibernate核心配置文件中 配置当前线程绑定的Session -->
<property name="hibernate.current_session_context_class">thread</property>
```
```java
//测试当前线程绑定的Session

public class HibernateDemo4 {
    @Test
    public void demo1(){
        Session session = HibernateUtils.getCurrentSession();
        Transaction tx = session.beginTransaction();

        Customer customer = new Customer();
        customer.setCust_name("王西");
        session.save(customer);

        tx.commit();
    }
}
```
# 1.7 Hibernate 的其他API
## 1.7.1 Query
Query接口用于接收HQL，查询多个对象。
HQL：Hibernate Query Language，这种语言与SQL的语法极其类似
```java
//Hibernate的其他API
public class HibernateDemo5 {
    @Test
    //Query
    public void demo1(){
        Session session = HibernateUtils.getCurrentSession();
        Transaction tx = session.beginTransaction();

        //通过Session获得Query接口
        //简单查询
        //String hql = "from Customer";
        //条件查询
        //String hql = "from Customer where cust_name like ?";
        //分页查询
        String hql = "from Customer";
        Query query = session.createQuery(hql);
        //设置条件
        //query.setParameter(0,"王%");
        //设置分页
        query.setFirstResult(0);
        query.setMaxResullt(3);

        List<Customer> list = query.list();
        for(Customer customer : list) {
            System.out.println(customer);
        }

        tx.commit();
    }
}
```
## 1.7.2 Criteria
Criteria:QBC（Query By Criteria）
更加面向对象的查询方式
```java
@Test
public void demo2(){
    Session session = HibernateUtils.getCurrentSession();
    Transaction tx = session.beginTransaction();

    //通过session获得Criteria的对象
    //Criteria criteria = session.createCriteria(Customer.class);
    //List<Customer> list = criteria.list();

    //条件查询
    //Criteria criteria = session.createCriteria(Customer.class);
    //criteria.add(Restrictions.like("cust_name","王%"));

    Criteria criteria = session.createCriteria(Customer.class);
    criteria.setFirstResult(3);
    criteria.setMaxResults(3);
    List<Customer> list = criteria.list();

    for(Customer customer : list){
        System.out.println(Customer);
    }

    tx.commit();
}
```
## 1.7.3 SQLQuery
SQLQuery用于接收SQL。特别复杂的情况下使用SQL。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190313195007908.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hvdXdhbmxl,size_16,color_FFFFFF,t_70)

