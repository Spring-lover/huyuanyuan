# Vue

## 项目文件目录

- node_modules：这个目录是存放项目开发依赖的一些模块
- public：存放在此处的静态资源是不会经过webpack，如果需要使用里面的静态资源就需要使用绝对路径来对其进行引用
- src：这个目录是我们的源码所在
- static是资源目录。里面包含我们的样式文件，字体文件，图片文件等等静态资源
- package.json是项目配置文件，引x入的插件的配置信息都在里面

## src目录

- api：用于新建接口模块并使用axios实例
- assets：模块资源目录，与static不同的是，会被webpack所处理，而static文件则是直接使用即可
- components：模块组件目录，里面存放着我们所创建的各个组件，将这些组件分为两组：common公共组件和page页面组件
- router：路由配置目录，中心化之后的路由配置文件
- utils：这个目录是用于存放项目公用的 js 文件
- App.Vue：这个文件是主应用程序组件，也是我们项目的根组件，所有组件都需要挂载到这个根组件上面。
- main.js：这个文件是项目的核心入口文件，我们之前安装的插件也是在这个文件当中去进行引入和挂载，在这里面引入的插件我们就可以直接在整个项目中进行使用。

## 使用路由

```javascript
// App.vue
import Vue from 'vue'
import App from './App.vue'
import router from './router'

new Vue({
    router,
    render: h => h(App)
}).$mount('#app');
```

```javascript
// router/index.js
import Vue from 'vue'
import VueRouter from 'vue-router'
import Vhome from '../components/common/Home.vue'
import VLogin from '../components/common/Login.vue'

Vue.use(VueRouter);

// 导出
export default new VueRouter({
    routes:[
        {
            path:'/home',
            component:vHome,
            meta:{
                title: 'Home组件'
            }
        },
        {
            path: 'login',
            component: vLogin,
            meta:{
                title: 'Login组件'
            }
        }
    ]
})
```

```javascript
// App.vue中修改template部分以下代码
<template>
    <div id="app">
        <router-view></router-view> 输出的出口
	</div>
</template>
```

当配置多个路由时，可以通过箭头函数直接挂载到组件上

```javascript
// router/index.js
import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter);
// export default 只能导出一个默认模块，这个模块可以匿名
export default new VueRouter({
    routes:[
        {
            path: '/home',
            component: () => import('../components/common/Home.vue'),
            ......
        }
    ]
})
```

## Vue生命周期created和mounted

created ：是在页面渲染之前发生的 ，如果想要获取数据渲染到html之后元素的宽高 这些事拿不到的。

mounted：是在渲染data里面的数据到页面上之后 发生的 所以这时候去元素的具体信息是可以拿到的。

## slot

1. 插槽的基本使用
2. 插槽的默认值 <slot>button</slot>
3. 如果有多个值，同时放入到组件进行替换，一起作为替换元素

```html
<div id="app">
    <cpn><h2>插槽使用</h2></cpn>
</div>
```

```html
<template id="cpn">
    <div>
        <h2>我是组件</h2>
        <p>我是组件，哈哈哈</p>
        <slot><button>按钮</button></slot> // 默认值
    </div>
</template>
```



## Vue指令

#### Mustache：{{}}

#### v-once：只渲染一次

#### v-html：解析html

```html
<h2 v-html="url"></h2>
url = '<a href="http://www.baidu.com">百度一下</a>'
```

#### v-text = {{message}}

#### v-pre：对{{}}表达式不进行解析，直接进行显示

#### v-bind：动态绑定属性

```html
<img v-bind:src="imgurl">
```

#### v-bind：对象绑定语法

```html
<h2 class="title" v-bind:class="{active: isActive, line: isLine}"></h2>
<h2 class="title" v-bind:class="getClasses()"></h2>
<!--class中是必须有的属性，而v-bind:class是可选的属性-->
```

```javascript
const app = new Vue({
    el:"#app",
    data:{
        isActive: true,
        isLine: false,
    },
    methods:{
        getClasses: function (){
            return {active: this.isActive, line: this.isLine}
        }
    }
})
```

#### v-bind：数组语法

```html
<h2 class="title" v-bind:class="[active, line]"></h2>
<!--数组语法 active,line解析成变量-->
```

```javascript
const app = new Vue({
    el: "#app",
    data: {
       	active: 'aaaa',
        line: 'bbbb',
    },
    methods: {
        getClasses: function(){
            return [this.active, this.line]
        }
    }
})
```

#### v-bind绑定style

如果需要绑定的值的逻辑比较复杂，那么可以将其抽离封装到一个计算属性或者method中

```html
<h2 v-bind:style="{color: currentColor, fontSize:fontSize + 'px'}"></h2>
<!--其中currentColor代表着变量 使用常量时需要使用''-->
```

```javascript
const app = new Vue({
    el: "#app",
    data: {
        currentColor: 'red',
        fontSize: 100,
    },
})
```

#### 计算属性computed：

compute不是按照函数的方式来使用，而是按照属性的方式来使用

computed的setting和getting方法

一般只需要实现计算属性的get方法，一般是只读属性

