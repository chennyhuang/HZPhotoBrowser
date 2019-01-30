//
//  HZWaitingView.m
//  HZPhotoBrowser
//
//  Created by huangzhenyu on 15-2-6.
//  Copyright (c) 2015年 huangzhenyu. All rights reserved.
//

#import "HZWaitingView.h"
@implementation HZWaitingView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HZWaitingViewBackgroundColor;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
    if (progress >= 1) {
        [self removeFromSuperview];
    }
}

- (void)setFrame:(CGRect)frame
{
    //设置背景图为圆
    frame.size.width = 50;
    frame.size.height = 50;
    self.layer.cornerRadius = 25;
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor whiteColor] set];
    switch (kWaitingViewProgressMode) {
        case HZWaitingViewModePieDiagram:
            [self drawPipe:rect];
            break;
        default:
            [self drawCircle:rect];
            break;
    }
}

//画圆
- (void)drawCircle:(CGRect)rect{
    CGFloat radius = rect.size.width / 2;
    CGPoint center  = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat end = -M_PI_2 + self.progress * M_PI * 2;
    CGFloat lineW = 3;
    UIBezierPath *bezier = [UIBezierPath bezierPathWithArcCenter:center radius:radius-lineW startAngle:-M_PI_2 endAngle:end clockwise:YES];
    bezier.lineWidth = lineW;
    bezier.lineCapStyle = kCGLineCapRound;
    UIColor *whiteColor = [UIColor whiteColor];
    [whiteColor set];
    [bezier stroke];
}

- (void)drawPipe:(CGRect)rect{
    CGFloat radius = rect.size.width / 2;
    CGPoint center  = CGPointMake(rect.size.width/2, rect.size.height/2);
    UIColor *whiteColor = [UIColor whiteColor];
    
    //cornerRadius：圆角半径（绘制矩形的左上角开始，也就是0，5）
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    circlePath.lineWidth = 2;
    [whiteColor set];
    [circlePath stroke];
    
    
    CGFloat end = -M_PI_2 + self.progress * M_PI * 2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius - 4 startAngle:-M_PI_2 endAngle:end clockwise:YES];
    
    [whiteColor set];
    //添加一根线到圆心
    [path addLineToPoint:center];
    //关闭路径，是从终点到起点
    [path closePath];
    [path stroke];
    
    //使用填充，默认就会自动关闭路径，（终点到起点）
    [path fill];
}

@end
