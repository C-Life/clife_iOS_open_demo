//
//  NetWorkErrorEmptyView.m
//  ClifeOpenApp_Kit
//
//  Created by Miao on 2018/7/27.
//  Copyright © 2018年 het. All rights reserved.
//

#import "NetWorkErrorEmptyView.h"

@interface NetWorkErrorEmptyView ()
@property (nonatomic,strong) UIImageView                                           *icon;
@property (nonatomic,strong) UILabel                                               *label;
@property (nonatomic,strong) UIButton                                              *btn;
@end

@implementation NetWorkErrorEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
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
    
    [self addSubview:self.btn];
    // 未登录按钮 距离 未登录文案 底部 的距离
    CGFloat marginH_btn = 29 *BasicHeight;
    CGFloat loginBtnW = 120 *BasicWidth;
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.label.mas_bottom).offset(marginH_btn);
        make.width.equalTo(@(loginBtnW));
        make.height.equalTo(@(36*BasicHeight));
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
        _label.text = @"网络异常，请重试";
        _label.textColor = [UIColor colorFromHexRGB:@"b9b9b9"];
        _label.font = OPFont(17);
    }
    return _label;
}

- (UIButton *)btn
{
    if (!_btn) {
        _btn = [UIButton new];
        [_btn setTitle:@"重试刷新" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor colorFromHexRGB:@"3285ff"] forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor clearColor];
        _btn.layer.borderColor = [UIColor colorFromHexRGB:@"3285ff"].CGColor;
        _btn.layer.borderWidth = 0.5;
        _btn.layer.cornerRadius = 5;
        _btn.clipsToBounds = YES;
        _btn.titleLabel.font = OPFont(16);
        [_btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(0, 300);
}

- (void)btnAction{
    if (self.btnBlock) {
        self.btnBlock();
    }
}
@end
