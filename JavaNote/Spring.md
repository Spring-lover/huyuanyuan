# Spring

#### IOC

控制反转Ioc（Inversion of Control）是一种设计思想，**并通过第三方去生产或获取特定对象的方式**

Spring容器在初始化时先读取配置文件，根据配置文件或元数据创建与组织对象存入容器中，程序使用时再从Ioc容器中取出需要的对象

#### 关于为什么容器中取出的对象不能是Impl类的原因：

由于将实现类注入到容器中，容器在生成类的基础上进行增强（Proxy）使用JDK的BeanProxy类是和Impl是兄弟关系而不是父子关系，所以只能强转为接口实现多态。

#### Bean的自动装配

见注解描述1~3

## 动态代理

```java
/* 代理类和被代理类实现同一个接口，对方法或者参数进行加强*/
 Proxy newProxyInstance方法的参数：
	ClassLoader:类加载器,代理对象和被代理对象使用相同的类加载器
	Class[]:字节码数组;
	new InvocationHandler(){};

	final Producer producer = new Producer();
	IProducer proxyProducer= (IProducer) Proxy.newProxyInstance(producer.getClass().getClassLoader(),
                producer.getClass().getInterfaces(), new InvocationHandler() {
                    /**
                     * 作用：执行被代理对象的任何接口方法都会经过该方法
                     * 方法参数的含义
                     * @param proxy   代理对象的引用
                     * @param method  当前执行的方法
                     * @param args    当前执行方法所需的参 数
                     * @return        和被代理对象方法有相同的返回值
                     * @throws Throwable
                     */
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        Object returnValue=null;
                        //提供增强的代码
                        //1.获取方法执行的参数
                        Float money = (Float)args[0];
                        //2.判断当前方法是不是销售
                        if("sellProduct".equals(method.getName())){
                           returnValue = method.invoke(producer, money*0.8F);
                        }
                        return returnValue;
                    }
                });
	proxyProducer.sellProduct(1000F);

```

## AOP

面向切面编程，利用AOP可以对业务逻辑的各个部分进行隔离，从而使得业务逻辑各部分之间的耦合度降低，提高程序的可重用性，同时提高了开发的效率

即AOP在不改变原有代码的情况下，去增加新的功能

#### 定义切点：

```java
package concert;

public interface Performance{
    public void perform();
}

execution(*.concert.Performance.perform(..)) && within(concert.*);
execution(*.concert.Performance.perform(..)) and bean('woodsock');
```

*：代表不关心函数的返回值是什么

concet.Performance：关注哪一个类

perform：方法名

(..)：代表任意的参数

within：代表只有concert包下的类

bean('woodsock')：代表限定bean的id为woodsock

```java
@Aspect
public class Audience{
    @Before("execution(* com.Learn.Service.Imp.UserServiceImp.*(..))")
	public void takeSeat(){
    	System.out.println("Take seats");
	}
    @Before("execution(* com.Learn.Service.Imp.UserServiceImp.*(..)))"
    public void silenceCellphones(){
        System.out.println("Silencing cell phones");
    }
    @After("execution(* com.Learn.Service.Imp.UserServiceImp.*(..)))"
    public void demandRefund(){
        System.out.println("Demanding a refund");
    }
}
```

可以简写为

```java
@PointCut("execution(* com.Learn.Service.Imp.UserServiceImp.*(..))")
public void performance() {}

@Before("performance()")
public void takeSeat(){
    System.out.println("Take seats");
}
@Before("performance()")
public void silenceCellphones(){
    System.out.println("Silencing cell phones");
}
@After("performance()")
public void demandRefund(){
    System.out.println("Demanding a refund");
}
```

需要在JavaConfig中开启注解，并且需要注册在Bean中

```java
@EnableAspectJAutoProxy
@Configuration
public class ConcertConfig{
    @Bean
    public Audience audience(){ // 注册了一个id="audience"的切面类
        return new Audience();
    }
}
```

# 注解

@Autowired

