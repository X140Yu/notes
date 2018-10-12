# Stack

在 x86 和 arm64 架构下，栈的地址是从高到低的，具体多高还得取决于操作系统 

当栈的地址到达边界时，就会产生 stack overflow 的错误



### RSP (Stack Pointer)  RBP (Base Pointer)

会一直指向栈顶

调用一个函数的时候，其实就是向调用栈 push 了一个新的 frame，RSP 会指向新的栈顶。调用完毕后，会把这个 frame pop 出来，RSP 会重新指向原来的 frame



在方法内部的时候，程序会使用与 RBP 的 offset 来获取局部变量和参数，



每个 frame 的 RBP 会指向上一层的 RBP，


```shell
(lldb) memory read -c80 0x7ffeefbff0e0 -fx -s8

0x7ffeefbff0e0: 0x00007ffeefbff2f0 0x00007fff68dcaabb
...
0x7ffeefbff350: 0x00007ffeefbff420 0x00007fff3a35575d

0x7ffeefbff360: 0x0000000000008003 0x00007fff3af5351c
...
0x7ffeefbff420: 0x00007ffeefbff470 0x00007fff3a344e97

0x7ffeefbff430: 0x0000000000000000 0x517caa5eb65885a9
...
0x7ffeefbff470: 0x00007ffeefbff490 0x0000000100007e8d
```





## Stack related opcode

### push

Store variable on the stack, push value to RSP

```shell
push some_val

->

RSP = RSP - sizeof(some_val)
*RSP = some_val
```

### pop

pop value from RSP, store it to destination

```shell
pop rdx

->

RDX = *RSP
RSP = RSP + sizeof(some_val)
```

### call

execute a function

先把要返回的地址(0x7fffb34de918) push 到栈上(这里直接操作 RIP 了)，然后把 RIP 修改为要 `call` 的地址

```shell
0x7fffb34de913 <+227>: call   0x7fffb34df410
0x7fffb34de918 <+232>: mov    edx, eax

->

RIP = 0x7fffb34de918
RSP = RSP - 0x8
*RSP = RIP
RIP = 0x7fffb34df410
```

### ret

与 `call` 相反，会把之前 `call` 下一行的地址 pop 出来到 RIP

```shell
ret 

->

RIP = *RSP
RSP = RSP + sizeof(some_val)
```



