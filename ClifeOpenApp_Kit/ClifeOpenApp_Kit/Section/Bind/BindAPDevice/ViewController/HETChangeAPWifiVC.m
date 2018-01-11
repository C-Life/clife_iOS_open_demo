//
//  HETChangeAPWifiVC.m
//  ClifeOpenApp_Kit
//
//  Created by miao on 2017/9/20.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETChangeAPWifiVC.h"
#import "HETChangeWIFIVC.h"
#import "HETBindAPDeviceVC.h"
#import "HETinstructionsPageView.h"

@interface HETChangeAPWifiVC ()<UITextFieldDelegate>
/** 设备引导图片 **/
@property(nonatomic,strong) HETinstructionsPageView *webPage;
/** 设备引导图片 **/
@property(nonatomic,strong) UIImageView             *guideImageView;
/** 当前连接的wifi SSID **/
@property(nonatomic,strong) UIButton                *currentLinkWiFiStateBtn;
/** 显示设备指定的SSID **/
@property(nonatomic,strong) UILabel                 *assignSSIDLabel;
/** 提示 **/
@property(nonatomic,strong) UILabel                 *explainLable;
/** 下一步 **/
@property(nonatomic,strong) UIButton                *nextBtn;
@property(nonatomic,assign) BOOL                    isNext;
@end

@implementation HETChangeAPWifiVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];

    // 2.设置导航栏
    [self createNavViews];

    // 3.初始化界面
    [self createSubView];

    self.isNext = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateCurrentWiFiState];

    NSString *SSIDStr = [NSString stringWithFormat:@"%@%04x%02x_xxxx",self.device.radiocastName,self.device.deviceTypeId.intValue,self.device.deviceSubtypeId.intValue];
    self.assignSSIDLabel.text = SSIDStr;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)createNavViews
{
    // 1.导航栏标题
    self.navigationItem.title = AddDeviceVCTitle;

    // 2.添加返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

- (void)createSubView
{
    [self.webPage addwebview];
    [self.view addSubview:self.webPage];
    [self.webPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(74);
        make.height.mas_equalTo(400 /2);
    }];

    [self.view addSubview:self.guideImageView];
    [self.guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.webPage.mas_bottom).offset(20/2);
        make.size.mas_equalTo(CGSizeMake(750/2*BasicHeight, 441/2*BasicHeight));
    }];

    [self.view addSubview:self.assignSSIDLabel];
    [self.assignSSIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(202/2*BasicHeight, 23/2*BasicHeight));
        make.top.equalTo(self.guideImageView.mas_top).offset(146/2 *BasicHeight);
        make.left.equalTo(self.guideImageView.mas_left).offset(258/2*BasicHeight);
    }];

    [self.view addSubview:self.explainLable];
    [self.explainLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(292, 28));
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.guideImageView.mas_bottom).offset(-34/2);
    }];

    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10 *BasicHeight);
    }];

    [self.view addSubview:self.currentLinkWiFiStateBtn];
    [self.currentLinkWiFiStateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.nextBtn.mas_centerX);
        make.bottom.equalTo(self.nextBtn.mas_top).offset(-12*BasicHeight);
    }];
}

- (NSDictionary *)fetchNetInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    //    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);

    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        //        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);

        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}
