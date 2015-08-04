//
//  CustomCell.h
//  dddddddddd
//
//  Created by huangzhenyu on 15/8/4.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *introduce;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContentHeight;
@property (weak, nonatomic) IBOutlet UIView *imageContentView;
@property (assign, nonatomic) NSInteger srcCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceWidth;

@end