可以对类成员变量、方法及构造函数进行标注，让Spring完成bean自动装配的工作

@Autowired默认是按照类去匹配，配合@Qualifier指定按照名称去装配

```java
@Controller
public class TestController{
    // 成员属性字段使用@Autowired, 无需字段的set方法
    @Autowired
    private TypeService typeService;
    
    // set 方法使用@Autowired
    private ArticleService articleService;
    @Autowired
    public void setArticleService(ArticleService articleService){
        this.articleService = articleService;
    }
    // 构造方法使用 @Autowired
    private TagService tagService;
    @Autowired
    public TestController(TagService tagService){
        this.tagService = tagService;
    }
}
```

## @Qualifier

Autowired是根据类型自动装配的，加上@Qualifier则可以根据byName的方式自动装配
Qualifer不能单独使用

Bean注解的默认name是方法的名称

例：如果有一个接口的两个实现类，注入的时候需要指明

```java
public interface ProductService {}

@Service("ProductServiceImp1")
public class ProductServiceImp1 implements ProductService {}

@Service("ProductServiceImp2")
public class ProductServiceImp2 implements ProductService {}

@Autowired
@Qualifier("ProductServiceImp1")
ProductService productService;
```

## @Resource

- 如有指定的name属性，先按该属性进行byName方式查找装配；
- 再进行默认的byName方式进行装配；
- 如果以上都不成功,则按byType的方式进行装配

## @Component

相当于配置文件中

```xml
<bean id="user" class="当前注解的类">
```

通过JavaConfig类进行配置

```java
@Configuration
public class Myconfig{
    @Bean // 通过该方法注册一个bean,这里的返回值就是Bean的类型，方法名是bean的id
    public Dog dog(){
        return new Dog();
    }
}
```

## @RequestParam

把请求中指定名称的参数给控制器中的形参赋值

- value：请求参数的名称
- name：同上
- required：请求参数是否必须提供此参数，默认是true

## @RequestBody

用于获取请求体的内容，直接获取得到的是**key=value&key=value**的数据

get请求方法不可用

required：是否必须要传请求体，默认值是true，当取值为true时，get请求方法会报错，但是取值为false时，get请求为null

```java
@RequestMapping("/useRequestBody")
public String useRequestBody(@RequestBody(required=false)String body){
    System.out.println(body);
    return "success";
}
```

@ResquestBody将Http请求正文插入方法中，使用适合的HttpMessageConverter将请求体写入对象例如将json对象的字符串返回一个`JavaBean`对象

```java
@RequestMapping(value = "testJson", method = RequestMethod.POST)
// 前台传来'{"addressName":"shanghai", "addressNum":100}'
// 不是json对象，而是json对象的字符串，@ResquestBody将参数封装到address对象中
// 并且通过@ResponseBody返回json数据
public @ResponseBody Address testJson(@RequestBody Address address){
    System.out.println(address);
    return address;
}
```

## @ResponseBody

是作用于方法上，表示该方法的返回结果直接写入HTTP response body中，例如：异步获取对象json数据，加上@ResponseBody会直接返回Json数据

```javascript
$(function () {
    $("#btn").click(function () {
        $.ajax({
            url: "${pageContext.request.contextPath}/json/testJson",
            contentType: "application/json;charset=UTF-8",
            data: '{"addressName":"shanghai", "addressNum":100}',
            dataType: "json",
            type: "post",
            success: function (data) {
                console.log(data.addressName);
            }
        })
    })
});
```

## @PathVariable

用于绑定url中的占位符，请求url中/delete/id其中的{id}就是url的占位符

value：用于指定url占位符名称

required：是否必须提供占位符

```html
<a href="userPathVariable/100"></a>
```

```java
@RequestMapping("userPathVariable/{id}")
public String UserPathVariable(@PathVariable(value="id"), Integer id){
    System.out.println(id);
    return "success";
}
```

## @ModelAttribute

1：出现在方法上：表示我当前方法会在控制器方法执行前先执行

2：出现在参数上：获取指定的数据给参数赋值

