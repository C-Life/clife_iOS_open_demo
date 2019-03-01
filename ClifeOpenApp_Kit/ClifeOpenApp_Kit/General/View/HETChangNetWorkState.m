//
//  HETChangNetWorkState.m
//  ClifeOpenApp_Kit
//
//  Created by miao on 2018/1/8.
//  Copyright © 2018年 het. All rights reserved.
//

#import "HETChangNetWorkState.h"
//#import "HETNetWorkRequest.h"

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

    self.loginUISeg = [[UISegmentedControl alloc] initWithItems:@[@"V1",@"V2",@"V3"]];
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

#if(HET_IS_ENTERPRISE == 0)
    self.netWorkSeg.hidden = YES;
    self.loginUISeg.hidden = YES;                                                                                                                                                                                                                                                                                             
#endif
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
    id netWorkObject = [[NSUserDefaults standardUserDefaults]objectForKey:kUserDefaultNetWorkConfig];
    if (netWorkObject) {
        NSNumber *userSelectNetWork = (NSNumber *)netWorkObject;
        NSString *loginUIVersion= [[NSUserDefaults standardUserDefaults]objectForKey:kUserDefaultLoginUIVersion];
        [self updateParams:userSelectNetWork.unsignedIntegerValue loginUIVersion:loginUIVersion];
    }else{
        [self updateParams:HETNetWorkConfigType_PE loginUIVersion:@"3"];
    }
}

- (void)switchVersion:(UISegmentedControl *)seg{
    
    switch (seg.selectedSegmentIndex) {
        case 0:
            self.loginUIVersion = @"1";
            break;
        case 1:
            self.loginUIVersion = @"2";
            break;
        case 2:
            self.loginUIVersion = @"3";
            break;
        default:
            self.loginUIVersion = @"1";
            break;
    }
    // 缓存切换登录风格的设置
    [[NSUserDefaults standardUserDefaults]setObject:self.loginUIVersion forKey:kUserDefaultLoginUIVersion];
    if (self.changeBlock) {
        self.changeBlock();
    }
    [self updateTestUI];
}

-(void)switchServer:(UISegmentedControl *)seg{
    switch (seg.selectedSegmentIndex) {
        case 0:
            self.netWorkConfigType = HETNetWorkConfigType_ITE;
            break;
        case 1:
            self.netWorkConfigType = HETNetWorkConfigType_ETE;
            break;
        case 2:
            self.netWorkConfigType = HETNetWorkConfigType_PRE;
            break;
        case 3:
            self.netWorkConfigType = HETNetWorkConfigType_PE;
            break;
        default:
            self.netWorkConfigType = HETNetWorkConfigType_ITE;
            break;
    }
    
    [HETOpenSDK setNetWorkConfig:self.netWorkConfigType];
    //缓存切换环境的设置
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithUnsignedInteger:self.netWorkConfigType ] forKey:kUserDefaultNetWorkConfig];
    if (self.changeBlock) {
        self.changeBlock();
    }
    [self updateTestUI];
}

- (void)updateTestUI
{
    if (self.netWorkConfigType == HETNetWorkConfigType_PE)
    {
        self.serverDisplayLabel.text = @"当前为正式环境:open.api.clife.cn";
    }
    else if(self.netWorkConfigType == HETNetWorkConfigType_PRE)
    {
        self.serverDisplayLabel.text = @"当前为预发布环境:pre.open.api.clife.cn";
    }
    else if(self.netWorkConfigType == HETNetWorkConfigType_ITE)
    {
        self.serverDisplayLabel.text=@"当前为内部测试环境:200.200.200.50";
    }else{
        self.serverDisplayLabel.text=@"当前为外部测试环境:dp.clife.net";
    }
    
    NSString *versionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    versionStr = [versionStr stringByAppendingString: @"."];
    versionStr = [versionStr stringByAppendingString: [NSString stringWithFormat:@"(%@)",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]]];
    
    self.serverDisplayLabel.text = [NSString stringWithFormat:@"%@ %@ UI:%@",self.serverDisplayLabel.text,versionStr,self.loginUIVersion];
