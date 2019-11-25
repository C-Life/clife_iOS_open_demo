//
//  HETDeviceUpgradeController.m
//  HETPublic
//
//  Created by tl on 15/8/17.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import "HETDeviceUpgradeController.h"
#import "HETPublicLoadingInView.h"
#import "HETCoreResource.h"
#import "CCCommonHelp.h"
#import "HETDUResource.h"
#import "HETPublicUIConfig+Fetch.h"

@interface HETDeviceUpgradeController ()

@property (nonatomic,strong) UIView *progressView;
@property (nonatomic,strong) UIView *progressBgView;
@property (nonatomic,strong) HETPublicLoadingInView *loadingView;
@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UILabel *label2;
@property (nonatomic,strong) UILabel *label3;
@property (nonatomic,strong) UIButton *functionBtn;
@property (nonatomic,assign) LoadingState upgradeState;

@property (nonatomic,strong) UILabel *deviceLabel;
@property (nonatomic,strong) UILabel *macLabel;

@end

@implementation HETDeviceUpgradeController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self configUIs];
    
    @weakify(self);
    [[RACObserve(self, viewModel) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self);
        [self configViewModel];
    }];
}
-(void)configViewModel{
    @weakify(self);
    self.upgradeState = LoadingStatePreLoading;
    [RACObserve(self.viewModel, tipMsg) subscribeNext:^(NSString *errorMsg) {
        if (errorMsg.length >0) {
            [CCCommonHelp showAutoDissmissAlertView:nil msg:errorMsg];
        }
    }];
    
    [RACObserve(self.viewModel, progress) subscribeNext:^(NSNumber *progress) {
        @strongify(self);
        [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.progressBgView.mas_width).multipliedBy(progress.floatValue);
            make.height.equalTo(self.progressBgView);
            make.left.equalTo(self.progressBgView);
            make.top.equalTo(self.progressBgView);
        }];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
    self.viewModel.upgradeSuccess = ^{
        @strongify(self);
        self.upgradeState = LoadingStateSuccess;
    };
    
    self.viewModel.upgradeFailure = ^{
        @strongify(self);
        self.upgradeState = LoadingStateFailure;
    };
    [RACObserve(self, upgradeState) subscribeNext:^(id x) {
        @strongify(self);
        [self configUIState];
    }];
}