应用场景：当提交表单数据不是完整的实体数据时，保证没有提交的字段使用数据库原来的数据。

```java
// 该方法会在控制器方法执行前执行，获取到user的对象
@ModelAttribute
public void showUser(String name, Map<String, User> map){
    System.out.println("方法执行中");
    User user = new User();
    user.setUname("Vue");
    user.setUage(18);
    user.setDate(new Date());
    map.put("vue", user);
}
// 该方法会在ModelAttribute中获取键值为“vue”的user对象
@RequestMapping("testModelAttribute")
public String testModelAttribute(@ModelAttribute(value = "vue") User user){
    System.out.println(user);
    return "success";
}
```

## @SessionAttribute

将属性存储到`Session`域中，用于多次执行控制器方法间参数的共享

```java
// 注解作用于类上
@SessionAttribute(values={"username", "password"}, types={"String.class, String.class"})
public class HelloController{
    @RequestMapping(path="/save")
    public void save(Model model){ //通过使用Model对象将属性存储在Model中
        model.addAttribute("username", "root");
        model.addAttribute("password", "123456");
    }
    @RequestMapping(path="/find")
    public String find(ModelMap modelMap){ // 通过使用ModelMap对象将存储在Session中的属性取出
        String uname = (String)modelMap.get("username");
        String passwd = (String)modelMap.get("password");
        return "success";
    }
    @RequestMapping(value="/clean")
    public void delete(SessionStatus status){
        status.setComplete(); // 清除Session中的数据
        return "success";
    }
}
```

## @requestMapping

path：指定请求路径的url

value：value属性和path属性是一样的

method：指定方法的请求方式，RequestMethod.POST(enum枚举类型)

params：指定限制请求参数的条件

headers：发送的请求中必须包含的请求头，ps：Accept.......

## @transient

需要实现Seriliziable接口，将不需要序列化的属性前添加关键字transient，序列化对象的时候，这个属性就不会序列化到指定的目的地中。

如果有一些敏感信息（如密码，银行卡号等）为了安全起见，不希望在网络操作中被传输，这些信息对应的变量就可以加上transientu关键字，这个字段的生命周期仅存于调用者的内存而不会写到磁盘持久化

## @属性注入

1. 可以不用提供的set方法，直接在类名上添加`@Value("value")`
2. 如果提供了set方法，在set方法上添加了`@Value("value")`
3. SpringBoot中如果需要使用yaml来获取值需要使用`${}`来取值

@Controller：web层

@Service：service层

@Repository：dao层

@**scope**

**singleton**：Spring采用单例模式创建这个对象。关闭工厂时，所有的对象都会被销毁

**prototype**：多例模式。关闭工厂，所有的对象不会销毁，内部的垃圾回收机制会回收

# SpringMVC

SpringMVC框架基于组件执行流程

1：前端控制器DispatchServlet 接受用户的请求 请求查找Handler

2：处理器映射器HandlerMapping匹配相应的Controller中的方法

3：返回一个执行链 HelloController中的sayhello()

4：请求适配器执行HandleAdapter 返回ModelAndView(信息和视图) → "success"

5：进入视图解析器ViewResolver 进行资源匹配jsp，html，FreeMaker......

6：最后进行视图的渲染并且response响应

## ModelAndView对象

```java
@RequestMapping("getModelAndView")
public ModelAndView getModelAndView(){
    ModelAndView mv = new ModelAndView();
    mv.setViewName("success"); // 这里会调用视图解析器
    mv.addObject("username", "Vue");
    return mv;
}
```

在前端`Jsp`中需要使用${requestScope.username}取出

## 输入中文字符乱码

```xml
<!--
配置中文乱码问题
配置web.xml filter
-->
<filter>
    <filter-name>characterEncodingFilter</filter-name>
    <!--CharacterEncodingFilter类型-->
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
        <param-name>encoding</param-name>
        <param-value>UTF-8</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>characterEncodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

## 自定义类型转换器

让用户可以通过输入2020-1-1转化为2020/1/1的形式

```xml
<!--ConversionServiceFactoryBean-->
<bean id="conversionService" class="org.springframework.context.support.ConversionServiceFactoryBean">
    <property name="converters">
        <set>
            <bean class="utils.StringToDateConverter"/>
        </set>
    </property>
