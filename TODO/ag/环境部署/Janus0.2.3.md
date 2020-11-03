## [Janus0.2.3](http://10.106.128.29:8002/#/dashboard)

0. jdk1.8
```shell
tar -zxvf jdk1.8.0_111.tar.gz

vim /etc/profile

export JAVA_HOME=/opt/install/jdk1.8.0_111
export CLASSPATH=$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib
export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH:$HOME/bin
```

1. 部署janusgraph-0.2.3环境

```shell
# 安装janusgraph-0.2.3
unzip janusgraph-0.2.3-hadoop2

# 创建一个新的用户hjl 启动es的时候会用到 但是这个好像不会用到
useradd hjl
passwd hjl 

# 赋予用户使用/opt/janusgraph-0.2.3-hadoop2的权限
chown -R hjl:hjl /opt/janusgraph-0.2.3-hadoop2

cd /opt/janusgraph-0.2.3-hadoop2
nohup ./bin/gremlin-server.sh ./conf/gremlin-server/util_0718.yaml &
```

2. 安装maven

```shell
# 安装maven环境
tar -zxvf apache-maven-3.3.9-bin.tar.gz
mv apache-maven-3.3.9 /usr/lib

export MAVEN_HOME=/usr/lib/apache-maven-3.3.9
export PATH=$MAVEN_HOME/bin:$PATH 

source /etc/profile

mvn -v
```

3. 安装node js

```shell
tar -zxvf node-v8.11.3-linux-x64.tar.gz

ln -s /opt/install/node-v8.11.3-linux-x64/bin/npm /usr/local/bin/
ln -s /opt/install/node-v8.11.3-linux-x64/bin/node /usr/local/bin/ 

node -v

npm install --unsafe-perm=true --allow-root # 使用root用户进行npm install
```

4. Postgres

```shell
psql -U postgres -p 7432 -d ag
# 10.106.128.29	上安装了postgres 不知道需不需要安装
```

5. AG-Server

```shell
# 启动ag-server 
cd /opt/aisino_graph/ag-server/bin
agserver.sh restart

chmod 755 config_agserver_home.sh # 配置运行时的参数

source config_agserver_home.sh

#db_host=localhost
#db_port=5432

jvm_options_common="-Xmx4G"

db_host=localhost
db_name=ag
db_user=postgres
db_pass=postgres
db_port=5432

janus_host=localhost
janus_port=8182

HANDSQL="$psqlWhich/psql -U ${db_user} -d ${db_name} -h ${db_host} -p ${db_port}"
ADMINSQL="$psqlWhich/psql -U ${db_user} -d postgres -h ${db_host} -p ${db_port}"
CREATEDBSQL="$psqlWhich/createdb ${db_name} -U ${db_user} -h ${db_host} -p ${db_port} -e"

```

6. AG-Client

```shell

cd /opt/aisino_graph/ag-client/
# 启动ag-client
npm run pre 

nohup npm run dev >/dev/null 2>&1 & exit # 让npm在后台中运行
```

7. 数据导入

```shell
# 导入程序 (需要保证 schema 和 datamapper 文件中文件名的正确性)

# 5times ag_enhanced_data
nohup run.sh import /hdfs/data1/ag_enhanced_data/conf/janus023_5_times_base.properties /hdfs/data1/ag_enhanced_data/5times /opt/aisino_graph/janusgraph-utils/aisino-conf/utiltest_schema.json /opt/aisino_graph/janusgraph-utils/aisino-conf/utiltest_datamapper.json 20201027_5time_base
# 133 cassandra
nohup ./run.sh import /opt/janusgraph-0.2.3-hadoop2/conf/janusgraph-cassandra-es.properties /hdfs/data2/ag_1_times /opt/aisino_graph/janusgraph-utils/aisino-conf/utiltest_schema.json /opt/aisino_graph/janusgraph-utils/aisino-conf/utiltest_datamapper.json 20201103_cassandra &
# 133 cassandra smalltest 
nohup ./run.sh import /opt/janusgraph-0.2.3-hadoop2/conf/janusgraph-cassandra-es.properties /hdfs/data2/ag-data-test /opt/aisino_graph/janusgraph-utils/aisino-conf/utiltest_schema.json /opt/aisino_graph/janusgraph-utils/aisino-conf/utiltest_datamapper.json 20201103_cassandra_smalltest &
# 133 cassandra person
nohup ./run.sh import /opt/janusgraph-0.2.3-hadoop2/conf/janusgraph-cassandra-es.properties /hdfs/data2/ag_person_1_times /opt/aisino_graph/janusgraph-utils/aisino-conf/utiltest_schema.json /opt/aisino_graph/janusgraph-utils/aisino-conf/ImportPerson.json 20201103_cassandra_133&
# 本地 cassandra person
nohup ./run.sh import /Users/hujiale/ProgramFiles/janusgraph-0.2.3-hadoop2/conf/janusgraph-cassandra-es.properties /Users/hujiale/IdeaProjects/aisino_gragh/janusgraph-utils/smalltest /Users/hujiale/IdeaProjects/aisino_gragh/janusgraph-utils/aisino-conf/utiltest_schema.json /Users/hujiale/IdeaProjects/aisino_gragh/janusgraph-utils/aisino-conf/ImportPerson.json 20201103_cassandra_localhost &

# 查看进程

ps -ef | grep -v grep | grep BatchImport

# 日志文件

janusgraph-utils/logs/20201027_5times.log

# hbase 清空表

hbase shell

truncate tablename

# 数据传输 (将当前目录下的所有文件传输到指定的目录下)
scp ./* root@10.106.128.29:/hdfs/data1/ag_enhanced_data

```

8. redis

```shell
tar -zxvf redis-5.0.9.tar.gz

cd redis-5.0.9

make

cd src

make install PREFIX=/usr/local/redis

cd ..

mkdir /usr/local/redis/etc

mv redis.conf /usr/local/redis/etc

vim /usr/local/redis/etc/redis.conf // 将daemonize no 改成daemonize yes

cp /usr/local/redis/bin/redis-server /usr/local/bin/

cp /usr/local/redis/bin/redis-cli /usr/local/bin/

nohup redis-server /usr/local/redis/redis.conf &

ps -ef | grep -v grep | grep redis-server 
```