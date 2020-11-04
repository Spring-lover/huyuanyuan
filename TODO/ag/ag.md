

## 数据库索引

### 索引：

使用索引的全部意义就是通过缩小一张表中需要查询的记录/行的数目来加快搜索的速度

一个索引是存储的表中一个特定列的值数据结构。

索引包含一个表中列的值，并且这些值存储在一个数据结构中

索引存储了指向表中某一行的指针

### 代价：

索引会占用空，表越大，索引占用的空间越大

性能损失，主要是值更新的操作，索引也会有相同的更新操作，**建立在某列（或多列）索引需要保存该列最新的数据**。

## Janusgraph utils

delimiter命令指定了mysql解释器命令行的结束符，默认为**“;”**

### 索引：

JanusGraph支持两种不同的Graph Index，Composite index和Mixed Index

- composite index：索引列全使用并且等值匹配，不需要后端索引存储、支持唯一性、排序在内存中成本高

### Graph Index

Graph Index是整个图上的全局索引结构，用户可以通过属性高效查询Vertex或Edge

#### Composite Index

Compostie非常高效和快速，**但只能应用对某特定的，预定义的属性key组合进行相等查询**。

Composite Index 需要在查询条件完全匹配（必须该索引中所有字段全部用上才可以触发索引

```java
g.V().has('name', 'hercules');
g.V().has('age', 30).has('name', 'hercules');
// 以上都是可以触发索引
g.V().has('age', 30);
// 因并未对age建立索引
g.V().has('name', 'hercules').has('age', inside(20, 50));
// 因只支持精确范围，不支持范围查询
```



#### Index Uniqueness

Composite Index 也可以作为图的属性的唯一约束使用，如果composite graph index被设置为unique()，则只能存在一个对应的属性组合。

#### Mixed index

Mixed index可用在查询任何index key的组合上并支持多条件查询，除了相等条件要依赖于后端索引存储。

## Gremlin

```bash
graph = JanusGraphFactory.open("conf/janusgraph-cassandra-es.properties")
g = graph.traversal()
g.V().valueMap()

删除整个图库
graph.close()
JanusGraphFactory.drop(graph)
```

## aisino_graph

项目结构pom文件

```bash
10.106.128.132 node45 web
10.106.128.131 node43 janus + pg

root haohan#2016data
```

1. ```markdown
   1. 属性 VertexMap，edgeMap Input表格有什么用
   ```

2. ```markdown
   1. Header逻辑：
   	1.1 Header不需要回点
   	1.2 如何schema和datamapper不一致的问题，以后再考虑
   ```

3. ```markdown
   1. VertexMap 添加字段名逻辑：
      1. 一开始input默认显示，当input内的内容不为空的时候，继续添加按钮出现
      2. 在input中输入会出现继续添加，点击则相当于确认后继续添加
      3. 点击左下方的添加按钮相当于增加一行
   2. 多属性添加的写法：
      1. 利用一个数组将输入的字段名保存，每次点击之后先刷新字段名然后再显示继续添加
   ```

4. ```markdown
   1. 对于文件路径的传入和修改
   2. v-if的显示逻辑有问题
   3. 所有的文件上传问题
   4. 解决一下文件路径的问题
   5. 解决文件上传的问题 以及页面布局的问题
    5.1: schema文件上传时，如果上传成功时，再显示文件的路径？
    5.2: 文件上传的时候 input是怎么使用
   ```

## select data path


1. 建立数据库表，将数据保存在服务端，方便下次管理员进行读写操作
2. spring-jpa 不支持 update 和 delete操作

```java
@Service
@Transactional
public class DataAndModelStoreService{
  public Integer updateFilePath(String newPath) {
        Query query = em.createNativeQuery(jpql);
        return query.executeUpdate(); // 执行事务
    }
}
```

## edit schema

