//
//  SystemMessageCell.m
//  ClifeOpenApp_Kit
//
//  Created by miao on 2017/10/9.
//  Copyright © 2017年 het. All rights reserved.
//

#import "SystemMessageCell.h"

@interface SystemMessageCell (){
    UIView *_containerView;
    UILabel *_bigLabel;
    UILabel *_smallLabel;
    UILabel *_timeLabel;
}
@end

@implementation SystemMessageCell
+ (instancetype)initWithTableView:(UITableView *)tabbleView
{
    static NSString *ID = @"SystemMessageCell";
    SystemMessageCell *cell = [tabbleView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[SystemMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    _containerView = [UIView new];
    [self.contentView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20.f);
        make.left.equalTo(self.contentView).offset(16.f);
        make.right.equalTo(self.contentView.mas_right).offset(-16.f);
    }];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = 6.f;
    _containerView.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
    _containerView.layer.borderColor = [[UIColor colorFromHexRGB:@"919191"] colorWithAlphaComponent:0.4].CGColor;

    _bigLabel = [UILabel new];
    [_containerView addSubview:_bigLabel];
    [_bigLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView).offset(12.f);
        make.left.equalTo(_containerView).offset(12.f);
        make.height.mas_equalTo([UIFont systemFontOfSize:18.f].pointSize*1.1);
    }];
    _bigLabel.numberOfLines = 1;
    _bigLabel.textColor = [UIColor colorFromHexRGB:@"000000"];
    _bigLabel.font = [UIFont systemFontOfSize:18.f];


    _timeLabel = [UILabel new];
    [_containerView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bigLabel);
        make.left.equalTo(_bigLabel.mas_right).offset(12.f);
        make.right.lessThanOrEqualTo(_containerView.mas_right).offset(-12.f);
        make.height.mas_equalTo([UIFont systemFontOfSize:12.f].pointSize*1.1);
    }];
    [_timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    _timeLabel.numberOfLines = 1;
    _timeLabel.textColor = [[UIColor colorFromHexRGB:@"919191"] colorWithAlphaComponent:0.4];
    _timeLabel.font = [UIFont systemFontOfSize:12.f];


    _smallLabel = [UILabel new];
    [_containerView addSubview:_smallLabel];
    [_smallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bigLabel.mas_bottom).offset(10.f);
        make.left.equalTo(_containerView).offset(12.f);
        make.right.equalTo(_containerView.mas_right).offset(-12.f);
        make.bottom.equalTo(_containerView.mas_bottom).offset(-12.f);
    }];
    _smallLabel.numberOfLines = 0;
    _smallLabel.textColor = [[UIColor colorFromHexRGB:@"919191"] colorWithAlphaComponent:0.4];
    _smallLabel.font = [UIFont systemFontOfSize:15.f];
    UILongPressGestureRecognizer *recongnizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBtn:)];
    [_containerView addGestureRecognizer:recongnizer];
}

-(void)longPressBtn:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        !self.deleteBtnClick?:self.deleteBtnClick();
    }
}

@end
