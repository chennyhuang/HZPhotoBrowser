//
//  HZRootViewController.m
//  ptoto
//
//  Created by huangzhenyu on 2018/7/12.
//  Copyright © 2018年 huangzhenyu. All rights reserved.
//

#import "HZRootViewController.h"
#import "HZTableViewController.h"
#import "HZPhotoBrowser.h"

@interface HZRootViewController ()

@end

@implementation HZRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//方式一，需要自定义九图控件，自定义cell
- (IBAction)style1:(id)sender {
    HZTableViewController *tabvc = [[HZTableViewController alloc] init];
    [self.navigationController pushViewController:tabvc animated:YES];
}

//直接传url列表
- (IBAction)style2:(id)sender {
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = YES;

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
    browser.currentImageIndex = 3;
    [browser show];
}
@end