1. reload逻辑 (TO DO: signature 为null的问题）
2. 上传schema文件

## edit datamapper schema

用户填写注意的错误点：

1. VertexIndexes：使用的PropertyKey需要使用schema配置的PropertyKey

2. VertexMap：[VertexLabel]需要使用Schema中配置的Label，其中所有的属性都需要使用Schema中

3. ```json
   "[edge_left]": {
     "CWFZR_ZJHM": "person.ZJHM"
   },
   "[EdgeLabel]": "fincontrol",
   "[edge_right]": {
     "NSRSBH": "nsr.NSRSBH"
   },
   // 属性需要使用schema中的属性
   ```

1. 编写测试类，测试使用JavaBean对象来存储Map<String, Object> 和 Map<String, String>	
2. reload逻辑
   2.1: 父组件使用v-if 但是没有数据的时候需要显示原始的表格
4. vertexMap edgeMap 中配置了文件的上传文件的名称

## $nextTick()

将回调延迟到下次 DOM 更新循环之后执行。在修改数据之后立即使用它，然后等待 DOM 更新。

很好的解决了getElementsByClassName的问题:cry:

```javascript
this.$nextTick(function() {
    this.relationships = document.getElementsByClassName('graph-cv-item-text')
    // 对象数组当html未渲染的时候就会执行输出的length为0
    console.log(this.relationships)
    for (let i = 0; i < this.relationships.length; i++) {
        console.log(this.relationships[i].innerHTML)
    }
    this.$store.state.relationships = this.relationships
})
```

## graph data model

```markdown
1. 对datamapper.json文件进行解析，构造Vertex和edge
2. VertexMap:{
		person.csv, // 作为结点的id
		nsr.csv,
		commodity.csv
	}
	edgeMap: {
		nsr_finperson.csv: { // 作为结点的id
			"[EdgeLabel]" : "fincontrol", //作为边的label 
			"[edge_left]": 'nsr.NSRSBH', // 分割字符串 左边作为结点的 id
			"[edge_right]": 'person.MC' 
		}
	}
```

## import data

1. 需要读取log文件，并且将导入过程输出到前端
	1.1: 使用logback.xml的配置来完成此功能
	1.2: 使用websocket实现，服务端向前端传输数据
	1.3: 连接出现问题，被前端的拦截器所拦截
	1.4: 使用2秒轮询去读取logback.log文件
2. 需要修改conf/hbase的内容 添加上hbase的表名，再通过janusgraph-utils来进行添加
	2.1: 使用input来获取properties字段，添加属性值
3. 用户点击开始导入，才显示文件下所有的文件名
	3.1: 可以尝试mounted生命周期中直接请求下来，click再传过去
4. 每一个用户的janusgrpah的配置路径不同，如何保证可以顺利读取到janusgraph的配置文件？
5. 输入hbase 表名 storage.hbase.table = hbase 再进行数据到导入
6. 需要在前端处理用户文件不存在的问题

## DataAndStoreController问题

1. 在DataAndStoreController中维护一个RequestID来发送请求,并且根据DataAndStoreController对应的RequestID写日志文件（包括INFO以及ERROR）
2. 在检查信号量的同时需要 不仅需要return null以及 throw 异常给前端捕捉，而且需要再次检查是否有服务重启时子进程依旧再执行（shell脚本实现）通过传递RequestID来给run.sh来获取对应的日志文件来进行前端展示

## datastatistics

1. 根据读取datamapper中文件名获取csv中行数，从而记录每一个结点或者边的数量

## 读取hbase conf 文件并修改其中的配置文件

```java
// 读取properties的属性
public static void getAllProperties(String filePath) throws IOException {
  Properties pps = new Properties();
  InputStream in = new BufferedInputStream(new FileInputStream(filePath));
  pps.load(in);
  Enumeration en = pps.propertyNames();
  while (en.hasMoreElements()) {
    String strKey = (String) en.nextElement();
    String strValue = pps.getProperty(strKey);
    System.out.println(strKey + " = " + strValue);
  }
}
```

```java
// 修改hbase conf 文件
public static void modifyHbaseConf(String filePath, String key, String value) {
  Properties properties = new Properties();
  try {
    InputStream in = new BufferedInputStream(new FileInputStream(filePath));
    properties.load(in);
    String propertyValue = properties.getProperty(key);
    properties.setProperty(key, value);

    OutputStream out = new FileOutputStream(filePath);
    properties.store(out, "Update " + key + " " + value);
  } catch (IOException e) {
    e.printStackTrace();
  }
}
```

## 处理导入错误问题

1. 多列会导致数据的顺延

```shell
g.V().hasLabel('person').has('ZJHM', '330481198905104422')

翟榆婷	330481198905104422	error	error	87298148	15167366781	null	person

[GDDH:[15167366781],DZYX:[person],MC:[翟榆婷],YDDH:[null],ZJHM:[87298148]]
```

2. 少列会导致的原有的数据列会缺少

```shell
g.V().hasLabel('person').has('ZJHM', '87298148')

翟榆婷	87298148	15167366781	null	person 
```

3. 删除文件会导致reader找不到文件，导致后台卡死

```shell
java.io.FileNotFoundException: janusgraph-utils/aisino-data-test/person.csv (No such file or directory)

3.1：卡死之后怎么样停止？

3.2：显示错误信息之后，如何才能重新开始导入呢？

3.3：开始导入时候 button需要显示正在导入，导入错误要显示导入失败
```

4. 数据类型不正确

## 跨域问题

浏览器从一个域名的网页去请求另一个域名的资源时，域名，端口，协议任一不同都是跨域

```markdown
vue-cli3 中解决跨域问题，要在根目录下创建vue.config.js
```

```javascript
module.exports = {
  publicPath: '/',
  devServer: {
    proxy:{
      '/dev-api':{
        target: 'http://localhost:8080/',
        changeOrigin: true,
        ws: true,
        pathRewrite: {
          ^/api: ''
        }
      }
    }
  }
}
```

## Logback.xml

`<configuration>` 
	scan: 此属性设置为true时，配置文件如果发生改变，将会被重新加载，默认是true
	scanPeriod: 设置监测配置文件是否有修改的时间间隔，如果没有给出时间单位，默认单位是毫秒。当scan为true时，此属性生效。默认的时间间隔为1分钟。
	debug: 当此属性设置为true时，将打印出logback内部日志信息，实时查看logback运行状态。默认值为false。

`<appender>`
	负责写日志的组件，有两个必要属性name和class。name指定appender名称，class指定appender的类名

`<ConsoleAppender>`

​	`<encoder>`：对日志进行格式化

​	`<target>`：字符串System.out(默认)或者是System.err

```xml
<configuration> 
　　　<appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender"> 
　　　　　 <encoder> 
　　　　　　　　　<pattern>%-4relative [%thread] %-5level %logger{35} - %msg %n</pattern> 
　　　　　 </encoder> 
　　　</appender> 

　　　<root level="DEBUG"> 
　　　　　　<appender-ref ref="STDOUT" /> 
　　　</root> 
</configuration>
```

`<FileAppender>`

`<file>`：被写入的文件名，可以是相对目录，也可以是绝对目录，如果上级目录不存在会自动创建，没有默认值。　　　　　

`<append>`：如果是 true，日志被追加到文件结尾，如果是 false，清空现存文件，默认是true。
`<encoder>`：对记录事件进行格式化。（具体参数稍后讲解 ）
`<prudent>`：如果是 true，日志会被安全的写入文件，即使其他的FileAppender也在向此文件做写入操作，效率低，默认是 false。

```xml
<configuration> 
  <appender name="FILE" class="ch.qos.logback.core.FileAppender"</appender>
  <file>testFile.log</file> 
  <append>true</append> 
　　　<encoder> 
　　　　<pattern>%-4relative [%thread] %-5level %logger{35}-%msg%n</pattern> 
　　　</encoder> 
　</appender> 

<root level="DEBUG"> 
　<appender-ref ref="FILE" /> 
</root> 
</configuration>
```

## Websocket

前端和后端的交互模式最常见的就是前端发送数据请求。如果前端不做操作，后端不能主动向前端推送数据，这也就是http协议等缺陷

websocket：服务端可以主动向客户端推送消息，实现了平等

## hbase


```shell
echo $HOME
shiyanlou
echo "$HOME"
shiyanlou
echo '$HOME'
shiyanlou
```

## 使用Java调用sh脚本

Java可以通过Runtime调用Linux命令

```java
Runtime.getRuntime().exec(command);
// 调用Runtime.exec方法产生一个本地的进程，并返回一个Process子类的实例

// 该子进程的标准IO(stdin, sdtout, stderr)都重定向给它的父进程了
```



## 重启janusgraph服务

查询进程号并kill进程
lsof -i :8186        （8186为端口号，在/opt/janusgraph-0.2.3-hadoop2/conf/gremlin-server/util_0718.yaml 中有指定端口号）
kill -9 （上一个步骤查到的进程号）

重启

```shell
cd /opt/janusgraph-0.2.3-hadoop2
nohup ./bin/gremlin-server.sh ./conf/gremlin-server/util_0718.yaml &
```

## elasticsearch 启动

1. ss -tanl  查看9200端口是否可以进行访问

2. 无法使用root启动elasticsearch 

3. ```shell
   ./elasticsearch -d 启动elasticsearch
   ```

## Logback-spring.xml

### 输出日志文件到本地：

首先在`application.yml`中配置日志输出

```yaml
logging:
	path: ${user.dir}/logs
  file: ${logging.path}/${spring.application.name}.log
```

如果只是这样，那么本地是不会出现相关的日志文件，接下来，就是要在xml中配置logging.path

***Logback-spring.xml在application之后可以扫描到，如果只写logback.xml那么该xml就会优先于application.yml进行扫描，因此无效***

```xml
<!-- name的值是变量的名称，value的值时变量定义的值。通过定义的值会被插入到logger上下文中。定义后，可以使“${}”来使用变量。 -->
引用bootstrap.yaml中配置的路径
<property name="logging.path" value="${LOG_PATH:-.}"/>
<property name="logging.file" value="${LOG_FILE:-.}"/>
```

1. bash /Users/hujiale/IdeaProjects/aisino_gragh/janusgraph-utils/run.sh import /Users/hujiale/ProgramFiles/janusgraph-0.2.3-hadoop2/conf/janusgraph-cassandra-es.properties /Users/hujiale/IdeaProjects/aisino_gragh/janusgraph-utils/meta-json-files/../aisino-data-test /Users/hujiale/IdeaProjects/aisino_gragh/janusgraph-utils/meta-json-files/8b3472b8-ef29-4ef4-9ff7-2f6e4e0bffb1-schema.json /Users/hujiale/IdeaProjects/aisino_gragh/janusgraph-utils/meta-json-files/8b3472b8-ef29-4ef4-9ff7-2f6e4e0bffb1-datamapper.json 8b3472b8-ef29-4ef4-9ff7-2f6e4e0bffb1

2. 如果直接在Java程序中调用批处理程序，则AG-Server层会等待Shell执行完再执行

3. 在run.sh中将jar包的执行放在程序后台 Java程序不需要等待其执行完成 

   ```shell
   java -cp "$CP":"${utilityJar}" com.ibm.janusgraph.utils.importer.BatchImport "$1" "$2" "$3" "$4" > ./logs/$5.log 2>&1 &
   # 让BatchImport进程放在后台执行
   echo $! > ./logs/pid.txt
   # 保存程序最后一次执行的PID来保证其他用户导入时给予警告
   ```

TO DO LIST：

1. 解决pom 文件依赖的问题 解耦ag-server和janusgraph-utils之间的依赖
2. nohup 让程序放在后台运行，判断导入程序进程是否结束的方法 修改为判断日志文件是否存在
4. 增加导入进度条 在tab页面添加 */n 类型的进度条

## Shell

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

### 只重定向错误

```shell
ls -al badfile 2> test4
cat test4
ls: cannot access badfile: No such file or directory
# shell会只重定向错误信息，而非普通数据
```

### 重定向错误和数据

```shell
ls -al test test2 test3 badtest 2> test6 1> test7

cat test6
ls: cannot access test: No such file or directory
cat test7
-rw-rw-r-- 1 rich rich 158 2020-10-16 11:32 test2
# 将stdout输出到test6 将stderr输出到stderr
```

### 将stdout和stderr重定向到同一个输出文件

```shell
ls -al test test2 test3 badtest &> test7
# 命令生成的所有输出都会发送到同一个位置，包括数据和错误
./test.sh > test2.log 2>&1
# shell 标准输出和错误输出都到同一个文件中
```

### nohup

1) nohup命令是永久执行，忽略挂起信息。&是指在后台执行

