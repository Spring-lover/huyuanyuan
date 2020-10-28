## CSS

```css
#father1 #p1 : 选中某个元素的子元素

#lv+div : 选择该元素的下一个兄弟元素

h3,div,p,span{color:red;} :群组选择器
```

## 字体

```css
font-family: 字体类型
font-size: 字体大小
font-weight: 字体粗细
font-style: 字体斜体
color: 颜色
```

## 边框样式

```css
border-width: 边框的宽度
border-style: 边框的外观
border-color: 边框的颜色
border: 1px, solid, gray

上边框
border-top-width:1px;
border-top-style:solid;
border-top-color:red;
border-right:1px solid red;
```

## 背景

```css
background-image: 定义背景图像的路径，这样图片才能显示嘛
background-repeat: 定义背景图像显示方式，例如纵向平铺、横向平铺
background-position: 定义背景图像在元素哪个位置
background-attachment: 定义背景图像是否随内容而滚动
background-color: 背景颜色
背景颜色半透明：background：rgba(0, 0, 0, 0.3);
```

## CSS优先级

ID 选择器 > 类选择器 > 元素选择器

继承的权重是0，如果该元素没有直接选中，不管父元素权重多高，子元素得到的权重都是0

## 显示模式

### 行内元素：

```html
<a> <strong> <b> <em> <i> <del> <s> <span>
```

- 相邻行内元素 在一行上，一行可以显示多个
- 高，宽的设置是无效的
- 默认宽度就是它本身内容的宽度
- 行内元素只能容纳文本或其他行内元素
- 链接里面不能再放链接`<a>`特殊情况链接`<a>`里面可以放块级元素，但是给`<a>`转换一下块级模式最安全

### 块内元素：

```html
<h1> <p> <div> <ul> <ol> <li>
```

- 高度，宽度，外边距以及内边距都可以控制
- 是一个容器及盒子，里面可以放行内或者块级元素
- `<p> <h1>~<h6>`主要用于存放文字，因此`<p>`不能放块级元素

### 行内块元素：

```html
<img> <input/> <td> 同时具有快元素和行内元素的特点
```

- 和相邻行内元素（行内块）在一行上，但是他们之间会有空白缝隙。一行可以显示多个（行内元素特点）。
- 默认宽度就是它本身内容的宽度（行内元素特点）。
- 高度，行高、外边距以及内边距都可以控制（块级元素特点）。

### 相互转化

```css
display: inline
display: block
display: inline-block
```

## 盒子模式

border：元素边框

margin(外边距)：用于定义页面中元素与元素之间的距离

padding(内边距)：用于定义内容与边框之间的距离

content(内容)：可以是文字或图片

行内元素或者行内块元素水平居中给其父元素添加 text-align:center即可

设置圆角矩形 将radis = height / 2 即可

## 浮动

浮动的盒子只会影响浮动的盒子后面的标准流，不会影响前面的标准流

## 清除浮动

由于父级盒子很多情况下，不方便给高度，但是子盒子浮动又不占有位置，最后父级盒子高度为0，就会影响下面的标准流盒子

由于浮动元素不再占用原文档流的位置，所以它会对后面的元素排版产生影响

- 隔墙法
- 在父元素上添加overflow：hidden属性
- after伪元素

```css
.clearfix:after{
    content: "";
    display: block;
    height: 0;
    clear: both;
    visibility: hidden;
}
.clearfix{
    *zoom: 1;
}
```

- after before 伪元素

```css
.clearfix:before, .clearfix:after {
    content: "";
    display: table;
}
.clearfix:after{
    clear: both;
}
.clearfix{
    *zoom: 1;
}
```

## 定位

1. 浮动可以让多个块级盒子一行没有缝隙排列显示，经常用于横向排列盒子
2. 定位则是可以让盒子自由的在某个盒子内移动位置或固定屏幕中某个位置，并且可以压住其他盒子

定位 = 定位模式 + 边偏移

相对定位：

1. 是相对于自己原来的位置来移动的（移动位置的时候参照点是自己原来的位置）
2. 原来在标准流的位置继续占有，后面的盒子仍然以标准流的方法来对待它（不脱标，继续保留原来位置）

绝对定位：

1. 如果没有祖先元素或者祖先元素没有定位，则以浏览器为准定位（Document文档）
2. 如果祖先元素有定位（相对、绝对、固定定位），则以最近一级有定位祖先元素为参考点移动位置
3. 绝对定位不在占用原来的位置（脱标）

子绝父相：因为父级需要占有位置，因此是相对定位，子盒子不需要占用位置，则是绝对定位

## logo

使用一个div来制作

```html
<div>
    <h1>
        <a href="index.html" title="品优购商场">品优购商场</a>
    </h1>
</div>
```

```css
.logo{
    position: absolute;
    top: 25px;
    width: 171px;
    height: 61px;
}
.logo a{
    display: block;
    width: 171px;
    height: 61px;
    background: url(../image/logo.png) no-repeat; 
    font-size: 0px; /*消除h1*/
}
```

## padding 和盒子

如果设置了盒子的宽和高，padding会将盒子撑大

如果没有设置盒子的高和宽，而设置了盒子的父级标签的宽度，padding不会将盒子撑大，只会压缩内容

## flex布局

display：inline-flex 行内元素

display：flex 块元素

主轴和交叉轴main cross

## justify-content

决定了flex items在 main axis上的对齐方式

- space-between: flex items之间的距离相等 与main start, main end 两端对齐
- space-evenly:flex items之间与main start, main end之间的距离等于flex items之间的距离
- space-around:flex item之间距离相等,flex items与main end 之间的距离是flex item的一半

## align-items

决定flex items在交叉轴的对齐方式

## flex-wrap

决定了 flex container是单行还是多行

- wrap多行
- nowarp（默认）单行
- wrap-reverse：多行

## align-content

决定了多行flex item在cross上的排列方式

## 实现局部滚动

```css
.content{
    height: 150px;
    overflow-y: scroll;
}
```

