//
//  HETChangeWIFIViewController.m
//  HETPublicSDK_DeviceBind
//
//  Created by hcc on 2016/10/10.
//  Copyright © 2016年 HET. All rights reserved.
//

#import "HETChangeWIFIVC.h"
@interface HETChangeWIFIVC()

@property (strong,nonatomic) UILabel *titleLable;
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UIView *bottomView;
@property (strong,nonatomic) UIButton *iKnownButton;

@end

@implementation HETChangeWIFIVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = ChangeWifiTitle;

    [self createSubView];
}

#pragma mark - Init
- (void)createSubView {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.titleLable];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(17+64);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@23);
    }];

    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];

    [self.view addSubview:self.iKnownButton];
    [self.iKnownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@44);
    }];
}

#pragma mark - Event response
-(void)iKnownButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getters and setters
#pragma mark-----标题
-(UILabel *)titleLable
{
    if(!_titleLable)
    {
        _titleLable=[[UILabel alloc]initWithFrame:CGRectZero];
        _titleLable.textColor = [UIColor colorFromHexRGB:@"808080"];
        _titleLable.text = ChangeWifiAlertInfo;
        [_titleLable setFont:[UIFont systemFontOfSize:14]];
    }
    return _titleLable;
}

#pragma mark-----按钮
-(UIButton *)iKnownButton
{
    if(!_iKnownButton)
    {
        _iKnownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iKnownButton setTitle:CommoniKnoew forState:UIControlStateNormal];
        [_iKnownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_iKnownButton addTarget:self action:@selector(iKnownButtonAction) forControlEvents:UIControlEventTouchUpInside];
         _iKnownButton.backgroundColor = NavBarColor;
    }
    return _iKnownButton;
}

#pragma mark 帮助图片
-(UIImageView *)imageView{
    if(!_imageView)
    {
        _imageView = [[UIImageView alloc]init];
        UIImage *image = [UIImage imageNamed:@"changwifi_deviceBind"];
        _imageView.image = image;
    }
    return _imageView;
}
@end