computed属性是具有缓存作用

#### v-on：

```html
<button v-on:click="btn1click">按钮1</button>
<!--当默认函数需要一个参数的时候，方法不加()则默认传event事件对象-->
<button v-on:click="btn1click()">按钮2</button>
<!--当使用()时，则参数定义为undefined-->
<button v-on:click="btn1click(name, $event)">按钮3</button>
<!--需要使用参数并且也要使用event事件时，则使用$event来传参-->
```

```javascript
const app = new Vue(){
    el: "#app",
    methods:{
        btn1click(name){
            console.log(name);
        },
    }
}
```

#### v-on修饰符

.stop：阻止事件的冒泡

```html
<div v-on:click="doThat">
	<button v-on:click.stop="doThis"></button>    
</div>
```

.prevent：阻止默认事件的发生

```html
<form action="baidu">
    <input type="submit" value="提交" v-on:click.prevent="doThis">
</form>
```

.keyup.enter键盘事件

```html
<input type="text" v-on:keyup="KeyUp"> 
<!--键盘事件-->
<input type="text" v-on:keyup.enter="KeyUp">
<!--回车事件-->
```

.once只生效一次

```html
<button v-on:click.once="btn2click"></button>
```

.native

当需要监听一个组件的原生事件，必须加上native修饰符

```javascript
<back-top @click.native="backClick"></back-top>
// 给back-top添加原生点击事件
```

#### v-if v-else-if v-else

```html
<div id="app">
    <span v-if="isUser">
        <label for="username">用户账号</label>
        <input type="text" id="username" placeholder="用户账号", key="abc">
    </span>
    <span v-else>
        <label for="email">用户邮箱</label>
        <input type="text" id="email" placeholder="用户邮箱", key="cde">
    </span>
    <button v-on:click="isUser = !isUser">切换类型</button>
</div>
<!--vue虚拟dom 会复用生成的Input的输入框，解决方法是使用相应的key来辨别唯一的input-->
```

#### v-show

当v-if的条件为false时，包含v-if指令的元素，根本就不会存在dom中

v-show的条件为false时，v-show只是给我们的元素添加一个行内样式，只是添加了一个display:none

- 当需要在显示与隐藏之间切换很频繁，使用v-show
- 当只有一次切换时，通过使用v-if

#### v-for

```html
<ul>
	<li v-for="(value, key, index) in info">{{value}} {{key}} {{index}}</li>
</ul>
```

v-for遍历的时候顺序为value，key，index

官方推荐在使用v-for，给对应的元素或组件添加上一个:key属性（就地复用）

这个key值对数据改变之后的diff更新比较有很大的性能提升，有了key和没有key是两种比较和更新的机制

key值一般不选择index，key是一个值不重复的值

#### Vue响应式数组操作

```javascript
Vue.set(this.letters, 0, 'bbbbb'); // 使用Vue内置的方法

this.letters.splice(0, 1, 'bbbbb');
// splice (start, number, content)
// start: 开始的下标
// number: 需要添加或者删除元素的个数
// ...content: 可选参数，通过传入添加，删除，替换的元素

this.letters.sort();
this.letters.reverse();

// 直接对数组元素进行修改不会进行响应式的展示
this.letters[0] = 'bbbbbb'
```

#### V-model

实现输入框的双向绑定，

```html
<input type="text" v-model="message">
<input type="text" v-bind:value="message" v-on:input="message=$event.target.value">
```

结合radio类型

```html
<input type="radio" id="male" value="男" v-model="sex">
<input type="radio" id="female" value="女" v-model="sex">
<!--如果没有v-model则需要增加name属性来保证互斥-->
Vue.js 对于Radio的默认选中值只要设定data中的数值等于value即默认选中
```
结合checkbox单，多选框
```html
<!--单选框-->
<input type="checkbox" v-model="isAgree">同意协议
<!--多选框-->
<input type="checkbox" value="篮球" v-model="hobbies">篮球
<input type="checkbox" value="足球" v-model="hobbies">足球
<input type="checkbox" value="乒乒球" v-model="hobbies">乒乒球
<input type="checkbox" value="羽毛球" v-model="hobbies">羽毛球
```
```javascript
const app = new Vue({
	el: "#app",
	data: {
		isAgree: false,
		hobbies: [],
	}
})
```

结合select

```html
<select v-model="myselect">
    <option value="a">a</option>
    <option value="b">b</option>
    <option value="c">c</option>
</select>

<select v-model="myselects" multiple>
    <option value="a">a</option>
    <option value="b">b</option>
    <option value="c">c</option>
</select>
```

```javascript
const app = new Vue({
    data:{
        myselect: "a",
        myselects: [],
    }
})
```

#### v-model修饰符

lazy：默认情况下 v-model和input是双向绑定的，但是加上lazy修饰符可以让数据再失去焦点或者回车时才会更新

number：input输入框输入的值默认是String类型的，加上number修饰符之后转化为number类型

trim：自动过滤输入内容最开始和最后的空格，中间的会保留一个空格，多的会被过滤掉

## ES6

#### let/var

