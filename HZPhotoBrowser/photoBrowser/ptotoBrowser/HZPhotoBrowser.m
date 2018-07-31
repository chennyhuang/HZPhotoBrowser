//
//  HZPhotoBrowser.m
//  photobrowser
//
//  Created by huangzhenyu on 15-2-3.
//  Copyright (c) 2015年 huangzhenyu. All rights reserved.
//

#import "HZPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "HZPhotoBrowserView.h"
#import "HZPhotoBrowserConfig.h"


@interface HZPhotoBrowser()
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic,strong) UIPanGestureRecognizer *pan;
@property (nonatomic,strong) UIImageView *tempView;
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) HZPhotoBrowserView *photoBrowserView;
@property (nonatomic,assign) UIDeviceOrientation orientation;
@property (nonatomic,assign) HZPhotoBrowserStyle photoBrowserStyle;
@end
@implementation HZPhotoBrowser 
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;//开始展示图片浏览器
    UILabel *_indexLabel;
    UIButton *_saveButton;
    UIView *_contentView;
}

#pragma mark recyle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HZPhotoBrowserBackgrounColor;
        self.isFullWidthForLandScape = YES;
        self.isNeedLandscape = YES;
    }
    return self;
}

//当视图移动完成后调用
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    //处理下标可能越界的bug
    _currentImageIndex = _currentImageIndex < 0 ? 0 : _currentImageIndex;
    NSInteger count = _imageCount - 1;
    if (count > 0) {
        if (_currentImageIndex > count) {
            _currentImageIndex = 0;
        }
    }
    [self setupScrollView];
    [self setupToolbars];
    [self addGestureRecognizer:self.singleTap];
    [self addGestureRecognizer:self.doubleTap];
    [self addGestureRecognizer:self.pan];
    self.photoBrowserView = _scrollView.subviews[self.currentImageIndex];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    NSLog(@"layoutSubviews -- ");
    CGRect rect = self.bounds;
    rect.size.width += HZPhotoBrowserImageViewMargin * 2;
    _scrollView.bounds = rect;
    _scrollView.center = CGPointMake(self.bounds.size.width *0.5, self.bounds.size.height *0.5);
    NSLog(@"%@",NSStringFromCGRect(_scrollView.frame));
    CGFloat y = 0;
    __block CGFloat w = _scrollView.frame.size.width - HZPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    [_scrollView.subviews enumerateObjectsUsingBlock:^(HZPhotoBrowserView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = HZPhotoBrowserImageViewMargin + idx * (HZPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, _scrollView.frame.size.height);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    _indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    _indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 30);
    _saveButton.frame = CGRectMake(30, self.bounds.size.height - 70, 55, 30);
    _tipLabel.frame = CGRectMake((self.bounds.size.width - 150)*0.5, (self.bounds.size.height - 40)*0.5, 150, 40);
}

- (void)dealloc
{
//    NSLog(@"图片浏览器销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setSourceImagesContainerView:(UIView *)sourceImagesContainerView{
    _sourceImagesContainerView = sourceImagesContainerView;
    _imageArray = nil;
    _photoBrowserStyle = HZPhotoBrowserStyleDefault;
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    _imageCount = imageArray.count;
    _sourceImagesContainerView = nil;
    _photoBrowserStyle = HZPhotoBrowserStyleSimple;
}

#pragma mark getter settter
- (UITapGestureRecognizer *)singleTap{
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.delaysTouchesBegan = YES;
        //只能有一个手势存在
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
    }
    return _singleTap;
}

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
//        _doubleTap.numberOfTouchesRequired = 1;
    }
    return _doubleTap;
}

- (UIPanGestureRecognizer *)pan{
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    }
    return _pan;
}

- (UIImageView *)tempView{
    if (!_tempView) {
        HZPhotoBrowserView *photoBrowserView = _scrollView.subviews[self.currentImageIndex];
        UIImageView *currentImageView = photoBrowserView.imageview;
        CGFloat tempImageX = currentImageView.frame.origin.x - photoBrowserView.scrollOffset.x;
        CGFloat tempImageY = currentImageView.frame.origin.y - photoBrowserView.scrollOffset.y;
        
        CGFloat tempImageW = photoBrowserView.zoomImageSize.width;
        CGFloat tempImageH = photoBrowserView.zoomImageSize.height;
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (UIDeviceOrientationIsLandscape(orientation)) {//横屏
            
            //处理长图,图片太长会导致旋转动画飞掉
            if (tempImageH > KAppHeight) {
                tempImageH = tempImageH > (tempImageW * 1.5)? (tempImageW * 1.5):tempImageH;
                if (fabs(tempImageY) > tempImageH) {
                    tempImageY = 0;
                }
            }

        }
        
        _tempView = [[UIImageView alloc] init];
        //这边的contentmode要跟 HZPhotoGrop里面的按钮的 contentmode保持一致（防止最后出现闪动的动画）
        _tempView.contentMode = UIViewContentModeScaleAspectFill;
        _tempView.clipsToBounds = YES;
        _tempView.frame = CGRectMake(tempImageX, tempImageY, tempImageW, tempImageH);
        _tempView.image = currentImageView.image;
    }
    return _tempView;
}

