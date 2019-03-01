//
//  DeviceDetailsCell.m
//  ClifeOpenApp_Kit
//
//  Created by Miao on 2018/5/17.
//  Copyright © 2018年 het. All rights reserved.
//

#import "DeviceDetailsCell.h"
@interface DeviceDetailsCell ()
@property (nonatomic,strong) UIImageView                                       *deviceImageView;
@property (nonatomic,strong) UILabel                                           *deviceNameLabel;
@property (nonatomic,strong) UILabel                                           *macNameLabel;
@property (nonatomic,strong) UILabel                                           *modelLabel;
@end

@implementation DeviceDetailsCell
+ (instancetype)initWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"DeviceDetailsCell";
    DeviceDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[DeviceDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    self.deviceNameLabel.font = [UIFont systemFontOfSize:15];
    
    self.macNameLabel     = [[UILabel  alloc]init];
    [self.contentView addSubview:self.macNameLabel];
    self.macNameLabel.textAlignment = NSTextAlignmentLeft;
    self.macNameLabel.textColor = [UIColor colorFromHexRGB:@"919191"];
    self.macNameLabel.font = [UIFont systemFontOfSize:12];
    
    self.modelLabel     = [[UILabel  alloc]init];
    [self.contentView addSubview:self.modelLabel];
    self.modelLabel.textColor = [UIColor colorFromHexRGB:@"919191"];
    self.modelLabel.font = [UIFont systemFontOfSize:12];
    
    [self.deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25 *BasicWidth);
        make.size.mas_equalTo(CGSizeMake(40,40));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5 *BasicHeight);
        make.left.mas_equalTo(self.deviceImageView.mas_right).offset(25*BasicWidth);
        make.width.equalTo(@(210 *BasicWidth));
    }];
    
    [self.macNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deviceNameLabel.mas_bottom).offset(8 *BasicHeight);
        make.left.mas_equalTo(self.deviceImageView.mas_right).offset(25*BasicWidth);
        make.right.equalTo(self.contentView);
    }];
    [self.modelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deviceImageView.mas_right).offset(25*BasicWidth);
        make.top.equalTo(self.macNameLabel.mas_bottom).offset(8 *BasicHeight);
    }];
}

- (void)refreshData:(HETDevice *)device
{
    self.deviceNameLabel.text = device.deviceBrandName;
    self.macNameLabel.text = [NSString stringWithFormat:@"Mac:%@",device.macAddress];
    [self.deviceImageView sd_setImageWithURL:[NSURL URLWithString:device.productIcon]];
    self.modelLabel.text = device.productCode;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
