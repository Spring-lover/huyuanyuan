## 预编译和执行阶段

```javascript
f();
function f(){
    alert(1);
}
// 合法，在预编译期，Javascript解释器只能够为声明变量f进行处理
```

```javascript
f();
var f = function(){
    alert(1);
}
// 变量f的值，只能等到执行期时按顺序进行赋值
```

## null and Undefined

```javascript
==:是相等的操作符，比较值是否相等
===:是全等操作符，比较值和类型是否都相等
null 和 undefined 的值都不等于0
null and undefined 的值相等，但是类型不相等
undefined 表示所有赋值变量的默认值
null 表示一个变量不再指向任何对象地址
```

```javascript
Boolean(123); // returns true
Boolean("abc"); // returns true
Boolean(null); // returns false
Boolean(undefined); // returns false
Boolean(NaN); // returns false
Boolean(0); // returns false
Boolean(""); // returns false
Boolean(false); // returns false
Boolean("false"); // returns true
Boolean(-1); // returns true
```

## Javascript创建对象

```javascript
// 字面量
var student = {
  name: "zhangsan",
  age: 18,
  gender: "male",
  sayHi: function () {
    console.log("hi,my name is " + this.name);
  },
};
```

```javascript
// 通过new Object()创建对象, 利用()进行对象的赋值
var student = new Object();
(student.name = "zhangsan"),
  (student.age = 18),
  (student.gender = "male"),
  (student.sayHi = function () {
    console.log("hi,my name is " + this.name);
  });
```

```javascript
// 通过工厂模式创建对象
function createStudent(name, age, gender) {
  var student = new Object();
  student.name = name;
  student.age = age;
  student.gender = gender;
  student.sayHi = function () {
    console.log("hi,my name is " + this.name);
  };
  return student;
}
var s1 = createStudent("zhangsan", 18, "male");
```

```javascript
// 自定义构造函数
function Student(name, age, gender) {
  this.name = name; // this 指代 Student
  this.age = age;
  this.gender = gender;
  this.sayHi = function () {
    console.log("hi,my name is " + this.name);
  };
}
var s1 = new Student("zhangsan", 18, "male");
```

## Prototype

```javascript
function Student(name, age, gender) {
    this.name = name;
    this.age = age;
    this.gender = gender;
}

Student.prototype = {
    constructor:Student,
    hobby:"study",
    sayHi:function () {
        console.log("Hello world");
    },
};

var s1 = new Student("wangwu", 18, "male");
console.log(Student.prototype.constructor == Student);
/*
由于s1, s2是两个对象，如果使用字面量生成对象会造成代码的冗余
使用工厂模式会导致每一个对象都共享一个函数
使用构造函数会使每一个对象拥有独立的完全相同的函数,导致浪费内存
使用原型prototype来构造函数：
	原型对象包含一个指向构造函数的指针 constructor
	实例都包含一个指向原型对象的内部指针__proto__
*/
```

## Call()

```javascript
function Father(name, age) {
  this.name = name;
  this.age = age;
}
// 让一个对象可以调用另一个对象的方法
function Son(name, age) {
  Father.call(this, name, age); // 实现了继承
  this.hobby = "study";
}

var S1 = new Son("zhangsan", 18);
S1; // Son {name: "zhangsan", age: 18, hobby: "study"}
```

## apply()

```javascript
// 与call唯一的区别是call()方法接受的是参数，apply()方法接受的是数组
var array = ["a", "b", "c"];
var nums = [1, 2, 3];
array.apply(array, nums);
```

## bind()

```javascript
this.num = 6;
var test = {
  num: 66,
  getNum: function () {
    return this.num;
  },
};

test.getNum(); // 返回 66

var newTest = test.getNum;
newTest(); // 返回 6, 在这种情况下，"this"指向全局作用域

// 创建一个新函数，将"this"绑定到 test 对象
var bindgetNum = newTest.bind(test);
bindgetNum(); // 返回 66
```

## 作用域

#### 块级作用域

```javascript
{
  var num = 123;
  {
    console.log(num);
  }
}
console.log(num);
// JavaScript没有块级作用域，程序会输出123两次
```

#### 函数作用域

```javascript
//JavaScript 的函数作用域是指在函数内声明的所有变量在函数体内始终是可见的，不涉及赋值。
function test() {
  var num = 123;
  console.log(num);
  if (2 == 3) {
    var k = 5;
    for (var i = 0; i < 10; i++) {}
    console.log(i);
  }
  console.log(k); // 不会报错，而是显示 undefined
}
test();
```

