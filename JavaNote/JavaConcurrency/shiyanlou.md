两种创建多线程的方法

```java
package JavaConcurrencyInPractice;

public class test0 {
    public static void main(String[] args) {
//        Thread myThread = new MyThread();
//        myThread.start();
        MyRunnable myRunnable = new MyRunnable();
        Thread thread = new Thread(myRunnable);
        thread.start();
    }
}

class MyThread extends Thread{
    @Override
    public void run() {
        System.out.println("hello myThread" + Thread.currentThread().getName());
    }
}
// 如果创建的线程类已经含有父类时，不能够再次继承Thread类，此时需要使用实现Runnable接口来创建多线程
class MyRunnable implements Runnable{

    @Override
    public void run() {
        System.out.println("hello myRunnable" + Thread.currentThread().getName());
    }
}
```

## start 和 run的区别

```java
start(): 函数用来启动线程，start方法来启动一个线程，这时线程是处于就绪状态，并没有运行;不可以多次调用
run(): 不会创建新的线程，可以被多次调用;
run()函数只是一个普通的函数,start()函数才是真正意义上创建了多线程
```

## isAlive()

```java
一个线程在new出来后，处于非活跃状态，而在运行与结束后，都处于活跃状态
```

## synchronized and static synchronized

```java
synchronized 是实例锁(锁在某一个实例对象上，如果该类是单例，那么该锁也具有全局锁的概念);

static synchronized 是全局锁(该锁针对的是类, 无论实例多少对象，那么线程都共享该锁);
```

## synchronized块详解

修饰代码块下 -- 成员锁

```java
synchronized (myLock.lock){
  try{
    myLock.lock.wait();
  } catch(InterruptedException e){
    e.printStackTrace();
  }
}
```

修饰代码块下 -- 实例对象锁 this 代表当前实例

```java
synchronized(this){
  for (int j = 0; j < 100; j++){
    i ++;
  }
}
```

修饰代码块下 -- 当前类的class对象锁 

```java
synchronized(AccountingSync.class){
  for(int j = 0; j < 100; j++){
    i ++;
  }
}
```

