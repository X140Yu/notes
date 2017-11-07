
# Thread safety

[doc](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Multithreading/ThreadSafety/ThreadSafety.html)

## `@synchronized`

其实等同于下面的方法

```objc
func mySynchronized(anObj: AnyObject!) {
    objc_sync_enter(anObj)
    // thread safe
    objc_sync_exit(anObj)
}
```

关于 Swift 中等同的调用方式，可以参考[这篇文章](http://swifter.tips/lock/)