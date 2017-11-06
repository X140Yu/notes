## Swift 和 Objective-C 混编

大体上来说，看[这个](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html)文档就能解决大部分问题

### Swift 引 Objective-C

把对应的 Objective-C 头文件放入 `ProductModuleName-Bridging-Header.h` 里

#### 一些好用的关键字

- `NS_SWIFT_NAME`
- `NS_REFINED_FOR_SWIFT`
- `NS_SWIFT_UNAVAILABLE`

### Objective-C 引 Swift

`#import "ProductModuleName-Swift.h"`

#### 什么东西不能被 Objective-C 看到

[看这里](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/InteractingWithObjective-CAPIs.html#//apple_ref/doc/uid/TP40014216-CH4-ID53)