```javascript
function test(){
    var k = 3;
}
test();
console.log(k); // 这里会报错
```

#### 全局作用域

全局作用域也就是说什么地方都能够访问到。比如我们不用 `var` 关键字，直接声明变量的话，那这个变量就是全局变量，它的作用域就是全局作用域。使用 window 全局对象来声明，全局对象的属性也是全局变量。另外在所有的函数外部用 `var` 声明的变量也是全局变量，这是因为内层作用域可以访问外层作用域。

## 变量名提升

JavaScript 是解释型的语言，但是它并不是真的在运行的时候完完全全的逐句的往下解析执行。

在预解析阶段，会将以关键字 `var` 和 `function` 开头的语句块提前进行处理。当变量和函数的声明处在作用域比较靠后的位置的时候，变量和函数的声明会被提升到作用域的开头。

```javascript
console.log(num);
var num = 10;
```

等价于

```javascript
var num;
console.log(num);
num = 10;
```

```javascript
// 例如
var num = 3;
function foo() {
  console.log(num);
  var num = 4;
  console.log(num);
}
foo();
// 等价于
function foo(){
    var num;
    console.log(num);
    num = 4;
    console.log(num);
}
var num = 3;
```

## 闭包

闭包是指函数可以使用函数之外定义的变量

```javascript
var name = "The Window";

var object = {
    name : "My Object",

    getNameFunc : function(){
        var that = this;
        return function(){
            return that.name;
        };

    }

};

alert(object.getNameFunc()()); // My Object

var name = "The Window";

var object = {
    name : "My Object",

    getNameFunc : function(){
        return function(){
            return this.name;
        };

    }

};

alert(object.getNameFunc()()); // The Window
```

## for of && for in

for ...of 循环仅适用于迭代，而普通对象不可迭代

```javascript
const obj = {fname:'foo', lname:'bar'};
for (const value of obj){
    console.log(value);// TypeError: obj[Symbol.iterator] is not a function
}
```

```javascript
//for-in-example.js
Array.prototype.newArr = () => {};
Array.prototype.anotherNewArr = () => {};
const array = ['foo', 'bar', 'baz'];
 
for (const value in array) { 
  console.log(value);
}
// Outcome:
// 0
// 1
// 2
// newArr
// anotherNewArr
// for...in 不仅枚举上面的数组声明，它还从构造函数的原型中查找继承的非枚举属性，在这个例子中，newArr 和 anotherNewArr 也会打印出来。
Array.prototype.newArr = () => {};
const array = ['foo', 'bar', 'baz'];
 
for (const value of array) { 
  console.log(value);
}
// Outcome:
// foo
// bar
// baz
// for...of 不考虑构造函数原型的不可枚举属性。它只需要查找可枚举属性并将其打印出来。
```

## 高阶函数

```javascript
const nums = [10, 20, 111, 222, 444, 50, 60];

let total = nums.filter(n => n <100).map(n => n * 2).reduce((prevalue, n)=> prevalue + n);
console.log(total);

// filter: 过滤提供一个回调函数返回true或false
nums.filter(function (n){
   	return n < 100;
})

// map:提供一个函数作用于数组中所有的值
nums.map(function(n){
    return n * 2;
})

// reduce:提供一个preValue, n参数，和一个回调函数以及一个初始值
nusm.reduce(function(preValue, n){
    return preValue + n;
}, 0)

// preValue: 0	n:10 => 10
// preValue: 10	n:20 => 30
// ......
```

## ES6 import 和 export

- export 与 export default均可用于导出常量、函数、文件、模块等
- 都可以使用import导入

#### 不同点：

- export可以有多个，export default只能有一个
- 通过export方式导出，在导入时要加`{}`， export default则不需要
- 使用export default为模块指定默认输出，导入时只需要知道文件名即可，但是使用export必须知道导出的变量或者函数等，导入时变量名要一致

```javascript
// demo1.js
export default const/vat/let a = "hello world";
// 导入方式
import b from 'demo1.js'; // 这里的b可以是任意变量

// demo2.js
export const/var/let a = "hello world";
// 导入方式
import {a} from 'demo2.js';
```

```javascript
// 导出其他的方法
let sum = function(num1, num2){
    return num1 + num2;
}
let app = 100;
export {sum, app};

// 导入模块的方式
import * as test from "./test.js";
```

