## Gettings Started

```shell
# This will set the executable target to Xcode.
(lldb) file /Applications/Xcode.app/Contents/MacOS/Xcode

# launch process, redirect output using tty
(lldb) process launch -e /dev/ttys027 --

# find how many framework are written using swift
(lldb) script print "\n".join([i.file.basename for i in lldb.target.modules if i.FindSection("__swift3_typeref")])

# find a view using a click
(lldb) b -[NSView hitTest:]

# print the first argument of the method
(lldb) po $rdi
# print formating, (unsigned long) $3 = 0x00007f96f10b3a00
(lldb) p/x $rdi
(lldb) po 0x00007f96f10b3a00

# call a method then flush the UI
(lldb) po [$rdi setHidden:!(BOOL)[$rdi isHidden]]; [CATransaction flush]

# modify a breakpoint
(lldb) breakpoint modify 1 -c '(BOOL)[$rdi isKindOfClass:(id)NSClassFromString(@"IDEPegasusSourceEditor.SourceCodeEditorView")]'

# disable/enable a breakpoint
(lldb) breakpoint disable/enable 1

# execute swift code 
(lldb) ex -l swift -- import Foundation
(lldb) ex -l swift -- import AppKit
(lldb) ex -l swift -o -- unsafeBitCast(0x14bdd9b50, to: NSObject.self)

# search methods
(lldb) image lookup -rn objc\sIDEPegasusSourceEditor.SourceCodeEditorView.*getter
(lldb) image lookup -rn SourceCodeEditorView.*

# search swift private method
(lldb) image lookup -rvn  objc\sSourceEditor.SourceEditorView.insertText\
(Any\)
> `look for mangled="_T012SourceEditor0aB4ViewC10insertTextyypFTo"`

# 把这个方法 extern 出来
(lldb) po extern void _T012SourceEditor0aB4ViewC10insertTextyypFTo(long, char *,id);
# call this private method
(lldb) po _T012SourceEditor0aB4ViewC10insertTextyypFTo($rdi, 0,@"wahahahahah")
```

## Help

```shell
(lldb) apropos swift

(lldb) apropos "reference count"
```



## Attach

```shell
# attach to a process
lldb -n Xcode

pgrep -x Xcode # 89944
lldb -p 89944

# Attaching to a future process
lldb -n Finder -w
pkill Finder

# specify the path to the executable and manually launch
lldb -f /System/Library/CoreServices/Finder.app/Contents/MacOS/Finder
(lldb) process launch
# pass command line options
(lldb) process launch -w /Applications
# expand the tilde in the argument
(lldb) process launch -X true -- ~/Desktop
# 'run' is an abbreviation for 'process launch -X true --'
(lldb) run ~/Desktop
# pipe stdout to the given file
(lldb) process launch -o /tmp/ls_output.txt -- /Applications
# pass the file content as launch arguments
(lldb) process launch -i /tmp/wc_input.txt
```


## breakpoint

```shell
# search for symbols
(lldb) image lookup -n "-[UIViewController viewDidLoad]"
# case-sensitive regex lookup
(lldb) image lookup -rn UIViewController.*
# look for ObjC setters
(lldb) image lookup -n "-[TestClass setName:]"
# look for Swift setters
(lldb) image lookup -rn Signals.SwiftTestClass.name.setter


# remove all breakpoints
(lldb) breakpoint delete

# regular expressions
# create many breakpoints using smart regular expressions
(lldb) rb SwiftTestClass.name.setter
# equals
(lldb) b Breakpoints.SwiftTestClass.name.setter :
Swift.ImplicitlyUnwrappedOptional<Swift.String>

# breaks on every UIViewController call
(lldb) rb '\-\[UIViewController\ '
# category methods
(lldb) rb '\-\[UIViewController(\(\w+\))?\ '

# set a breakpoint on all the property getters/setters, blocks/closures, extensions/categories, and functions/methods in this file. -f is known as a scope limitation.
(lldb) rb . -f DetailViewController.swift

# limited it to `Commons` library
(lldb) rb . -s Commons
```



```shell
# source regex breakpoints 
(lldb) breakpoint set -L swift -r . -s Commons
(lldb) breakpoint set -A -p "if let"
# use -f to limit the scope
(lldb) breakpoint set -p "if let" -f MasterViewController.swift -f
DetailViewController.swift

# dump sections
(lldb) image dump sections <exeable name>



```



