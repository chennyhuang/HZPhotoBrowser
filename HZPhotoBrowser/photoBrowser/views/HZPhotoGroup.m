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

#define HZPhotoGroupImageMargin 15

@interface HZPhotoGroup () <HZPhotoBrowserDelegate>

@end

@implementation HZPhotoGroup 
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除图片缓存，便于测试
        [[SDWebImageManager sharedManager].imageCache clearMemory];
        [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:^{
            
        }];
    }
    return self;
}

- (void)setUrlArray:(NSArray<NSString *> *)urlArray
{
    _urlArray = urlArray;
    //清除所有子控件，根据数据重新布局
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [urlArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [[UIButton alloc] init];
        
        //让图片不变形，以适应按钮宽高，按钮中图片部分内容可能看不到
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.clipsToBounds = YES;
        
        [btn sd_setImageWithURL:[NSURL URLWithString:obj] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"whiteplaceholder"]];
        btn.tag = idx;
        
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
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

- (void)buttonClick:(UIButton *)button
{
    //启动图片浏览器
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = YES;
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = self.urlArray.count; // 图片总数
    browser.currentImageIndex = (int)button.tag;
    browser.delegate = self;
    [browser show];
}

#pragma mark - photobrowser代理方法
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

@end