## 箭头函数

### 什么时候使用箭头函数

当使用函数作为参数的时候，使用箭头函数



箭头函数如果只有一个参数`()`可以省略不写

```javascript
render: h => h(App);
// 效果是等价的
render: function(h){
    return h(App);
}
```

### 箭头函数中的this指针（this来自作用域链，来自更高层函数的作用域）

```javascript
const obj = {
    func(){
        setTimeout(function(){
            console.log(this); // window 这里是window.call的全局方法
        }, 1000);
        setTimeout(() => {
            console.log(this); // 箭头函数的this是指向最近作用域的对象的this
        }, 1000);
    }
}
this指针指向的是定义时所在的对象，而不是运行时所在的对象
如果有对象嵌套的情况，则this绑定到最近的一层对象上
```

## 递归调用箭头函数

```javascript
let insert = (value) => ({
  into: (array) => ({
    after: (afterValue) => {
      array.splice(array.indexOf(afterValue) + 1, 0, value)
      return array
    }
  })
})
```

## 提升

- 有多个“重复”声明的代码中，是函数会首先会提升
- let声明的变量，在相应的块级作用域是不会被提升

## Promise

是异步编程的一种解决方案

Promise对象代表着一个异步操作，有三种状态Pending(进行中)、Resolved(已完成)、Rejected(已失败)

resolve(data)将这个promise标记位resolved，然后进行下一步then(data)的操作

## async await

需求：先进行一个Ajax请求，等请求数据之后再进行其他操作

1. async 函数内部设置的return返回的值，会自动成为then回调函数的参数。要想使用async函数的回调then，async必须有个return，不然回调的是undefined
2. async 函数内部所有的异步操作执行完毕，才会执行其then方法指定的回调函数

1. await命令后是一个promise对象，如果不是，会被自动转成一个立即resolve的promise对象，await可以是任何类型的
2. 只要有一个await语句后的promise变成了reject，那么整个async函数都会中断。
3. 如果多个await的时候，为了避免上述情况发生导致下面代码不执行，可以将前面的await放在try catch中，这样await就会执行

```javascript
const asy = function(x, time){
    return new Promise((resolve, reject)=>{
        setTimeout(() => {
            resolve(x)
        }, time)
    })
}
const add = async function(){
    const a = await asy(3, 5000)
    console.log(a)
    const b = await asy(4, 10000)
    console.log(b)
    cosnt c = await asy(5, 15000)
    console.log(a, b, c)
    const d = a + b + c
    console.log(d)
}

add()
```

## js选择器 改变类选择器

```javascript
let content = document.getElementsByClassName('span-content')

content[0].innerText // 获取标签内html的值
console.log(content[0].innerHTML) 

content[0].style.setProperty('display', 'inline-block')
```

## 查找

作用域查找始终从运行时所处的最内部作用域开始，逐级向外或者说向上进行，知道遇见第一个匹配的标识符为止

## 函数参数的默认值

- 与解构赋值默认值结合使用

```javascript
function fetch(url, {method='GET', headers={}}){
    console.log(method)
}

fetch('http://example.com', {}) // 'GET'
fetch('http://example.com') // 报错

function fetch(url, {method: 'GET'} = {}){
    console.log(method)
}
fetch('http://example.com') // 'GET'
// 先通过对象的解构获取默认值然后再执行
函数参数是默认的一个作用域，利用参数默认值可以指定某一个参数不得省略
```

- rest参数 必须是最后一个参数

## 闭包

```javascript
当函数可以记住并访问所在的词法作用域时，就产生了闭包，不会被垃圾回收机制给回收，都会持有对原始定义作用域的引用。
```

```javascript
function wait(message){
    setTimeout(function timer(){
        console.log(message)
    }, 1000)
}

wait('Hello Clousure!')

timer函数依然保持wait(..)作用域的闭包，因此保有对message的引用
```

## 模块+闭包

```javascript
function CoolModule() {
  let something = 'cool'
  let another = [1, 2, 3]

  function doSomething() {
    console.log(something)
  }

  function doAnother() {
    console.log(another.join(' ! '))
  }

  return {
    doSomething: doSomething,
    doAnother: doAnother
  }
}

const foo = CoolModule()

foo.doSomething()
foo.doAnother()

单例模式
let foo = (function CoolModule() {
  let something = 'cool'
  let another = [1, 2, 3]

  function doSomething() {
    console.log(something)
  }

  function doAnother() {
    console.log(another.join(' ! '))
  }

  return {
    doSomething: doSomething,
    doAnother: doAnother
  }
})()

传递参数
function CoolModule(id) {
    function identify(id){
        console.log(id)
    }
    return {
        identify: identify
    }
}
```