ES5之前是因为var对于if，for是没有块级作用域的，只有function有作用域，只能用函数闭包来解决

ES6中let有自己的作用域

```javascript
var btns = document.getElementsByTagName("button");
for (var i = 0; i < btns.length; i++) {
    btns[i].addEventListener("click", function () {
        console.log("第" + i + "个按钮被点击");
    });
}
// 由于i对于for没有作用域，所以i的值一直都是5 
```

```javascript
// 使用函数闭包解决问题
// 相当于定义了一个匿名函数，然后直接调用
var btns = document.getElementsByTagName("button");
for (var i = 0; i < btns.length; i++) {
    (function(i){
        btns[i].addEventListener('click', function(){
            console.log('第' + i + '个按钮被点击');
        })
    })(i);
}
```

```javascript
//ES6 let拥有自己的作用域
var btns = document.getElementsByTagName("button");
for (let i = 0; i < btns.length; i++) {
    btns[i].addEventListener('click', function(){
        console.log('第' + i + '个按钮被点击');
    })
}
```

#### const

不能修改指向的对象，但是可以修改指向的对象内部的属性值

# 组件

1：创建组件的构造器

使用Vue.extend方法进行注册，其中包含template关键字

2：注册组件

使用Vue.component('my-cpn', cpn); // 注册的是全局组件

```javascript
const cpn = Vue.extend({
    template:
    `<h1>Hello Vue</h1>
	`,
});
Vue.component('my-cpn', cpn); // 注册的是全局组件 在所有的Vue对象下都能使用

const app = new Vue({
    el: "#app",
    data:{
        
    },
    components:{
        "my-cpn": cpn, // 注册的是局部组件,只能在同一个Vue对象下使用
        cpn: cpn, // 命名不能加-,如果需要加上-使用字符串
    }
})
```

3：使用组件

必须包含在一个根标签下

## 父组件和子组件

在组件中可以使用components关键字来生成子组件

使用语法糖来注册并生成组件，不调用extend方法而是直接传template对象{}

```javascript
Vue.component('mycpn', {
    template:
    `<div><h1>Hello Vue</h1></div>
    `,
})
```

注册子组件

```javascript
Vue.component('mycpn', {
    template:
    `<div>
      <h1>Hello Vue</h1>
      <cpn1></cpn1>
    </div>
    `,
    components:{
      'cpn1':{
        template:'<h1>Hello Java</h1>'
      }
    }
```

## 模板分离写法

```html
<template id="python">
    <div>
        <h2>Hello Vue</h2>
        <h2>Hello Python</h2>
    </div>
</template>
```

```javascript
const app = new Vue({
    el : "#app",
    components:{
        "cpn": {
            template: "#python"
        } 
    }
})
```

## 组件data

组件data必须通过函数来绑定数据，原因是要保证函数返回数据的**唯一性**

```javascript
Vue.component("cpn", {
    template: "#btn",
    data() {
        return {
            counter: 0,
        };
    },
    methods: {
        increment() {
            this.counter++;
        },
        decrement() {
            this.counter--;
        },
    },
});
```

# 组件之间的通信

## 父组件传子组件

```javascript
props: [] // 数组写法
props: {} // 对象写法
```

```html
<template id = "vue">
    <div>
        <ul>
            <li v-for="item in cmovies">{{item}}</li>
        </ul>
        <h2>{{cmessage}}</h2>
    </div>
</template>
<div id="app">
    <cpn :cmovies="movies" :cmessage="message"></cpn>
</div>
```

```javascript
const cpn = {
    template: '#vue',
    props: ['cmovies', 'cmessage'],
} // 数组写法
const cpn = {
    template: '#vue',
    props: {
        cmovies: {
            type:Array,
            default(){
                return [];
            },
            required: true
        },
        cmessage: {
            type: String,
            default: 'Hello Vue',
            required: true
        },
    }
} // 对象写法 
const app = new Vue({
    el: "#app",
    data: {
        movies:['A', 'B', 'C'],
        message:"Hello Vue",
    }
    components: {
        cpn, // ES6增强对象的写法
    }
})
```

## 子组件传父组件

子组件传递父组件通过使用自定义事件来实现

子组件$emit，父组件v-on监听事件

```html
<div id="app">
    <cpn @DIYevent="sout"></cpn>
</div>

<template id="vue">
    <div>
        <button v-for="item in numbers"
                v-on:click="DIYfunction(item)">{{item}}</button>
    </div>
</template>
```

```javascript
// 子组件
const cpn = {
    template: "vue",
    data(){
        return {
            numbers: ['A', 'B', 'C', 'D'],
        }
    },
    methods: {
        DIYfunction(item){
            this.$emit("DIYevent", item);
        }
    }
}
// 父组件
const app = new Vue({
    el: "#app",
    components:{
        cpn,
    },
    methods: {
        sout(item){
           	console.log('Click Over', item);
        }
    }
})
```

## 父子组件双向绑定的问题

