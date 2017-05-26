# 奇技淫巧 in Swift

## Defer
`defer` 的执行是在当前 scrope 执行之后

### 安全地释放资源
有了 `defer` 以后，再也不怕资源忘记释放的问题了！

```swift hl_lines="5 6 7 8"
func resizeImage(url: NSURL) -> UIImage? {
    // ...
    let dataSize: Int = ...
    let destData = UnsafeMutablePointer<UInt8>.alloc(dataSize)
    defer {
        // 不管这个下面走到哪个分支，只要当前函数执行完，destData 都会被释放
        destData.dealloc(dataSize)
    }

    var destBuffer = vImage_Buffer(data: destData, ...)

    // scale the image from sourceBuffer to destBuffer
    var error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, ...)
    guard error == kvImageNoError 
        else { return nil }

    // create a CGImage from the destBuffer
    guard let destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, ...) 
        else { return nil }
    // ...
}
```

### 一个小 trick

实现类似 C 中的 `x++` 效果，巧妙地利用了 `defer` 的延时特性。也就是在函数返回之后，`x` 的值才会发生改变。

```swift
postfix func ++(inout x: Int) -> Int {
    // fuck temp value
    let current = x
    x += 1
    return current
}
```

```swift hl_lines="3"
postfix func ++(inout x: Int) -> Int {
    // that's better
    defer { x += 1 }
    return x
}
```

### reference
- http://nshipster.com/guard-and-defer/

