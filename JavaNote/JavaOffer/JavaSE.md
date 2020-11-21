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

### jdk7 HashMap的put方法

- part1: 特殊的key值处理，key为null时
- part2: 计算table中目标bucket的下标
- part3: 指定目标bucket，遍历Entry结点链表，若找到key相同的Entry结点，则做替换
- part4: 若未找到Entry结点，则新增一个结点

#### jdk7特殊key值处理

a): HashMap中，允许key，value都为null的，且key为null只存一份，多次存储会将旧value值覆盖
b): key为null的存储位置，都统一放在下标为0的bucket，即table[0]位置的链表
c): 如果第一次对key=null做put操作，将会在table[0]的位置新增一个Entry结点，使用头插法做链表的插入

#### jdk7 addEntry()

给定hash，key，value，bucket下标，新增一个结点，如果哈希表中存放k-v对数量阈值（threshold = table.length* loadFactor）且当前bucket下标有链表存在，那么就做扩容处理（resize），扩容之后，重新计算hash，最终获得新的下标

#### jdk7 扩容

a) 扩容后大小是扩容前的2倍
b) 数据搬迁，从旧table迁到扩容后的新table。为了避免碰撞过多，先决策是否需要对每一个Entry链表结点重新hash，然后根据hash值计算得到bucket下标，再用头插法做结点迁移

#### jdk 如何计算bucket下标

使用key的hashCode作为算式的输入，得到了hash值

将table的容量与hash值做“与”运算，得到哈希table的bucket下标

**扩展**

为什么哈希table的大小控制为2次幂数？

1: 降低发生碰撞的概率，使散列更均匀。根据 key 的 hash 值计算 bucket 的下标位置时，使用“与”运算公式：h & (length-1)，当哈希表长度为 2 的次幂时，等同于使用表长度对 hash 值取模，散列更均匀；
2. 表的长度为 2 的次幂，那么(length-1)的二进制最后一位一定是 1，在对 hash 值做“与”运算时，最后一位就可能为 1，也可能为 0，换句话说，取模的结果既有偶数，又有奇数。设想若(length-1)为偶数，那么“与”运算后的值只能是 0，奇数下标的 bucket 就永远散列不到，会浪费一半的空间。

#### 谈一下HashMap中哈希函数是怎么实现的？ 

```java
static final int hash(Object key) {
    int h;
    return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
}
 
static int indexFor(int h, int length) {
    return h & (length-1);
}
```

首先根据key的hashcode进行右位移运算（>>>）获取hashcode的高16位数，之后再与hashcode本身做异或（^）操作，获取的值降低了冲突的可能性。该函数也被叫做：扰动函数，说白了就是将hashcode的高16位与低16位进行混合，替换掉hashcode的低16位。

获取到散列值后需要和数组长度做取模操作，HashMap中通过做与操作（&）完成，这也是为什么要求数组容量必须是2的幂次了，只有2的幂次取与操作才相当于取模操作。

#### 谈一下为什么不直接将key作为哈希值而是与高16位做异或运算？

桶位的确定是通过散列值和数组长度做与（&）操作确定的，实际只使用了散列值的低位（由数组长度确定），如果直接使用哈希值其发生冲突的可能性增加，而HashMap中通过与高16位做异或操作将低位与高位进行混合，这样增加了散列值的随机性，降低了hash冲突的可能性。


#### 头插法为什么会出现死锁

transfer函数中，同时扩容时，会生成循环链表，等下次再访问时则会发生死锁