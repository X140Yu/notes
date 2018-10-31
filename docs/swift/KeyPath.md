# KeyPath


## Objective-C 中的 KeyPath

看下面两段 Objective-C 的代码，

```objc
// KVO
[someObject setValue:someValue forKey:@"someKey"];

// KVO
[account addObserver:self
          forKeyPath:@"balance"
             options:NSKeyValueObservingOptionNew
             context:PersonAccountBalanceContext];
```

上面的代码存在的一个共同问题是 `KeyPath` 的类型是 `NSString *`，所以就不要指望会有任何编译检查了。如果在未来的某一天，property 的名字发生了变化，就会导致上面的代码错误，所以 Objective-C 中的 KeyPath 并不安全（其实这样的例子在 Objective-C 中比比皆是）。

[extobjc 中的 @keypath 宏](https://github.com/jspahrsummers/libextobjc/blob/master/extobjc/EXTKeyPathCoding.h#L38) 就解决了上面调用不安全的问题，为 KeyPath 提供了编译时期的检查。

```objc
@keypath(NSURL.new, baseURL);

// equals

((NSString * _Nonnull)@((((void)(NO && ((void)NSURL.new.baseURL, NO)), "baseURL"))));
```

那么 Swift 是如何解决这个问题的呢？

## KeyPath in Swift

