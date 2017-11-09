>写了 iOS 好久，这本书一直没读过，2017.11.07 开始读一遍

第一章看起来就比较熟悉了，大多都是编码规范相关的东西。

## Property

其实 `property` 就是 accessor + instance variable，在我们定义一个 `property` 的时候，编译器自动帮我们加上了相关的实现。

### 常用的 property 修饰符

| name   | 作用   |
| ------ | ---- |
| assign | 普通赋值 |
| weak   |      |
| strong |      |
| copy   |      |



#### weak 和 assign 的区别



### 实例变量和 property 的区别

1. 访问实例变量的速度比 property 要快。因为没有方法调用的过程
2. 直接访问实例变量，它的内存访问修饰符不会起作用

```objective-c
@property (nonatomic, copy) NSString *str;
```

有这样一个字符串，在 `_str` 访问的时候，它的内存访问修饰符不会起作用，这时候把一个 `mutableString` 给它的时候，就会有问题：

```objective-c
_str = someMutableString
```

3. 直接访问实例变量，不会触发 KVO

