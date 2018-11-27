## Swift 和 Objective-C 混编

大体上来说，看[这个](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html)文档就能解决大部分问题

### Swift 引 Objective-C

把对应的 Objective-C 头文件放入 `ProductModuleName-Bridging-Header.h` 里

如果在 Pods 中的 Public 文件，不需要做任何操作。因为 Objective-C 中的 public 文件会被引入 `xxx-umbrella.h`，这其中文件会被 Swift 看到

#### 一些好用的关键字

- `NS_SWIFT_NAME`
- `NS_REFINED_FOR_SWIFT` 通俗来说就是把一个在 Objective-C 里的方法在 Swift 中重新实现一下。 [Blog](https://briancoyner.github.io/2018/02/10/ns-refined-for-swift.html)
- `NS_SWIFT_UNAVAILABLE`

### Objective-C 引 Swift

`#import "ProductModuleName-Swift.h"`

#### 什么东西不能被 Objective-C 看到

[看这里](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/InteractingWithObjective-CAPIs.html#//apple_ref/doc/uid/TP40014216-CH4-ID53)