//做颜色渐变动画的view，让退出动画更加柔和
- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = HZPhotoBrowserBackgrounColor;
    }
    return _coverView;
}

- (void)setPhotoBrowserView:(HZPhotoBrowserView *)photoBrowserView{
    _photoBrowserView = photoBrowserView;
    __weak typeof(self) weakSelf = self;
    _photoBrowserView.scrollViewWillEndDragging = ^(CGPoint velocity,CGPoint offset) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (((velocity.y < -2 && offset.y < 0) || offset.y < -100)) {
            [strongSelf hidePhotoBrowser];
        }
    };
}

- (void)setCurrentImageIndex:(int)currentImageIndex{
    _currentImageIndex = currentImageIndex < 0 ? 0 : currentImageIndex;
    NSInteger count0 = _imageCount;
    NSInteger count1 = _imageArray.count;
    if (count0 > 0) {
        if (_currentImageIndex > count0) {
            _currentImageIndex = 0;
        }
    }
    if (count1 > 0) {
        if (_currentImageIndex > count1) {
            _currentImageIndex = 0;
        }
    }
}

#pragma mark private methods
- (void)setupToolbars
{
    // 1. 序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
    indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    indexLabel.center = CGPointMake(kAPPWidth * 0.5, 30);
    indexLabel.layer.cornerRadius = 15;
    indexLabel.clipsToBounds = YES;
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
        _indexLabel = indexLabel;
        [self addSubview:indexLabel];
    }

    // 2.保存按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.layer.borderWidth = 0.1;
    saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
    saveButton.layer.cornerRadius = 2;
    saveButton.clipsToBounds = YES;
    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    _saveButton = saveButton;
    [self addSubview:saveButton];
}

