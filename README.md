# BounceBall
Demo的改动效果
![游戏过程](https://github.com/Sugarjunfeng/BounceBall/blob/master/BounceBall-Demo/BounceBall.gif)
##1.first submit
环境：Xcode6.4
###1.1 将部分宏定义修改为类型常量
`static const uint32_t slowBallCategory = 0x1 << 3;`

`static const uint32_t waterCategory = 0x1 << 4;`

`static const uint32_t barCategory = 0x1 << 5; `

##2.second submit
环境Xcode 7.2
###2.1 之前作者的原项目使用Xcode6.4写的，使用Xcode7.2打开后，报了以下错误。
/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/dsymutil /Users/tangjunfeng/Library/Developer/Xcode/DerivedData/CrazyBounce-OC-clzfjxmxrsjvizciuvolvstjgsph/Build/Products/Debug-iphonesimulator/CrazyBounce-OC.app/CrazyBounce-OC -o /Users/tangjunfeng/Library/Developer/Xcode/DerivedData/CrazyBounce-OC-clzfjxmxrsjvizciuvolvstjgsph/Build/Products/Debug-iphonesimulator/CrazyBounce-OC.app.dSYM

这个问题，我在自己的简书博客中写到过，上面有解决办法。
地址如下：[简书](http://www.jianshu.com/p/617ee322ab68)

