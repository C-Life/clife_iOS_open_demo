//
//  HETChangNetWorkState.m
//  ClifeOpenApp_Kit
//
//  Created by miao on 2018/1/8.
//  Copyright © 2018年 het. All rights reserved.
//

#import "HETChangNetWorkState.h"

@interface HETChangNetWorkState()
/** 环境切换文字 **/
@property (nonatomic,strong) UILabel                                               *serverDisplayLabel;
/** 网络环境类型 **/
@property (nonatomic,assign) HETNetWorkConfigType                                  netWorkConfigType;
/** 登录UIVersion **/
@property (nonatomic,copy)   NSString                                              *loginUIVersion;
@property (nonatomic,strong) UILabel                                               *currentAppIDLabel;
@end


@implementation HETChangNetWorkState

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
        [self updateDefaultState];
    }
    return self;
}

- (void)createSubView
{
    
    self.loginUISeg = [[UISegmentedControl alloc] initWithItems:@[@"登录风格V1",@"登录风格V2",@"登录风格V3"]];
    [self.loginUISeg sizeToFit];
    [self.loginUISeg addTarget:self action:@selector(switchVersion:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.loginUISeg];
    [self.loginUISeg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(ScreenWidth - 60);
    }];
    
    self.netWorkSeg = [[UISegmentedControl alloc] initWithItems:@[@"内部测试",@"外部测试",@"预发布",@"正式"]];
    [self.netWorkSeg sizeToFit];
    [self.netWorkSeg addTarget:self action:@selector(switchServer:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.netWorkSeg];
    [self.netWorkSeg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginUISeg.mas_bottom).offset(20*BasicHeight);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(ScreenWidth - 60);
    }];
    
    self.serverDisplayLabel=[[UILabel alloc]init];
    self.serverDisplayLabel.font=[UIFont systemFontOfSize:12];
    self.serverDisplayLabel.textAlignment=NSTextAlignmentCenter;
    self.serverDisplayLabel.textColor=[UIColor colorFromHexRGB:@"666666"];
    [self addSubview: self.serverDisplayLabel];
    [self.serverDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.netWorkSeg.mas_bottom).offset(12*BasicHeight);
        make.centerX.equalTo(self);
    }];
    
    self.currentAppIDLabel=[[UILabel alloc]init];
    self.currentAppIDLabel.font=[UIFont systemFontOfSize:12];
    self.currentAppIDLabel.textAlignment=NSTextAlignmentCenter;
    self.currentAppIDLabel.textColor=[UIColor colorFromHexRGB:@"666666"];
    [self addSubview: self.currentAppIDLabel];
    [self.currentAppIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serverDisplayLabel.mas_bottom).offset(12*BasicHeight);
        make.centerX.equalTo(self);
    }];
}

- (void)updateDefaultState
{
    [self updateTestUI];
}

- (void)change
{
    [self updateTestUI];
}

- (void)switchVersion:(UISegmentedControl *)seg{
    
    self.loginUIVersion = [NSString stringWithFormat: @"%ld", seg.selectedSegmentIndex];
    
    [HETAppConfigTool saveLoginUIVersion:self.loginUIVersion];
    if (self.changeBlock) {
        self.changeBlock();
    }
    [self change];
}

-(void)switchServer:(UISegmentedControl *)seg{
    self.netWorkConfigType = (HETNetWorkConfigType)seg.selectedSegmentIndex;
    [HETOpenSDK setNetWorkConfig:self.netWorkConfigType];
    [HETAppConfigTool saveNetWorkConfigType:self.netWorkConfigType];
    if (self.changeBlock) {
        self.changeBlock();
    }
    [self change];
}

- (void)updateTestUI
{
//    if ([[HETAppConfigTool getAppId] integerValue] == kTestAPPKEY) {
//        self.netWorkSeg.hidden = YES;
//        self.loginUISeg.hidden = YES;
//    }else{
//        self.netWorkSeg.hidden = NO;
//        self.loginUISeg.hidden = NO;
//    }
    
    self.netWorkSeg.hidden = YES;
    self.loginUISeg.hidden = YES;
    
    self.netWorkConfigType = [HETAppConfigTool getNetWorkConfigType];
    self.loginUIVersion = [HETAppConfigTool getLoginUIVersion];
    
    if(self.netWorkConfigType == HETNetWorkConfigType_ITE)
    {
        self.serverDisplayLabel.text = @"当前为内部测试环境:200.200.200.50";
    }
    else if (self.netWorkConfigType == HETNetWorkConfigType_ETE){
        self.serverDisplayLabel.text=@"当前为外部测试环境:dp.clife.net";
    }
    else if(self.netWorkConfigType == HETNetWorkConfigType_PRE)
    {
        self.serverDisplayLabel.text = @"当前为预发布环境:pre.open.api.clife.cn";
        
    }
    else if (self.netWorkConfigType == HETNetWorkConfigType_PE)
    {
        self.serverDisplayLabel.text = @"当前为正式环境:open.api.clife.cn";
    }
    else {
        self.serverDisplayLabel.text = @"当前为外部测试环境:dp.clife.net";
    }
    
    
    self.netWorkSeg.selectedSegmentIndex = self.netWorkConfigType;
    self.loginUISeg.selectedSegmentIndex = [self.loginUIVersion integerValue];
    
    NSString *versionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    versionStr = [versionStr stringByAppendingString: @"."];
    versionStr = [versionStr stringByAppendingString: [NSString stringWithFormat:@"(%@)",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]]];
    
    self.serverDisplayLabel.text = [NSString stringWithFormat:@"%@ %@ UI:%ld",self.serverDisplayLabel.text,versionStr,[self.loginUIVersion integerValue] + 1];
    self.currentAppIDLabel.text = [NSString stringWithFormat:@"当前APPID为:%@",[HETAppConfigTool getAppId]];
    OPLog(@"_serverDisplayLabel.text = %@",_serverDisplayLabel.text);
    
    //授权主题设置
    HETAuthorizeTheme *theme = [HETAuthorizeTheme new];
    theme.navHeadlineContent = SafeLoginTitle;           // 标题
    theme.logoshow = YES;                           // logo显示
    theme.weixinLogin = YES;                        // 微信登录显示
    theme.qqLogin = YES;                            // QQ登录显示
    theme.weiboLogin = YES;                         // 微博登录显示
    theme.loginType = [NSString stringWithFormat:@"%ld",[self.loginUIVersion integerValue] + 1];                      // 主题样式（1、2、3）
    theme.navTitleColor = @"FFFFFFFF";              // 导航标题文字颜色
    theme.loginBtnFontColor = @"FF3b96ff";          // 登录按钮文字颜色
    theme.navBackgroundColor = @"FF3b96ff";         // 导航颜色
    theme.navBackBtnType = @"white";                // 返回按钮
    theme.loginBtnBackgroundColor = @"FFFFFFFF";    // 登录按钮颜色
    theme.loginBtnBorderColor = @"FF3b96ff";        // 登录边框颜色
    [HETOpenSDK setAuthorizeTheme:theme];
}

@end
