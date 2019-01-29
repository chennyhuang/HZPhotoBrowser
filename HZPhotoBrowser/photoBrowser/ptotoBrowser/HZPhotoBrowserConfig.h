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


#ifndef    weakify
#if __has_feature(objc_arc)

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif
#endif

#ifndef    strongify
#if __has_feature(objc_arc)

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")

#endif
#endif


#define SCREEN_HEIGHTL [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTHL [UIScreen mainScreen].bounds.size.width

//#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define UI_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define UI_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define UI_IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
//判断iPHoneXr
#define SCREENSIZE_IS_XR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
//判断iPHoneX、iPHoneXs
#define SCREENSIZE_IS_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
#define SCREENSIZE_IS_XS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
//判断iPhoneXs Max
#define SCREENSIZE_IS_XS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)

//判断是否为 iPhoneXS  Max，iPhoneXS，iPhoneXR，iPhoneX。根据iPhoneXS Max，iPhoneXS，iPhoneXR，iPhoneX 的宽高比近似做的判断
#define KIsiPhoneHear ((int)((SCREEN_HEIGHTL/SCREEN_WIDTHL)*100) == 216)?YES:NO


//状态栏高度，iphoneX->44 其他 20
#define kStatusBar_Height [UIApplication sharedApplication].statusBarFrame.size.height
//底部安全距离 iphoneX->34 其他 0
#define kBottomSafeHeight (KIsiPhoneHear?34.0f:0.0f)

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

