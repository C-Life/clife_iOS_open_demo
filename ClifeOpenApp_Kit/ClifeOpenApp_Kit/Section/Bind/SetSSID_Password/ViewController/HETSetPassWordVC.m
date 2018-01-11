//
//  HETSetPassWordVC.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/9/1.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETSetPassWordVC.h"
#import "HETChangeWIFIVC.h"
#import "HETBindWifiDeviceVC.h"
#import "HETChangeAPWifiVC.h"

#import "CLWifiPasswordInfo.h"

#import "HETinstructionsPageView.h"

#define CC_scale  (float)ScreenWidth/640.0
@interface HETSetPassWordVC ()<UITextFieldDelegate>
/** 中间的文字 “请确认您当前的WiFi或使用其他WiFi进行绑定” **/
@property(strong,nonatomic)UILabel          *centerLabel;
/** 中间的文字 顶部的边框线 **/
@property(strong,nonatomic)UILabel          *zeroLine;
/** 中间的文字 底部的边框线 **/
@property(strong,nonatomic)UILabel          *firstLine;
/** ssid 底部的边框线 **/
@property(strong,nonatomic)UILabel          *secondLine;
/** wifi密码 底部的边框线 **/
@property(strong,nonatomic)UILabel          *thirdLine;
/** ssid输入框 **/
@property(strong,nonatomic)UITextField      *wifiNameField;
/** wifi密码输入框 **/
@property(strong,nonatomic)UITextField      *passwordField;
/** 保存wifi密码按钮 **/
@property(strong,nonatomic)UIButton         *savePswButton;
/** 保存wifi密码文案 **/
@property(strong,nonatomic)UILabel          *savePswButtonLabel;
/** 下一步按钮 **/
@property(strong,nonatomic)UIButton         *nextBindButton;
/** 绑定引导H5页面 **/
@property(strong,nonatomic)HETinstructionsPageView *webPage;
/** 是否显示WiFi密码 **/
@property(assign,nonatomic)BOOL             showPassword;
/** 上次的ssid **/
@property(copy,nonatomic)NSString           *lastSSIDStr;
/** 路由器的mac地址 **/
@property(copy,nonatomic)NSString           *macAddr;
@end

@implementation HETSetPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.设置背景颜色
    self.view.backgroundColor = VCBgColor;

    // 2.设置导航栏
    [self createNavViews];

    // 3.初始化界面
    [self createSubView];

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver: self
                                            selector: @selector(textFieldEditChanged:)
                                                name: UITextFieldTextDidChangeNotification
                                              object: self.passwordField];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[HETWIFIBindBusiness sharedInstance] fetchSSIDInfoWithInterVal:1.0F WithTimes:0 SuccessBlock:^(NSString *ssidStr) {
        //OPLog(@"ssidstr:%@,%@",ssidStr,lastSSIDStr);
        //需要考虑同一个WiFi，只是修改了WiFi密码， 那然后手机重新连接这个ssid，需要清空密码框
        if(![self.lastSSIDStr isEqualToString:ssidStr])
        {
            //OPLog(@"ssidstr:%@",ssidStr);
            self.lastSSIDStr = ssidStr;
            self.wifiNameField.text=ssidStr;
            [self fetchWifiPassword];
        }
    }];
    self.nextBindButton.enabled = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[HETWIFIBindBusiness sharedInstance] stopFetchSSIDInfo];
}

-(void) fetchWifiPassword
{
    self.macAddr = [[HETWIFIBindBusiness sharedInstance] fetchmacSSIDInfo];
    if (!self.macAddr || [self.macAddr isEqualToString:@""])
    {
        self.passwordField.text = nil;
        return;
    }
    if ([CLWifiPasswordInfo initWifiPasswordInfoList])
    {
        NSString *wifipassword = [CLWifiPasswordInfo getWifiPasswordInfoListlByMacAddr:self.macAddr];
        if (wifipassword && ![wifipassword isEqualToString:@""])
        {
            self.passwordField.text = wifipassword;
            self.savePswButton.selected = YES;
        }
        else
        {
            self.passwordField.text = nil;
            self.savePswButton.selected = NO;
        }
    }

    [self checkPassword];
}

