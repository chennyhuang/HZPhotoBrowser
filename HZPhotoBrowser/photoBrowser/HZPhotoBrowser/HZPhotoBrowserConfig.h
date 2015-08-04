//
//  HZPhotoBrowserConfig.h
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

typedef enum {
    HZIndicatorViewModeLoopDiagram, // 环形
    HZIndicatorViewModePieDiagram // 饼型
} HZIndicatorViewMode;

#define kAPPWidth [UIScreen mainScreen].bounds.size.width
#define kAppHeight [UIScreen mainScreen].bounds.size.height

//图片缩放比例
#define kMinZoomScale 0.6f
#define kMaxZoomScale 2.0f

//是否支持横屏
#define shouldSupportLandscape YES
#define kIsFullWidthForLandScape YES //是否在横屏的时候直接满宽度，而不是满高度，一般是在有长图需求的时候设置为YES

#define kIndicatorViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
#define kPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:1]

// 图片间的间距
#define kPhotoBrowserImageViewMargin 10

// 图片下载进度指示器内部控件间的间距
#define kIndicatorViewItemMargin 10

// browser消失的动画时长
#define kPhotoBrowserHideDuration 0.4f

// browser出现的动画时长
#define kPhotoBrowserShowDuration 0.4f