```shell
(lldb) file /bin/ls
(lldb) run
(lldb) image dump sections ls

# ls.__TEXT 段的内容就是它的代码，
# 地址从 0x0000000100000000 到 0x0000000100005000
(lldb) breakpoint set -n "-[UIView setTintColor:]" -c "*(uintptr_t*)$rsp
<= 0x0000000108067000 && *(uintptr_t*)$rsp >= 0x0000000108056000"
Sections for '/bin/ls' (x86_64):
  SectID     Type             Load Address                             Perm File Off.  File Size  Flags      Section Name
  ---------- ---------------- ---------------------------------------  ---- ---------- ---------- ---------- ----------------------------
  0x00000100 container        [0x0000000000000000-0x0000000100000000)* ---  0x00000000 0x00000000 0x00000000 ls.__PAGEZERO
  0x00000200 container        [0x0000000100000000-0x0000000100005000)  r-x  0x00000000 0x00005000 0x00000000 ls.__TEXT
  0x00000001 code             [0x0000000100000f0c-0x0000000100004420)  r-x  0x00000f0c 0x00003514 0x80000400 ls.__TEXT.__text
  0x00000002 code             [0x0000000100004420-0x00000001000045e8)  r-x  0x00004420 0x000001c8 0x80000408 ls.__TEXT.__stubs
  0x00000003 code             [0x00000001000045e8-0x00000001000048f0)  r-x  0x000045e8 0x00000308 0x80000400 ls.__TEXT.__stub_helper
  0x00000004 regular          [0x00000001000048f0-0x0000000100004ae8)  r-x  0x000048f0 0x000001f8 0x00000000 ls.__TEXT.__const
  0x00000005 data-cstr        [0x0000000100004ae8-0x0000000100004f67)  r-x  0x00004ae8 0x0000047f 0x00000002 ls.__TEXT.__cstring
  0x00000006 compact-unwind   [0x0000000100004f68-0x0000000100004ff8)  r-x  0x00004f68 0x00000090 0x00000000 ls.__TEXT.__unwind_info
  0x00000300 container        [0x0000000100005000-0x0000000100006000)  rw-  0x00005000 0x00001000 0x00000000 ls.__DATA
  0x00000007 data-ptrs        [0x0000000100005000-0x0000000100005010)  rw-  0x00005000 0x00000010 0x00000006 ls.__DATA.__nl_symbol_ptr
  0x00000008 data-ptrs        [0x0000000100005010-0x0000000100005038)  rw-  0x00005010 0x00000028 0x00000006 ls.__DATA.__got
  0x00000009 data-ptrs        [0x0000000100005038-0x0000000100005298)  rw-  0x00005038 0x00000260 0x00000007 ls.__DATA.__la_symbol_ptr
  0x0000000a regular          [0x00000001000052a0-0x00000001000054c8)  rw-  0x000052a0 0x00000228 0x00000000 ls.__DATA.__const
  0x0000000b data             [0x00000001000054d0-0x00000001000054f8)  rw-  0x000054d0 0x00000028 0x00000000 ls.__DATA.__data
  0x0000000c zero-fill        [0x0000000100005500-0x00000001000055e0)  rw-  0x00000000 0x00000000 0x00000001 ls.__DATA.__bss
  0x0000000d zero-fill        [0x00000001000055e0-0x000000010000566c)  rw-  0x00000000 0x00000000 0x00000001 ls.__DATA.__common
  0x00000400 container        [0x0000000100006000-0x000000010000a000)  r--  0x00006000 0x00003730 0x00000000 ls.__LINKEDIT
```



## Expression

```shell
# po
expression -O --
# p
expression --
```

### Swift and Objective-C context

```shell
# in swift context, execute ObjC code
(lldb) expression -l objc -O -- [UIApplication sharedApplication]
```



```shell
# define variables
(lldb) po id $test = [NSObject new];
(lldb) po $test


# modify variables
# $R0 come from lldb output, it's lldb defined variable
(lldb) expression -l swift -- $R0.title = "! ! ! ! ! "

# execute the expression and jump to the function
(lldb) expression -l swift -O -i 0 -- $R0.viewDidLoad()
```



• x: hexadecimal • d: decimal 

• u: unsigned decimal 

• o: octal
 • t: binary
 • a: address 

• c: character constant 

• f: float 

• s: string 



## Stack & Heap

![image-20180929180914878](assets/image-20180929180914878.png)Last in first out

grow downwards, from higher address to lower address



```shell
(lldb) thread backtrace
(lldb) frame info
(lldb) frame select 1
# skip the breakpoint
(lldb) run
# move one line 
(lldb) next # n
(lldb) step
(lldb) finish
```

```shell
# the scope of all the variables in your function as well as any global variables within your program using the appropriate options.
(lldb) frame variable
# look at all the private variables available to self
(lldb) frame variable -F self
```



### image

`alias image = target modules`



dynamic link editors (dyld)



```shell
(lldb) image list Foundation
# dump all the symbol table information available for UIKit
(lldb) image dump symtab UIKit -s address
# search _block_invoke symbol in Signals module
(lldb) image lookup -rn _block_invoke Signals
```



```
# UUID / load address / location

[  0] D153C8B2-743C-36E2-84CD-C476A5D33C72 0x000000010eb0c000 /
Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/
Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/
Contents/Resources/RuntimeRoot/System/Library/Frameworks/
Foundation.framework/Foundation
```

```shell
(lldb) rb appendSignal.*_block_invoke -s Commons
(lldb) frame variable
(__block_literal_5 *) .block_descriptor = 0x00006000031c6e00
(int) sig = 23
(siginfo_t *) siginfo = 0x00007ffee2d16f28
(UnixSignalHandler *) self = 0x0000600003109000
(UnixSignal *) unixSignal = 0x0000000110f4f6e5

(lldb) image lookup -t  __block_literal_5

Best match found in /Users/x140yu/Library/Developer/Xcode/DerivedData/Signals-ceiixmqoncipndgsmrrnqpxceutg/Build/Products/Debug-iphonesimulator/Signals.app/Frameworks/Commons.framework/Commons:
id = {0x100000c70}, name = "__block_literal_5", byte-size = 52, decl = UnixSignalHandler.m:123, compiler_type = "struct __block_literal_5 {
    void *__isa;
    int __flags;
    int __reserved;
    void (*__FuncPtr)();
    __block_descriptor_withcopydispose *__descriptor;
    UnixSignalHandler *const self;
    siginfo_t *siginfo;
    int sig;
}"
```



```shell
# break all block in a module 
rb .*.*block_invoke -s Commons
```



```shell
(lldb) image lookup -rn NSObject\(IvarDescription\)
_ivarDescription
_propertyDescription
_methodDescription
_shortMethodDescription

# all ivars
(lldb) po [[UIApplication sharedApplication] _ivarDescription]
```