- (void)createNavViews
{
    // 1.导航栏标题
    self.navigationItem.title = SetPasswordVCTitle;

    // 2.添加返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

- (void)createSubView
{
    [self.view addSubview:self.centerLabel];
    [self.view addSubview:self.zeroLine];
    [self.view addSubview:self.firstLine];
    [self.view addSubview:self.secondLine];
    [self.view addSubview:self.thirdLine];

    [self.view addSubview:self.wifiNameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.savePswButton];
    [self.view addSubview:self.savePswButtonLabel];
    [self.view addSubview:self.nextBindButton];
    [self.webPage addwebview];
    [self.view addSubview:self.webPage];

    // 约束是从下到上写的
    [self.nextBindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.height.mas_equalTo(44 *BasicHeight);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.bottom.equalTo(self.view.mas_bottom).offset(-16);
    }];

    [self.savePswButtonLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.savePswButton.mas_right).offset(16);
        make.height.mas_equalTo(20);
//        make.width.mas_equalTo(50);
        make.bottom.equalTo(self.nextBindButton.mas_top).offset(-31 *BasicHeight);
    }];

    [self.savePswButton mas_makeConstraints:^(MASConstraintMaker *make) {

        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.bottom.equalTo(self.nextBindButton.mas_top).offset(-31 *BasicHeight);
        make.left.equalTo(self.view.mas_left).offset(16);
    }];
    [self.thirdLine mas_makeConstraints:^(MASConstraintMaker *make) {

        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.savePswButton.mas_top).offset(-16);
    }];

    UIView *passwordbkView = [[UIView alloc]init];
    passwordbkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:passwordbkView];
    [passwordbkView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.height.mas_equalTo(48 *BasicHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.thirdLine.mas_top);
    }];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {

        make.height.mas_equalTo(48 *BasicHeight);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.thirdLine.mas_top);
    }];
    [self.view bringSubviewToFront:self.passwordField];

    [self.secondLine mas_makeConstraints:^(MASConstraintMaker *make) {

        make.height.mas_equalTo(0.5f);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.passwordField.mas_top);
    }];

    UIView *SSIDbkView = [[UIView alloc]init];
    SSIDbkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SSIDbkView];
    [SSIDbkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(48 *BasicHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.secondLine.mas_top);
    }];
    [self.wifiNameField mas_makeConstraints:^(MASConstraintMaker *make) {

        make.height.mas_equalTo(48 *BasicHeight);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.secondLine.mas_top);
    }];
    [self.view bringSubviewToFront:self.wifiNameField];

    [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {

        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.wifiNameField.mas_top);
    }];
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.height.mas_equalTo(40 *BasicHeight);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.firstLine.mas_top);
    }];
    [self.zeroLine mas_makeConstraints:^(MASConstraintMaker *make) {

        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.centerLabel.mas_top);
    }];

    [self.webPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(64);
        make.bottom.equalTo(self.zeroLine.mas_top);
    }];
}

