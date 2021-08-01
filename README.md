# 使用 Time Profile 定位可复现掉帧bug

## 前言

自工作以来查过N个卡顿掉帧的bug，类型有下面几种：

- IO 大量读写，前台主线程卡顿
- 滚动时触发类似大量计算等复杂逻辑
- Debug模式下日志暴打

反馈卡顿掉帧问题的有两种情况：

- 对于能复现的掉帧卡顿问题：基本是通过 Time Profile 进行定位的

- 对于不能复现的掉帧卡顿问题：是通过拉取 卡顿堆栈 + 客户端日志定位的（涉敏，遂不在博客帖出）

这篇文章聊一下如何 通过 Time Profile 定位可复现掉帧bug，先聊使用用法，然后聊一聊原理。

## 一、使用 Time Profile 进行卡顿分析的步骤

### （一）Xcode 编译配置与环境

#### 1. 真机

在开始进行应用程序性能分析的时候,一定要使用真机,模拟器运行在Mac上，然而Mac上的CPU往往比iOS设备要快。相反，Mac上的GPU和iOS设备的完全不一样，模拟器不得已要在软件层面（CPU）模拟设备的GPU，这意味着GPU相关的操作在模拟器上运行的更慢，尤其是使用CAEAGLLayer来写一些OpenGL的代码时候. 这就导致模拟器性能数据和用户真机使用性能数据相去甚运.

#### 2. release版本

使用 Time Profile 进行卡顿问题分析，首先要明确：应该要编 release 包，而非 debug 包，debug包模式下会有大量日志打印，影响正常debug。

#### 3. 检查 dSYM File