//保存图像
- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    HZPhotoBrowserView *currentView = _scrollView.subviews[index];
    if (currentView.hasLoadedImage) {
        UIImageWriteToSavedPhotosAlbum(currentView.imageview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    } else {
        [self showTip:HZPhotoBrowserSaveImageFailText];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if (error) {
        [self showTip:HZPhotoBrowserSaveImageFailText];
    } else {
        [self showTip:HZPhotoBrowserSaveImageSuccessText];
    }
}

- (void)showTip:(NSString *)tipStr{
    if (_tipLabel) {
        [_tipLabel removeFromSuperview];
        _tipLabel = nil;
    }
    UILabel *label = [[UILabel alloc] init];
    _tipLabel = label;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = tipStr;
    [self addSubview:label];
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    for (int i = 0; i < self.imageCount; i++) {
        HZPhotoBrowserView *view = [[HZPhotoBrowserView alloc] init];
        view.isFullWidthForLandScape = self.isFullWidthForLandScape;
        view.imageview.tag = i;
        [_scrollView addSubview:view];
    }
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    HZPhotoBrowserView *view = _scrollView.subviews[index];
    if (view.beginLoadingImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [view setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        view.imageview.image = [self placeholderImageForIndex:index];
    }
    view.beginLoadingImage = YES;
}

- (void)onDeviceOrientationChangeWithObserver
{
    [self onDeviceOrientationChange];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)onDeviceOrientationChange
{
    if (!self.isNeedLandscape) {
        return;
    }
    
    HZPhotoBrowserView *currentView = _scrollView.subviews[self.currentImageIndex];
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    self.orientation = orientation;
    if (UIDeviceOrientationIsLandscape(orientation)) {
        if (self.bounds.size.width < self.bounds.size.height) {
            [currentView.scrollview setZoomScale:1.0 animated:YES];//还原
        }
        [UIView animateWithDuration:kRotateAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.transform = (orientation==UIDeviceOrientationLandscapeRight)?CGAffineTransformMakeRotation(M_PI*1.5):CGAffineTransformMakeRotation(M_PI/2);
            if (iPhoneX) {
                self.center = [UIApplication sharedApplication].keyWindow.center;
                self.bounds = CGRectMake(0, 0,  KAppHeight - kStatusBar_Height - kBottomSafeHeight, kAPPWidth);
            } else {
                self.bounds = CGRectMake(0, 0, KAppHeight, kAPPWidth);
            }
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
        
        }];
        
    }else if (orientation==UIDeviceOrientationPortrait){
        if (self.bounds.size.width > self.bounds.size.height) {
            [currentView.scrollview setZoomScale:1.0 animated:YES];//还原
        }
        [UIView animateWithDuration:kRotateAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.transform = (orientation==UIDeviceOrientationPortrait)?CGAffineTransformIdentity:CGAffineTransformMakeRotation(M_PI);
            if (iPhoneX) {
                self.bounds = CGRectMake(0, 0, kAPPWidth, KAppHeight - kStatusBar_Height - kBottomSafeHeight);
            } else {
                self.bounds = CGRectMake(0, 0, kAPPWidth, KAppHeight);
            }
            
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

- (void)showFirstImage
{
    self.userInteractionEnabled = NO;
    if (_photoBrowserStyle == HZPhotoBrowserStyleDefault) {
        UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
        CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
        UIImageView *tempView = [[UIImageView alloc] init];
        tempView.frame = rect;
        tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
        [self addSubview:tempView];
        tempView.contentMode = UIViewContentModeScaleAspectFit;
        
        CGFloat placeImageSizeW = tempView.image.size.width;
        CGFloat placeImageSizeH = tempView.image.size.height;
        CGRect targetTemp;
        CGFloat selfW = self.frame.size.width;
        CGFloat selfH = self.frame.size.height;
        
        CGFloat placeHolderH = (placeImageSizeH * selfW)/placeImageSizeW;
        if (placeHolderH <= selfH) {
            targetTemp = CGRectMake(0, (selfH - placeHolderH) * 0.5 , selfW, placeHolderH);
        } else {//图片高度>屏幕高度
            targetTemp = CGRectMake(0, 0, selfW, placeHolderH);
        }
        //先隐藏scrollview
        _scrollView.hidden = YES;
        _indexLabel.hidden = YES;
        _saveButton.hidden = YES;
        [UIView animateWithDuration:HZPhotoBrowserShowImageAnimationDuration animations:^{
            //将点击的临时imageview动画放大到和目标imageview一样大
            tempView.frame = targetTemp;
        } completion:^(BOOL finished) {
            //动画完成后，删除临时imageview，让目标imageview显示
            _hasShowedFistView = YES;
            [tempView removeFromSuperview];
            _scrollView.hidden = NO;
            _indexLabel.hidden = NO;
            _saveButton.hidden = NO;
            self.userInteractionEnabled = YES;
        }];
    } else {
        _photoBrowserView.alpha = 0;
        _contentView.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            //将点击的临时imageview动画放大到和目标imageview一样大
            _photoBrowserView.alpha = 1;
            _contentView.alpha = 1;
        } completion:^(BOOL finished) {
            _hasShowedFistView = YES;
            self.userInteractionEnabled = YES;
        }];
    }
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if (_photoBrowserStyle == HZPhotoBrowserStyleDefault) {
        if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
            return [self.delegate photoBrowser:self placeholderImageForIndex:index];
        }
    } else {
        return nil;
    }
    
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if (_photoBrowserStyle == HZPhotoBrowserStyleDefault) {
        if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
            return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
        }
    } else {
        return [NSURL URLWithString:_imageArray[index]];
    }
    return nil;
}


- (void)hidePhotoBrowser
{
    [self prepareForHide];
    [self hideAnimation];
}

- (void)hideAnimation{
    self.userInteractionEnabled = NO;
    CGRect targetTemp;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    UIView *sourceView = [self getSourceView];
    if (!sourceView) {
        targetTemp = CGRectMake(window.center.x, window.center.y, 0, 0);
    }
    if (_photoBrowserStyle == HZPhotoBrowserStyleDefault) {
        UIView *sourceView = [self getSourceView];
       targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    } else {
        //默认回到屏幕中央
        targetTemp = CGRectMake(window.center.x, window.center.y, 0, 0);
    }
    self.window.windowLevel = UIWindowLevelNormal;//显示状态栏
    [UIView animateWithDuration:HZPhotoBrowserHideImageAnimationDuration animations:^{
        if (_photoBrowserStyle == HZPhotoBrowserStyleDefault) {
            _tempView.transform = CGAffineTransformInvert(self.transform);
        }
        _coverView.alpha = 0;
        _tempView.frame = targetTemp;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_tempView removeFromSuperview];
        [_contentView removeFromSuperview];
        _tempView = nil;
        _contentView = nil;
        sourceView.hidden = NO;
    }];
}

- (UIView *)getSourceView{
    if (_currentImageIndex <= self.sourceImagesContainerView.subviews.count - 1) {
        UIView *sourceView = self.sourceImagesContainerView.subviews[_currentImageIndex];
        return sourceView;
    }
    return nil;
}