#pragma ButtonAction是否显示密码
-(void)showpasswordOrNot
{
    self.showPassword = !self.showPassword;
    UIButton *button = (UIButton *)self.passwordField.rightView;
    if (self.showPassword) {
        [button setImage:[UIImage imageNamed:@"showpsw_deviceBind"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:@"showpassword"];
        [self.passwordField setSecureTextEntry:NO];
    }
    else{
        [button setImage:[UIImage imageNamed:@"unShowPassword"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:@"showpassword"];
        [self.passwordField setSecureTextEntry:YES];
    }
}
#pragma ButtonAction保存密码
- (void)savePswButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;

    if (self.macAddr && ![self.macAddr isEqualToString:@""])
    {
        if ([CLWifiPasswordInfo initWifiPasswordInfoList])
        {
            if (!sender.selected)
            {
                [CLWifiPasswordInfo DeletePasswordWith:self.macAddr];
            }
            else
            {
                [CLWifiPasswordInfo saveOrUpdateWifiPasswordInfoList:self.wifiNameField.text MacAddr:self.macAddr Password:self.passwordField.text];
            }
        }
    }
}

#pragma ButtonAction进入下一个扫描所有设备界面
- (void) turnToScanDeviceVCAction
{
    [self.view endEditing:YES];

    if (self.wifiNameField.text.length == 0)
    {
        [HETCommonHelp showHudAutoHidenWithMessage:EmptyWifiNameTip];
        return;
    }
    self.nextBindButton.enabled = NO;

    if (self.macAddr && ![self.macAddr isEqualToString:@""])
    {
        if ([CLWifiPasswordInfo initWifiPasswordInfoList])
        {
            if (!self.savePswButton.selected)
            {
                [CLWifiPasswordInfo DeletePasswordWith:self.macAddr];
            }
            else
            {
                [CLWifiPasswordInfo saveOrUpdateWifiPasswordInfoList:self.wifiNameField.text MacAddr:self.macAddr Password:self.passwordField.text];
            }
        }
    }

    // AP设备
    if ([self.device.moduleType integerValue] == 9) {
        HETChangeAPWifiVC *changeWIFIVC = [HETChangeAPWifiVC new];
        changeWIFIVC.device = self.device;
        changeWIFIVC.ssid = self.wifiNameField.text;
        changeWIFIVC.password = self.passwordField.text;
        [self.navigationController pushViewController:changeWIFIVC animated:YES];
        return;
    }
    // smartLink 设备
    if ([self.device.moduleType integerValue] == 1) {
        HETBindWifiDeviceVC *bindWifiDeviceVC = [HETBindWifiDeviceVC new];
        bindWifiDeviceVC.device = self.device;
        bindWifiDeviceVC.ssid = self.wifiNameField.text;
        bindWifiDeviceVC.password = self.passwordField.text;
        [self.navigationController pushViewController:bindWifiDeviceVC animated:YES];
        return;
    }
}

#pragma ButtonAction进入切换密码的帮助页面
-(void)gotoChangeWIFIVC
{
    [self.view endEditing:YES];
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

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-----UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==self.passwordField)
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField==self.wifiNameField)
    {
        return NO;
    }
    return YES;
}

- (void)textFieldEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];//获取高亮部分
    if (!position)
    {
        [self checkPassword];
    }
}

- (void)checkPassword
{
    NSInteger len = self.passwordField.text.length;
    if (len > 0 && len <8)
    {
        self.nextBindButton.enabled = NO;
        [self.nextBindButton setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.2]];
    }
    else
    {
        self.nextBindButton.enabled = YES;
        self.nextBindButton.backgroundColor = NavBarColor;
    }
}

#pragma mark - 键盘弹出和收起的监听回调方法:
- (void)keyBoardWillShow:(NSNotification *)noti
{
    CGRect keyFrame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    // 键盘的高度;
    CGFloat keyHeight = keyFrame.size.height;
    CGRect rect = self.view.frame;
    rect.origin.y = -keyHeight;
    self.view.frame = rect;
}

