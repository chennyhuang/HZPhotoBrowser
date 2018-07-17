## HZPhotoBrowser

## 简介
一个类似于新浪微博图片浏览器的框架。

* 支持显示和隐藏动画。
* 支持双击缩放，手势放大缩小。
* 支持横竖屏切换。
* 支持手势拉动退出，效果类似微博。
* 支持长图展示。
* 提供两种展示模式。
* 适配 iphone X


## 功能展示

#### 竖屏
![image](https://github.com/chennyhuang/HZPhotoBrowser/blob/master/1.gif)
<hr/>

![image](https://github.com/chennyhuang/HZPhotoBrowser/blob/master/2.gif)

#### 横屏
![image](https://github.com/chennyhuang/HZPhotoBrowser/blob/master/3.gif)
<hr/>


### 创建图片浏览器
#### 方式1
* 直接传url数组，然后展示出来。调用方式简单，无需其他控件支持。
* 具体代码参照 HZRootViewController.m -> - (IBAction)style2:(id)sender方法
```objc
HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
browser.isFullWidthForLandScape = YES;
browser.isNeedLandscape = YES;
browser.currentImageIndex = 3;
browser.imageArray = @[
@"http://ww2.sinaimg.cn/bmiddle/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
@"http://ww2.sinaimg.cn/bmiddle/642beb18gw1ep3629gfm0g206o050b2a.gif",
@"http://ww4.sinaimg.cn/bmiddle/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg",
@"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
@"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
@"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
@"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
@"http://ww2.sinaimg.cn/bmiddle/677febf5gw1erma104rhyj20k03dz16y.jpg",
@"http://ww4.sinaimg.cn/bmiddle/677febf5gw1erma1g5xd0j20k0esa7wj.jpg"
];
[browser show];
```

#### 方式2
##### 步骤
###### 1.自定义九图控件，在九图控件的item点击事件里面调起图片浏览器。具体代码参照HZPhotoGroup类。
###### 关键代码
```objc
//启动图片浏览器
HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
browser.isFullWidthForLandScape = YES;
browser.isNeedLandscape = YES;
browser.sourceImagesContainerView = self; // 原图的父控件
browser.currentImageIndex = (int)button.tag;
browser.imageCount = self.urlArray.count; // 图片总数
browser.delegate = self;
[browser show];
```
```objc
//实现photobrowser代理方法
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
return [self.subviews[index] currentImage];
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
NSString *urlStr = [self.urlArray[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
return [NSURL URLWithString:urlStr];
}
```
###### 2.将九图控件添加到tableview的cell上。cell的代码参照HZTableViewCell类。
###### 3.cell添加到tableview上面。

### tips
#### 要想实现上面的方式2，不可能像上面介绍的方式1一样，初始化一下图片浏览器，然后传入图片url数组，调起图片浏览器就完了。必须自定义九图控件。
#### 关于九图控件的布局，和里面item使用的view的类型，各人根据自己的需求自己定义。
#### 项目中使用 SDWebImage 4.0.0及以上版本加载网络图片。