```html
 <div id="app">
     <cpn :number1="num1" :number2="num2"
          @num1change="number1change"
          @num2change="number2change"/>
     <!--子组件获取父类的属性-->
</div>
<template id="cpn">
    <div>
        <h2>props: {{number1}}</h2>
        <h2>data: {{dnumber1}}</h2>
        <input type="text" :value="dnumber1" v-on:input="num1Input">
        <!--默认会传event参数-->
        <h2>props: {{number2}}</h2>
        <h2>data: {{dnumber2}}</h2>
        <input type="text" :value="dnumber2" v-on:input="num2Input">
    </div>
</template>
```

```javascript
const app = new Vue({
    el: "#app",
    data: {
        num1: 0,
        num2: 1,
    },
    methods: {
        number1change(value){
            value = parseFloat(value);
            this.num1 = value;
        },
        number2change(value){ // 默认拿到的值是String类型
            value = parseFloat(value);
            this.num2 = value;
        }
    },
    components: {
        cpn: {
            template: "#cpn",
            props: {
                number1: Number,
                number2: Number, // 参数
            },
            data() { // 不能绑定props中传的参数，应该绑定子组件中的属性值
                return {
                    dnumber1: this.number1,
                    dnumber2: this.number2,
                }
            },
            methods: {
                num1Input(event){
                    this.dnumber1 = event.target.value; 
                    this.$emit('num1change', this.dnumber1);

                    this.dnumber2 = this.dnumber1 * 100;

                    this.$emit('num2change', this.dnumber2);
                },
                num2Input(event){
                    this.dnumber2 = event.target.value;
                    this.$emit('num2change', this.dnumber2);
                }
            }
        }
    }
});
```

同时也可以利用监听属性进行实现

```javascript
<script>
    // 将input中的value赋值到dnumber中
    // 为了让父组件可以修改值，发出一个事件
    // 同时修饰dnumber2的值
   	const app = new Vue({
        el: "#app",
        data: {
            num1: 0,
            num2: 1,
        },
        methods: {
            number1change(value){
                value = parseFloat(value);
                this.num1 = value;
            },
            number2change(value){
                value = parseFloat(value);
                this.num2 = value;
            }
        },
        components: {
            cpn: {
                template: "#cpn",
                props: {
                    number1: Number,
                    number2: Number, // 参数
                },
                data() {
                    return {
                        dnumber1: this.number1,
                        dnumber2: this.number2,
                    }
                },
                watch: { // watch 监听属性和components相同级，使用元数据的方法来获取newValue和oldValue
                    dnumber1(newValue, oldValue){
                        this.$emit('num1change', newValue);
                        this.$emit('num2change', newValue *100);
                        this.dnumber2 = newValue * 100;
                    },
                    dnumber2(numValue, oldValue){
                        this.dnumber1 = newValue /100;
                        this.$emit('num2change', newValue);
                    }
                }
            }
        }
    });
```

## $refs(父访问子)

可以在父组件上使用$refs来获取唯一的子组件

```html
<div id="app">
    <cpn></cpn>
    <cpn></cpn>
    <cpn ref="vue"></cpn>
    <button v-on:click="btnClick">按钮</button>
</div>
<template id="cpn">
    <div>test</div>
</template>
```

```javascript
const app = new Vue({
    el: "#app",
    methods: {
        btnClick(){
            console.log(this.$refs.vue.name); // 父组件获取唯一的子组件
        }
    },
    components: {
        cpn: {
            template: "#cpn",
            data(){
                return{
                    name: "Hello vue",
                }
            }
        }
    }
})
```

## $parent

使用$parent可以访问父组件的属性，但是会导致程序的耦合度高，不建议使用。

## slot插槽

用来复用组件，让每一个组件拥有不同的属性

```html
<div id="vm">
    <cpn><p slot="left">替换slot中的默认值</p></cpn> 
    <!--具名slot-->
    <cpn><p slot="center">Hello Vue</p></cpn>
    <cpn></cpn>
</div>
<template id="mycpn">
    <div>
        <slot name="left"><button>默认按钮</button></slot>
        <slot name="center"></slot>
        <slot name="right"></slot>
    </div>
</template>
```

slot的name对象需要替换的slot的属性

## 作用域插槽

由于父（子）组件作用域只能访问父（子）组件的属性

当需要将子组件插槽的属性传递给父组件插槽时，使用`v-slot`来传递数据（方便修改子组件的展示形式，修改需求）

```html
<div id="app">
    <cpn>
        <template v-slot:default="slotProps">
            <!--绑定-->
            <span>{{slotProps.data.join(' - ')}}</span>
        </template>
    </cpn>
</div>
<template id="cpn">
    <div>
        <slot v-bind:data="pLanguages"> 
            <!--将子组件中的pLanguages属性传给父组件-->
            <ul>
                <li v-for="item in pLanguages">{{item}}</li>
            </ul>
        </slot>
    </div>
</template>
```

```javascript
<script>
    const app = new Vue({
        el: "#app",
        components: {
            cpn: {
                template: "#cpn",
                data() {
                    return {
                        pLanguages: ["Java", "Python", "C++", "Javascript"],
                    };
                },
            },
        },
    });
</script>
```

