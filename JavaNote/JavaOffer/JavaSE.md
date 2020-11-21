# Java 基础

## Java集合

### List

1. ArrayList: 基于数组实现，增删慢，查询快，线程不安全
   1. 扩容的机制会创建一个新的更大的数组，并将已有的数据复制到新的数组中
2. Vector: 基于数组实现，增删慢，查询快，线程安全
   1. Vector会进行加锁和释放锁的操作，读写的效率比ArrayList低

3. LinkedList: 基于双向链表，增删快，查询慢，线程不安全
   1. 提供了List接口中未定义的方法，用于操作链表头部和尾部的元素


### Queue

### Set

1. HashSet: HashMap实现， 无序

    HashSet 存放的是散列值，按照元素的散列值来存取元素的

2. TreeSet: 二叉树实现
    
    TreeSet 基于二叉树的原理对新添加的对象按照指定的顺序排序，自定义数据结构必须实现Comparable接口

3. LinkHashSet: 继承HashSet, HashMap实现数据存储，双向链表记录顺序

### Map

1. HashMap: 数组 + 链表存储数据，线程不安全

    

# 问答题

## Java 中应该使用什么数据类型来表示价格

不关心内存和性能 BigDecimal,否则double即可

## 怎么将byte转换为String

String 接收 byte[] 参数的构造器来进行转换，需要注意的点是要使用的正确的编码，否则会使用平台默认编码

## HashSet是如何保证数据不可重复的？

HashSet 的底层使用的其实就是HashMap，只不过HashSet是实现了Set接口并且把数据保存在K值了，而V值则使用一个相同的虚值来保存

## i++ ++i
 - 赋值=， 最后计算
 - =右边的从左到右加载值依次压入操作数栈
 - 实际先算哪个，看运算符优先级
 - 自增、自减操作都是直接修改变量的值，不经过操作数栈
 - 最后的赋值之前，临时结果也是存储在操作数栈中

### String StringBuilder StringBuffer

- 可变与不可变 String是final是不可变的，StringBuilder和StringBuffer都是继承于AbstractStringBuilder都是可变的
- 线程安全 String是不可修改的，StringBuffer对方加了同步锁是线程安全的，StringBuilder没有对方法添加同步锁，所以是非线程安全的
- 执行效率 String执行效率是最慢的，StringBuffer执行效率差别不大，StringBuilder是执行效率最高的

### HashMap和HashTable的区别

- HashMap几乎可以等价于HashTable，除了HashMap不是线程安全的，HashTable是线程安全
- HashMap可以接受key为null以及value为null的，而HashTable不行
- HashMap把HashTable的contains方法去掉了，改成了containsValue和containsKey
- 