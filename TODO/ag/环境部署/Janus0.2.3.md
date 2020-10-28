## [Janus0.2.3](http://10.106.128.29:8002/#/dashboard)

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
tar -zxvf apache-maven-3.6.3-bin.tar.gz

export MAVEN_HOME=/usr/local/apache-maven-3.6.3
export PATH=$MAVEN_HOME/bin:$PATH 

source /etc/profile

mvn -v
```

3. 安装node js

```shell
tar -zxvf node-10.6.0-linux-x64.tar.gz

ln -s /opt/node-10.6.0-linux-x64/bin/npm /usr/local/bin/
ln -s /opt/node-10.6.0-linux-x64/bin/node /usr/local/bin/ 

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

config.sh # 配置运行时的参数
```

6. AG-Client

```shell
# 启动ag-client
npm run pre 

nohup npm run dev >/dev/null 2>&1 & exit # 让npm在后台中运行
```

7. 数据导入

```shell
# 导入程序 (需要保证 schema 和 datamapper 文件中文件名的正确性)

nohup run.sh import /hdfs/data1/ag_enhanced_data/conf/janus023_5_times_base.properties /hdfs/data1/ag_enhanced_data/5times /opt/aisino_graph/janusgraph-utils/aisino-conf/utiltest_schema.json /opt/aisino_graph/janusgraph-utils/aisino-conf/utiltest_datamapper.json 20201027_5time_base

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