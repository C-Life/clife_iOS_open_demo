//
//  UnLoginEmptyView.m
//  ClifeOpenApp_Kit
//
//  Created by Miao on 2018/7/26.
//  Copyright © 2018年 het. All rights reserved.
//

#import "HETLoginEmptyView.h"
#import "HETChangNetWorkState.h"

@interface HETLoginEmptyView()
/** 提示未登录图片 **/
@property (nonatomic,strong) UIImageView                                           *unLoginIcon;
/** 提示未登录文字 **/
@property (nonatomic,strong) UILabel                                               *unLoginLabel;
/** 登录按钮 **/
@property (nonatomic,strong) UIButton                                              *loginBtn;
/** 切换appid按钮(头像区域) **/
@property (nonatomic,strong) UIButton                                              *changAppidBtn;
/** 改变网络环境，登录界面 **/
@property (nonatomic,strong) HETChangNetWorkState                                  *settingView;
@property (nonatomic,copy) NSString                                                *appid;
@property (nonatomic,copy) NSString                                                *appSectet;
@end

@implementation HETLoginEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
        
        self.appid = [HETAppConfigTool getAppId];
        self.appSectet = [HETAppConfigTool getAppSecret];
        }
    return self;
}

- (void)createSubView
{
    // 未登录提示图片、文字，登录按钮
    [self addSubview:self.changAppidBtn];
    // 未登录按钮 距离 未登录文案 底部 的距离
    [self.changAppidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).mas_offset(50);
        make.width.equalTo(@(118/2));
        make.height.equalTo(@(118/2));
    }];
    
    [self addSubview:self.unLoginLabel];
    // 未登录文案 距离 未登录图片 底部 的距离
    CGFloat marginH_label = 18 *BasicHeight;
    [self.unLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.changAppidBtn.mas_bottom).offset(marginH_label);
    }];
    
    [self addSubview:self.loginBtn];
    // 未登录按钮 距离 未登录文案 底部 的距离
    CGFloat marginH_btn = 29 *BasicHeight;
    CGFloat loginBtnW = 120 *BasicWidth;
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.unLoginLabel.mas_bottom).offset(marginH_btn);
        make.width.equalTo(@(loginBtnW));
        make.height.equalTo(@(36*BasicHeight));
    }];
    
    
    [self addSubview:self.settingView];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(100);
        make.width.equalTo(@(ScreenWidth -100));
        make.height.equalTo(@(80));
    }];
}

- (UILabel *)unLoginLabel
{
    if (!_unLoginLabel) {
        _unLoginLabel = [UILabel new];
        _unLoginLabel.text = UnLoginLabelStr;
        _unLoginLabel.textColor = [UIColor colorFromHexRGB:@"b9b9b9"];
        _unLoginLabel.font = OPFont(17);
    }
    return _unLoginLabel;
}

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton new];
        [_loginBtn setTitle:LoginBtnTitle forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor colorFromHexRGB:@"3285ff"] forState:UIControlStateNormal];
        _loginBtn.backgroundColor = [UIColor clearColor];
        _loginBtn.layer.borderColor = [UIColor colorFromHexRGB:@"3285ff"].CGColor;
        _loginBtn.layer.borderWidth = 0.5;
        _loginBtn.layer.cornerRadius = 5;
        _loginBtn.clipsToBounds = YES;
        _loginBtn.titleLabel.font = OPFont(16);
        [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)changAppidBtn
{
    if (!_changAppidBtn) {
        _changAppidBtn = [UIButton new];
        [_changAppidBtn setImage:[UIImage imageNamed:@"deviceListVC_unlogin"] forState:UIControlStateNormal];
        [_changAppidBtn addTarget:self action:@selector(changAppid) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changAppidBtn;
}

- (HETChangNetWorkState *)settingView
{
    if (!_settingView) {
        _settingView = [HETChangNetWorkState new];
        WEAKSELF
        _settingView.changeBlock = ^{
            STRONGSELF
            if (strongSelf.netWorkBlock) {
                strongSelf.netWorkBlock();
            }
        };
    }
    return _settingView;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(0, 400);
}

- (void)loginAction{
    if (self.loginBlock) {
        self.loginBlock();
    }
}

- (void)changAppid
{

    self.appid = kTestAPPKEY;
    self.appSectet = kTestAPPSECRET;
    [HETOpenSDK registerAppId:self.appid appSecret:self.appSectet];
    NSString *tip = [NSString stringWithFormat:@"当前APPID是 %@",self.appid];
    [HETCommonHelp showAutoDissmissWithMessage:tip];
    
    [HETAppConfigTool saveAppId:self.appid];
    [HETAppConfigTool saveAppSecret:self.appSectet];
    
    [self.settingView change];
}
@end
