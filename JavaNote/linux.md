## Windows 端口查询

```shell
netstat -ano | findstr "1080" // windows查找端口号
```

## NAT 静态IP

```shell
vim /etc/sysconfig/network-scripts/ifcfg-ens33

BOOTPROTO= static
ONBOOT= yes
IPADDR= 192.168.66.100 # 设置和VM8在同一网段的IP地址
NETMASK= 255.255.255.0
GATEWAY= 192.168.66.2
DNS= 8.8.8.8
ZONE= public
NM_CONTROLLED= no

service network restart
```

## 安装JDK

```shell
rpm -qa | grep jdk

# copy-jdk-configs-3.3-10.el7_5.noarch
# java-1.8.0-openjdk-1.8.0.242.b08-1.el7.x86_64
# java-1.8.0-openjdk-headless-1.8.0.242.b08-1.el7.x86_64

yum -y remove java-1.8.0-openjdk-headless-1.8.0.242.b08-1.el7.x86_64 # 删除原来的jdk

tar -zxvf jdk-8u251-linux-x64.tar.gz -C /usr/local/java/

vim /etc/profile

export JAVA_HOME=/usr/local/java/jdk1.8.0_251
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH

source /etc/profile
java -version
```

## 设置集群之间无密码登录

```shell
ssh-keygen -t rsa
cd .ssh
cp id_rsa.pub authorized_keys
chmod 600 authorized_keys 
scp authorized_keys master:/root/.ssh
rm -rf id_rsa.pub
```

# Shell

## bash shell

```shell
(;) 可以在同一行上写两个或两个以上的命令
(;;) 可以终止case选项
(.) 等价于source 在当前的bash环境下读取并执行FileName.sh中的命令
(') 会阻止STRING中所有特殊字符的解释
(") 会阻止STRING中大部分特殊的字符
(/) 文件名路径分隔符。分隔文件名不同的部分
(\) 一种单字符的引用机制 \X 将会"转义"字符X 转义符也提供续行功能，也就是编写多行命令的功能
(`) 反引号中的命令会优先执行
(:) 空命令被认为与shell的内建命令true作用相同
(?) 双括号结构中 ?就是c语言中的三元操作符
(()) 	
	在括号中的命令列表，将会作为一个子shell来运行
	初始化数组 
({})
	文件名扩展 在大括号中，不允许有空白，除非这个空白被引用或转义
	代码块，事实上创建了一个匿名函数，在其中声明的变量，对于脚本其他部分的代码来说还是可见的
([])
	条件测试表达式[] 
	数组元素
重定向：
	test.sh > filename
  test.sh &> filename 重定向stdout和stderr 到filename中
  test.sh >&2: 重定向test.sh 的stdout到stderr
  test.sh >> filename 把test.sh输出追加到文件filename中
(|) 分析前边命令到输出，并将输出作为后边命令的输入
(-) 在所有的命令内如果想使用选项参数的话
$#: 传递到脚本到参数个数
$0: 脚本文件自身的名字
$1 $2: 第一个参数 + 第二个参数
```

`shell`对于错误信息的处理是跟普通输出分开的

#### 只重定向错误

```shell
ls -al badfile 2> test4
cat test4
ls: cannot access badfile: No such file or directory
# shell会只重定向错误信息，而非普通数据
```

#### 重定向错误和数据

```shell
ls -al test test2 test3 badtest 2> test6 1> test7

cat test6
ls: cannot access test: No such file or directory
cat test7
-rw-rw-r-- 1 rich rich 158 2020-10-16 11:32 test2
# 将stdout输出到test6 将stderr输出到stderr
```

#### 将stdout和stderr重定向到同一个输出文件

```shell
ls -al test test2 test3 badtest &> test7
# 命令生成的所有输出都会发送到同一个位置，包括数据和错误
./test.sh > test2.log 2>&1
# shell 标准输出和错误输出都到同一个文件中
```

#### nohup

1) nohup命令是永久执行，忽略挂起信息。&是指在后台执行

2）用&后台运行程序时，如果是守护进程，断开终端则程序继续执行，如果不是守护进程，断开终端则程序也会被断开停止运行

3）使用nohup命令，如果指定了输出文件，输出信息则会附加到输出文件中，如果没有指定输出文件，则输出信息会附加到当前目录下的nohup.out文件中，如果当前目录的nohup.out文件不可写，输出重定向到$HOME/nohup.out文件中。

## linux命令

```shell
sed -e 4a\newLine testfile
```



## 安装Hadoop

```shell
tar -xzvf hadoop-3.2.0.tar.gz -C /opt/hadoop

