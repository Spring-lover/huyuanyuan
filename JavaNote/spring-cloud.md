### DepencyManagement 应用场景

在项目顶层的POM文件中，我们会看到dependencyManagement元素，通过它元素来管理jar包的版本，让子项目中引用一个依赖而不用显示的列出版本号，Maven会沿着父子层次向上走，直到找到一个拥有dependencyManagement元素的项目

### 什么是服务注册与发现

Eureka采用了CS的设计结构我Eureka Server服务注册功能的服务器，它是服务注册中心。而系统中的其他微服务，使用Eureka的客户端连接到Eureka Server并维持心跳连接。这样系统的维护人员就可以通过Eureka Server来监控系统中各个微服务是否正常运行。这点和zookeeper很相似

### ZooKeeper

#### 概念

是一个基于观察者设计模式设计的分布式服务管理框架，它负责存储和管理数据，然后接受观察者的注册，一旦这些数据的状态发生变化，ZooKeeper就将负责通知已经在ZooKeeper上注册的那些观察者作出相应的反应

#### 特点

- ZooKeeper：一个领导者Leader，多个跟随者Follower组成的集群
- 集群中只要有半数以上节点存活，ZooKeeper集群就能存活
- 全局数据一致，每一个Server保存一份相同的数据副本，Client无论连接到哪个Server，数据都是一致的
- 更新请求顺序进行，来自同一个Client的更新请求按其发送顺序依次执行
- 数据更新原子性，一次数据更新要么成功，要么失败
- 实时性，在一定时间范围内，Client能读到最新的数据