在编译 release 版本前，我们要检查一下 Xcode release 版本下有没有打开 `DWARF with dSYM File'，也就是说编译的时候要把符号表要编出来，这样才能实现映射关系。

```
dSYM文件是什么?
debugger Symbols 的简称
.dSYM文件是一个符号表文件, 这里面包含了一个16进制的保存函数地址映射信息的中转文件, 所有Debug的symbols都在这个文件中(包括文件名、函数名、行号等).
一般Xcode项目每次编译后, 都会产生一个新的.dSYM文件和.app文件, 这两者有一个共同的UUID.
注:项目编译完dSYM文件和app文件在同一个目录，Xcode Debug 编译默认不会生成.dSYM文件, Release 编译才会生成
```

### （二）打开 Time Profile 路径区别

打开 Time Profile 有两个路径：

- 路径一：Xcode -> Open Developer Tool -> Instruments -> Time Profile 
- 路径二：Xcode -> Product -> Profile

这两个渠道的区别是：

路径一会在当前Xcode选择的编译证书下进行分析，如果你已经用 release_wc 编译完，那么使用路径一则会直接在 release_wc 的基础上进行监听。

路径二会默认使用 release 编译项目工程（目前我还没找到使用路径二可以修改编译scheme配置的路径）。

所以我采用的是路径一，先使用Xcode编译完 release_wc ，然后使用路径一打开 Time Profile

### （三）Time Profile 的配置问题

首次打开 Time Profile，可能会复杂的页面给震住，其实这个工具用起来并不麻烦。

![](https://tva1.sinaimg.cn/large/008i3skNgy1gt0mbwhx0oj30sa0hbac5.jpg)

这里我提供了一个Demo，github可见：[Time Profile调试Demo](https://github.com/BNineCoding/timeProfileUILagDemo)

可以模拟 scrollView / tableView 卡顿的场景，我们首先开始对 scrollView卡顿 进行监听，卡顿表现如下：

![](https://tva1.sinaimg.cn/large/008i3skNgy1gt1o0zykcug30cg0qogz6.gif)

我们在 「scrollView 的 scrollViewDidScroll: 中做了大量的计算」，调用的函数如下：

```
+ (void)caclLotsUselessNums {
    // 测试卡顿使用
    int num = 0;
    for (int i = 0 ; i < 1000; i ++) {
        num ++;
        NSLog(@"BNToolHelper num:%d",num);
    }
}
```

滑动后 Time Profile 展示如下：

![](https://tva1.sinaimg.cn/large/008i3skNgy1gt0mixkcmaj30s40s1tcg.jpg)

首先我们看红框1标记的地方，是不同线程的运行时间，因为我们无需展示系统调用函数，所以我们点击 红框2 进行配置：

![](https://tva1.sinaimg.cn/large/008i3skNgy1gt0mkl8x7pj308o04zmx6.jpg)

这里的配置的含义分别是：

- Separate by Thread（建议选择）：线程分离,只有这样才能在调用路径中能够清晰看到占用CPU最大的线程.每个线程应该分开考虑。只有这样你才能揪出那些大量占用CPU的"重"线程，按线程分开做分析，这样更容易揪出那些吃资源的问题线程。特别是对于主线程，它要处理和渲染所有的接口数据，一旦受到阻塞，程序必然卡顿或停止响应。
- Invert Call Tree（建议选择）：调用树倒返过来，将习惯性的从根向下一级一级的显示，如选上就会返过来从最底层调用向一级一级的显示。如果想要查看那个方法调用为最深时使用会更方便些。
- Hide System Libraries（建议选择）：选上它只会展示与应用有关的符号信息，一般情况下我们只关心自己写的代码所需的耗时，而不关心系统库的CPU耗时。
- Flatten Recursion（一般不选）：选上它会将调用栈里递归函数作为一个入口。
- Top Functions（可选）：选上它会将最耗时的函数降序排列，而这种耗时是累加的，比如A调用了B，那么A的耗时数是会包含B的耗时数。

完成对 Call Tree 的配置后，我们滚动视图，重新录制监控，得到监控堆栈如下：

![](https://tva1.sinaimg.cn/large/008i3skNgy1gt0muup1ahj30nf0ajabd.jpg)

可以看到我们添加的做大量无用计算的函数被监测出来了：

![](https://tva1.sinaimg.cn/large/008i3skNgy1gt0muup1ahj30nf0ajabd.jpg)

至此，「scrollView 的 scrollViewDidScroll: 中做了大量的计算」的卡顿原因就被定位到了。


## 二、UITableView 卡顿实测

接下来我要举一个稍微复杂一点的会导致 tableView 卡顿的例子，这个例子也已上传github[Time Profile调试Demo](https://github.com/BNineCoding/timeProfileUILagDemo)，这个例子工作很久的工程师也可能会犯。

### （一）发现问题

产品反馈，tableView 滚动时会卡顿，表现如下：

![](https://tva1.sinaimg.cn/large/008i3skNgy1gt1o2ajv90g30cg0qoe81.gif)

### （二）使用 Time Profile 定位问题

环境配置好后，我们开启 Time Profile 打印出卡顿堆栈：

![](https://tva1.sinaimg.cn/large/008i3skNgy1gt0n2t6rihj30ou0d440v.jpg)

我们发现在 `[BNDemoTableViewCell layoutSubviews]` 中调用了我们埋下的耗时计算方法`[BNToolHelper caclLotsUselessNums]`，打开`BNDemoTableViewCell`类一看，果然是有问题。

![](https://tva1.sinaimg.cn/large/008i3skNgy1gt0n48gzzhj30tc0rnq6k.jpg)

那么这个case怎么修改呢？

这种逻辑是编写 `UITableViewCell` 经常犯的错，`[cell layoutUI]`调整布局的方法应该在 `updateContentTitle:`结束后触发，而不应该放在 `layoutSubviews`中。

如果你知道`layoutSubviews`触发的条件，你就会明白为什么滚动时会疯狂触发 `layoutSubviews`：

```

layoutSubviews在以下情况下会被调用/被触发？

1、init初始化不会触发layoutSubviews，但是是用initWithFrame 进行初始化时，当rect的值 非CGRectZero时,也会触发。

2、addSubview会触发layoutSubviews

3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化

4、⭐️滚动一个UIScrollView会触发layoutSubviews

5、旋转Screen会触发父UIView上的layoutSubviews事件

6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件

```

修改后的代码是:

![](https://tva1.sinaimg.cn/large/008i3skNgy1gt0n9ba0e6j30ru0oktc3.jpg)
