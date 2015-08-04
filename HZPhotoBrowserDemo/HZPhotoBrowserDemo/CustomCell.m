//
//  CustomCell.m
//  dddddddddd
//
//  Created by huangzhenyu on 15/8/4.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "CustomCell.h"
#define DEVICE_IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height == 480)
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define DEVICE_IS_IPHONE6 ([[UIScreen mainScreen] bounds].size.width == 375)
#define DEVICE_IS_IPHONE6plus ([[UIScreen mainScreen] bounds].size.width == 414)
@implementation CustomCell

- (void)awakeFromNib {
    self.icon.layer.cornerRadius = 30;
    self.icon.clipsToBounds = YES;
    
    if (DEVICE_IS_IPHONE6) {
        self.introduceWidth.constant = 340;
    } else if (DEVICE_IS_IPHONE6plus) {
        self.introduceWidth.constant = 360;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