# webpack

全局的webpack有且只有一个，但是实际情况不同，不同项目的webpack的版本可能不同。当项目需求的webpack版本和全局不同时，就需要安装局部webpack

- `dependencies`：应用程序在生产环境中所需要的
- `devDependencies`：只是在开发和测试中需要的
- `-g`代表的是全局安装，不带`-g`会安装到项目文件夹下
- `-S`安装包信息会写入`dependencies`中
- `-D`安装包信息写入`devDependencies`

## webpack：静态css文件

使用`css-loader`将css文件进行加载

使用`style-loader`进行渲染

```javascript
module: {
    rules: [
        //css-loader只负责将css文件进行加载
        //style-loader负责进行渲染
        // webpack在读取loader的过程中，按照从右向左的顺序进行读取
        {
            test: /\.css$/,
            use: ['style-loader', 'css-loader']
        }
    ]
},
```

## webpack：图片文件

使用`url-loader`和`file-loader`进行文件的上传

`base64`：是网络上最常见的用于传输8Bit字节码的编码方式之一，从二进制到字符的过程

```js
{
    test: /\.(png|jpg|gif|jpeg)$/i,
        use: [
            {
                // 如果文件上传是大于limit则使用file-loader进行上传
                // 为了让图片文件可以使用 一般会加上publicPath来进行打包处理
                // 如果文件小于则使用 base64编码进行上传
                loader: 'url-loader',
                options: {
                    limit: 8192,
                    /*
                    	[name]: name为原本文件的名字
                    	[hash:8]: 取hash值的8位
                    	[ext]: 后缀名
                    */
                    name: '[name].[hash:8].[ext]'
                },
            },
        ],
},
```

## 使用babel将es6转化为es5

## npm install --save-dev // --save // -g

`npm install --save-dev` ：是开发环境需要用到的依赖包

`npm install --save`：是生产环境需要的依赖包

`npm install -g`：是全局需要的依赖包

## runtime-only // runtime-compiler

`runtime-compiler`

template -> ast(抽象语法树) -> render -> virtualdom -> UI

`runtime-only`(效率更高)

render -> vdom -> UI

其中

```javascript
new Vue({
  router,
  render: h => h(App) // render 钩子函数可以通过传入组件对象来进行渲染
}).$mount('#app');
```

```javascript
render: function(createElement){
    return createElement(cpn); // cpn就是app组件对象
}
// 其中省略掉的vue编译的过程由vue-template-compiler实现
```

- 如果在之后开发中，依然使用template，就需要选择Runtime-compile
- 如果之后的开发中，使用的是.vue文件开发，那么可以选择Runtime-only

## vue.config.js

vue-cli3来添加配置文件，配置别名.......

# Vue router

## 前端路由

`后端路由`：后端处理URL和页面之间的映射关系 -> jsp

服务器直接生产渲染好对应的HTML页面，返回给客户端进行展示

`前后端分离 前端渲染`：浏览器中显示的网页中大部分内容，都是由前端编写的js代码在浏览器中执行，最终渲染出来的网页

`前端路由`：SPA页面 单页富应用(只有一个html页面) 第一次向静态资源浏览器请求所有的资源，当url发生变化的同时，前端路由会选择渲染哪一个html  + css + js 页面 ，改变url，页面不进行重新请求刷新

## 暴露和接受变量格式一致：

```javascript
// 1:变量暴露 export
export default {
    router
}
// 1:导入 import
import {router} form 'xx.js'
```

```javascript
// 2: 直接暴露 export
export default router
// 2: 导入 import
import router from 'xx.js'
```

## router-link补充

- `tag`：决定router-link 将渲染成什么样式
- `replace`：将`history.pushState`替换为`history.replace`
- `active-class`：当`<router-link>`点击时，会默认添加`router-link-active`的class，可以在路由routes里设置`linkActiveClass`
- 路由routes修改`mode`为history可以将默认的hash模式替换为history模式

## 代码路由跳转

```javascript
methods: {
    linkToHome() {
        this.$router.push('/home')
    },
    linkToAbout() {
        this.$router.replace('/about')
    }
}
```

## npm run build(项目部署->dist)

- app：业务代码
- manifest：对打包项目的底层支撑
- vendor：第三方库的文件

## 路由懒加载

```javascript
const Home = () => import('../components/Home')
const About = () => import('../components/About')
const User = () => import('../components/User') // 对应模块的懒加载
const HomeNew = () => import('../components/HomeNew')
const HomeMessage = () => import('../components/HomeMessage')
const profile = () => import('../components/Profile')
```

## 子路由

```javascript
const routes = [
    {
        path: '/home',
        component: Home,
        children: [
            {
                path: 'new', // 不用加 '/'
                components: HomeNew
            }
        ]
    }
]
```

## 路由之间的参数传递

`$router`：为Vue的实例，想到导航到不同的URL，则使用\$router.push或\$router.replace方法

`$route`：当前route跳转对象里面可以获取name, path, query params等

### 方法一：

```html
<router-link :to="'/user/' + userId"></router-link>
```

