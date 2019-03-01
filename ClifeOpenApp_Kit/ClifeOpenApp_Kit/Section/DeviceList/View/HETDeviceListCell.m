//
//  DeviceCell.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/8/25.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETDeviceListCell.h"

@interface HETDeviceListCell ()

///设备图片
@property (nonatomic,strong) UIImageView *deviceImageView;
///设备名称
@property (nonatomic,strong) UILabel *deviceNameLabel;
///设备mac地址
@property (nonatomic,strong) UILabel *macNameLabel;
///设备在线、离线文案
@property (nonatomic,strong) UILabel *onlineLabel;
///引导点击箭头
@property (nonatomic,strong) UIImageView *accessView;

@end

@implementation HETDeviceListCell

+ (instancetype)initWithTableView:(UITableView *)tabbleView
{
    static NSString *ID = @"kHETDeviceListCellIdentifier";
    HETDeviceListCell *cell = [tabbleView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[HETDeviceListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    self.deviceNameLabel.textColor = OPColor(@"333333");
    self.deviceNameLabel.font = OPFont(16);

    self.macNameLabel     = [[UILabel  alloc]init];
    [self.contentView addSubview:self.macNameLabel];
    self.macNameLabel.textAlignment = NSTextAlignmentLeft;
    self.macNameLabel.textColor = OPColor(@"919191");
    self.macNameLabel.font = OPFont(12);

    self.onlineLabel     = [[UILabel  alloc]init];
    [self.contentView addSubview:self.onlineLabel];
    self.onlineLabel.font = OPFont(12);
    
    self.accessView     = [[UIImageView  alloc]init];
    [self.contentView addSubview:self.accessView];
    self.accessView.image = [UIImage imageNamed:@"deviceListVc_cellArrow"];

    [self.deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25 *BasicWidth);
        make.size.mas_equalTo(CGSizeMake(40,40));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    [self.deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15 *BasicHeight);
        make.left.mas_equalTo(self.deviceImageView.mas_right).offset(25*BasicWidth);
        make.width.equalTo(@(210 *BasicWidth));
    }];

    [self.macNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(-15 *BasicHeight);
        make.left.mas_equalTo(self.deviceImageView.mas_right).offset(25*BasicWidth);
        make.width.equalTo(@(210 *BasicWidth));
    }];
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deviceNameLabel.mas_right).offset(12*BasicWidth);
        make.centerY.equalTo(self.contentView);
    }];
     
    [self.accessView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.equalTo(self.contentView).offset(-15*BasicWidth);
         make.centerY.equalTo(self.contentView.mas_centerY);
         make.height.mas_equalTo(12);
         make.width.mas_equalTo(7);
     }];
}

- (void)refreshData:(HETDevice *)device
{
    self.deviceNameLabel.text = device.deviceBrandName;
    self.macNameLabel.text = [NSString stringWithFormat:@"Mac:%@",device.macAddress];
    [self.deviceImageView sd_setImageWithURL:[NSURL URLWithString:device.productIcon]];

    if ([device.onlineStatus integerValue] == 1) {
        self.onlineLabel.text = CommonDeviceOnline;
        self.onlineLabel.textColor = OPColor(@"6dce68");
    }else{
        self.onlineLabel.text = CommonDeviceOffline;
        self.onlineLabel.textColor = OPColor(@"cacaca");
    }
}

@end