2）用&后台运行程序时，如果是守护进程，断开终端则程序继续执行，如果不是守护进程，断开终端则程序也会被断开停止运行

3）使用nohup命令，如果指定了输出文件，输出信息则会附加到输出文件中，如果没有指定输出文件，则输出信息会附加到当前目录下的nohup.out文件中，如果当前目录的nohup.out文件不可写，输出重定向到$HOME/nohup.out文件中。

### shell层：

一开始进行`nohup java -cp` 生成`RequestID-loading.log`文件，标志导入后台程序正在执行
执行过程 并设置后台轮询检查导入程序是否完成 `ps -ef ｜ grep -v grep ｜ grep run.sh`
导入程序完成之后就生成 `ReqeustID-down.log`文件，标志着导入后台程序执行完成
同时使用`RequestID-info`来记录导入程序的日志情况

```shell
# checkprocess.sh
#!/bin/sh

loadingfile=$2/logs/$1-loading.log
endingfile=$2/logs/$1-ending.log

echo $loadingfile $endingfile >> filetype.log
echo $1 >> info.log

line=`ps aux | grep BatchImport | grep -v "grep" | wc -l`
while [ $line -eq 1 ]
do
    if [ ! -d "$loadingfile" ]; then
      touch "$loadingfile"
    fi
    echo "no~" >> process.log
    sleep 3
    line=`ps aux | grep BatchImport | grep -v "grep" | wc -l`
#    val=`ps -aux | grep BatchImport | grep -v "grep" | awk '{print $8}'`
#    echo $val >> status.log
#    if [ "$val" == "Z"]; then
#      pid=`ps -aux | grep BatchImport | grep -v "grep" | awk '{print $2}'`
#      kill -9 $pid
#    fi
done

if [ ! -d "$endingfile" ]; then
  touch "$endingfile"
fi
echo "yes!" >> process.log
```