# 配置hadoop 
vim /opt/hadoop/hadoop-3.2.0/etc/hadoop/hadoop-env.sh
# 添加一下内容
export JAVA_HOME=/usr/local/java/jdk1.8.0_251

# 添加Hadoop 的环境变量
export HADOOP_HOME=/opt/hadoop/hadoop-3.2.0/
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

source /etc/profile
hadoop version

mkdir  /root/hadoop
mkdir  /root/hadoop/tmp
mkdir  /root/hadoop/var
mkdir  /root/hadoop/dfs
mkdir  /root/hadoop/dfs/name
mkdir  /root/hadoop/dfs/data
```

## 环境变量

```shell
# 有的linux发行版通过修改/etc/profile可能会只在当前的terminal中有效关闭则失效
# 应该修改~/.bashrc中的环境变量 source ~/.bashrc
```

## Git操作

```shell
git add . # 添加文件到暂存区
git commit -m "message" # 添加文件到本地仓库
git push # 添加文件到远程仓库
```

删除本地文件

- 误删

```shell
git checkout -- HelloGit.java # 将暂存区的文件恢复到本地仓库
```

- 确定删除

```shell
git rm HelloGit.java # 将暂存区的文件删除
git commit -m "delete HelloGit.java"
```

版本回溯

```shell
git reset --hard HEAD^ # 回退一个版本
git reset --hard HEAD^^ # 回退两个版本
git reset --hard commit id # 回退指定版本

git reflog # 查看所有的版本信息
git log # 查看当前版本以前的信息
```

查看分支

```shell
git branch dev # 创建分支

git switch master # 切换分支

git branch -d dev # 删除分支
```

团队合作

```shell
git branch MissBear # 新建分支
touch test.py

git add ./test.py
git commit -m "test"
git push origin MissBear # 同步分支

git switch dev # 合并分支
git pull
git merge MissBear
git push origin dev # 远程同步
```

## flume启动

```shell
bin/flume-ng agent --conf conf --conf-file conf/netcat-flume-logger.conf --name a1 -Dflume.root.logger=INFO,console
```

# redis

`redis-server.exe redis.windows.conf`：启动redis服务 windows

`tar -xvf `进行解压操作

`ps -ef|grep redis`搜索redis的进程

`redis-server /redisdir/redis.conf`使用指定的配置文件进行启动

`redis-cli -p 6379`进行redis客户端的连接

## 基础知识：

`redis`是默认有16个数据库 默认使用的是第0个

1. Redis是纯内存数据库，一般都是简单的存取操作，线程占用的时间很多，时间的花费主要集中在IO上，所以读取速度快。
2. 再说一下IO，Redis使用的是非阻塞IO，IO多路复用，使用了单线程来轮询描述符，将数据库的开、关、读、写都转换成了事件，减少了线程切换时上下文的切换和竞争。
3. Redis采用了**单线程**的模型，保证了每个操作的原子性，也减少了线程的上下文切换和竞争。

## 基本命令

```bash 
keys *：查看所有的key值

flushall：清除所有的数据库的数据

flushdb：清除当前的数据库的数据

select index  ：选用index号数据库

exists：判断当前的key是否存在

expire：设置当前key的过期时间，单位为秒

ttl key：查看当前key的剩余时间

type key：查看当前key的类型

del key：删除当前的key

append key value：追加字符串，如果当前key不存在，就相当于set key

strlen key：获取字符串的长度

incr key：自增 1

decr key：自减1

incrby key step：可以设置增加步长

decrby key step：可以设置减少步长

getrange key start end：截取字符串的start -> end
getrange key 0 -1 ：获取字符串所有的长度

setrange key start value：替换指定位置开始的字符串

setex (set with expire) # 设置过期时间
setex key3 30 "hello world"

setnx (set if not exist) # 不存在再设置
setnx mykey "redis"
setnx mykey "MongoDB" # 如果mykey存在，创建失败

mset # 同时设置多个值
mset k1 v1 k2 v2 k3 v3

msetnx k1 v1 k4 v4 #msetnx 是一个原子性操作，要么一起成功要么一起失败

# 对象
set user:1 {name: hujiale, age: 3}
# 这里的key是一个巧妙的设计 user:{id}:{filed}

mset user:1:name hujiale user:1:age 3
mget user:1:name user:1:age

getset # 先get然后再set
```

## List

```bash
# list相关命令
lpush key value：从left push
rpush key value：从right push

lrange list 0 -1 # 获取list中的值

lpop # 移除list的最左边的值
rpop # 移除list最右边的值