```javascript
// 配置路由时 
path: /user/:userId //代表是动态获取的参数

{{$route.params.userId}} // 获取传递的参数
```

### 方法二：

```vue
<router-link :to=" {path: '/profile',
                  query:
                  {name: 'HuJiaLe', age: 18, height: 1.83}
                  }">Profile
</router-link>
```

```javascript
// 配置路由时
path: '/profile'

{{$route.params.query.name}} // 获取传递的参数对象

// button 函数方式
$route.params.push({
    path: '/profile',
    query: {
        name: 'HujiaLe',
        age: 18,
        height: 1.83
    }
})
```

## 导航守卫

### 全局守卫：

获取路由跳转的信息

```javascript
router.beforeEach(to, from, next){
    document.title = to.matched[0].meta.title; // 可以给路由传入meta信息
    next(); // 默认必须要执行
}
```

to: 即将要进入的目标的路由对象

from:当前导航即将要离开的路由对象

next:调用该方法时，才能进入下一个钩子

### 路由独享的守卫：

### 组件内的守卫

## keep-alive

1. keep-alive：activated/deactivated
2. 首页中使用path属性记录离开时的路径，在beforeRouteLeave中记录
3. keep-alive是Vue内置的一个组件，可以使被包含的组件保留状态，或避免重新渲染
   1. exlude：排除需要缓存的组件
   2. include：包括需要缓存的组件
4. router-view也是一个组件，如果直接包在keep-alive里面，所有路径匹配到的视图组件都会被缓存

# TabBar

使用插槽时，最好使用`<div>`进行包裹，让div进行属性的继承，因为slot是利用替换生效的

```javascript
<div class="tab-bar-item">
    <div v-if="!isActive">
        <slot name="item-icon"></slot>
    </div>
    <div v-else>
        <slot name="item-icon-active"></slot>
    </div>
    <div :class="{active: isActive}">
        <slot name="item-text"></slot>
    </div>
</div>
```

# Vuex

Vuex是一个专为Vue.js应用程序开发的状态管理模式

管理什么状态：

1. 用户名称、头像、地理位置信息等等
2. 商品的收藏、购物车中的物品等等
3. 这些状态信息，都可以放在统一的地方，对它进行保存和管理，而且还是响应式的

使用方法：

- 提取出一个公共的store对象，用于保存在多个组件中共享的状态
- 将store对象放置在new Vue对象，这样可以保证在所有的组件中都可以使用
- 在其他组件中使用store对象中保存的状态即可
  - 通`this.$store.state`属性的方法来访问状态
  - 通过`this.$store.commit(‘mutation中方法’)`来修改状态

**state->Vue Component->Action(异步操作 Backend API)->Mutation(同步操作)**

```html
<button @click="add">
    增加counter
</button>
<button @click="sub">
    增加counter
</button>
<span>{{counter}}</span>
```

```javascript
import Vuex from 'vuex'
import Vue from 'vue'

Vue.use(Vuex)

const store = new Vuex.Store({
    state: {
        count: 0
    },
    mutations: {
        increment(state){
            state.count++
        },
        decrement(state){
            state.count--
        }
    }
})
```

```javascript
methods: {
    add() {
        this.$store.commit('add')
    },
    sub() {
        this.$store.commit('sub')
    }
}
```

## 核心概念

## State

单一状态树，全局只存在一个store对象（单例）
data和state都可以存储一些数据，但是一般将state挂载到组件的computed计算属性上，这样有利于state的值发生改变的时候及时响应给子组件

```javascript
const Counter = {
  data () {return {}},
  template: `<div>{{ count }}</div>`,
  computed: {
    count() {
      return store.state.count
    }
  }
}
```

如果把`store.state.count`放在data中，`store.state.count`的变化是不会主动出发界面刷新的

## Getters

getters相当于store的**计算属性**，在state中定义使用的方法

如果有多个组件需要用到此属性，要么复制这个函数，或者抽取到一个共享函数，但是不好进行统一管理
getters的返回值会根据他的依赖被缓存起来，且只有当它的依赖值发生了改变才会被重新计算

```html
<h2>{{$store.getters.moreAgeStu(19)}}</h2>
```

```javascript
getters: { // getters定义的函数默认是有state和getters参数
    more20stu(state) {
      return state.students.filter(s => s.age >=19)
    },
    more20stuLength(state, getters){
      return getters.more20stu.length
    },
    // 这里是通过外界传递参数,给Getter传参
    moreAgeStu(state){
      return (age) => { // 箭头函数的写法
        return state.students.filter(s => s.age > age)
      }
      return function(age) { // 正常写法
          return state.students.filter(s => s.age > age)
      }
    }
}
```
...mapGetters解析
```javascript
computed: {
	...mapGetters({
		'test': 'one'
	})
}

// 等价于
computed: {
   test: () => this.$store.getters.one
}
```

```javascript
import {mapState} from 'vuex'

export default {
    computed: mapState({
        count: function(state) {
            return state.count
        },
        
    })
}
```



## Mutation

定义可以访问state属性的方法（同步方法）

- 字符串的事件类型
- handle回调函数

