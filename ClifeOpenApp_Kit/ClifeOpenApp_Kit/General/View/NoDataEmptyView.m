//
//  NoDataEmptyView.m
//  ClifeOpenApp_Kit
//
//  Created by Miao on 2018/7/26.
//  Copyright © 2018年 het. All rights reserved.
//

#import "NoDataEmptyView.h"

@interface NoDataEmptyView ()
@property (nonatomic,strong) UIImageView                                           *icon;
@property (nonatomic,strong) UILabel                                               *label;
@end

@implementation NoDataEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(0, 300);
}

- (void)createSubView
{
    // 2.未登录提示图片、文字，登录按钮
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@(118/2));
        make.height.equalTo(@(118/2));
    }];
    
    [self addSubview:self.label];
    // 未登录文案 距离 未登录图片 底部 的距离
    CGFloat marginH_label = 18 *BasicHeight;
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.icon.mas_bottom).offset(marginH_label);
    }];
}

- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.image = [UIImage imageNamed:@"deviceListVC_unlogin"];
    }
    return _icon;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [UILabel new];
        _label.text = AddDevcieTipStr;
        _label.textColor = [UIColor colorFromHexRGB:@"b9b9b9"];
        _label.font = OPFont(17);
    }
    return _label;
}

@end
