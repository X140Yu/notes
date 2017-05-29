### CSS 的引入方式
#### 1. 作为属性

```html
<p style="color: red;">This text is important.</p>
```

#### 2. 写在 `<head>` 标签里

```html
<html>
  <head>
    <title>Hello World</title>
    <style type="text/css">
      p { color: red; }
    </style>
  </head>
  <body>
    <p>This paragraph will be red.</p>
  </body>
</html>
```

#### 3. 作为一个单独的文件

```html
<html>
  <head>
    <title>Hello World</title>
    <link rel="stylesheet" type="text/css" href="style.css">
  </head>
  <body>
    <p>This paragraph will be red.</p>
  </body>
</html>
```

```css
p { color: red; }
```

### CSS 的语法

CSS 的语法非常简单：

```css
selector { property: value; }

/* 其实也就是 */
who { what: how; }
```
#### 一、selector
知道了语法，那么如何找到一个元素成了首要的问题。CSS 通过以下几种方式选中一个元素：

##### 1. tag
直接通过选中标签和名字，便可以选中这个标签。

```css
a { /* Links */ }
p { /* Paragraphs */ }
ul { /* Unordered lists */ }
li { /* List items */ }
```

##### 2. class
我们可以给 HTML 的元素添加 class，然后通过选中 class 来达到选择某个元素的目的。

```html
<p class="date">
  Saturday Feb 21
</p>
<p>
  The event will be on <em class="date">Saturday</em>.
</p>
```

```css
/* 所有 class 为 date 的元素都会变为红色*/
.date {
  color: red;
}
```

##### 3. ID
跟 class 很像的还有 ID，不过语法略微不同：

```html
<h1 id="tagline">This heading will be orange.</h1>
```

```css
#tagline{ color: orange;}
```

注意，id 是 `#` 开头，而 class 是 `.` 开头。

##### 4. 其它
1. 可以通过 `tag+class` 的形式，把这些 selector 给组合起来：

```css
.date {
  color: red;
}

/* em 中带 date class 的都会变成蓝色 */
em.date {
  color: blue;
}
```

2. Hierarchy selectors

```css
/*选中 header 里的所有 a 标签*/
header a {
  color: red;
}
```

3. Pseudo-class selectors

```css
a {
  color: blue;
}

/*当 a 标签在 hover 状态的时候变成红色*/
a:hover {
  color: red;
}
```

#### 二、Inheritance
有一些属性是可以被继承的：

1. text color
2. font (family, size, style, weight)
3. line-height

#### 三、Priority

```
#id selectors are worth 100
.class selectors are worth 10
tag selectors are worth 1
```

所以当有多个 selectors 都指向一个元素的时候，只有优先级最高的会被应用到那个元素上面去：

```html
<p class="message" id="introduction">
  MarkSheet is a free HTML and CSS tutorial.
</p>
```

```css
/*这个时候只有 #introduction 会被应用，因为它有 100 分*/
#introduction { color: red;}
.message { color: green;}
p { color: blue;}
```

为了避免冲突：

1. 多使用 class，尽量避免 id
2. 不要对一个元素使用应用多个 class
3. 不要使用 inline css 的方式


### Color & Size Unit

#### Color
##### 1. Names
CSS 内置的 [100 多种](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value)颜色的名字，可以直接使用。

```css
body { color: black;}
a { color: orange;}
```

##### 2. rgb, rgba

```css
a { color: rgb(219, 78, 68);}
body { color: rgba(0, 0, 0, 0.8);}
```

##### 3. hsl, hsla

```css
/*the Hue a value ranging from 0 to 360, defines which color you want. 颜色*/
/*the Saturation percentage, ranging from 0% to 100%, defines how much of that color you want. 饱和度*/
/*the Lightness percentage, ranging from 0% to 100%, defines how bright you want that color to be. 亮度*/
a { color: hsl(4, 68%, 56%);}
/*a 代表 alpha*/
body { color: hsla(4, 68%, 56%, 0.5);}
```

##### 4. Hexadecimal
没什么好说的，就是用 16 进制表示颜色嘛~

```css
body { background-color: #e42331; }
```

#### Size
CSS 中有很多属性需要 size 的单位，比如：
- font-size
- border-width
- margin
- left/right/top/bottom

而 CSS 中的 size 单位有以下几种：
- px
- %
- em

##### 1. px

```css
/* px 代表的是绝对宽度，是不会改变的，当在设置 position 和 spacing 的时候广泛使用 */
body { width: 400px;}
```

##### 2. %

