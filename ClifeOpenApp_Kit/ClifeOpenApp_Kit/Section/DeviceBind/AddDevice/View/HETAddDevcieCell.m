//
//  AddDevcieCell.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/9/1.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETAddDevcieCell.h"

@interface HETAddDevcieCell ()
@property (nonatomic,strong) UIImageView                                       *deviceImageView;
@property (nonatomic,strong) UILabel                                           *deviceNameLabel;
@end
@implementation HETAddDevcieCell

+ (instancetype)initWithTableView:(UITableView *)tabbleView
{
    static NSString *ID = @"AddDevcieCell";
    HETAddDevcieCell *cell = [tabbleView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[HETAddDevcieCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    self.deviceNameLabel.textColor = [UIColor blackColor] ;
    self.deviceNameLabel.font = [UIFont systemFontOfSize:17];


    [self.deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(13 *BasicWidth);
        make.size.mas_equalTo(CGSizeMake(36 *BasicHeight, 36 *BasicHeight));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.deviceImageView.mas_right).offset(8 *BasicWidth);
    }];
}

- (void)refreshMainType:(NSDictionary *)deviceDict
{

    NSString *deviceTypeIcon = [deviceDict valueForKey:@"deviceTypeIcon"];
    NSString *deviceTypeName = [deviceDict valueForKey:@"deviceTypeName"];
    [self.deviceImageView sd_setImageWithURL:[NSURL URLWithString:deviceTypeIcon]];
    self.deviceNameLabel.text = deviceTypeName;
}

- (void)refreshSubType:(NSDictionary *)deviceDict
{
    NSString *deviceTypeIcon = [deviceDict valueForKey:@"deviceIcon"];
    NSString *deviceTypeName = [deviceDict valueForKey:@"deviceSubtypeName"];
    [self.deviceImageView sd_setImageWithURL:[NSURL URLWithString:deviceTypeIcon]];
    self.deviceNameLabel.text = deviceTypeName;
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
