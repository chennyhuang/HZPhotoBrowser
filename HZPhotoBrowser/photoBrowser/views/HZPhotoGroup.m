//
//  HZPhotoGroup.m
//  HZPhotoBrowser
//
//  Created by huangzhenyu on 15-2-4.
//  Copyright (c) 2015年 huangzhenyu. All rights reserved.
//
/** 此控件就是传说中的九图控件，布局自己在layoutSubviews里面处理*/

#import "HZPhotoGroup.h"
#import "UIButton+WebCache.h"
#import "HZPhotoBrowser.h"
#import "HZPhotoBrowserConfig.h"
#import <FLAnimatedImageView+WebCache.h>
#import <FLAnimatedImage/FLAnimatedImageView.h>
#define HZPhotoGroupImageMargin 15

@interface HZPhotoGroup () <HZPhotoBrowserDelegate>

@end

@implementation HZPhotoGroup 
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setUrlArray:(NSArray<NSString *> *)urlArray
{
    _urlArray = urlArray;
    //清除所有子控件，根据数据重新布局
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [urlArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        
        //让图片不变形，以适应按钮宽高，按钮中图片部分内容可能看不到
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        //默认占位图whiteplaceholder必须设置，否则在小图都没有加载成功时候，点击展示图片浏览器会崩溃
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:HZPhotoBrowserImage(@"whiteplaceholder.png")];
        
        imageView.tag = idx;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:tap];
        
        [self addSubview:imageView];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    long imageCount = self.urlArray.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF); // ((imageCount + perRowImageCount - 1) / perRowImageCount)
    CGFloat w = 80;
    CGFloat h = 80;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        
        long rowIndex = idx / perRowImageCount;
        int columnIndex = idx % perRowImageCount;
        CGFloat x = columnIndex * (w + HZPhotoGroupImageMargin);
        CGFloat y = rowIndex * (h + HZPhotoGroupImageMargin);
        btn.frame = CGRectMake(x, y, w, h);
    }];

    self.frame = CGRectMake(10, 10, 280, totalRowCount * (HZPhotoGroupImageMargin + h));
}

- (void)tap:(UIGestureRecognizer *)gesture
{
    FLAnimatedImageView *imageView = (FLAnimatedImageView *)gesture.view;
    //启动图片浏览器
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = YES;
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.currentImageIndex = (int)imageView.tag;
    browser.imageCount = self.urlArray.count; // 图片总数
    browser.delegate = self;
    [browser show];
}

#pragma mark - photobrowser代理方法
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    FLAnimatedImageView *imageView = (FLAnimatedImageView *)self.subviews[index];
    return imageView.image;
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.urlArray[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

@end
