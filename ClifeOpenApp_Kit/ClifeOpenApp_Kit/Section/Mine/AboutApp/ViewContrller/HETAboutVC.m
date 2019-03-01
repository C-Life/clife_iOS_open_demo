//
//  HETAboutVC.m
//  ClifeOpenApp_Kit
//
//  Created by Miao on 2018/6/22.
//  Copyright © 2018年 het. All rights reserved.
//

#import "HETAboutVC.h"
#import "HETAppUpgradeCheck.h"
#import "HETAPPIntrodutionVC.h"
NSString * const kSettingAboutCellID = @"cell";
@interface HETAboutVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *versionLabel;
@property (nonatomic,strong) UILabel  *copyrightLabel;

@end

@implementation HETAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于APP";
    
    [self createSubView];
}

- (void)createSubView
{
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 210)];
    
    // appLogo
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.iconImageView.image = [UIImage imageNamed:@"AboutVc_LOGO"];
    self.iconImageView.layer.cornerRadius = 10;
    self.iconImageView.layer.masksToBounds = YES;
    [view addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(99,99));
        make.top.equalTo(view.mas_top).offset(44.f);
        make.centerX.equalTo(view);
    }];
    
    // app版本
    _versionLabel = [UILabel new];
    _versionLabel.textColor = OPColor(@"5e5e5e");
    _versionLabel.font = OPFont(17);
    [view addSubview:_versionLabel];
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(20);
        make.height.equalTo(@18.f);
        make.centerX.equalTo(view);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).valueOffset([NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 70, 0)]);
    }];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSettingAboutCellID];
    _tableView.tableHeaderView = view;
    _tableView.tableFooterView = [UIView new];
    
    _copyrightLabel = [UILabel new];
    [self.view addSubview:_copyrightLabel];
    _copyrightLabel.textAlignment = NSTextAlignmentCenter;
    _copyrightLabel.numberOfLines = 2;
    _copyrightLabel.font = OPFont(15);
    _copyrightLabel.textColor = OPColor(@"5e5e5e");
    [_copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50.f);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20.f);
        make.centerX.equalTo(self.view);
    }];
    
    NSString *labelText = @"Copyright ©2017 C-Life\n 深圳和而泰家居在线网络科技有限公司";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:10];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    _copyrightLabel.attributedText = attributedString;
    _copyrightLabel.textAlignment = NSTextAlignmentCenter;
    
    // 当前版本
    UILabel *appNameLabel = [[UILabel alloc]init];
    [self.view addSubview:appNameLabel];
    [appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(30*BasicHeight);
    }];
    
    appNameLabel.textColor = OPColor(@"888888");
    appNameLabel.font = OPFont(15);
    
    NSString *versionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    versionStr = [versionStr stringByAppendingString: @"."];
    versionStr = [versionStr stringByAppendingString: [NSString stringWithFormat:@"(%@)",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]]];
    
    appNameLabel.text = [NSString stringWithFormat:@"开放平台DemoApp当前版本 %@",versionStr];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingAboutCellID forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == 0){
        cell.textLabel.text = @"功能介绍";
    }else{
        cell.textLabel.text = @"检查最新版本";
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HETAPPIntrodutionVC *introductionVC = [[HETAPPIntrodutionVC alloc] init];
        [self.navigationController pushViewController:introductionVC animated:YES];
    }else{
        [HETAppUpgradeCheck activeAppUpgradeCheck:nil];
    }
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