//    self.currentAppIDLabel.text = [NSString stringWithFormat:@"当前APPID为:%@",[HETNetWorkRequest shared].appId];
    OPLog(@"_serverDisplayLabel.text = %@",_serverDisplayLabel.text);
    
    //授权主题设置
    HETAuthorizeTheme *theme = [HETAuthorizeTheme new];
    theme.navHeadlineContent = SafeLoginTitle;           // 标题
    theme.logoshow = YES;                           // logo显示
    theme.weixinLogin = YES;                        // 微信登录显示
    theme.qqLogin = YES;                            // QQ登录显示
    theme.weiboLogin = YES;                         // 微博登录显示
    theme.loginType = self.loginUIVersion;                         // 主题样式（1、2、3）
    theme.navTitleColor = @"FFFFFFFF";              // 导航标题文字颜色
    theme.loginBtnFontColor = @"FF3b96ff";          // 登录按钮文字颜色
    theme.navBackgroundColor = @"FF3b96ff";         // 导航颜色
    theme.navBackBtnType = @"white";                // 返回按钮
    theme.loginBtnBackgroundColor = @"FFFFFFFF";    // 登录按钮颜色
    theme.loginBtnBorderColor = @"FF3b96ff";        // 登录边框颜色
    [HETOpenSDK setAuthorizeTheme:theme];
}

- (void)updateParams:(HETNetWorkConfigType)netWorkConfigType loginUIVersion:(NSString *)loginUIVersion
{
    self.netWorkConfigType = netWorkConfigType;
    self.loginUIVersion = loginUIVersion;
    // 1.修改环境提示文案,修改网络状态记录，修改网路选择器
    if (self.netWorkConfigType == HETNetWorkConfigType_PE)
    {
        self.serverDisplayLabel.text = @"当前为正式环境:open.api.clife.cn";
        self.netWorkConfigType = HETNetWorkConfigType_PE;
        self.netWorkSeg.selectedSegmentIndex = 3;
    }
    else if(self.netWorkConfigType == HETNetWorkConfigType_PRE)
    {
        self.serverDisplayLabel.text = @"当前为预发布环境:pre.open.api.clife.cn";
        self.netWorkConfigType = HETNetWorkConfigType_PRE;
        self.netWorkSeg.selectedSegmentIndex = 2;
    }
    else if(self.netWorkConfigType == HETNetWorkConfigType_ITE)
    {
        self.serverDisplayLabel.text=@"当前为内部测试环境:200.200.200.50";
        self.netWorkConfigType = HETNetWorkConfigType_ITE;
        self.netWorkSeg.selectedSegmentIndex = 0;
    }else{
        self.serverDisplayLabel.text=@"当前为外部测试环境:dp.clife.net";
        self.netWorkConfigType = HETNetWorkConfigType_ETE;
        self.netWorkSeg.selectedSegmentIndex = 1;
    }
    
    [HETOpenSDK setNetWorkConfig:self.netWorkConfigType];
    
    // 2.修改登录风格选择器
    if ([self.loginUIVersion isEqualToString: @"1"]) {
        self.loginUISeg.selectedSegmentIndex = 0;
    }else if ([self.loginUIVersion isEqualToString: @"2"])
    {
        self.loginUISeg.selectedSegmentIndex = 1;
    }
    else if ([self.loginUIVersion isEqualToString: @"3"])
    {
        self.loginUISeg.selectedSegmentIndex = 2;
    }
    else{
        self.loginUIVersion = @"1";
        self.loginUISeg.selectedSegmentIndex = 0;
    }
    
    NSString *versionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    versionStr = [versionStr stringByAppendingString: @"."];
    versionStr = [versionStr stringByAppendingString: [NSString stringWithFormat:@"(%@)",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]]];
    
    self.serverDisplayLabel.text = [NSString stringWithFormat:@"%@ %@ UI:%@",self.serverDisplayLabel.text,versionStr,self.loginUIVersion];
//    self.currentAppIDLabel.text = [NSString stringWithFormat:@"当前APPID为:%@",[HETNetWorkRequest shared].appId];
    OPLog(@"_serverDisplayLabel.text = %@",_serverDisplayLabel.text);
    
    // 3.修改配置主题参数
    HETAuthorizeTheme *theme = [HETAuthorizeTheme new];
    theme.navHeadlineContent = SafeLoginTitle;           // 标题
    theme.logoshow = YES;                           // logo显示
    theme.weixinLogin = YES;                        // 微信登录显示
    theme.qqLogin = YES;                            // QQ登录显示
    theme.weiboLogin = YES;                         // 微博登录显示
    theme.loginType = self.loginUIVersion;                         // 主题样式（1、2、3）
    theme.navTitleColor = @"FFFFFFFF";              // 导航标题文字颜色
    theme.loginBtnFontColor = @"FF3b96ff";          // 登录按钮文字颜色
    theme.navBackgroundColor = @"FF3b96ff";         // 导航颜色
    theme.navBackBtnType = @"white";                // 返回按钮
    theme.loginBtnBackgroundColor = @"FFFFFFFF";    // 登录按钮颜色
    theme.loginBtnBorderColor = @"FF3b96ff";        // 登录边框颜色
    [HETOpenSDK setAuthorizeTheme:theme];
}

@end
