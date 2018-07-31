//
//  HZPhotoBrowserConfig.h
//  HZPhotoBrowser
//
//  Created by huangzhenyu on 15-2-9.
//  Copyright (c) 2015年 huangzhenyu. All rights reserved.
//


typedef enum {
    HZWaitingViewModeLoopDiagram, // 环形
    HZWaitingViewModePieDiagram // 饼型
} HZWaitingViewMode;

typedef enum {
    HZPhotoBrowserStyleDefault, //复杂类型，带有弹回原位置动画效果
    HZPhotoBrowserStyleSimple // 简单类型
} HZPhotoBrowserStyle;

#define kMinZoomScale 0.6f
#define kMaxZoomScale 2.0f

#define kAPPWidth [UIScreen mainScreen].bounds.size.width
#define KAppHeight [UIScreen mainScreen].bounds.size.height

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//状态栏高度，iphoneX->44 其他 20
#define kStatusBar_Height [UIApplication sharedApplication].statusBarFrame.size.height
//底部安全距离 iphoneX->34 其他 0
#define kBottomSafeHeight (iPhoneX?34.0f:0.0f)

// 图片路径
#define HZPhotoBrowserSrc(file)  [@"HZPhotoBrowser.bundle" stringByAppendingPathComponent:file]
#define HZPhotoBrowserImage(file)     [UIImage imageNamed:HZPhotoBrowserSrc(file)]

// 图片保存成功提示文字
#define HZPhotoBrowserSaveImageSuccessText @" 保存成功 "

// 图片保存失败提示文字
#define HZPhotoBrowserSaveImageFailText @" 保存失败 "

// browser背景颜色
#define HZPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:1]

// browser中图片间的margin
#define HZPhotoBrowserImageViewMargin 10

//横竖屏切换动画时长
#define kRotateAnimationDuration 0.35f

// browser中显示图片动画时长
#define HZPhotoBrowserShowImageAnimationDuration 0.35f

// browser中隐藏图片动画时长
#define HZPhotoBrowserHideImageAnimationDuration 0.35f

// 图片下载进度指示进度显示样式（HZWaitingViewModeLoopDiagram 环形，HZWaitingViewModePieDiagram 饼型）
#define HZWaitingViewProgressMode HZWaitingViewModeLoopDiagram

// 图片下载进度指示器背景色
#define HZWaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
//#define HZWaitingViewBackgroundColor [UIColor clearColor]

// 图片下载进度指示器内部控件间的间距
#define HZWaitingViewItemMargin 10

