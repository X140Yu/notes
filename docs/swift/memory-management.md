# Swift 中的内存管理

## 到底使用 `weak` 还是 `unowned`？

先抛出结论，在你不理解到底该用哪个的时候，用 `weak` 是最稳妥的行为。

根据 Apple 的[文档][1]，

>Use an unowned reference only when you are sure that the reference always refers to an instance that has not been deallocated.

>If you try to access the value of an unowned reference after that instance has been deallocated, you’ll get a runtime error.

也就是说，为了防止引用循环的出现，如果你确定，当前对象存在的时候，你引用的对象是 100% 存在的，那么用 `unowned` 就可以了。

还有，`weak` 的变量必须是 `optional` 的。

总之好好读文档啦



[1]: https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html