- (void)keyBoardWillHide:(NSNotification *)noti
{
    self.view.frame = CGRectMake(0,0, ScreenWidth,ScreenHeight);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 懒加载
-(UILabel *)centerLabel
{
    if(!_centerLabel)
    {
        _centerLabel=[[UILabel alloc]init];
        _centerLabel.textColor=[UIColor colorFromHexRGB:@"5e5e5e"];
        _centerLabel.text= CenterLabelStr;
        [_centerLabel setFont:[UIFont systemFontOfSize:12]];
    }
    return _centerLabel;
}

-(UILabel *)zeroLine
{
    if(!_zeroLine)
    {
        _zeroLine=[[UILabel alloc]init];
        _zeroLine.backgroundColor=[UIColor colorFromHexRGB:@"ebebeb"];
    }
    return _zeroLine;
}

-(UILabel *)firstLine
{
    if(!_firstLine)
    {
        _firstLine=[[UILabel alloc]init];
        _firstLine.backgroundColor=[UIColor colorFromHexRGB:@"ebebeb"];
    }
    return _firstLine;
}

-(UILabel *)secondLine
{
    if(!_secondLine)
    {
        _secondLine=[[UILabel alloc]init];
        _secondLine.backgroundColor=[UIColor colorFromHexRGB:@"ebebeb"];

    }
    return _secondLine;

}

-(UILabel *)thirdLine
{
    if(!_thirdLine)
    {
        _thirdLine=[[UILabel alloc]init];
        _thirdLine.backgroundColor = [UIColor colorFromHexRGB:@"ebebeb"];
    }
    return _thirdLine;
}

-(UITextField *)wifiNameField
{
    if(!_wifiNameField)
    {
        _wifiNameField = [[UITextField alloc] init];
        _wifiNameField.backgroundColor = [UIColor whiteColor];
        _wifiNameField.placeholder = WifiNameFieldPlaceholder;
        _wifiNameField.textColor = [UIColor colorFromHexRGB:@"000000"];
        _wifiNameField.returnKeyType = UIReturnKeyNext;
        _wifiNameField.delegate = self;
        _wifiNameField.font = [UIFont systemFontOfSize:14];
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(56*CC_scale, 0, 56*CC_scale*2, 40*CC_scale*2)];
        [rightBtn setImage:[UIImage imageNamed:@"setSsid_right"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(gotoChangeWIFIVC) forControlEvents:UIControlEventTouchUpInside];
        _wifiNameField.rightView = rightBtn;
        _wifiNameField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _wifiNameField;
}

-(UITextField *)passwordField
{
    if(!_passwordField)
    {
        _passwordField = [[UITextField alloc] init];
        _passwordField.backgroundColor = [UIColor whiteColor];
        _passwordField.placeholder = PasswordFieldPlaceholder;
        _passwordField.textColor = [UIColor colorFromHexRGB:@"000000"];
        _passwordField.returnKeyType = UIReturnKeyDone;
        _passwordField.delegate = self;
        _passwordField.font = [UIFont systemFontOfSize:14];

        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(56*CC_scale, 0, 56*CC_scale*2, 40*CC_scale*2)];
        if (self.showPassword) {
            [rightBtn setImage:[UIImage imageNamed:@"showpsw_deviceBind"] forState:UIControlStateNormal];
        }
        else{
            [rightBtn setImage:[UIImage imageNamed:@"unShowPassword"] forState:UIControlStateNormal];
        }
        [rightBtn addTarget:self action:@selector(showpasswordOrNot) forControlEvents:UIControlEventTouchUpInside];
        if (self.showPassword) {
            [_passwordField setSecureTextEntry:NO];
        }
        else{
            [_passwordField setSecureTextEntry:YES];
        }
        _passwordField.rightView = rightBtn;
        _passwordField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _passwordField;
}

-(UIButton *)savePswButton
{
    if(!_savePswButton)
    {
        _savePswButton=[[UIButton alloc]init];
        [_savePswButton setImage:[UIImage imageNamed:@"savePassword_unSelect"] forState:UIControlStateNormal];
        [_savePswButton setImage:[UIImage imageNamed:@"savePassword"] forState:UIControlStateSelected];
        [_savePswButton addTarget:self action:@selector(savePswButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _savePswButton;
}

-(UILabel *)savePswButtonLabel
{
    if(!_savePswButtonLabel)
    {
        _savePswButtonLabel=[[UILabel alloc]init];
        _savePswButtonLabel.textColor=[UIColor colorFromHexRGB:@"808080"];
        _savePswButtonLabel.text= SavePswButtonLabelStr;
        _savePswButtonLabel.textAlignment=NSTextAlignmentLeft;
//        _savePswButtonLabel.adjustsFontSizeToFitWidth=YES;
        [_savePswButtonLabel setFont:[UIFont systemFontOfSize:16]];
    }
    return _savePswButtonLabel;
}

-(UIButton *)nextBindButton
{
    if(!_nextBindButton)
    {
        _nextBindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBindButton setTitle:NextBindButtonTitle forState:UIControlStateNormal];
        [_nextBindButton setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        [_nextBindButton addTarget:self action:@selector(turnToScanDeviceVCAction) forControlEvents:UIControlEventTouchUpInside];
        _nextBindButton.layer.cornerRadius= 5;
        _nextBindButton.clipsToBounds = YES;
        _nextBindButton.backgroundColor = NavBarColor;
    }
    return _nextBindButton;
}

-(HETinstructionsPageView *)webPage
{
    if (!_webPage)
    {
        _webPage = [[HETinstructionsPageView alloc]init];
        _webPage.device = self.device;
    }
    return _webPage;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