mutation的函数表现形式

```javascript
decrement(state, payload){ // payload是传递过来的参数对象
    state.counter += payload.count
}
```

```javascript
<button v-on:click="itemClick(10)">++10</button>

methods: {
    itemClick(count) { // 通过this.$store.commit({提交一个对象})
        this.$store.commit({
            type: 'decrement',
            count
        })
    }
}
```

## Mutation响应规则

- 提前在store中初始化好所需的属性
- state对象添加新属性时，使用`Vue.set(obj, 'newProp', 123)`响应式
- state对象删除属性时，使用`Vue.delete(state.info, 'age')`响应式

## Action

在Vuex中进行异步操作，使用action

action 调用时使用dispatch

包含一个context参数（相当于state）调用`context.commit`相当于调用了mutation的方法，要严格按照官方推荐的顺序

```javascript
// 调用Promise来执行异步的操作
actions: {
    aUpdateInfo(context){
        return new Promise((resolve, reject)=>{
            setTimeout(()=>{
                context.commit('updateInfo')
            }, 1000)
            resolve('Hello Vue') // 传递的信息
        })
    }
}

// 在组件中的方法调用
methods:{
    // 输出 Hello Vue
    this.$store.dispatch('aUpdateInfo').then(res => console.log(res)) 
}
```

## Module

当应用变得非常复杂时，store对象就有可能变得相当臃肿，为了解决这个问题，Vuex允许将store分割撑模块，而每个模块拥有组件的state，mutations，actions，getters等

```javascript
const store = new Vuex.Store({
    state: {
        counter: 0,
    }
})
    
}
const moduleA = {
    getters: {
        fullname(state){
            return state.name + '1111'
        },
        fullname2(state, getters, rootState){
            // 这里取到的是store中的state对象
            return getters.fullname + '2222' + rootState.counter 
        }
    }
}
```

# axios

```javascript
axios.defaults.baseURL =;
axios.defaults.timeout =;
// 设置全局配置
```

## 简单使用

```javascript
axios({
    url: 'http://123.207.32.32:8000/home/multidata',
    method: 'get',
    params: {
        type: 'pop',
        page: 1
    }
}).then(res=>{
    console.log(res);
})
```

## axios.all()

```javascript
axios.all([ // 保证两个http请求都执行完之后再进行下一步
    axios({
        url: 'http://123.207.32.32:8000/home/multidata',
        method: 'get'
    }), 
    axios({
        url: 'http://123.207.32.32:8000/home/data',
    	params: {
      		type: 'pop',
      		page: 1
    	}
    })]).then(axios.spread((res1, res2)=>{ // 将数组中获取的信息分开
        console.log(res1)
        console.log(res2)
}))
```

## axios拦截器

```javascript
instance.interceptors.request.use(config =>{
    console.log(config)
    return config // 必须要将返回回去 要不拿不到结果
}, err =>{
    console.log(err)
})
```

1. 比如Config中的一些信息不符合服务器的请求
2. 比如每次发送网络请求时，都希望在界面中显示一个请求的图标
3. 某些网络请求（比如登录token）必须携带一些特殊的信息

## $refs

```html
/* 使用 $refs可以减少获取dom节点的消耗 */
<input type="text" ref="input1">
// 父组件同时可以访问子组件的属性和方法
<child ref='child'></child>
```

```javascript
new Vue({
    el: "#app",
    methods:{
        
    }
    add: function(){
    	this.$refs.input1.value = "22"; //this.$refs.input1 减少获取dom节点的消耗
    	this.$refs['child'].func() // func为子组件的方法
	}
})
```

## $option

vue的实例$option时用来获取定义在data外的数据和方法

## 混入

混入(minin)提供了一种非常灵活的方式，来分发Vue组件中可复用的功能，一个混入对象可以包含任意组件选项。

```javascript
var myMixin = {
    created: function(){
        this.hello()
    },
    methods:{
        hello: function(){
            console.log('hello from mixin')
        }
    }
}

// 定义一个使用混入对象的组件
let Component = Vue.extend({
    minxins: [myMixin]
})

let component = new Component() // => 'Hello from mixin'
```

## Vue.extend()

使用基础Vue构造器，创建一个“子类”。参数是一个包含组件选项的对象

```html
<div id="mount-point"></div>
```

```javascript
var Profile = Vue.extend({
    template: '<p>{{firstName}}</p>',
    data(){
        return {
            firstName: 'Hujiale',
        }
    }
})
new Profile().$mount('#mount-point')
```

## watch 监听属性

```html
<input type="text" v-model="cityName">
```

```javascript
new Vue({
    el: '#root',
    data: {
        cityName: 'shanghai'
    },
    watch: {
        cityName(newValue, oldValue) {
            
        }
    }
})
```

2：直接在watch里面写监听处理函数，当每次监听到cityName值发生改变时，执行在所监听的数据后面直接加字符串形式的方法名：

```javascript
watch: {
    cityName: 'nameChange'
}
```

3：使用handler和immediate

