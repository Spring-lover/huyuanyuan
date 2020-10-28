## docker镜像:

是Docker容器运行的只读模板，每一个镜像由一系列的层layer组成。通过镜像可以创建多个容器

## docker容器：

是基于镜像启动起来的，容器中可以运行一个或多个进程。容器之间是相互隔离的

镜像是docker生命周期中的构建和打包阶段，而容器则是启动或执行阶段

Docker是一个Client-Server结构的系统，Docker的守护进程运行在主机上。通过Socket从客户端进行访问

## Docker命令

```shell
docker info
docker version

docker images # 查看所有本地主机上的镜像
docker imgaes -a # 列出所有镜像的详细信息
docker imgaes -aq # 列出所有镜像的id

docker search # 搜索镜像
docker search mysql --filter=STAR=3000 # 搜索3000star以上的仓库

docker pull # 下载镜像
docker pull tomcat[:tag]

docker rmi # 删除镜像
docker rmi -f 镜像id # 删除指定id的镜像
docker rmi -f ${docker images -aq} # 删除所有的镜像

# 容器命令
docker run 镜像id # 新建容器并且启动
docker ps # 列出所有运行的容器 docker container list
docker rm 容器id # 删除指定的容器，不能删除正在运行的容器
docker rm -f ${docker ps -aq} # 删除所有的容器
docker ps -a -q|xargs docker rm # 删除所有的容器

docker start 容器id # 启动容器
docker restart 容器id # 重启容器
docker stop 容器id # 停止当前正在运行的容器
docker kill 容器id # 强制停止当前容器

# 新建容器并且启动
docker run [] image
--name="Name" # 容器的名字 tomcat01, tomcat02 用来区别容器
-d # 后台的方式运行
-it # 使用交互方式进行，进入容器中查看内容
-p # 指定容器的端口
-P # 随机指定端口
docker run -it centos /bin/bash

# 列出所有运行的容器
docker ps # 列出当前正在运行的容器
[-a, --all] # 列出当前正在运行的容器 + 带出历史运行过的容器
[-n=?, --last int] # 列出最近创建的?个容器，为1则只列出最近创建的一个容器
[-q, --quiet] # 只列出容器的编号
# docker 容器使用后台进行运行，就必须要有一个前台进程，docker发现没有应用，就会自动停止


# 退出容器
ctrl + P + Q # 容器不停止退出
exit # 容器直接退出

# 查看日志
docker logs [-tf --tail number] 容器id
[-t] # 显示时间戳
[-f] # 追踪日志
[--tail number] # 显示最后几条日志条数
docker logs -t --tail n 容器id # 查看n行日志
docker logs -tf 容器id # 跟着日志

# 查看容器中进程的信息ps
docker top 容器id

# 查看容器中的元数据
docker inspect 容器id

# 进入当前正在运行的容器
# 通常容器都是使用后台进行运行的，需要进入容器，修改一些配置
1. docker exec -it 容器id /bin/bash # 进入容器后开启一个新的终端，可以在里面操作
2. docker attach 容器id # 进入容器正在执行的终端

# 从容器内拷贝到主机上
docker cp 容器id:容器内路径 主机目的路径
```



## Docker Tomcat | Nginx

```shell
docker run -it --rm tomcat:9.0 # --rm：一般用来测试，用完就删除了

docker pull tomcat
docker run -d -p 3344:8080 --name tomcat01 tomcat

# 进入容器
docker exec -it tomcat01 /bin/bash 

# 阿里云镜像的问题，默认是最小的镜像，所有不必要的东西都剔除掉
```

## Docker eslasticsearch

```shell
docker stats # 查看容器所占用的内存
-e ES_JAVA_OPTS="Xms64m -Xmx512m" 设置所占内存的大小
```

## Docker portainer

```shel
docker run -d -p 8088:9000 --restart=always -v /var/run/docker.sock:/var/run/docker.sock --privileged=true portainer/portainer
```

## UnionFS(联合文件系统)

Union文件系统（UnionFS）是一种分层、轻量级并且高性能的文件系统，支持对文件系统的修改作为一次来一层层的叠加。

## docker commit 

