//
//  ViewController.m
//  dddddddddd
//
//  Created by huangzhenyu on 15/8/4.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "personInfo.h"
#import "HZIndicatorView.h"
#import "HZImagesGroupView.h"
#import "HZPhotoItemModel.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) personInfo *info;
@property (nonatomic,strong) NSMutableArray *modelArray;
@property (nonatomic,strong) CustomCell *cell;
@end

@implementation ViewController

- (NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    personInfo *p0 = [[personInfo alloc] init];
    p0.string = @"000";
    p0.introStr = @"00000000000000000000";
//    p0.srcStringArray = @[];
    [self.modelArray addObject:p0];
    
    personInfo *p1 = [[personInfo alloc] init];
    p1.string = @"11111111";
    p1.introStr = @"111111111111111111111111111111111111111111111111111111111111111111111111";
    p1.srcStringArray = @[
                          @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg"
                            ];
    [self.modelArray addObject:p1];
    
    personInfo *p2 = [[personInfo alloc] init];
    p2.string = @"22222222";
    p2.introStr = @"22222222222222222222222222222222222222222222222222222222222222222222222222222222";
    p2.srcStringArray = @[
                          @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                          @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif"
                          ];
    [self.modelArray addObject:p2];
    
    personInfo *p3 = [[personInfo alloc] init];
    p3.string = @"3333333";
    p3.introStr = @"3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333";
    p3.srcStringArray = @[
                          @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                          @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                          @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg"
                          ];
    [self.modelArray addObject:p3];
    
    personInfo *p4 = [[personInfo alloc] init];
    p4.string = @"44444444";
    p4.introStr = @"44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444";
    p4.srcStringArray = @[
                          @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                          @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                          @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                          @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg"
                          ];
    [self.modelArray addObject:p4];
    
    personInfo *p5 = [[personInfo alloc] init];
    p5.string = @"55555555";
    p5.introStr = @"55555555555555555555555555555555";
    p5.srcStringArray = @[
                          @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                          @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                          @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                          @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                          @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg"
                          ];
    [self.modelArray addObject:p5];
    
    personInfo *p6 = [[personInfo alloc] init];
    p6.string = @"6666666666";
    p6.introStr = @"666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666";
    p6.srcStringArray = @[
                          @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                          @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                          @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                          @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                          @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
                          @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg"
                          ];
    [self.modelArray addObject:p6];
    
    
    personInfo *p7 = [[personInfo alloc] init];
    p7.string = @"77";
    p7.introStr = @"7777777";
    p7.srcStringArray = @[
                          @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                          @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                          @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                          @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                          @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
                          @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                          @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"
                          ];
    [self.modelArray addObject:p7];
    
    personInfo *p8 = [[personInfo alloc] init];
    p8.string = @"8888";
    p8.introStr = @"888888888888888888888888888888";
    p8.srcStringArray = @[
                          @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                          @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                          @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                          @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                          @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
                          @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                          @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
                          @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg"
                          ];
    [self.modelArray addObject:p8];
    
    personInfo *p9 = [[personInfo alloc] init];
    p9.string = @"99999999999999999999";
    p9.introStr = @"999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999";
    p9.srcStringArray = @[
                          @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                          @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                          @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                          @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                          @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
                          @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                          @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
                          @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
                          @"http://ww4.sinaimg.cn/thumbnail/677febf5gw1erma1g5xd0j20k0esa7wj.jpg"
                          ];
    [self.modelArray addObject:p9];
}

- (CustomCell *) cellForIndexPath:(NSIndexPath *) indexPath
{
    CustomCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"cell"];
    personInfo *model = [self.modelArray objectAtIndex:indexPath.row];
    
//    cell.icon.image = [UIImage imageNamed:@"photo.jpg"];
    //传入introduce.text用于计算高度
//    cell.label.text = model.string;
    cell.introduce.text = model.introStr;
    cell.srcCount = model.srcStringArray.count;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"cell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    if (cell.imageContentView.subviews.count>0) {
        HZImagesGroupView *imageGroupView = cell.imageContentView.subviews[0];
        [imageGroupView removeFromSuperview];
    }
    
    
    personInfo *model = self.modelArray[indexPath.row];
    
    cell.icon.image = [UIImage imageNamed:@"photo.jpg"];
    cell.label.text = model.string;
    cell.introduce.text = model.introStr;
    
    HZImagesGroupView *imagesGroupView = [[HZImagesGroupView alloc] init];
    NSMutableArray *temp = [NSMutableArray array];
    [model.srcStringArray enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
        HZPhotoItemModel *item = [[HZPhotoItemModel alloc] init];
        item.thumbnail_pic = src;
        [temp addObject:item];
    }];

    imagesGroupView.photoItemArray = [temp copy];
    cell.imageContentHeight.constant = imagesGroupView.bounds.size.height;
    
    [cell.imageContentView addSubview:imagesGroupView];
    
    
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [self cellForIndexPath:indexPath];
//    [cell.introduce setPreferredMaxLayoutWidth:320];
    
    NSInteger count = cell.srcCount;
    CGFloat imageContentHeight;
    if (count == 0) {
        imageContentHeight = 2;
    } else if (count>0 && count <= 3) {
        imageContentHeight = 95;
    } else if (count>3 && count <= 6){
        imageContentHeight = 190;
    } else if (count >6){
        imageContentHeight = 285;
    }
    //设置存放图片集的view的高度
    cell.imageContentHeight.constant = imageContentHeight;
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