当值第一次进行绑定时，不会执行监听函数，只有当值发生改变时才会执行。如果我们需要在最初绑定值的时候也执行函数，就需要使用到immediate

```javascript
new Vue({
    el: "#root",
    data: {
        cityName: ''
    },
    watch: {
        cityName: {
            handler(newValue, oldValue){
                
            },
            immediate: true
        }
    }
})
```

4：使用deep

当需要监听一个对象的改变时，普通的watch方法无法监听到对象内部属性的改变，只有deep才能监听到变化

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

## 解决Vuex刷新之后store消失的问题

https://blog.csdn.net/guzhao593/article/details/81435342

因为store的数据是保存在运行内存中的，当页面进行刷新时，页面会重新加载Vue实例，store里面的数据就会被重新赋值

1. 一种是state里的数据是通过请求来出发action和mutation来改变
2. 一种是将state里的数据保存一份到本地存储(localStorage，sessionStorage, cookie)

利用SessionStorage来状态管理 beforeunload这个事件在页面刷新时先触发的，放在App.vue这个入口组件中，就可以保证每次刷新页面都可以触发
```javascript
export default{
	name: 'App',
	created: {
		if(sessionStorage.getItem("store"){
			this.$store.replaceState(Object.assign({}, this.$store.state, JSON.parse(sessionStorage.getItem("store"))))
		}
		windows.addEventListener("beforeunload", ()=>{
			sessionStorage.setItem('store', JSON.stringfy(this.$store.state))
		})
	}
}
```

## $listeners 孙，父组件通信

```javascript
inheritAttrs: false 在所有的孙,子组件加上
v-on="$listeners" 在中间件的组件上加上
结果：可以使得孙组件自定义事件父组件可以直接监听到
```

## Better-Scroll

```javascript
/*
	默认情况下BScroll是不可以实时的监听滚动位置
	0/1：都是不侦测实时的位置
	2：在手指滚动的过程中侦测，手指离开后的惯性滚动过程中不侦测
	3：只要是滚动都是侦测
*/

const bscroll = new BScroll(document.querySelector('.content'), {
  probeType: 3
})
```

## v-if 和 v-show绑定动态数据失效

使用`this.$set或者vue.set()`

```javascript
this.$set(arr, index, value)
this.$set(object, key, value)
```

## 父组件和子组件动态获取异步数据

```vue
<edgeMap v-if="edgeMapData.length > 0"></edgeMap>
子组件使用v-if
```

```javascript
watch:{
	json2edgeMap:{
		handler(newValue, oldValue){
			this.json2edgemap = newValue
		}
	}
}
子组件使用监听对象属性进行动态刷新
```

## vue upload

首先后端需要提供一个文件上传的接口

```java
SimpleDateFormat sdf = new SimpleDateFormat("/yyyy/MM/dd/");
@PostMapping("/import")
public RespBean importData(MultipartFile file, HttpServletRequest req) throws IOException {
    String format = sdf.format(new Date());
    String realPath = req.getServletContext().getRealPath("/upload") + format;
    File folder = new File(realPath);
    if (!folder.exists()) {
        folder.mkdirs();
    }
    String oldName = file.getOriginalFilename();
    String newName = UUID.randomUUID().toString() + oldName.substring(oldName.lastIndexOf("."));
    file.transferTo(new File(folder,newName));
    String url = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + "/upload" + format + newName;
    System.out.println(url);
    return RespBean.ok("上传成功!");
```

>  方法一：Ajax上传

```html
<input type="file" ref="myfile">
<el-button @click="importData" type="success" size="mini" icon="el-icon-upload2">导入数据</el-button>
```

```javascript
importData() {
  let myfile = this.$refs.myfile;
  let files = myfile.files;
  let file = files[0];
  var formData = new FormData();
  formData.append("file", file);
  this.uploadFileRequest("/system/basic/jl/import",formData).then(resp=>{
    if (resp) {
      console.log(resp);
    }
  })
}
```

1. 构造一个FormData，用来存放上传的数据
2. 请求方法为POST，设置`Content-Type`为`multipart/form-data`

> 方法二：el-upload

```vue
<el-upload
  :http-request="uploadfunc"
  :show-file-list="false"
  action=""
>
```

```javascript
uploadfunc(file) {
  const self = this
  console.log(file)
  const formData = new FormData()
  formData.append('file', file.file)
  this.onProcess()
  setTimeout(() => {
    DataApi.uploadfile(formData).then(data => {
      this.onSuccess()
    }).catch(() => {
      this.onError()
    })
  }, 1000)
},
```

1. 使用`http-request`来自定义上传函数
2. 定义formdata数组，进行file对象的传递
3. 默认不会触发`onSuccess`和`onProcess`钩子函数，需要手动触发

## Vue $emit 传递多个参数

```javascript
// 单个参数
this.$emit('requestReload', this.dataMapperFileName)
@requestReload="reloadfunc($event)"

// 多个参数
this.$emit('requestReload', this.schemaFileName, false)
@requestReload="reloadfunc(arguments)"

reloadfunc(values){
  console.log(values[0]) // this.schemaFileName
  console.log(values[1]) // false
}

```