Docker镜像都是只读的，当容器启动时，一个新的可写层（容器层）被加载到镜像的顶部，容器之下的叫做镜像层

```shell
docker commit -m="message" -a="author" 容器id 目标镜像名:[tag]

# 测试部署tomcat服务器
docker run -d -p 8080:8080 tomcat

docker exec -it 容器id

# 拷贝文件进去

docker commit -m="message" -a="author" 容器id 目标镜像名:[tag]
```

## 容器数据卷

数据的持久化，让数据可以同步到本地

容器的持久化和同步操作，容器间也是可以数据共享的。

```shell
docker run -it -v 主机目录:容器内目录 -p 主机端口:容器内端口
# 即便容器已经停止，数据依然是同步的
```

## Docker Mysql

```shell
# -d 后台运行
# -v 挂载
# -e 环境配置 设置mysql的密码
# 删除容器时，挂载的数据没有丢失，实现数据的持久化

docker run -d -p 3310:3306 -v /home/mysql/conf:/etc/mysql/conf.d -v /home/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 --name mysql03 mysql:5.7
```

## 具名和匿名挂载

```shell
# 匿名挂载
-v 容器内路径
docker run -d -P --name nginx01 -v /etc/nginx nginx

# docker volume ls

# 具名挂载
-v 卷名:容器内路径
docker run -d -P --name nginx02 -v juming-nginx:/etc/nginx nginx

docker volume inspect juming-nginx

# 所有的docker容器内的卷，没有指定目录的情况下都是在**/var/lib/docker/volumes/自定义的卷名/_data**下 如果指定了目录，则docker volume ls 是查不到的

区别三种挂载方式：
-v 容器内路径    # 匿名挂载
-v 卷名:容器内路径	# 具名挂载
-v /宿主机路径:容器内路径 # 指定路径挂载 docker volume ls 是查不到的

# 通过设定 -v 容器内路径 ro rw 改变读写权限
ro # readonly
rw # readwrite
# docker run -d -P --name nginx01 -v juming:/etc/nginx:ro nginx
# docker run -d -P --name nginx01 -v juming:/etc/nginx:rw nginx
```

## 数据卷容器

实现多个容器进行数据同步

```shell
docker run -it --name docker02 --volumes-from docker1 missbear/centos:latest
# --volumes-from 
# 实现多个Mysql的数据共享

docker run -d -p 3306:3306 -v /home/mysql/conf:/etc/mysql/conf.d -v /home/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 --name mysql01 mysql:5.7

docker run -d -p 3310:3306 -e MYSQL_ROOT_PASSWORD=123456 --name mysql02 --volumes-from mysql01  mysql:5.7
```

容器之间的配置信息的传递，数据卷容器的生命周期一直持续到没有容器使用为止，但是一旦你持久化到了本地，这个时候，本地的数据是不会删除

## DockerFile 

dockerfile 就是用来构建Docker镜像的文件，命令行参数脚本

## DockerFile 指令

```shell
FROM			#from：基础镜像，一切从这里开始
MAINTAINER		#maintainer:镜像是谁写的，姓名+邮箱
RUN				#run:镜像构建的时候需要运行的命令
ADD				#add:步骤,tomcat镜像，tomcat压缩包,添加内容
WORKDIR			#workdir:镜像的工作目录
VOLUME			#volume:挂载的目录
EXPOSE			#expose:暴露的端口号
CMD				#cmd:指定这个容器启动的时候需要执行的命令，只有最后一个生效，可以被替代掉
ENTRYPOINT		#entrypoint:指定这个容器启动时候,可以追加命令
ONBUILD			#onbuild:当构建一个被继承的DockerFile这个时候就会运行这个onbuild指令,触发指令
COPY			#copy:类似ADD,将我们的文件拷贝到镜像中
ENV				# env:构建的时候设置环境变量
```

## MyCentos With Vim

```shell
# dockerfile文件
FROM centos
MAINTAINER MissBear<1004173119@cugb.edu.cn>
ENV MYPATH /usr/local
WORKDIR $MYPATH
RUN yum -y install vim
RUN yum -y install net-tools
# 如果是在一个不支持shell的平台运行或者不希望在shell中运行，使用exec格式的RUN
# RUN ["yum", "-y", "install", "net-tools"]                        
EXPOSE 80
CMD echo $MYPATH
CMD echo "--------end--------"
CMD /bin/bash
```

