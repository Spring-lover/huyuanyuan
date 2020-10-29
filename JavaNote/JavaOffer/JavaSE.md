## Java 中应该使用什么数据类型来表示价格

不关心内存和性能 BigDecimal,否则double即可

## 怎么将byte转换为String

String 接收 byte[] 参数的构造器来进行转换，需要注意的点是要使用的正确的编码，否则会使用平台默认编码
