//
//  HETShareCodeVC.m
//  ClifeOpenApp_Kit
//
//  Created by miao on 2017/9/29.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETShareCodeVC.h"
#import "SGQRCodeGenerateManager.h"

@interface HETShareCodeVC ()
/** 分享二维码 **/
@property (nonatomic,strong) UIImageView                                           *codeImageView;

/** 分享文字 **/
@property (nonatomic,strong) UILabel                                               *shareTipLabel;

@end

@implementation HETShareCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.设置背景颜色
    self.view.backgroundColor = VCBgColor;

    // 2.设置导航栏
    [self createNavViews];

    // 3.初始化界面
    [self createSubView];

    // 4.获取设备分享码
    [self getShareCode];
}

- (void)createNavViews
{
    // 1.导航栏标题
    self.navigationItem.title = ShareFunctionFaceToFace;

    // 2.添加返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

- (void)createSubView
{
    [self.view addSubview:self.codeImageView];
    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];

    [self.view addSubview:self.shareTipLabel];
    [self.shareTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.codeImageView.mas_bottom).offset(60);
        make.left.equalTo(self.view).offset(32);
        make.right.equalTo(self.view).offset(-32);
    }];
}

- (void)getShareCode{
    WEAKSELF
    [HETDeviceShareBusiness getShareCodeWithDeviceId:self.deviceId shareType:HETDeviceShareType_FaceToFaceShare success:^(id responseObject) {
        OPLog(@"responseObject == %@",responseObject);
        NSString *shareCode = [responseObject valueForKey:@"shareCode"];
        [weakSelf setupGenerateQRCode:shareCode];
    } failure:^(NSError *error) {
        OPLog(@"error == %@",error);
         [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
    }];
}

// 生成二维码
- (void)setupGenerateQRCode:(NSString *)shareCode{
    NSString *code = [NSString stringWithFormat:@"shareCode=%@",shareCode];
    // 将CIImage转换成UIImage，并放大显示
    self.codeImageView.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:code imageViewWidth:300];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (UIImageView *)codeImageView
{
    if (!_codeImageView) {
        _codeImageView = [UIImageView new];
        _codeImageView.backgroundColor = [UIColor colorFromHexRGB:@"ffffff"];
    }
    return _codeImageView;
}

- (UILabel *)shareTipLabel
{
    if (!_shareTipLabel) {
        _shareTipLabel = [UILabel new];
        _shareTipLabel.text = ShareFunctionAlertTips;
        _shareTipLabel.numberOfLines = 0;
    }
    return _shareTipLabel;
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