## 动态作用域

词法作用域是写代码或者说是定义时确定的，而动态作用域是在运行时确定的

## 关于This

this提供了一中更加优雅的方式来隐式传递一个对象的引用

```javascript
NaN：一个表达式中如果有减号（-）、乘号（*）等运算符时，JS引擎在运算之前会试图将表达式的每个分项转化为Number类型。如果转化失败则返回NaN
```

- this实际是在函数被调用时发生的绑定，它指向什么完全取决于函数在哪里被调用

```javascript
function test() {
    console.log(this); // this 指的是window
}
test();
```

- 函数在定义的时候this是不确定的，只有在调用的时候才可以确定
- 一般函数直接执行，内部`this`指向window。
- 函数作为一个对象的方法，被该对象所调用，那么 `this` 指向的是该对象。
- 构造函数中的 `this`，始终是 `new` 的当前对象。

> 默认绑定

```javascript
function foo(){
    console.log(this.a)
}
var a = 2
foo() // 2

this.a 被解析为全局变量a 函数调用时应用了this的默认绑定，因此指向全局变量
```

> 隐式绑定

```javascript
function foo(){
    console.log( this.a )
}
var obj = {sdh
    a : 2,
    foo : foo
}

obj.foo() // 2

调用位置会使用obj上下文来引用函数
```

> 隐式丢失

被`隐式绑定`的函数会丢失绑定对象，会应用默认绑定，从而把this绑定到全局对象或者undefined上

1. 函数别名

```javascript
function foo (){
    console.log( this.a ) 
}
var obj = {
    a: 2,
    foo: foo
}

var bar = obj.foo // 函数别名

var a = 'oops, global'

bar() // 'oops, global' 
实际上绑定的是foo函数本身
```

2. 传入回调函数

```javascript
function foo(){
    console.log( this.a )
}

function doFoo(fn){
    // 这里引用的实际上foo函数
    fn()
}
结果和上述情况相同
```
> 显式绑定

利用显式绑定间接绑定到这个对象上

```javascript
利用apply和call函数进行绑定，强制指定this的对象
bind函数来进行硬绑定来解决丢失绑定问题
```

**例子：**

```javascript
bind 进行绑定
var circle = {
    radius: 10,
    outerDiameter() {
        var innerDiameter = function() {
            console.log(2 * this.radius)
        }
    	innerDiameter = innerDiameter.bind(this)
    	innerDiameter()
    }
}
```

```javascript
使用临时变量self
var circle = {
	radius: 10,
	outerDiameter() {
		var self = this;
		var innerDiameter = function() {
			console.log(2 * self.radius)
		}
		innerDiameter()
	}
}
circle.outerDiameter(); // 打印20
```

```javascript
使用箭头函数
var circle = {
	radius: 10,
	outerDiameter() {
		var innerDiameter = () => {
			console.log(2 * this.radius)
		}
		innerDiameter()
	}
}
circle.outerDiameter() // 打印20
```

> new绑定

包括内置对象函数（比如Number(...)）在内的所有函数都可以用new来调用，这种函数调用被称为构造函数调用，`实际上不存在所谓的“构造函数”，只有对于函数的“构造调用”`

```javascript
function foo(a){
    this.a = a
}

var bar = new foo(2)
console.log(bar.a) // 2

会构造一个新对象并把它绑定到foo(..)调用中的this中
```

> 优先级

1. 由new调用？绑定到新创建的对象
2. 由call或者apply(或者bind)调用?绑定到指定的对象
   1. call apply：显式绑定	bind：硬绑定
   2. 硬绑定可以解决绑定丢失的问题 但是不能修改this，softBind(软绑定)可以修改
   3. 绑定空对象`Object.create(null)`
3. 由上下文对象调用？绑定到上下文对象
4. 默认，在严格模式下绑定到undefined，否则绑定到全局对象

## 对象

JavaScript中二进制前三位为0的话，会判断为object类型，但是null的二进制都是0，所以执行typeof时会返回object

在对象中，属性名都是字符串，如果使用string(字面量)以外的其他值作为属性名，那它首先会被转换为一个字符串