</bean>
<!--开启Spingmvc框架的注解的支持以及convert-service支持-->
<mvc:annotation-driven conversion-service="conversionService"/>
```
###  utils/StringToDateConverter.java

```java
public class StringToDateConverter implements Converter<String, Date> {
    // 注意Converter<String, Date>泛型的实现
    @Override
    public Date convert(String source) {
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

        try {
            return df.parse(source);
        } catch (Exception e) {
            throw new RuntimeException("输入数据错误");
        }
    }
}
```

## SpringMVC文件上传

SpringMVC框架提供了MultipartFile对象，该对象表示上传的文件

1：配置multipartResolver对象，class：CommonMutilpartResolver

2：Controller中的对象为MultipartFile upload(要求变量名称必须和表单file标签的name属性名称相同)

3：upload.transferTo(new File(file, filename));完成文件的上传

## SpringMVC异常处理

1：自定义**异常类**

2：自定义异常**处理器** 实现`HandlerExceptionResolver`接口，手动配置ModelAndView的路径和信息

3：`springxml`配置异常处理器

```java
package exception;

public class SysException extends Exception {
    private static final long serialVersionUID = 4055945147128016300L;

    private String message;

    public SysException(String message) {
        this.message = message;
    }
    public String getMessage() {
        return message;
    }
    public void setMessage(String message) {
        this.message = message;
    }
}
```

```java
public class SysExceptionResolver implements HandlerExceptionResolver { // 实现接口 重写方法 并且需要在SpringXML中注册
    @Override
    public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) { // 其中ex是接受到的异常
        SysException e = null;
        if(ex instanceof SysException) e = (SysException) ex;
        else e = new SysException("请联系管理员");
        ModelAndView mv = new ModelAndView();
        mv.addObject("message", e.getMessage());
        mv.setViewName("error");
        return mv;
    }
}
```

```xml
<!--配置处理异常类-->
    <bean id="sysExceptionResolver" class="exception.SysExceptionResolver"/>
```

```java
@Controller
public class HelloController {

    @RequestMapping(path = "/hello")
    public String sayHello() throws SysException { // 抛出异常
        System.out.println("Hello SpringMVC");
        int number = 1 / 0;
        return "success";
    }
}
```

SpringMVC拦截器

过滤器是servlet规范中的一部分，任何Java Web工程都可以使用

拦截器是SpringMVC框架自己的，使用使用了SpringMVC框架的工程才能使用

过滤器在url-pattern中配置了/*之后，可以对所有要访问的资源拦截

拦截器只会拦截访问的控制器的方法，如果访问jsp，html，css或者是js是不会进行拦截的

1：编写拦截器类，实现HandleInterceptor接口

2：配置拦截器

```xml
<mvc:interceptors>
    <mvc:interceptor>
        <mvc:mapping path="/usr/*"/>
        <bean class="Interceptor.MyInterceptor"></bean>
    </mvc:interceptor>
</mvc:interceptors>
<!--配置拦截器设置-->
```

```java
public class MyInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        return false;
    }
    // return true：表示成功放行，可以根据request对象进行页面跳转
    // return false: 表示拦截
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}
/* 拦截器都是拦截Controller执行的方法，
preHandle在Controller执行之前拦截
postHandle在Controller执行之后拦截，在jsp视图执行前
afterCompletion在jsp执行后执行*/
```

# Maven

```xml
<project>
	<modelVersion>4.0.0</modelVersion>
	<groupId>com.itranswarp.learnjava</groupId>
	<artifactId>hello</artifactId>
	<version>1.0</version>
	<packaging>jar</packaging>
	<properties>
        ...
	</properties>
	<dependencies>
        <dependency>
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
            <version>1.2</version>
        </dependency>
	</dependencies>