### AG_SERVER层：

直接读取`Request-info.log`的日志文件
轮询判断是否存在`loading`文件，如果存在则表示还在执行
轮询判断是否存在`ending`文件，如果存在则表示导入完成

在`AG-SERVER`使用`sh`运行`run.sh`脚本，在脚本执行`nohup java -cp`和`checkprocess.sh`防止`AG-SERVER`重启之后后台的父进程也会跟着结束

```shell
# 通过指定logback.xml的配置路径来解决日志输出的格式问题
nohup java -Dlogback.configurationFile=$logbackpath -cp "$CP":"${utilityJar}" com.ibm.janusgraph.utils.importer.BatchImport "$1" "$2" "$3" "$4"  > ./logs/$5-info.log 2>&1 &
```

1. 不同用户进程导入时，控制单线程 -> 给予警告 等待后台执行完成
2. 导入时，当前用户有导入进程在后台运行 -> 直接给予恢复
3. 导入时，AG-SERVER重启之后 用户也有导入进程在后台运行 -> 给予恢复

```java
public void deleteAllFiles(File file) throws Exception {
    if (!file.exists()) {
        throw new Exception("文件删除失败,请检查文件路径是否正确");
    }
    //取得这个目录下的所有子文件对象
    File[] files = file.listFiles();
    //遍历该目录下的文件对象
    for (File f : files) {
        //打印文件名
        String name = f.getName();
        System.out.println(name + " is deleted");
        //判断子目录是否存在子目录,如果是文件则删除
        if (f.isDirectory()) {
            deleteAllFiles(f);
        } else {
            f.delete();
        }
    }
}
```