```javascript
var myObject = {}
myObject[true] = "foo"
myObject[3] = "bar"

myObject["true"]; // foo
myObject["3"]; // bar
```

## 复制对象

```javascript
Object.assign(..)
var newObj = Object.assign({}, myObject); // 实现浅复制
```

## 存在性：

```javascript
in 操作符会检查属性是否在对象及其[[Prototype]]原型链中
hasOwnProperty() 只会检查属性是否在MyObject对象中，不会检查[[Prototype]]

in 实际上检查的是某个属性名是否存在
```

## 函数防抖

概念：延迟要执行的动作，若在延时的这段时间内，再次触发了，则取消之前开启的动作，重新计时

举例：电脑无操作1分钟后会进行休眠，当40秒时鼠标被移动了一下，重新计时1分钟

```javascript
// 防抖
export function _debounce(fn, delay) {
  var delayTime = delay || 200
  var timer
  return function() {
    var th = this
    var args = arguments
    if (timer) {
      clearTimeout(timer)
    }
    timer = setTimeout(function() {
      timer = null
      fn.apply(th, args)
    }, delayTime)
  }
}
```



## 函数节流

设定一个特定的时间，让函数在特定的时间内执行一次，不会频繁执行

举例：fps游戏，鼠标按住不松手，子弹也不会连成一条线

```javascript
// 节流
export function _throttle(fn, delayTime) {
  var lastTime
  var timer
  var delay = delayTime || 200
  return function() {
    var args = arguments
    // 记录当前函数触发的时间
    var nowTime = Date.now()
    if (lastTime && nowTime - lastTime < delay) {
      clearTimeout(timer)
      timer = setTimeout(function() {
        // 记录上一次函数触发的时间
        lastTime = nowTime
        // 修正this指向问题
        fn.apply(this, args)
      }, delay)
    } else {
      lastTime = nowTime
      fn.apply(this, args)
    }
  }
}
```

1. 在路由调转的时候 绑定的scroll事件会保留下来，需要在destroyed中移除监听事件
2. 加上防抖或节流函数，发现解绑失败，需要在mounted中利用中间函数做转换
3. 在按钮进行节流优化的时候，同样需要在mounted中利用中间函数做转换

```javascript
mounted() {
  const _ = this
  this.throtteLoad = _throttle( ()=> _.onScroll(), 1000)
  window.addEventListener('scroll', this.throttleLoad)
}

destroyed() {
  window.removeEventListener('scroll', this.throttleLoad)
}
```

```javascript
mounted() {
  const _ = this
  this.throttleQueryFunc = _throttle(() => _.queryNsrRiskLinkAbnormalData(), 1000)
},
methods:{
  this.throttleQueryFunc()
}
```

## 原型：

```javascript
Object.create():会创建一个对象并把这个对象的prototype关联到指定的对象
```

所有普通的Prototype链都会指向内置的Object.prototype

prototype对象的constructor属性直接指向类的本身

如果属性名foo既出现在myObject中也出现在myObject的Prototype链上层，那么就会发生屏蔽。myObject中包含的foo属性会屏蔽原型链上的所有的foo属性

```javascript
// 当foo不直接存在于myObject中而是存在于原型链上层
1.如果在上层存在名为foo的普通数据访问属性，并且没有被标记为只读，那么直接会在myObjet中添加一个名为foo的新属性，它是屏蔽属性
2.如果在上层存在名为foo的普通数据访问属性，并且被标记为只读，那么无法修改已有的属性或者在myObject上创建屏蔽属性
3.如果在Prototype上存在foo并且它是一个setter，那么就一定会调用这个setter
```

## ES6 对象

```javascript
class Point{
	constructor(x, y){
		this.x = x
		this.y = y
	}
  toString()
  toValue()
}
typeof Point // function
Point === Point.prototype.constructor // true
// ES6 生成的对象定义的方法不可枚举，ES5使用原型链生成的对象方法是可以枚举的
```

## 局部变量成为对象的属性

```javascript
const keyName = 'leftKey'
const keyValue = 'NSR'

object = {[keyName]: keyValue}
console.log(JSON.stringify(object))

使用[]来实现动态加载
```

## 判断元素是否在数组中

```javascript
const arrays = ['a', 'b', 'c']

('a' in arrays) // false
(arrays.includes('a'))  // true
(arrays.indexOf('a')) // 0
```

