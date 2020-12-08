### Hello Go

GOROOT: go的安装路径

GOPATH: 编译后二进制的存放目的地和import包时的搜索路径(你可以在 src 下创建你自己的 go 源文件，然后开始工作)

- bin: 目录主要存放可执行文件
- pkg: 目录存放编译好的库文件
- src: 目录下主要存放Go的源文件

### Go数组

go初始化数组

```go
var array [5]int 

array := [5]int{1, 2, 3, 4, 5}

array := [...]int{1, 2, 3, 4, 5}

array := [5]int{1: 10, 2: 20}
```

数组变量的类型包括数组长度和每一个元素的类型

```go
var array1 [4]string
var array2 [5]string

array1 = array2 // Compile Error
```

声明二维数组

```go
var array [4][2] int

array := [4][2] int {
    {10, 11},
    {20, 21},
    {30, 31},
    {40, 41}
}
```

使用指针在函数间传递大数组

```go
// 相对比于值传递 需要8MB的空间而现在只需要8个字节的空间
func foo(array *[1e6] int) {

}
```

nil切片和空切片

```go
// nil 切片
var silce []int

// 空切片
slice := []int{}
slice := make([]int, 0)
```

切片的长度和容量

```go
var array [k]int

silce := array[i: j]

长度为 j - i
容量为 k - i 
```

设置长度和容量的好处

```go
source := []string{"A", "B", "C", "D", "E"}

// 如果不设置容量限制，则会在原数组上进行修改
slice := source[2:3:3]
//slice := source[2:3]

slice = append(slice, "F")

fmt.Println(slice)  // C F
fmt.Println(source) // A B C F E
```

映射创建和初始化

切片, 函数以及包含切片的结构类型这些类型由于具有引用语义都不能作为映射的键

```go
dict := make(map[string]int)
dict := map[string]int {"Red": 1, "Blue": 2}
```

```go
// nil映射不能存储键值对
var color map[string]string // nil映射

colors := make(map[string]string){} // 空映射
```

go 并不能总是获取到一个值的地址
T类型的值的方法集只包含值接受者声明的方法。而指向T类型的指针的方法集既包含值接受者声明的方法，也包含指针接受者声明的方法

### channel

1. 对一个关闭的通道再发送值就会导致panic。
2. 对一个关闭的通道进行接收会一直获取值直到通道为空。
3. 对一个关闭的并且没有值的通道执行接收操作会得到对应类型的零值。
4. 关闭一个已经关闭的通道会导致panic。

#### 单向通道

chan<- int是一个只能发送的通道，可以发送但是不能接收；
<-chan int是一个只能接收的通道，可以接收但是不能发送。

#### ... 语法糖

```go
func (r *Runner) Add(tasks ...func(int)){
    r.tasks = append(t.tasks, tasks...)
}
```