```shell
docker build -f dockerfile -t mycentos:0.1 . # -f:dockerfile的路径 -t:target 镜像名[:tag] .:当前的目录
docker history # 镜像的历史变更信息
```

## CMD，ENTRYPOINT的区别

```shell
CMD		# 指定这个容器启动的时候要运行的命令，只有最后一个会生效，可被替代
ENTRYPOINT # 指定这个容器启动的时候要运行的命令，可以追加命令
```

## tomcat + Jdk

```shell
# dockerfile:
FROM centos 
MAINTAINER MissBear<1004173119@cugb.edu.cn>
COPY README /usr/local/README
ADD jdk-8u231-linux-x64.tar.gz /usr/local/
ADD apache-tomcat-9.0.35.tar.gz /usr/local/
RUN yum -y install vim
ENV MYPATH /usr/local
WORKDIR $MYPATH

ENV JAVA_HOME /usr/local/jdk.1.8.0._231
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV CATALINA_HOME /usr/local/apache-tomcat-9.0.35
ENV CATALINA_BASH /usr/local/apache-tomcat-9.0.35

ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/lib:$CATALINA_HOME/bin
# 这里的是在原来的PATH的基础上加上后面三个环境变量 ':' 是分隔符
EXPOSE 8080

CMD /usr/local/apache-tomcat-9.0.35/bin/startup.sh && tail -F /usr/local/apache-tomcat-9.0.35/logs/catalina.out # 设置默认命令
```

## Docker Hub

```shell
docker push # 需要添加到自己用户名的仓库
```

## Docker Networking

```
每启动一个docker容器，docker就会给docker容器分配一个ip，将docker0用作路由器进行桥接模式，使用veth-pair技术(一对虚拟设备接口)

只要容器删除，对应的一对网桥就被删除
```

![img](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2NoZW5nY29kZXgvY2xvdWRpbWcvbWFzdGVyL2ltZy9pbWFnZS0yMDIwMDUxNjE3NDI0ODYyNi5wbmc?x-oss-process=image/format,png)

## --link

```shell
docker exec -it tomcat02 ping tomcat01 # ping不通 因为不识别 tomcat01

docker run -d -P --name tomcat03 --link tomcat02 tomcat

docker exec -it tomcat03 ping tomcat02 # 可以ping通

--link # 本质就是hosts配置中添加映射, 但是tomcat02 ping tomcat03 还是ping不通，所以这个方法不常用

docker0 网络的问题：不支持容器名的访问
```

## 自定义网络

```shell
# 网络模式：
bridge : 桥接docker
none : 不配置网络
host : 和宿主机共享网络
container : 容器网络联通联通（用的比较少）
```

```shell
docker run -d -P --name tomcat01 tomcat
=>
docker run -d -P --net bridge --name tomcat01 tomcat

docker0 # 默认，域名不能访问, --link 可以打通连接, 很麻烦
docker network create --dirver bridge --subnet 192.168.0.0/16 --gateway 192.168.0.1 mynet

docker network inspect mynet
```

## 网络连通

```shell
docker network connect mynet tomcat01 # 跨网段连通
```

```shell
docker top # 查看容器内进程
docker stats # 显示一个或多个容器的统计信息
```

## docker run -d -p 80 --name static_web MissBear/static_Web nginx -g "daemon off"

```shell
-g "daemon off" # docker容器启动时，默认会把容器内部第一个进程，也就是pid=1的程序，作为docker容器是否正在运行的依据，如果docker容器pid=1的进程挂了，那么docker容器便会直接退出
# docker未执行自定义的CMD之前，nginx的pid是1，执行到CMD之后，nginx就在后台运行，bash/sh脚本的pid就变成了1，一旦执行完自定义的CMD之后，nginx容器就退出了
```

## CMD & ENTRYPOINT

```shell
ENTRYPOINT ["/usr/sbin/nginx"]
CMD["-h"]

# 该镜像既可以运行一个默认的命令(docker run /usr/sbin/nginx -h)，同时它也支持通过docker run命令行为该命令指定可覆盖的选项或者标志
```

