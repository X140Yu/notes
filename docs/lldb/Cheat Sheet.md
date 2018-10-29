### 读取一个地址对应的汇编语句

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