- (void)prepareForHide{
    [_contentView insertSubview:self.coverView belowSubview:self];
    _saveButton.hidden = YES;
    _indexLabel.hidden = YES;
    [self addSubview:self.tempView];
    _photoBrowserView.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    _contentView.backgroundColor = [UIColor clearColor];
    UIView *view = [self getSourceView];
    view.hidden = YES;
}

- (void)bounceToOrigin{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:HZPhotoBrowserHideImageAnimationDuration animations:^{
        self.tempView.transform = CGAffineTransformIdentity;
        _coverView.alpha = 1;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        _saveButton.hidden = NO;
        _indexLabel.hidden = NO;
        [_tempView removeFromSuperview];
        [_coverView removeFromSuperview];
        _tempView = nil;
        _coverView = nil;
        _photoBrowserView.hidden = NO;
        self.backgroundColor = HZPhotoBrowserBackgrounColor;
        _contentView.backgroundColor = HZPhotoBrowserBackgrounColor;
        UIView *view = [self getSourceView];
        view.hidden = NO;
    }];
}

#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    long left = index - 1;
    long right = index + 1;
    left = left>0?left : 0;
    right = right>self.imageCount?self.imageCount:right;
    
    for (long i = left; i < right; i++) {
         [self setupImageOfImageViewForIndex:i];
    }
}

//scrollview结束滚动调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int autualIndex = scrollView.contentOffset.x  / _scrollView.bounds.size.width;
    //设置当前下标
    self.currentImageIndex = autualIndex;
    self.photoBrowserView = _scrollView.subviews[self.currentImageIndex];
    
    //将不是当前imageview的缩放全部还原 (这个方法有些冗余，后期可以改进)
    for (HZPhotoBrowserView *view in _scrollView.subviews) {
        if (view.imageview.tag != autualIndex) {
                view.scrollview.zoomScale = 1.0;
        }
    }
}

#pragma mark - tap
#pragma mark 单击
- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    [self hidePhotoBrowser];
}

#pragma mark 双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    HZPhotoBrowserView *view = _scrollView.subviews[self.currentImageIndex];
    CGPoint touchPoint = [recognizer locationInView:self];
    if (view.scrollview.zoomScale <= 1.0) {
        CGFloat scaleX = touchPoint.x + view.scrollview.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + view.scrollview.contentOffset.y;//需要放大的图片的Y点
        [view.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
    } else {
        [view.scrollview setZoomScale:1.0 animated:YES]; //还原
    }
}

#pragma mark 长按
- (void)didPan:(UIPanGestureRecognizer *)panGesture {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(orientation)) {//横屏不允许拉动图片
        return;
    }
    //transPoint : 手指在视图上移动的位置（x,y）向下和向右为正，向上和向左为负。
    //locationPoint ： 手指在视图上的位置（x,y）就是手指在视图本身坐标系的位置。
    //velocity： 手指在视图上移动的速度（x,y）, 正负也是代表方向。
    CGPoint transPoint = [panGesture translationInView:self];
//    CGPoint locationPoint = [panGesture locationInView:self];
    CGPoint velocity = [panGesture velocityInView:self];//速度
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self prepareForHide];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            _saveButton.hidden = YES;
            _indexLabel.hidden = YES;
            double delt = 1 - fabs(transPoint.y) / self.frame.size.height;
            delt = MAX(delt, 0);
            double s = MAX(delt, 0.5);
            CGAffineTransform translation = CGAffineTransformMakeTranslation(transPoint.x/s, transPoint.y/s);
            CGAffineTransform scale = CGAffineTransformMakeScale(s, s);
            self.tempView.transform = CGAffineTransformConcat(translation, scale);
            self.coverView.alpha = delt;
        }
            break;
        case UIGestureRecognizerStateEnded:
//        case UIGestureRecognizerStateCancelled:
        {
            if (fabs(transPoint.y) > 220 || fabs(velocity.y) > 500) {//退出图片浏览器
                [self hideAnimation];
            } else {//回到原来的位置
                [self bounceToOrigin];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark public methods
- (void)show
{
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = HZPhotoBrowserBackgrounColor;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _contentView.center = window.center;
    _contentView.bounds = window.bounds;

    if (iPhoneX) {
        self.frame = CGRectMake(0, kStatusBar_Height,kAPPWidth,KAppHeight - kStatusBar_Height - kBottomSafeHeight);
    } else {
        self.frame = _contentView.bounds;
    }
    window.windowLevel = UIWindowLevelStatusBar+10.0f;//隐藏状态栏
    [_contentView addSubview:self];
    
    [window addSubview:_contentView];
    
    [self performSelector:@selector(onDeviceOrientationChangeWithObserver) withObject:nil afterDelay:HZPhotoBrowserShowImageAnimationDuration + 0.2];
}

@end
