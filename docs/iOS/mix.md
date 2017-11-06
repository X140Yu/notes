## CALayer

CALayer 的有些属性改变都是自带隐式 animation 的，如果需要去掉，需要 

```swift
CATransaction.begin()
CATransaction.setDisableActions(true)
/// a.frame = ...
CATransaction.commit()
```