### getBoundingClientRect()

```javascript
rectObject.top: 元素上边到视窗上边的距离
rectObject.right: 元素右边到视窗左边的距离
rectObject.bottom: 元素下边到视窗上边的距离
rectObject.left: 元素左边到视窗左边的距离
```

### 改变`$router`中的值但是页面不刷新的问题

```javascript
// 监听$route的变化

watch:{
  $route: {
  }
}
```

### 懒加载思路：

```javascript
FilePath: 
	ag-client/src/components/Risk/RiskNsrContent/RiskNsrContent.vue 父组件
  ag-client/src/components/Risk/RiskNsrContent/RiskContentItem/RNGraphLink.vue 子组件

// 父元素
this.SQGraphLink = true
const riskGraphLink = document.getElementById('risk-graph-link') // 获取到dom元素
this.riskGraphLinkBoundingClientRect = riskGraphLink.getBoundingClientRect().top // 获取该div到页面顶部的距离

1. 通过监听滚动事件来位置来传递是否查询的参数
onScroll() {
  // 防止多次查询
  if (this.getViewHeight() > this.riskGraphLinkBoundingClientRect && this.SQGraphLink === false) {
    this.SQGraphLink = true
  }
}

// 子元素监听父组件传递的参数
watch: {
  isQuery(newValue, oldValue) {
    if (newValue === true) {
      this.queryNsrRiskLinkAbnormalData() // 对应的查询函数
    }
  }
}

// 给对应的查询按钮添加防抖函数，避免多次发送请求
this.throttleQueryFunc = _throttle(() => _.queryNsrRiskLinkAbnormalData(), 1000)
queryFunc() {
  this.throttleQueryFunc()
}
```

