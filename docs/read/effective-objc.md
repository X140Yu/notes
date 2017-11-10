>写了 iOS 好久，这本书一直没读过，2017.11.07 开始读一遍

第一章看起来就比较熟悉了，大多都是编码规范相关的东西。

## Property

其实 `property` 就是 accessor + instance variable，在我们定义一个 `property` 的时候，编译器自动帮我们加上了相关的实现。

### 常用的 property 修饰符

| name   | 作用                                       |
| ------ | ---------------------------------------- |
| assign | 普通赋值                                     |
| weak   | 跟 assign 类似，不过当指针指向的对象被释放时，指针自动变成 nil    |
| strong | 先 retain 新值，再 release 旧值，最后赋值            |
| copy   | 先 copy 新值，再 release 旧值，最后赋值，常用于可能成为 mutable 的对象 |



#### weak 和 assign 的区别

`weak` 和 `assign` 其实都是普通的赋值，没有进行什么 `retain` `release` 之类的操作，但是当被指向的对象被释放时，`weak` 修饰的属性自动变成 nil，但 `assign` 还是指向那个旧的地址，所以 `assign` 可能会导致 crash。



要实现上面的功能，`weak` 要比 `assign` 多做一些事情，所以 `assign` 比 `weak` 的性能要更好。

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

