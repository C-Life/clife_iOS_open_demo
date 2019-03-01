//
//  BleTableViewCell.m
//  ClifeOpenApp_Kit
//
//  Created by miao on 2017/9/19.
//  Copyright © 2017年 het. All rights reserved.
//

#import "BleTableViewCell.h"

@interface BleTableViewCell ()
@property (nonatomic,strong) UIImageView                                       *deviceImageView;
@property (nonatomic,strong) UILabel                                           *deviceNameLabel;
@property (nonatomic,strong) UILabel                                           *macNameLabel;
@end

@implementation BleTableViewCell

+ (instancetype)initWithTableView:(UITableView *)tabbleView
{
    static NSString *ID = @"BleCell";
    BleTableViewCell *cell = [tabbleView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[BleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
}

- (void)refreshData:(CBPeripheral *)cbp productIcon:(NSString *)productIcon productName:(NSString*)productName
{
    self.deviceNameLabel.text = productName;
    self.macNameLabel.text = [NSString stringWithFormat:@"Mac:%@",cbp.mac];
    [self.deviceImageView sd_setImageWithURL:[NSURL URLWithString:productIcon]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end