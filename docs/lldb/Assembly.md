# Assembly

## Assembly Register Calling Convention

x86_64 is a 64-bit architecture, which means every address can hold up to 64 1s or 0s.

x86_64 is the architecture most likely used on your macOS computer

ARM64 architecture is used on mobile devices such as your iPhone where limiting energy consumption is critical.



### x86_64

RAX, RBX, RCX, RDX, RDI, RSI, RSP, RBP and R8 through R15.

arg1, arg2,  argx…….

- First Argument: RDI 
- Second Argument: RSI 
- Third Argument: RDX 
- Fourth Argument: RCX 
- Fifth Argument: R8 
- Sixth Argument: R9 

RAX is the return register





```shell
(lldb) register read
```





> Why you’ll never see the objc_msgSend in the LLDB backtrace?

The objc_msgSend family of functions perfoms a `jmp`, or jump opcode command in assembly. Which is called tail call optimization.

```shell
id UIApplicationClass = [UIApplication class];
objc_msgSend(UIApplicationClass, "sharedApplication");

$rdi -> UIApplicationClass
$rsi -> selector, (has to cast it to `char *` or `SEL`)

---

NSString *helloWorldString = [@"Can't Sleep; " stringByAppendingString:@"Clowns will eat me"];
NSString *helloWorldString = objc_msgSend(@"Can't Sleep; ", "stringByAppendingString:", @"Clowns will eat me");

$rdi -> "Can't Sleep"
$rsi -> selector
$rdx
```





```shell
(lldb) b -[NSWindow mouseDown:]
(lldb) po [$rdi setBackgroundColor:[NSColor redColor]]
```



```shell
# 替换所有 [UILabel setText:]
xcrun simctl list | grep "iPhone X"
> iPhone X (A68E22C0-8286-4E60-BF62-92559E15A622) (Shutting Down)

open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app --args -CurrentDeviceUDID A68E22C0-8286-4E60-BF62-92559E15A622

lldb -n SpringBoard
(lldb) p/x @"Yay! Debugging"
> (__NSCFString *) $3 = 0x0000618000644080 @"Yay! Debugging"

(lldb) b -[UILabel setText:]
(lldb) breakpoint command add
> po $rdx = 0x0000618000644080
> continue
> DONE

```



```shell
# hook all button action events
(lldb) b -[UIControl sendAction:to:forEvent:]
```



> - In Objective-C, the RDI register is the reference of the calling NSObject, RSI is the Selector, RDX is the first parameter and so on. 
> - In Swift, RDI is the first argument, RSI is the second parameter, and so on provided that the Swift method isn’t using dynamic dispatch. 
> - The RAX register is used for return values in functions regardless of whether you’re working with Objective-C, or Swift. 





Try attaching to an application on the iOS Simulator and map out the UIViewControllers as they appear using assembly, a smart breakpoint, and a breakpoint command.



```shell
lldb -n 'Preferences'
(lldb) b -[UIViewController viewDidLoad]
(lldb) breakpoint command add
> po $arg1
> DONE
```



### RIP

RIP register 存的是方法的地址，通过修改 RIP 寄存器的器的值可以动态修改方法的实现，



```shell
# 1. 在方法定义那行下断点

# 查看当前方法的地址（非必须）
(lldb) cpx $rip
> (unsigned long) $2 = 0x0000000100007b80

# 2. 搜索想要替换的方法，其中的 range 左边就是方法的起始地址
(lldb) image lookup -rvn '^Register.*goodMethod'
> Symbol: id = {0x00000308}, range = [0x0000000100007c50-0x0000000100007d20), name="Registers.AppDelegate.goodMethod() -> ()", mangled="$S9Registers11AppDelegateC10goodMethodyyF"

# 3. 修改 RIP 的值
(lldb) register write rip 0x0000000100007c50
```



![image-20181002093019589](assets/image-20181002093019589.png)





读取一个地址对应的汇编语句，

```shell
# 对应这个地址，读一条汇编指令
(lldb) memory read -fi -c1 0x100008910
->  0x100007b80: 55  push   rbp

# 上面的 55 其实是 `push rbp` 的编码
(lldb) expression -f i -l objc -- 0x55 # p/i 0x55
> $1 = 55  pushq  %rbp

(lldb) memory read -fi -c10 0x100008910
```



### 大小端

```shell
# 当以不同的 size 输出起始地址（0x100008910）开始的内存时
# 根据大小端的不同，lldb 会按照大小分组，正确地输出内存内容

(lldb) memory read -s1 -c20 -fx 0x100008910
> 0x100008910: 0x55 0x48 0x89 0xe5 0x48 0x81 0xec 0xc0

(lldb) memory read -s2 -c10 -fx 0x100008910
# 这里的 0x4855 和上面的前两个字节刚好是反过来的
> 0x100008910: 0x4855 0xe589 0x8148 0xc0ec 0x0000 0x4c00 0x6d89 0xb8f8

(lldb) memory read -s4 -c5  -fx 0x100008910
> 0x100008910: 0xe5894855 0xc0ec8148 0x4c000000 0xb8f86d89
```
