//
//  HETCloudAuthViewController.m
//  ClifeOpenApp_Kit
//
//  Created by yuan yunlong on 2017/10/31.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETCloudAuthViewController.h"

@interface HETCloudAuthViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *getAuthCodeButton;

@property (weak, nonatomic) IBOutlet UIButton *getRandomCodeButton;

@property (weak, nonatomic) IBOutlet UIButton *verifyRandomCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *verfiyTextFeild;

@property (weak, nonatomic) IBOutlet UITextField *telePhone;

@property (weak, nonatomic) IBOutlet UILabel *authoCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *randomCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *openIdLabel;

@property (nonatomic, strong) NSString *AuthCode;
@property (nonatomic, strong) NSString *randomCode;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *openID;

@property (nonatomic, assign) BOOL needMoveView;
@end

static  NSString *CloudAuthOpenIdKey = @"HETCloudAuthOpenIdKey";

@implementation HETCloudAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.telePhone.delegate = self;
    self.verfiyTextFeild.delegate = self;
    
    _needMoveView = false;
    self.openID = [self getOpenId];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDismiss:) name:UIKeyboardWillHideNotification object:nil];
    
}

// 根据键盘状态，调整_mainView的位置
-(void)keyboardShow:(NSNotification *)noti{
    if (!_needMoveView) {
        return;
    }
    NSValue *value = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    self.view.frame = CGRectMake(0, -keyboardRect.size.height/2, ScreenWidth, ScreenHeight);
}
-(void)keyboardDismiss:(NSNotification *)noti{
    self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.telePhone) {
        _needMoveView = false;
    }else{
        _needMoveView = true;
    }
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clearOpenID:(id)sender {
    [self clearOpenId];
}

- (IBAction)getAuthCodeAction:(id)sender {
    _account =  _telePhone.text;
    
    [[HETThirdCloudAuthorize shareInstance]getAuthorizationCodeWithAccount:_account withOpenId:self.openID success:^(id responseObject) {
        OPLog(@"user info success: %@", responseObject);
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject allKeys] containsObject:@"data"]) {
                NSDictionary *dict = [responseObject valueForKey:@"data"];
                NSString * authorizationCode = [dict objectForKey:@"authorizationCode"];
                self.AuthCode = authorizationCode;
            }
        }
    } failure:^(NSError *error) {
        [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
    }];
    
   
}

- (IBAction)getRandomCodeAction:(id)sender {

    if (_AuthCode == nil || _AuthCode.length < 1) {
        [HETCommonHelp showHudAutoHidenWithMessage:@"请获取授权码"];
        return;
    }
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *_timestamp = [NSString stringWithFormat: @"%lld", (long long)(time * 1000)];
    NSTimeInterval offsetTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"kHETOffsetTime"];
    NSString *timeTamp = [NSString stringWithFormat:@"%lld",(long long)(_timestamp.doubleValue + offsetTime *1000)];
    
    NSString *testAPPKEY =  kTestAPPKEY;
    NSString *testAPPSECRET =  kTestAPPSECRET;
    NSString *reqStr = [NSString stringWithFormat:@"appId=%@&appSecret=%@&timestamp=%@&authorizationCode=%@",testAPPKEY,testAPPSECRET,timeTamp,_AuthCode];
    NSURL *url = [NSURL URLWithString:@"http://200.200.200.230:8100/v1/cloud/auth"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [reqStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    // 由于要先对request先行处理,我们通过request初始化task
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                              {
                                  if (data == nil) {
                                      return ;
                                  }
                                  OPLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                                  NSDictionary *responseObject =  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                  NSString *code=[responseObject objectForKey:@"code"];
                                  if(code.intValue!=0)
                                  {
                                      NSString *msg=[responseObject objectForKey:@"msg"];
                                      return;
                                  }else{
                                      NSDictionary *dataDic = [responseObject objectForKey:@"data"];
                                      NSString *randomcode = [dataDic objectForKey:@"randomCode"];
                                      if(randomcode){
                                          self.randomCode = randomcode;
                                      }
                                  }
                              }];
    [task resume];
}




- (void)setAuthCode:(NSString *)AuthCode
{
    _AuthCode = AuthCode;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _authoCodeLabel.text = [NSString stringWithFormat:@"授权码: %@",AuthCode];
    });
    
}

- (void)setRandomCode:(NSString *)randomCode
{
    _randomCode = randomCode;
    dispatch_async(dispatch_get_main_queue(), ^{
        _randomCodeLabel.text = [NSString stringWithFormat:@"随机码: %@",randomCode];
    });
}

- (void)setOpenID:(NSString *)openID
{
    _openID = openID;
    dispatch_async(dispatch_get_main_queue(), ^{
        _openIdLabel.text = [NSString stringWithFormat:@"openId: %@", openID];
    });
    [self saveOpenId:openID];
}


- (IBAction)verifyRandomCodeAction:(id)sender {
    
    
    NSString *verifyCode = _verfiyTextFeild.text;
    if(verifyCode.length == 0){
        verifyCode = nil;
    }
    [[HETThirdCloudAuthorize shareInstance]autoAuthorizeWithRandomCode:_randomCode verificationCode:verifyCode withCompleted:^(NSString *openId, NSError *error) {
        OPLog(@"openId: %@", openId);
        if(error){
            [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
        }else

            if (openId) {
                self.openID = openId;
                
                [HETCommonHelp showHudAutoHidenWithMessage:@"授权成功"];
            }
    }];
}

- (IBAction)tapAction:(id)sender {
    [_verfiyTextFeild resignFirstResponder];
    [_telePhone resignFirstResponder];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)saveOpenId:(NSString *)openid
{
    //NSString *openId = @"07C28549DDB866E623D9A2F4A15D3F2B";
    [[NSUserDefaults standardUserDefaults]setObject:openid forKey:CloudAuthOpenIdKey];
}

- (void)clearOpenId
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:CloudAuthOpenIdKey];
    self.openID = @"";
}

- (NSString *)getOpenId
{
    NSString *openId = @"";
    NSString *saveOpenId =  [[NSUserDefaults standardUserDefaults]objectForKey:CloudAuthOpenIdKey];
    if (saveOpenId && saveOpenId.length > 0) {
        openId = saveOpenId;
    }
    return openId;
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
