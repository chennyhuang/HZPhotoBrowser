//
//  HZPhotoBrowserView.h
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZPhotoBrowserView : UIView
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL beginLoadingImage;

//单击回调
@property (nonatomic, strong) void (^singleTapBlock)(UITapGestureRecognizer *recognizer);

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
