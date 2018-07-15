//
//  HZTableViewCell.m
//  ptoto
//
//  Created by huangzhenyu on 2018/7/15.
//  Copyright © 2018年 huangzhenyu. All rights reserved.
//

#import "HZTableViewCell.h"
#import "HZPhotoGroup.h"

@interface HZTableViewCell()
@property (nonatomic,strong) HZPhotoGroup *groupView;
@end

@implementation HZTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.groupView];
    }
    return self;
}

- (HZPhotoGroup *)groupView{
    if (!_groupView) {
        _groupView = [[HZPhotoGroup alloc] init];
    }
    return _groupView;
}

- (void)setUrlArray:(NSArray<NSString *> *)urlArray{
    _urlArray = urlArray;
    self.groupView.urlArray = urlArray;
}
@end