</project>
<!--
groupId类似于Java的包名，通常是公司或组织名称
artifactId类似于Java的类名，通常是项目名称，再加上version
一个Maven工程就是由groupId，artifactId和version作为唯一标识

<dependency>声明一个依赖后，Maven就会自动下载这个依赖包并把它放在classpath中
-->
```

## 依赖关系

|  scope   |                     说明                      |
| :------: | :-------------------------------------------: |
| compile  |             编译时需要用到该jar包             |
|   test   |            编译Test需要用到该jar包            |
| runtime  |          编译时不需要但是运行时需要           |
| provided | 编译时需要用到，但运行时由JDK或某个服务器提供 |

```shell
mvn clean # 清理所有生辰的class和jar

mvn clean compile #先清理 再执行到compile

mvn clean test # 先清理 再执行到test

mvn clean package # 先清理，在执行到package
```

# SpringBoot

## 启动类

`@SpringBootApplication`是一个组合注解，组合了三个其他的注解

- `@SpringBootConfiguration`：将该类声明为配置类，这个注解实际上是`@Configuration`注解的特殊形式
- `@EnableAutoConfiguration`：启用SpringBoot的自动配置
- `@ComponentScan`：启用组件扫描

## @RestController

`@RestController = @ResponseBody + @Controller`

使用@RestController这个注解，就不能返回jsp，html页面，视图解析器无法解析jsp，html页面

## @AutoConfigurationPackage：自动配置包

将主配置类的（@SpringBootApplication标注的类）的所在包下所有的子包里面的所有组件都扫描到Spring容器中。

## @ConfigurationProperties(perfix="person")

通过将yaml资源文件中的属性值来配置JavaBean的对象，前提必须是容器中的对象才能配置

```java
@Component
@ConfigurationProperties(prefix = "person")
// 需要有set和get的方法
public class Person {
    private String name;
    private Integer age;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }
}
```

## @ConfigurationProperties and @Value

|                      | @ConfigurationProperties | @Value     |
| -------------------- | ------------------------ | ---------- |
| 功能                 | 批量注入配置文件中的属性 | 一个个指定 |
| 松散绑定（松散语法） | 支持(last-name=lastName) | 不支持     |
| SpEL                 | 不支持                   | 支持       |
| JSR303数据校验       | 支持                     | 不支持     |
| 复杂类型封装         | 支持                     | 不支持     |

```java
@Component
@ConfigurationProperties(perfix= "person")
@Validated
public class Person{
    // lastName必须是邮件格式
    @Email
    private String lastName;
}
```

## classpath

默认是src(source)目录下的所有包编译生成到target目录下`target/classes`路径下

## SpringBoot注入组件

1：使用`JavaConfig配置类`

```java
@Configuration
public class MyAppConfig {
    // 将方法的返回值添加到容器中,容器中这个组件默认的id就是方法名
    @Bean
    public HelloService helloService(){
        System.out.println("配置类@bean给容器中添加组件");
        return new HelloService();
    }
}
```

2：使用`注解Service/Controller/Component(value="helloService")`

```java
@Service(value = "helloService")
public class HelloService {
    
} 
```

3: Spring-Boot注入配置参数

- 获取application中的值

给类加`@ConfigurationProperties(prefix = "heartbeats")`

```java
@Component
@ConfigurationProperties(prefix = "heartbeats")
public class HeartBeatsConfig {
    private String index;

    public String getIndexPrefixName() {
        return index;
    }

    public void setIndexPrefixName(String indexPrefixName) {
        this.index = indexPrefixName;
        Constants.HeartBeatsPrefixName = indexPrefixName;
    }
}
```

可以使用@Autowired进行注入并使用

- 命令行注入(优先级高)

```java
nohup $JAVA_HOME/bin/java -Dclouderamanager.username="${clouderaManagerUserName}"

通过-D+参数名进行配置
```

```yml
clouderamanager:
  username: "admin"
```