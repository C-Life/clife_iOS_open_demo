//
//  DeviceCell.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/8/25.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETExitTableViewCell.h"

@interface HETExitTableViewCell ()
@property (nonatomic,strong) UILabel                                           *cellTitleLabel;
@end

@implementation HETExitTableViewCell
+ (instancetype)initWithTableView:(UITableView *)tabbleView
{
    static NSString *ID = @"MineCell";
    HETExitTableViewCell *cell = [tabbleView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[HETExitTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initSubviews];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    self.cellTitleLabel  = [[UILabel alloc]init];
    [self.contentView addSubview:self.cellTitleLabel];
    self.cellTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.cellTitleLabel.textColor = [UIColor colorFromHexRGB:@"ef4f4f"] ;
    self.cellTitleLabel.font = [UIFont systemFontOfSize:15];

    [self.cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
    }];

    self.cellTitleLabel.text = @"退出登录";
}

@end