lindex list 1# 通过下标获取list中的某一个值 下标是从0开始

llen list # 返回列表的长度

lrem list 1 one # 移除list集合中指定个数的value，精确匹配 并且是从左到右进行删除

trim 修剪 list进行截断
ltrim list 1 2 # 通过下标取指定的长度，这个list已经被改变了，截断了 并且只取剩下的元素

rpoplpush source destination # 将source的rpop元素lpush到dest

lset key index value #将列表中指定下标的值替换为另一个值，更新操作
lset list 0 item # 如果存在，更新值 如果不存在则报错

linsert key before/after “words” “other words” # 将具体的value插入到指定的某一个元素的前面或者后面

如果清除了所有的值，空链表，也代表不存在
```

## set

```bash
# set 无序不重复集合，抽随机

sadd myset “hello” # set集合中添加元素

smembers myset # 查看指定的set的所有值

sismember myset hello # 判断某一个值是不是在set集合中

scard myset # 获取set集合中的内容元素

srem myset hello # 移除set集合中指定的元素

srandmemeber myset # 随机抽选一个元素
srandmember myset 2 # 随机抽选指定个数的元素

spop myset # 随机删除一些set集合中的元素

smove myset myset2 "hujiale" 将一个指定的值，移动到另外一个set集

sdiff key1 key2 # 差集
sinter key1 key2 # 交集
sunion key1 key2 # 并集
```

## Hash

map集合，key-value

hash 更适合于对象存储，String更加适合字符串存储

```bash
hset myhash field1 hujiale # set 一个具体 key-value

hget myhash field1 # 获取一个字段的值

hmset myhash field1 hello field2 world # set 多个key-value

hmget myhash field1 field2 # 获取多个字段

hgetall myhash # 获取全部的数据

hdel myhash field1 # 删除hash指定的key字段，对应的value也就消失了

hlen myhash # 获取hash表的字段的数量

hexists myhash field1 # 判断hash中指定字段是否存在 存在的是key

hkeys myhash # 只获取所有的keys
hvals myhash # 只获取所有的values

hset myhash field3 5 # 指定增量
hincrby myhash field3 1 
hdecrby myhash field3 -1 
hsetnx myhash field4 hello # 如果不存在则可以设置
hsetnx myhash field4 world # 如果存在则不可以设置
```

## zset 有序集合

```bash
zadd salary 2500 xiaohong
zadd salary 5000 zhansan
zadd salary 500 hujiale

zrangebyscore salary -inf +inf # 显示所有的用户 从小到大
zrevrange salary 0 -1 # 从大到小进行排序
zrangebyscore salary -inf +inf withscore # 显示所有的用户，并带有成绩
```

## Redis事务

Redis事务本质：一组命令的集合，一个事务的所有命令都会被序列化，在事务执行过程中，会按照顺序执行

Redis单条命令是原子性的，但是事务不能保证原子性

### 放弃事务

编译型异常（命令有错误），事务中所有的命令都不会被执行

运行时异常（1/0）：如果事务队列中存在语法执行错误，其他的命令也是可以执行，这也是为什么**Redis事务不是原子性**的

### 常用的事务的命令

```bash
multi # 改命令标记着一个事务块的开始，可以输入多个操作代替逐条操作
exec # 执行这个事务内的所有命令
discard # 放弃事务，该事务内的所有命令都将取消
watch # 监控一个或者多个key，如果这些key在提交事务exec之前被其他用户修改过，那么事务将执行失败，需要重新获取最新数据重新开始操作（类似于乐观锁）
unwatch # 取消watch命令对多个key的监控，所有监控锁将会被取消
```

### 乐观锁：

认为数据不会出错，为了保证数据的一致性，会在每一个记录的后面添加一个标记（类似于版本号）

假设A获取K1这条数据，得到K1的版本号是1，并对其进行修改，这个时候B也获取K1这个数据，同时也对K1进行了修改，这个时候，如果B先提交了，那么K1的版本号会改变成2，这个时候，如果A提交数据，他会发现自己的版本号与最新的版本号不一致，这个时候A的提交将不会成功，A的做法是重新获取最新的k1的数据，重复修改数据、提交数据。

### 悲观锁：

这个模式认定数据一定会出错，所有做法是将整张表锁起来，这个会有很强的一致性，但是同时会有极低的并发性（常用于数据库备份工作，类似于表锁）

## Redis.conf 





## linux 命令

```shell
打包成tar.gz 格式压缩包
tar -zcvf ag.tar /opt/ag_tar/
解压tar.gz格式压缩包
tar zxvf ag.tar
```