-(void)configUIs{
    self.title = HETDULocalizedString(@"设备固件升级");
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.loadingView = [HETPublicLoadingInView inView:self.view y:44.f];
    self.progressBgView = [UIView new];
    self.progressBgView.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:223/255.0 alpha:1];
    self.progressBgView.layer.cornerRadius = 2.f;
    
    [self.view addSubview:self.progressBgView];
    [self.progressBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(127.f);
        make.right.equalTo(self.view.mas_right).offset(-127.f);
        make.centerX.equalTo(self.loadingView.mas_centerX);
        make.top.equalTo(self.loadingView.mas_bottom).offset(15);
        make.height.mas_equalTo(4.f);
    }];
    self.progressView = [UIView new];
    self.progressView.layer.cornerRadius = 2.f;
    if ([self.viewModel respondsToSelector:@selector(progressColor)] && [self.viewModel progressColor]) {
        self.progressView.backgroundColor = [self.viewModel progressColor];
    }else{
        self.progressView.backgroundColor = self.navigationController.navigationBar.barTintColor;
    }
    
    [self.progressBgView addSubview:self.progressView];
    
    
    self.label1 = [UILabel new];
    self.label1.textColor = [[UIColor colorFromHexRGB:@"5e5e5e"] colorWithAlphaComponent:0.6];
    self.label1.font = [UIFont systemFontOfSize:17.f];
    //    self.label1.text = @"固件升级";
    [self.view addSubview:self.label1];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loadingView.mas_centerX);
        make.top.equalTo(self.progressBgView.mas_bottom).offset(20);
        make.height.mas_equalTo(18);
    }];
    
    self.label2 = [UILabel new];
    self.label2.textColor = [[UIColor colorFromHexRGB:@"919191"] colorWithAlphaComponent:0.4];
    self.label2.font = [UIFont systemFontOfSize:12.f];
    //    self.label2.text = [NSString stringWithFormat:@"检测到新版本%@，马上更新",self.viewModel.versionModel.newDeviceVersion];
    [self.view addSubview:self.label2];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loadingView.mas_centerX);
        make.top.equalTo(self.label1.mas_bottom).offset(7);
        make.height.mas_equalTo(15);
    }];
    
    self.label3 = [UILabel new];
    self.label3.textColor = [[UIColor colorFromHexRGB:@"919191"] colorWithAlphaComponent:0.4];
    self.label3.font = [UIFont systemFontOfSize:12.f];
    //    self.label3.text = @"奔跑吧！小C";
    [self.view addSubview:self.label3];
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loadingView.mas_centerX);
        make.top.equalTo(self.label2.mas_bottom).offset(7);
        make.height.mas_equalTo(15);
    }];
    
    self.functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.functionBtn];
    [self.functionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(139, 37));
        make.centerX.equalTo(self.loadingView.mas_centerX);
        make.top.equalTo(self.label3).offset(48.f);
    }];
    self.functionBtn.layer.borderWidth = 1.f;
    self.functionBtn.layer.cornerRadius = 4.f;
    [self.functionBtn setTitle:HETDULocalizedString(@"升级中") forState:UIControlStateDisabled];
    [self.functionBtn setTitle:HETDULocalizedString(@"重新配置") forState:UIControlStateNormal];
    [self.functionBtn setTitleColor:[UIColor colorFromHexRGB:@"919191"] forState:UIControlStateDisabled];
    [self.functionBtn setTitleColor:[UIColor colorFromHexRGB:@"ef4f4f"] forState:UIControlStateNormal];
    [self.functionBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.macLabel = [UILabel new];
    self.macLabel.textColor = [[UIColor colorFromHexRGB:@"919191"] colorWithAlphaComponent:0.4];
    self.macLabel.font = [UIFont systemFontOfSize:12.f];
    self.macLabel.text = [NSString stringWithFormat:HETDULocalizedString(@"Mac地址：%@"),self.viewModel.deviceInfo.macAddress];
    [self.view addSubview:self.macLabel];
    [self.macLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loadingView.mas_centerX);
        make.bottom.equalTo(self.view).offset(-44.f);
        make.height.mas_equalTo(15);
    }];
    
    self.deviceLabel = [UILabel new];
    self.deviceLabel.textColor = [[UIColor colorFromHexRGB:@"919191"] colorWithAlphaComponent:0.4];
    self.deviceLabel.font = [UIFont systemFontOfSize:12.f];
    self.deviceLabel.text = [NSString stringWithFormat:HETDULocalizedString(@"设备型号：%@"),self.viewModel.deviceInfo.productCode];
    [self.view addSubview:self.deviceLabel];
    [self.deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loadingView.mas_centerX);
        make.bottom.equalTo(self.macLabel.mas_top).offset(0);
        make.height.mas_equalTo(15);
    }];
}

//下面的按钮点击，升级流程全靠按钮点击
-(void)btnClick{
    if (self.upgradeState == LoadingStateFailure || self.upgradeState == LoadingStatePreLoading) {
        
        self.upgradeState = LoadingStateLoading;
        [self.viewModel upgrade];
        
    }else if (self.upgradeState == LoadingStateSuccess){
        !self.upgradeSuccess?:self.upgradeSuccess();
    }
}