- (void)updateCurrentWiFiState
{
    dispatch_async(dispatch_get_main_queue(), ^{

        // 获取当前WiFi名称
        if ([[self fetchNetInfo] valueForKey:@"SSID"] && ![[[self fetchNetInfo] valueForKey:@"SSID"] isKindOfClass:[NSNull class]])
        {
            [self.currentLinkWiFiStateBtn setTitle:[NSString stringWithFormat:@"%@ :%@",BindInstructionCurrentWifl,[[self fetchNetInfo] valueForKey:@"SSID"]] forState:UIControlStateNormal];
        }


        NSString *currentSsid =[[self fetchNetInfo] objectForKey:@"SSID"];
        if(self.device.radiocastName.length!=0 &&[[currentSsid uppercaseString] rangeOfString:[self.device.radiocastName uppercaseString]].length==0)
        {
            [self.currentLinkWiFiStateBtn setImage:[UIImage imageNamed:@"wronglink"] forState:UIControlStateNormal];
            self.isNext =NO;
            [self performSelector:@selector(updateCurrentWiFiState) withObject:nil afterDelay:1.0f];
        }
        else
        {
            NSString* srcSSID = [[self fetchNetInfo] valueForKey:@"SSID"];
            if([srcSSID rangeOfString:[self.device.radiocastName uppercaseString]].length)
            {
                NSArray *separateSrcSSID = [srcSSID componentsSeparatedByString:@"_"];
                NSInteger srcDeviceTypeId = [self  hexStrToInt:[[separateSrcSSID objectAtIndex:1] substringWithRange:NSMakeRange(0, 4)]];
                NSInteger srcDeviceSubTypeId = [self  hexStrToInt:[[separateSrcSSID objectAtIndex:1] substringWithRange:NSMakeRange(4, 2)]];

                if(([self.device.deviceTypeId integerValue] == srcDeviceTypeId)&&([self.device.deviceSubtypeId integerValue] == srcDeviceSubTypeId))
                {
                    // 这里才算搜到整取的设备
                    [self.currentLinkWiFiStateBtn setImage:[UIImage imageNamed:@"rightlink"] forState:UIControlStateNormal];
                    [self.nextBtn setTitle:NextBindButtonTitle forState:UIControlStateNormal];
                    self.nextBtn.enabled = NO;
                    [self.nextBtn setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.3]];
                    [self performSelector:@selector(allowToNext) withObject:nil afterDelay:1.5f];
                }
                else
                {
                    [self performSelector:@selector(updateCurrentWiFiState) withObject:nil afterDelay:1.0f];
                }
            }
            else
            {
                [self performSelector:@selector(updateCurrentWiFiState) withObject:nil afterDelay:1.0f];
            }
        }
    });
}

- (void)allowToNext
{
    self.isNext = YES;
    self.nextBtn.enabled = YES;
    [self.nextBtn setBackgroundColor:NavBarColor];
}

//10进制转16进制
+(NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i =0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}

// 将16进制字符串转换为10进制数字
- (NSInteger)hexStrToInt:(NSString *)str
{
    const char *hexChar = [str cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (NSInteger)hexNumber;
}

- (void)nextBtn:(UIButton *)sender
{
    if(self.isNext && self.nextBtn.enabled)
    {
        HETBindAPDeviceVC *vc = [[HETBindAPDeviceVC alloc]init];
        vc.ssid = self.ssid ;
        vc.password = self.password;
        vc.device = self.device;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0)
        {
            NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
            else
            {
                HETChangeWIFIVC *vc = [[HETChangeWIFIVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else
        {
            NSURL *url = [NSURL URLWithString:@"App-Prefs:root=WIFI"];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
            else
            {
                HETChangeWIFIVC *vc = [[HETChangeWIFIVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

#pragma mark - 返回事件
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 懒加载
- (HETinstructionsPageView *)webPage
{
    if (!_webPage)
    {
        _webPage = [[HETinstructionsPageView alloc]init];
        _webPage.device = self.device;
    }
    return _webPage;
}

- (UIImageView *)guideImageView
{
    if (!_guideImageView)
    {
        _guideImageView = [[UIImageView alloc]init];
        _guideImageView.image = [UIImage imageNamed:@"guideLinkWiFi"];
        _guideImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _guideImageView;
}

- (UILabel *)assignSSIDLabel
{
    if (!_assignSSIDLabel) {
        _assignSSIDLabel = [[UILabel alloc]init];
        _assignSSIDLabel.text = @"";
        _assignSSIDLabel.font = [UIFont systemFontOfSize:10.0f *BasicHeight];
        _assignSSIDLabel.textAlignment = NSTextAlignmentLeft;
        _assignSSIDLabel.textColor = [UIColor redColor];
    }
    return _assignSSIDLabel;
}

- (UILabel *)explainLable
{
    if (!_explainLable) {
        _explainLable = [[UILabel alloc]init];
        _explainLable.text = ConnectWifiHelpInfo;
        _explainLable.font = [UIFont systemFontOfSize:15.0f];
        _explainLable.textAlignment = NSTextAlignmentCenter;
        _explainLable.textColor = [UIColor grayColor];
    }
    return _explainLable;
}

- (UIButton *)currentLinkWiFiStateBtn
{
    if (!_currentLinkWiFiStateBtn) {
        _currentLinkWiFiStateBtn  = [[UIButton alloc]init];
        _currentLinkWiFiStateBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _currentLinkWiFiStateBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_currentLinkWiFiStateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _currentLinkWiFiStateBtn;
}

- (UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]init];
        _nextBtn.layer.cornerRadius = 5;
        _nextBtn.clipsToBounds = YES;
        [_nextBtn setBackgroundColor:NavBarColor];
        [_nextBtn setTitle:ToConnectWifi forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (void)dealloc
{
    OPLog(@"%@ dealloc！！！",[self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
