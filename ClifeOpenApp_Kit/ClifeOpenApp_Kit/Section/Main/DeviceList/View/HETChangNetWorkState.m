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
/** 环境切换文字 **/
@property (nonatomic,assign) HETNetWorkConfigType                                  netWorkConfigType;
/** 登录UIVersion **/
@property (nonatomic,copy)   NSString                                              *loginUIVersion;
@property (nonatomic,strong) UISegmentedControl                                    *netWorkSeg;
@property (nonatomic,strong) UISegmentedControl                                    *loginUISeg;
@end


@implementation HETChangNetWorkState

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
        self.netWorkConfigType = HETNetWorkConfigType_PE;
        self.loginUIVersion = @"1";
        self.netWorkSeg.selectedSegmentIndex = 3;
        self.loginUISeg.selectedSegmentIndex = 0;
        [self updateTestUI];
    }
    return self;
}

- (void)createSubView
{
    self.serverDisplayLabel=[[UILabel alloc]init];
    self.serverDisplayLabel.font=[UIFont systemFontOfSize:12];
    self.serverDisplayLabel.textAlignment=NSTextAlignmentCenter;
    self.serverDisplayLabel.textColor=[UIColor colorFromHexRGB:@"666666"];
    [self addSubview: self.serverDisplayLabel];
    [self.serverDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-12*BasicHeight);
        make.centerX.equalTo(self);
    }];
    
    self.netWorkSeg = [[UISegmentedControl alloc] initWithItems:@[@"内部测试",@"外部测试",@"预发布",@"正式"]];
    [self.netWorkSeg sizeToFit];
    [self.netWorkSeg addTarget:self action:@selector(switchServer:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.netWorkSeg];
    [self.netWorkSeg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.serverDisplayLabel.mas_top).offset(-20*BasicHeight);
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(16 *BasicWidth);
        make.right.equalTo(self).offset(-16 *BasicWidth);
    }];
    
    self.loginUISeg = [[UISegmentedControl alloc] initWithItems:@[@"V1",@"V2",@"V3"]];
    [self.loginUISeg sizeToFit];
    [self.loginUISeg addTarget:self action:@selector(switchVersion:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.loginUISeg];
    [self.loginUISeg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.netWorkSeg.mas_top).offset(-20*BasicHeight);
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(16 *BasicWidth);
        make.right.equalTo(self).offset(-16 *BasicWidth);
    }];
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



@end
