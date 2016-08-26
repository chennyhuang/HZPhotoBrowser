## HZPhotoBrowser
##
目前的HZPhotoBrowserBUG比较多，整体思路上面可能有问题，我用了另外一种方式实现，这种方式比较完善，建议大家使用。
地址如下：
  https://github.com/chennyhuang/ptoto

##tips
据几位同学反映，图片在显示和隐藏的时候动画会出现错位情况。现对这种情况做出说明，首先这种情况的存在主要是由于convertRect坐标转换不正确导致，一般是直接用UITableviewController布局才会导致转换不正确。建议使用UIViewController + UITableview的方式布局。

##简介
一个类似于新浪微博图片浏览器的框架。<br/>
A framework similar to the sina weibo photo browser.

* 支持显示和隐藏动画。<br/>
  -- Support the show and hide animation effects
* 支持双击缩放，手势放大缩小。<br/>
  -- Supports double-click scaling, gestures to zoom in.
* 支持图片存储。<br/>
  -- Support photo storage.
* 支持网络加载gif图片，长图滚动浏览。<br/>
  -- Support network loading GIF images, scroll through long figure.
* 支持横竖屏显示。<br/>
  -- Support for landscape and vertical screen display switch.

##功能展示
<h5>1. 显示和退出图片浏览器的动画效果</h5>
![image](https://github.com/chennyhuang/GIFSource/blob/master/111.gif)
<hr/>

<h5>2. 双击放大缩小，手势捏合</h5>
<h6>（解决双击时图片跳跃问题，现在双击放大图片比较流畅）</h6>
![image](https://github.com/chennyhuang/GIFSource/blob/master/222.gif)
<hr/>

<h5>3. 显示gif图片</h5>
![image](https://github.com/chennyhuang/GIFSource/blob/master/333.gif)
<hr/>

<h5>4.长图滚动浏览</h5>
![iamge](https://github.com/chennyhuang/GIFSource/blob/master/444.gif)
<hr/>

<h5>5.放大至全屏无黑边</h5>
![image](https://github.com/chennyhuang/GIFSource/blob/master/555.gif)
<hr/>

<h5>6.支持横屏</h5>
![image](https://github.com/chennyhuang/GIFSource/blob/master/666.gif)
<hr/>


###创建图片浏览器
```objc
HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
browserVc.sourceImagesContainerView = 原图的父控件;
browserVc.imageCount = 图片总数;
browserVc.currentImageIndex = 当前图片index;
// 代理
browserVc.delegate = self;
// 展示图片浏览器
[browserVc show];
```

###实现代理
```objc
//临时占位图（thumbnail图）
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;
//高清原图 （bmiddle图）
- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;
```
###如何使用这份代码具体请看HZTableViewController.m文件的实现

##提示
* 本框架纯ARC。主要目的是为了大家学习使用。
