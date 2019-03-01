//
//  ChangeNameViewController.m
//  ClifeOpenApp_Kit
//
//  Created by 袁云龙 on 2019/1/23.
//  Copyright © 2019年 het. All rights reserved.
//

#import "ChangeNameViewController.h"

#define deviceNameLeght 8
#define SINGLE_LINE_WIDTH (1 / [UIScreen mainScreen].scale)

@interface ChangeNameViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *deviceDetailTextField;
@property (nonatomic,strong)UIView * topLine;
@property (nonatomic,strong)UIView * bottomLine;
@end

@implementation ChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavViews];
    [self createUI];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.deviceDetailTextField resignFirstResponder];
}

- (void)createUI
{
    [self.view addSubview:self.topLine];
    [self.view addSubview:self.deviceDetailTextField];
    [self.view addSubview:self.bottomLine];
    [self.deviceDetailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }else{
            make.top.mas_equalTo(self.view.mas_top);
        }
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(39);
    }];

    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.deviceDetailTextField);
        make.height.mas_equalTo(1);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.deviceDetailTextField);
        make.height.mas_equalTo(1);
    }];
}

- (void)createNavViews
{
    // 1.中间标题
    self.navigationItem.title = DeviceChangeNameTitle;
    
    // 2.添加设备按妞
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    // 3.保存按钮
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:DeviceChangeNameTitleSave forState:UIControlStateNormal];
    [saveButton setFrame:CGRectMake(0, 0, 40, 30)];
    [saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)saveButtonAction
{
    [self updateDeviceName];
}

- (void)updateDeviceName
{
    NSString *deviceName = self.deviceDetailTextField.text;
    if (deviceName.length == 0) {
        [HETCommonHelp showAutoDissmissWithMessage:DeviceChangeNameInputNickName];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.deviceModel.deviceId,@"deviceId",deviceName,@"deviceName",nil];
    [HETDeviceRequestBusiness startRequestWithHTTPMethod:HETRequestMethodPost withRequestUrl:@"/v1/device/update" processParams:dic needSign:true BlockWithSuccess:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            responseObject = (NSDictionary *)responseObject ;
            NSString *code = [responseObject objectForKey:@"code"];
            if (code.integerValue == 0) {
                //更新设备名称
                self.deviceModel.deviceName = deviceName;
                [HETCommonHelp showAutoDissmissWithMessage:CommonSaveSuccess];
                [self.navigationController popViewControllerAnimated:true];
                return ;
            }
            [HETCommonHelp showAutoDissmissWithMessage:CommonSaveFailed];
        }else{
             [HETCommonHelp showAutoDissmissWithMessage:CommonSaveFailed];
        }
    } failure:^(NSError *error) {
         [HETCommonHelp showAutoDissmissWithMessage:CommonSaveFailed];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark setter getter
-(UITextField *)deviceDetailTextField{
    if (!_deviceDetailTextField) {
        _deviceDetailTextField = [[UITextField alloc] initWithFrame:CGRectMake(0,  0, ScreenWidth, 39)];
        
        _deviceDetailTextField.backgroundColor = [UIColor whiteColor];
        _deviceDetailTextField.text = [self.deviceModel deviceName];
        _deviceDetailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _deviceDetailTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16,39)];
        _deviceDetailTextField.leftView.backgroundColor = [UIColor whiteColor];
        _deviceDetailTextField.leftViewMode = UITextFieldViewModeAlways;
        _deviceDetailTextField.keyboardType = UIKeyboardTypeDefault;
        _deviceDetailTextField.returnKeyType = UIReturnKeyDone;
        _deviceDetailTextField.delegate = self;
        //        [_deviceDetailTextField disableEmoji];
        [_deviceDetailTextField becomeFirstResponder];
    }
    return _deviceDetailTextField;
}
- (UIView *)topLine{
    
    if (_topLine == nil) {
        _topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, SINGLE_LINE_WIDTH)];
        _topLine.backgroundColor=[UIColor colorFromHexRGB:@"e3e3e3"];
    }
    
    return _topLine;
}

- (UIView *)bottomLine{
    
    if (_bottomLine == nil) {
        
        _bottomLine=[[UIView alloc]initWithFrame:CGRectMake(0,10+ 39-SINGLE_LINE_WIDTH, ScreenWidth, SINGLE_LINE_WIDTH)];
        _bottomLine.backgroundColor=[UIColor colorFromHexRGB:@"e3e3e3"];
    }
    
    return _bottomLine;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@" "]) {
        return NO;
    }
    if ([[[[UIApplication sharedApplication] textInputMode] primaryLanguage] isEqualToString:@"emoji"]||![[[UIApplication sharedApplication] textInputMode] primaryLanguage] ) {
//        [HelpMsg showMessage:@"不支持emoji表情输入" inView:  [UIApplication sharedApplication].keyWindow];
        [self showAlertInfoTitle:CommonAlert message:DeviceChangeNameNotSupportEmoji];
        return NO;
    }
    if (string.length == 0) {
        return YES;
    }
    
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField disableEmoji];
    [self.deviceDetailTextField resignFirstResponder];
    [self updateDeviceName];
    return YES;
}

- (void)showAlertInfoTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:CommoniKnoew style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:true completion:nil];
    }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:true completion:nil];
}

@end