//根据状态调整UI
-(void)configUIState{
    //    self.label1.text = isFailure?@"配置失败":@"正在配置页面";
    //    self.label2.text = isFailure?@"网络请求失败，请重新配置！":@"可能时间比较长，请耐心等待~";
    //    self.label3.text = isFailure?@"累死宝宝了~":@"奔跑吧！小C";
    if (LoadingStateSuccess == _upgradeState ) {
        self.functionBtn.layer.borderColor = [UIColor colorFromHexRGB:@"ef4f4f"].CGColor;
        self.functionBtn.enabled = YES;
        [self.functionBtn setTitle:HETDULocalizedString(@"确定") forState:UIControlStateNormal];
        //隐藏后退按钮
        [self.navigationItem setBackBarButtonItem:nil];
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.navigationItem setHidesBackButton:YES];
    }else if (LoadingStateLoading == _upgradeState){
        self.functionBtn.layer.borderColor = [UIColor colorFromHexRGB:@"919191"].CGColor;
        self.functionBtn.enabled = NO;
        //隐藏后退按钮
        [self.navigationItem setBackBarButtonItem:nil];
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.navigationItem setHidesBackButton:YES];
        
    }else if (LoadingStateFailure == _upgradeState){
        self.functionBtn.layer.borderColor = [UIColor colorFromHexRGB:@"ef4f4f"].CGColor;
        self.functionBtn.enabled = YES;
        [self.functionBtn setTitle:HETDULocalizedString(@"刷新") forState:UIControlStateNormal];
        //显示后退按钮
        //        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        backButton.frame = CGRectMake(0, 0, 30, 30);
        //        if (objc_getAssociatedObject(self, @selector(het_navBackButtonItemImage:))) {
        //            [backButton setImage: objc_getAssociatedObject(self, @selector(het_navBackButtonItemImage:)) forState:UIControlStateNormal];
        //        }else{
        //            [backButton setImage: [UIImage imageNamed:@"login_backButton"] forState:UIControlStateNormal];
        //        }
        //        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        //        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton] animated:NO];
        
        
        UIButton *backButton = objc_getAssociatedObject([HETPublicUIConfig class], @selector(het_navBackCustomButton:));
        
        if (backButton) {
        }else{
            //后退按钮
            backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            backButton.frame = CGRectMake(0, 0, 30, 30);
            if (objc_getAssociatedObject([HETPublicUIConfig class], @selector(het_navBackButtonItemImage:))) {
                [backButton setImage: objc_getAssociatedObject([HETPublicUIConfig class], @selector(het_navBackButtonItemImage:)) forState:UIControlStateNormal];
            }else{
                [backButton setImage: [HETCoreResource imageNamed:@"login_backButton"] forState:UIControlStateNormal];
            }
        }
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton] animated:NO];
        
        
        
    }else if (LoadingStatePreLoading == _upgradeState){
        self.functionBtn.layer.borderColor = [UIColor colorFromHexRGB:@"ef4f4f"].CGColor;
        self.functionBtn.enabled = YES;
        [self.functionBtn setTitle:HETDULocalizedString(@"升级") forState:UIControlStateNormal];
    }
    
    [self.loadingView setLoadingState:_upgradeState];
    
    if ([self.viewModel titleAtIndex:0 timeLine:_upgradeState].length > 0 ) {
        self.label1.text = [self.viewModel titleAtIndex:0 timeLine:_upgradeState];
    }
    if ([self.viewModel titleAtIndex:1 timeLine:_upgradeState].length > 0) {
        self.label2.text = [self.viewModel titleAtIndex:1 timeLine:_upgradeState];
    }
    if ([self.viewModel titleAtIndex:2 timeLine:_upgradeState].length > 0) {
        self.label3.text = [self.viewModel titleAtIndex:2 timeLine:_upgradeState];
    }
}

#pragma mark ----system method
-(void)backAction{
    !self.upgradeFailure?:self.upgradeFailure();
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([HETPublicUIConfig start_het_viewInteractivePopDisabled]) {
        [HETPublicUIConfig start_het_viewInteractivePopDisabled](self);
    }
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
