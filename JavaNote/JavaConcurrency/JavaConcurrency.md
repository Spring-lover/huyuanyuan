## 2020-8-16

无状态对象一定是线程安全，它既不包含任何域，也不包含任何对其他类中域的引用。计算过程中的临时状态仅存在于线程栈上的局部变量中，并且只能由正在执行的线程访问

```java
@NotThreadSafe
// 在没有同步的情况下，统计已处理请求数量的Servlet
public class UnsafeCountingFactorizer implements Servlet{
  private Long count = 0;
  
  public long getCount() {return count;}
  
  public void service(){
    ++count;
  }
}
```

一个常见的竞争条件：先检查后执行，即通过一个可能失效的观测结果来决定下一步的动作。

这种观察结果的失效就是大多数竞态条件的本质：基于一个**可能失效的观察结果**来做出判断或者执行某一个计算

```java
@NotThreadSafe
public class LazyInitRace{
  private ExpensiveObject instance = null;
  
  public ExpensiveObject getInstance(){
    if(instance == null) 
      instance = new ExpensiveObject();
    return instance;
  }
}
```

在实际情况下，尽可能使用现有的**线程安全**的对象来管理类的状态

```java
@ThreadSafe
public class CountingFactorizer implement Servlet{
  private final AtomicLong count = new AtomicLong(0);
  
  public long getCount() {return count.get();}
}
```

如何限制其中某一个方法`method()`被调用的并发数不超过100

```java
private static Semaphore semaphore = new Semaphore(1)
```



