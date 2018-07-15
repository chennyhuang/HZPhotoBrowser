//
//  HZTableViewController.m
//  HZPhotoBrowser
//
//  Created by huangzhenyu on 15-2-4.
//  Copyright (c) 2015年 huangzhenyu. All rights reserved.
//

#import "HZTableViewController.h"
#import "HZPhotoGroup.h"
#import "HZTableViewCell.h"

static NSString *ID = @"photo";
@interface HZTableViewController ()
@property (nonatomic, strong) NSArray *srcStringArray;
@end

@implementation HZTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 380;
    [self.tableView registerClass:[HZTableViewCell class] forCellReuseIdentifier:ID];
    self.title = @"图片浏览器";
    
    _srcStringArray = @[
                        @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                        @"http://ww4.sinaimg.cn/thumbnail/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                        @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
                        @"http://ww4.sinaimg.cn/thumbnail/677febf5gw1erma1g5xd0j20k0esa7wj.jpg"
                        ];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[HZTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.urlArray = _srcStringArray;
    return cell;
}
@end
