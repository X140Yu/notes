## parentViewController

## 没有设置 parentViewController 会导致什么问题？

有一次，在一个 tableView 里面的 cell 内嵌套了一个可以横向滑动的 pageViewController，pageViewController 内的每一个 child 都是一个 tableViewController。

点击状态栏，最内部的 tableViewController 没有滑动到屏幕的顶部，就是因为没有设置 pageViewController 的 pageViewController。

所以在视图中有多个 viewController 的时候，一定要**把它们的 parentViewController**都设置上，否则就会导致一些幺蛾子的 bug。