## v-loading

todo ：需要维护finally之后的hide-loading的状态

```javascript
FilePath: 
	ag-client/src/components/Risk/Common/RiskNsrHeader.vue
  ag-client/src/components/Risk/RiskNsrContent/RiskContentItem/RNCrossNsr.vue
// 非table的元素
data(){
  return {
    contentLoading: null
  }
},
  
showLoading() {
  this.hideLoading()
  this.contentLoading = this.$loading({
    target: document.querySelector('#risk-nsr-info-container'), // 选择对应需要loading样式的div
    background: 'rgba(0, 0, 0, 0.8)',
    lock: true
  })
},
hideLoading() {
  if (this.contentLoading) {
    this.contentLoading.close()
  }
},
checkIfEndingLoading() {
  const checkLoading = setInterval(() => {
    if (this.infod !== null) { // 这里判断需要看对应的数据是否异步获取到了 再hide loading样式
      this.hideLoading()
      clearInterval(checkLoading)
    }
  }, 1000)
}

// table元素
<el-table
	v-loading="loading"
  v-loading.lock="true"
>
</el-table>

data(){
  return {
    loading: true
  }
}

queryRiskCrossInfoTable() {
  DataApi.nsrriskcrossinfodiscovery_table({nsrsbh: this.info, year: this.year}).then(data => {
    this.loading = false // 根据异步获取到的数据来相应给予loading对应的值
    this.tableData = data
  })
}
```

## 10.106.128.29 服务器

1. 部署janusgraph-0.2.3环境

```shell
# 安装janusgraph-0.2.3
unzip janusgraph-0.2.3-hadoop2

# 创建一个新的用户hjl
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

nohup npm run dev & 
```

```shell
5倍：hdfs/data1/enhanceData5Times

HBase: 1026_5TIMES

10倍：hdfs/data2/enhanceData10Times

Hbase: 1026_10TIMES
```

## Job.sh

修改job.sh 判断是否有在data-test目录下有文件 如果有则运行job.sh 否则就不运行job.sh

```shell
awk '{print $1","$2}' nsr.csv > td_nsr.csv

\copy td_nsr_test from '/Users/hujiale/PycharmProjects/pythonProject/ag/test/td_nsr.csv' with csv header;
```



## Import data 5 times (Janus 0.2.3)

```shell
nohup run.sh import /hdfs/data1/ag_enhanced_data/conf/janus023_5_times_base.properties /hdfs/data1/ag_enhanced_data/5times /opt/aisino_graph/janusgraph-utils/aisino-conf/utiltest_schema.json /opt/aisino_graph/janusgraph-utils/aisino-conf/utiltest_datamapper.json 20201027_5time_base

# 修改hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

192.168.80.73   gpm
192.168.82.38   web
192.168.80.45    namenode
192.168.80.40    datanode40    datanode40.novalocal
192.168.80.41    datanode41    datanode41.novalocal
192.168.80.42    datanode42    datanode42.novalocal
192.168.80.43    datanode43    datanode43.novalocal
192.168.80.44    datanode44    datanode44.novalocal
```

