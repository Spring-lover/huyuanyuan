如何判断整数大小是否越界？

这里我们要进行模式识别，一旦涉及整数的运算，我们需要注意溢出。本题可能产生溢出的步骤在于推入，乘 10 操作和累加操作都可能造成溢出。对于溢出的处理方式通常可以转换为 INT_MAX 的逆操作。比如判断某数乘 10 是否会溢出，那么就把该数和 INT_MAX 除 10 进行比较。

正数与负数比较方法相同，只是大小负数的绝对值比正数的绝对值大一

```java
if (sign > 0 && res > (Integer.MAX_VALUE - digit) / 10) return Integer.MAX_VALUE;
if (sign < 0 && res > (Integer.MIN_VALUE + str.charAt(i) - '0') / 10 * (-1)) return Integer.MIN_VALUE;
```

