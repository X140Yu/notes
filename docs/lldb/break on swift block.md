## break on Swift block

```shell
# find all Swift closures within the Signals module
(lldb) image lookup -rn closure Signals

# create a breakpoint on every Swift closure within the Signals module.
(lldb) rb closure -s Signals

# try looking at code that can stop on didSet/willSet property helpers 
(lldb) rb willset -s Signals
(lldb) rb didset -s Signals

# do/try/catch blocks


```

## 更改 StatusBar 的 UI

这是 Advanced Apple Debugging & Reverse Engineering Chapter 7 的习题。

```shell
(lldb) image lookup -rn NSObject\(IvarDescription\)
_ivarDescription
_propertyDescription
_methodDescription
_shortMethodDescription
```

是一个 `_ivarDescription` 和 `_shortMethodDescription` 的练习，

```shell
(lldb)po [[UIApplication sharedApplication] _ivarDescription]
> _statusBar (UIStatusBar*) 0x0000001

(lldb)po [0x0000001 _ivarDescription]
> _statusBar (_UIStatusBar *) 0x0000002

(lldb)po [0x0000002 _ivarDescription]
> _items (NSMutableDictionary *) 0x0000003

(lldb)po 0x0000003
> 找到一个叫 _UIStatusBarTimeItem 的 item  0x0000004

(lldb)po [0x0000004 _ivarDescription]
> _shortTimeView (_UIStatusBarStringView *) 0x0000005

(lldb)po [0x0000005 _shortMethodDescription]
> setText

(lldb)po [0x0000005 setText:@"zxy"]
```

然后就更改成功了