//
//  HETBindGPRSDeviceVC.m
//  ClifeOpenApp_Kit
//
//  Created by miao on 2018/1/16.
//  Copyright © 2018年 het. All rights reserved.
//

#import "HETBindGPRSDeviceVC.h"
#import "AirPuriflerBindView.h"

@interface HETBindGPRSDeviceVC ()
/** GPRS绑定界面 **/
@property(nonatomic,strong) AirPuriflerBindView                     *bindView;
@end

@implementation HETBindGPRSDeviceVC

- (void)viewDidLoad{

    [super viewDidLoad];

    // 1.设置背景颜色
    self.view.backgroundColor = VCBgColor;

    // 2.设置导航栏
    [self createNavViews];

    // 3.初始化界面
    [self createSubView];

    // 4.获取设备信息
    [self requestDeviceModel];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHiden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)createNavViews
{
    // 1.导航栏标题
    self.navigationItem.title = @"设备绑定";
}

- (void)createSubView
{
    WEAKSELF

    self.bindView = [[AirPuriflerBindView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64) AndDeviceName:self.device.productName?:@"设备"  AndButtonClick:^(NSString *text,UIButton *button){
        STRONGSELF
        [strongSelf buttonAction:text AndButton:button];
    }];
    [self.view addSubview:self.bindView];

    if (self.imei && self.imei.length > 0) {
        self.bindView.IMEITextField.text = self.imei;
    }else if (self.mac && self.mac.length > 0) {
        self.bindView.IMEITextField.text = self.mac;
    }else{
        self.bindView.IMEITextField.text = @"";
    }
}

//MARK:----------------请求设备信息
- (void)requestDeviceModel{
    //如果当前设备没有获取到对应的设备名称 重新获取

    if (!self.device ||!self.device.productName || self.device.productName.length == 0) {
        WEAKSELF
        [HETDeviceRequestBusiness fetchDeviceInfoWithProductId:self.productId success:^(id responseObject) {
            STRONGSELF
            if ([[responseObject allKeys] containsObject:@"data"]) {
                NSDictionary *dataDict = [responseObject valueForKey:@"data"];
                // 根据moduleType 区分设备绑定类型
                HETDevice *device = [HETDevice mj_objectWithKeyValues:dataDict];
                strongSelf.device = device;
                strongSelf.productId = [NSString stringWithFormat:@"%@",self.device.productId];
                [strongSelf.bindView reloadDeviceName:strongSelf.device];
            }
        } failure:^(NSError *error) {
            STRONGSELF
            // msg=appId与产品未做关联
            if (error.code == 100022013) {
                [HETCommonHelp showHudAutoHidenWithMessage:@"appId与产品未做关联"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        }];
    }
}

#pragma mark-================事件========================
- (void)keyBoardShow:(NSNotification *)notification{

    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGFloat keyboardY = keyboardFrame.origin.y;
    [UIView animateWithDuration:0.5 animations:^{
        self.bindView.transform = CGAffineTransformMakeTranslation(0, (keyboardY - ScreenHeight)/2);
    }];
}

- (void)keyBoardHiden:(NSNotification *)notification{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGFloat keyboardY = keyboardFrame.origin.y;
    [UIView animateWithDuration:0.5 animations:^{
        self.bindView.transform = CGAffineTransformMakeTranslation(0,  keyboardY - ScreenHeight);
    }];
}

- (void)buttonAction:(NSString *)text AndButton:(UIButton *)button {

    [self.bindView hiddenKeyBoard];
    if (text.length == 0) {
        [HETCommonHelp showHudAutoHidenWithMessage:@"输入不能为空" toView:self.view];
        return;
    }

    button.enabled = NO;

    // 手动输入的text,根据text长度来覆盖mac、imei
    if (text.length > 0 && text.length == 15) {
        self.imei = text;
    }
    else if (text.length > 0 && text.length == 12) {
        self.mac = text;
    }else{
        [HETCommonHelp showHudAutoHidenWithMessage:@"请输入标准的MAC地址或者IMEI码" toView:self.view];
        button.enabled = YES;
        return;
    }

    [HETCommonHelp showMessage:@"绑定中..." toView:self.view];
    WEAKSELF
    [HETDeviceRequestBusiness bindGRPSDeviceWithMac:self.mac deviceImei:self.imei productId:[NSString stringWithFormat:@"%@",self.device.productId] success:^(id responseObject) {
        STRONGSELF
        [HETCommonHelp hideHudFromView:weakSelf.view];
        [HETCommonHelp showHudAutoHidenWithMessage:@"绑定成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBindDeviceSuccess object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        STRONGSELF
        [HETCommonHelp hideHudFromView:strongSelf.view];
        [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
        button.enabled = YES;
    }];
}

- (BOOL)validateNumber:(NSString *) textString
{
    NSString* number=@"^[A-Za-z0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

- (void)dealloc{
    OPLog(@"%@ dealloc！！！",[self class]);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