```css
/* % 是相对的单位，它的百分比是根据它的父级比的 */
strong { font-size: 150%;}
```

##### 3. em

```css
/* em 也是相对的单位，它的大小是根据它的父级的 font-size 来的 */
/* 一改变 body 的 font-size，h1, h2, aside 的值都会相应地改变 */
body { font-size: 16px; }
h1 { font-size: 2em; }        /* = 32px */
h2 { font-size: 1.5em; }      /* = 24px */
aside { font-size: 0.75em; }  /* = 12px */
```

##### 4. rem

```css
/* em 是根据父级，而 rem 是根据 html，可以理解为 root-em */
html { font-size: 18px;}
body { font-size: 1rem;}     /* = 18px */
h1 { font-size: 2rem;}       /* = 36px */
h2 { font-size: 1.5rem;}     /* = 27px */
```




### text

#### font
通过 font-family 属性可以设置字体，这么多值是因为当前一种字体计算机没有装的时候，浏览器会加载后一种字体，当这些字体都没有的时候，会加载默认的字体。

```css
body{ font-family: Arial, Verdana, sans-serif;}
```

#### font property

```css
/* 比较常用的是以下三种，文档都可以查到就不再赘述了 */
p { font-size: 16px;}
h2 { font-style: italic;}
h2 { font-weight: bold;}
```

#### line-height
`line-height` 有三种单位，`px`, `em`, `%`，当是数字的时候，单位默认是数字

```css
/* 这个时候 line-height 是 16*1.5=24px */
body { font-size: 16px; line-height: 1.5;}
/* line-height 也可以被继承，这个时候 blockquote 的 line-height 是 18*1.5=27px */
blockquote{ font-size: 18px;}
```

#### text property
有一些 text 相关的属性，比如 `text-align, text-indent, text-shadow` 之类的，文档都可以查到，就不再说明。

### Box Model

#### display
`display` 属性可以修改 HTML 元素的种类，比如 `<p>` 标签是 `block` 类型的，但是可以通过 `display` 修改为 `inline` 类型的（就像 `<span>` 一样）。

```css
p { display: inline; }
```

我们为什么要修改它们的种类呢？因为我们选择标签的时候是根据它们本身的种类，而不是它们显示的样子。比如我们要添加一个无序列表，但它的显示要是 `inline` 的，那显然 `<ul>` 是放在第一位的。

```html
<!-- 它们显示默认是 block 的 -->
<ul class="menu">
  <li>
    <a>Home</a>
  </li>
  <li>
    <a>Features</a>
  </li>
  <li>
    <a>Pricing</a>
  </li>
  <li>
    <a>About</a>
  </li>
</ul>
```

```css
/* 把它们都显示在一行 */
.menu li {
  display: inline;
}
```

- `display: none` 和 `visibility: hidden` 的区别
前者是完全把这个元素移除了，跟没有存在过一样，然而后者只是把它隐藏了，然而占用的位置还在。

#### width & height
注意一点，如果内容超出了 `width & height` 的区域，设置 `overflow` 属性可以避免超出的内容显示的有问题。

#### border & padding & marigin

- Content - The content of the box, where text and images appear
- Padding - Clears an area around the content. The padding is transparent
- Border - A border that goes around the padding and content
- Margin - Clears an area outside the border. The margin is transparent

网上有很多关于 box model 的解释，其实很简单，看懂一张图就全明白了：

![](http://ww2.sinaimg.cn/large/5cc3eefejw1f9i64ygt9yj207705e0sk.jpg)

### Position

position 有几个备选的值：
- static
static 是默认的值

- relative
很好理解，位置是相对的，比较的对象是它原本的位置。
- absolute

先介绍一下 positioned 的概念：当一个元素的 position 是 relative || absolute || fixed 的时候，那它就 positioned 了。
而当 position 是 absolute 的时候，这个元素的位置是根据它第一个已经 positioned 的祖先而确定的。

```html
<section>
  I'm in position relative.
  <p>
    I'm in position absolute!
  </p>
</section>
```

```css
section {
  background: gold;
  height: 200px;
  padding: 10px;
  position: relative; /* This turns the <section> into a point of reference for the <p> */
}

p {
  background: limegreen;
  color: white;
  padding: 10px;
  position: absolute; /* This makes the <p> freely movable */
  bottom: 10px; /* 10px from the bottom */
  left: 20px; /* 20px from the left */
}
```

- fixed
这个跟 absolute 很类似，只不过它真的是固定在一个位置了，边滚动屏幕的时候也不会跟着走，像极了网络上的牛皮癣小广告（摊手）


