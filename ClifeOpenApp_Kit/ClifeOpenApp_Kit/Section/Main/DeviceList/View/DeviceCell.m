//
//  DeviceCell.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/8/25.
//  Copyright © 2017年 het. All rights reserved.
//

#import "DeviceCell.h"

@interface DeviceCell ()
@property (nonatomic,strong) UIImageView                                       *deviceImageView;
@property (nonatomic,strong) UILabel                                           *deviceNameLabel;
@property (nonatomic,strong) UILabel                                           *macNameLabel;
@property (nonatomic,strong) UILabel                                           *onlineLabel;
@end

@implementation DeviceCell
+ (instancetype)initWithTableView:(UITableView *)tabbleView
{
    static NSString *ID = @"deviceCell";
    DeviceCell *cell = [tabbleView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[DeviceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    self.deviceImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.deviceImageView];

    self.deviceNameLabel  = [[UILabel alloc]init];
    [self.contentView addSubview:self.deviceNameLabel];
    self.deviceNameLabel.textAlignment = NSTextAlignmentLeft;
    self.deviceNameLabel.textColor = [UIColor colorFromHexRGB:@"000000"] ;
    self.deviceNameLabel.font = [UIFont systemFontOfSize:17];

    self.macNameLabel     = [[UILabel  alloc]init];
    [self.contentView addSubview:self.macNameLabel];
    self.macNameLabel.textAlignment = NSTextAlignmentLeft;
    self.macNameLabel.textColor = [UIColor colorFromHexRGB:@"919191"];
    self.macNameLabel.font = [UIFont systemFontOfSize:15];

    self.onlineLabel     = [[UILabel  alloc]init];
    [self.contentView addSubview:self.onlineLabel];
    self.onlineLabel.font = [UIFont systemFontOfSize:15];


    [self.deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25 *BasicWidth);
        make.size.mas_equalTo(CGSizeMake(40,40));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15 *BasicHeight);
        make.left.mas_equalTo(self.deviceImageView.mas_right).offset(25*BasicWidth);
        make.right.equalTo(self.contentView);
    }];
    [self.macNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(-15 *BasicHeight);
        make.left.mas_equalTo(self.deviceImageView.mas_right).offset(25*BasicWidth);
        make.right.equalTo(self.contentView);
    }];
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-29*BasicWidth);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)refreshData:(HETDevice *)device
{
    self.deviceNameLabel.text = device.deviceBrandName;
    self.macNameLabel.text = [NSString stringWithFormat:@"Mac:%@",device.macAddress];
    [self.deviceImageView sd_setImageWithURL:[NSURL URLWithString:device.productIcon]];

    if ([device.onlineStatus integerValue] == 1) {
        self.onlineLabel.text = CommonDeviceOnline;
        self.onlineLabel.textColor = [UIColor colorFromHexRGB:@"6dce68"];
    }else{
        self.onlineLabel.text = CommonDeviceOffline;
        self.onlineLabel.textColor = [UIColor colorFromHexRGB:@"cacaca"];
    }
}

@end
