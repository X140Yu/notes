
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

## pthread_mutex_t

### PTHREAD_MUTEX_DEFAULT

### PTHREAD_MUTEX_RECURSIVE

允许同一个线程在未释放其拥有的锁时反复对该锁进行加锁操作。

## NSLock

`== pthread_mutex_t(.default)`

## NSRecursiveLock

`== pthread_mutex_t(.recursive)`
