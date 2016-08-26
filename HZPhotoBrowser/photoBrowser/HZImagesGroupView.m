//
//  HZImagesGroupView.m
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "HZImagesGroupView.h"
#import "HZPhotoBrowser.h"
#import "UIButton+WebCache.h"
#import "HZPhotoItemModel.h"

#define kImagesMargin 15

@interface HZImagesGroupView() <HZPhotoBrowserDelegate>

@end

@implementation HZImagesGroupView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除图片缓存，便于测试
        [[SDWebImageManager sharedManager].imageCache clearDisk];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)setPhotoItemArray:(NSArray *)photoItemArray
{
    _photoItemArray = photoItemArray;
    [photoItemArray enumerateObjectsUsingBlock:^(HZPhotoItemModel *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [[UIButton alloc] init];
        
        //让图片不变形，以适应按钮宽高，按钮中图片部分内容可能看不到
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.clipsToBounds = YES;
        
        [btn sd_setImageWithURL:[NSURL URLWithString:obj.thumbnail_pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"whiteplaceholder"]];
        btn.tag = idx;
        
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    long imageCount = self.photoItemArray.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF); // ((imageCount + perRowImageCount - 1) / perRowImageCount)
    CGFloat w = 80;
    CGFloat h = 80;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        
        long rowIndex = idx / perRowImageCount;
        int columnIndex = idx % perRowImageCount;
        CGFloat x = columnIndex * (w + kImagesMargin);
        CGFloat y = rowIndex * (h + kImagesMargin);
        btn.frame = CGRectMake(x, y, w, h);
    }];
    
    self.frame = CGRectMake(10, 10, 280, totalRowCount * (kImagesMargin + h));
}

- (void)buttonClick:(UIButton *)button
{
    //启动图片浏览器
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    browserVc.sourceImagesContainerView = self; // 原图的父控件
    browserVc.imageCount = self.photoItemArray.count; // 图片总数
    browserVc.currentImageIndex = (int)button.tag;
    browserVc.delegate = self;
    [browserVc show];

}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [self.subviews[index] currentImage];
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [[self.photoItemArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}
@end