## 11-03

1. cassandra导入测试
2. 文档配置文件部分
3. 数据导入部分文件路径修改

## cassandra 导入测试

nsr.csv, 3736s, 1/5
jxx_nsr.csv, 212s, 2/5
commodity.csv, 2s, 3/5
invoiceFlow_nsr.csv, 293s, 4/5

## Nginx

###  基本概念
1. 反向代理
  正向代理：在客户端（浏览器）配置代理服务器，通过代理服务器进行互联网访问
  反向代理：我们只需要将请求发送给反向代理服务器，由反向代理服务器去选择目标服务器获取数据后，再返回给客户端，此时反向服务器和目标服务器对外就是一个服务器，暴露的是代理服务器地址，隐藏了真实服务器IP地址
2. 负载均衡
  单个服务器上解决不了高并发的情况，通过增加服务器的数量，然后将请求分发到各个服务器上，将原先请求集中到单个服务器上的情况改为将请求分发到多个服务器上，将负载分发到不同的服务器
3. 动静分离
  为了加快网站的解析速度，可以把动态页面和静态页面由不同的服务器来解析，加快解析速度，降低原来单个服务器的压力

### Nginx的分配方式

1. 轮询方法（默认）
    每个请求按照时间顺序逐一分配到不同的后端服务器上，如果后端服务器down掉，可以自动剔除

2. weight
    指定轮询几率，weight和访问比率成正比，用于后端服务器性能不均的情况
    ```shell
    upstream server_pool{
      server 192.168.5.31 weight=10;
      server 192.168.5.22 weight=20;
    }
    ```
3. ip_hash
    每个请求按访问ip的hash结果分配，这样每个访客固定底访问一个后端服务器，可以解决session的问题
    ```shell
    upstream server_pool{
      ip_hash;
      server 192.168.5.21:80;
      server 192.168.5.22:80;
    }
    ```
4. fair
    按后端服务器的响应时间来分配请求，响应时间短的优先分配
    ```shell
    upstream server_pool{
      server 192.168.5.21:80;
      server 192.168.5.22:80;
      fair;
    }
    ```
### ag中的nginx.conf

```shell

cd /usr/local/nginx
mkdir key
cd key

openssl genrsa -des3 -out ssl.key 4096
### 输入密码1111
Enter pass phrase for ssl.key:1111
Verifying - Enter pass phrase for ssl.key:1111

mv ssl.key xxx.key
openssl rsa -in xxx.key -out ssl.key
# 输入密码1111
rm -f xxx.key

openssl req -new -key ssl.key -out ssl.csr
############
Country Name (2 letter code) [XX]:CN
State or Province Name (full name) []:beijing
Locality Name (eg, city) [Default City]:haidian
Organization Name (eg, company) [Default Company Ltd]:aisino
Organizational Unit Name (eg, section) []:dev
Common Name (eg, your name or your server's hostname) []:0.0.0.0
Email Address []:1220041986@qq.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
############

openssl x509 -req -days 365 -in ssl.csr -signkey ssl.key -out ssl.crt
############
Signature ok
subject=/C=CN/ST=beijing/L=haidian/O=aisino/OU=dev/CN=0.0.0.0/emailAddress=1220041986@qq.com
Getting Private key
############

vi /usr/local/nginx/conf/nginx.conf

    server {
        listen 80;
        listen 443 ssl;
        server_name 0.0.0.0;

        ssl_certificate /usr/local/nginx/key/ssl.crt;
        ssl_certificate_key /usr/local/nginx/key/ssl.key;
        #ssl_session_timeout 5m;
        #ssl_protocols SSLv2 SSLv3 TLSv1;
        #ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;

        #ssl_prefer_server_ciphers on;

        location / {
            root html;
            index index.html index.htm;
        }
        location ~* ^/(ag-api) {
            proxy_pass         http://127.0.0.1:5577;
            rewrite "^/ag-api/(.*)$" /$1 break;
            proxy_set_header   X-Real-IP        $remote_addr;
            proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
        }
    }

/usr/local/nginx/sbin/nginx -s reload

```