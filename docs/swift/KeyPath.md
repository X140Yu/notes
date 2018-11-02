# KeyPath

## KeyPath in Objective-C

看下面两段 Objective-C 的代码，

```objc
// KVC
[someObject setValue:someValue forKey:@"someKey"];

// KVO
[account addObserver:self
          forKeyPath:@"balance"
             options:NSKeyValueObservingOptionNew
             context:PersonAccountBalanceContext];
```

上面的代码存在的一个共同问题是 `KeyPath` 参数的类型。`NSString *` 代表你和所谓的编译检查就没有什么关系了。在未来的某一天，如果 property 的名字发生了变化，代码就会出现问题。所以 Objective-C 中的 KeyPath 并不安全（这样的例子在 Objective-C 中并不少见）。

[extobjc 提供的 @keypath 宏](https://github.com/jspahrsummers/libextobjc/blob/master/extobjc/EXTKeyPathCoding.h#L38) 为 KeyPath 提供了编译时期的检查。如果未来 KeyPath 发生变化，就会产生编译错误。

```objc
@keypath(NSURL.new, baseURL);

// 等于

// 在编译的时候，这个表达式 `NSURL.new.baseURL` 会被执行，如果这个 KeyPath 不存在，编译器会报错
// 表达式只会被执行，但真正的返回值是最后的 `@"baseURL"`
((NSString * _Nonnull)@((((void)(NO && ((void)NSURL.new.baseURL, NO)), "baseURL"))));
```

同样的 API，在 Swift 那边调用想必会有类似的问题，那么它是如何解决？

## KeyPath in Swift

### `#keyPath()`

`#keyPath()` 是 Swift 在 [3.0 版本实现的](https://github.com/apple/swift-evolution/blob/master/proposals/0062-objc-keypaths.md)类似于上文提到的 `@keypath` 的表达式，但要比 `@keypath` 要更强大一些（毕竟它是在[语言层面的实现](https://github.com/apple/swift/commit/9f0cec4984d7bb23eb242d9eca7c82039310f52d)），在传递参数的时候，可以直接使用 `UILabel.text` 而不需要对应的实例存在(`label.text`)。

实现它的主要目的是在使用 Swift 调用与 Objective-C 相关需要 `String` 类型 KeyPath 的 API 时，提供带有编译检查的，更  安全的调用方式。

```swift
// KVC
label.setValue("value", forKey: #keyPath(UILabel.text))

// KVO
label.addObserver(self,
                  forKeyPath: #keyPath(UILabel.text),
                  options: .new,
                  context: nil)
```

那如果是非 NSObject 子类的纯 Swift 类(比如 struct)，是如何使用 KeyPath 的呢？

## KeyPath<Root, Value>

4.0 版本，Swift [实现了](https://github.com/apple/swift-evolution/blob/master/proposals/0161-key-paths.md)更好更安全的 KVC API，引入了 `KeyPath` 这个类型。

同样的 KVC 调用在 Swift 中是这样写的，

```swift
let label = UILabel()
label.text = "abc" # KeyPath<UILabel, String>
label[keyPath: \UILabel.text] // "abc"
```

上面代码中的 `\UILabel.text` 的类型就是一个 KeyPath<UILabel, String>，会与 Root 和 Value 的类型更安全，编译器不光能够确保你在调用这个方法的时候 KeyPath 一定在，还能通过 Value 的类型推断返回值。这是相比 Objective-C API 的一个很大的提升。

通过 KeyPath 获取到的对象是 readonly 的，如果需要对结果进行修改，需要使用下面两个类型，

- WritableKeyPath
- ReferenceWritableKeyPath

前者只能修改声明为 `var` 对象(struct 和 class) KeyPath 的 value，后者可以修改 class 对象对应 KeyPath 的 value

```swift
class Fruit {
  var name = "Apple"
}

// a let class object's KeyPath value can not be modified by WritableKeyPath
let f = Fruit() 
let keyPath: WritableKeyPath<Fruit, String> = \Fruit.name
f[keyPath: keyPath] = "Banana" // ❌ Cannot assign to immutable expression of type 'String'

// this will work
var f = Fruit()
let keyPath: WritableKeyPath<Fruit, String> = \Fruit.name
f[keyPath: keyPath] = "Banana" // f.name ... "Banana"
f[keyPath: \Fruit.name] = "Orange" // default is ReferenceWritable f.name ... "organ"
```

Swift 中的 KeyPath 很灵活，再加上 Swift 强大的类型系统，可以实现很多方便有趣的功能。但它也有缺点。你不能像使用 Objective-C 那样通过 `valueForKey:` 获取任意一个对象某个 KeyPath 下的属性（比如在类外生成它 private property 的 KeyPath），或通过 `setValue:ForKey:` 对任意 KeyPath 设置 value。但如果你对这样的 Hack 感兴趣，或许你应该看看 Swift 中的 [Mirror](https://developer.apple.com/documentation/swift/mirror) 类型或者 [Reflection](https://github.com/Zewo/Reflection) 这样的 library。Use it under your own risk，我的建议还是能不用就不要用。安全性的动态性本来就是很难平衡的。

## KeyPath 的应用

### Foundation

对于 Foundation 中一些使用 String 作为 KeyPath 的旧 API，Swift 添加了新的 KeyPath<Root, Value> 类型参数的新 API 支持，比如，

- [NSSortDescriptor](https://github.com/apple/swift/blob/6b68303997d25128c62264371e1ab1c04dc430ed/stdlib/public/SDK/Foundation/NSSortDescriptor.swift#L17)
- [NSExpression](https://github.com/apple/swift/blob/6b68303997d25128c62264371e1ab1c04dc430ed/stdlib/public/SDK/Foundation/NSExpression.swift#L26)
- [KVO](https://github.com/apple/swift/blob/6b68303997d25128c62264371e1ab1c04dc430ed/stdlib/public/SDK/Foundation/NSObject.swift#L195)

### 其它应用

还有一些其它优秀的关于 Swift KeyPath 的应用，大家可以翻翻看，

- https://www.objc.io/blog/2018/04/24/bindings-with-kvo-and-keypaths/
- http://www.chris.eidhof.nl/post/micro-autolayout-dsl/
- https://www.swiftbysundell.com/posts/the-power-of-key-paths-in-swift

希望大家从我做起，拒绝字符串编程 🙅🏻‍♂️
