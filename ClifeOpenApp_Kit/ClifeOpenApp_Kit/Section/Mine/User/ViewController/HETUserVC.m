//
//  HETUserVC.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/8/29.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETUserVC.h"
#import "HETFeedbackVC.h"
#import "HETFAQVC.h"
#import "HETMessageVC.h"
#import "HETAboutVC.h"
#import "HETAccountSecurityVC.h"
#import "HETExitTableViewCell.h"

@interface HETUserVC ()<UITableViewDataSource,UITableViewDelegate>

///个人信息列表 **/
@property (nonatomic,strong) UITableView *tableView;
///退出登录按钮 **/
@property (nonatomic,strong) UIButton *exitLoginBtn;
///个人信息数组 **/
@property (nonatomic,strong) NSMutableArray *dataSource;
///用户资料 **/
@property (nonatomic,strong) NSDictionary *userInfoDict;
///账户与安全
@property (nonatomic,strong) NSDictionary *accountDict;
///清理缓存
@property (nonatomic,strong) NSDictionary *clearCacheDict;
///关于关于开放平台App
@property (nonatomic,strong) NSDictionary *aboutAppDict;
///常见问题
@property (nonatomic,strong) NSDictionary *questionDict;
///意见反馈
@property (nonatomic,strong) NSDictionary *suggestionDict;
///退出登录
@property (nonatomic,strong) NSDictionary *exitDict;
///我的消息
@property (nonatomic,strong) NSDictionary *messageDict;

@end

@implementation HETUserVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = MyVCTitle;
    [self createSubView];
    [self getUserInfo];
    [self createCellData];
}

#pragma mark - Init
- (void)createSubView
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)createCellData{
    
    self.accountDict = @{@"titleName":@"账户与安全",@"imageName":@"mineVC_accountSafe"};
    self.messageDict = @{@"titleName":@"我的消息", @"imageName":@"mineVC_clearCache"};
    self.clearCacheDict = @{@"titleName":@"清理缓存",@"imageName":@"mineVC_clearCache"};
    self.aboutAppDict = @{@"titleName":@"关于开放平台App",@"imageName":@"mineVC_aboutApp"};
    self.suggestionDict = @{@"titleName":@"意见反馈",@"imageName":@"mineVC_feedback"};
    self.questionDict = @{@"titleName":@"常见问题",@"imageName":@"mineVC_faq"};
    self.exitDict = @{@"titleName":@"退出登录"};
    self.dataSource =  [@[@[self.accountDict],@[self.messageDict],@[self.questionDict,self.suggestionDict,self.clearCacheDict,self.aboutAppDict],@[self.exitDict]]mutableCopy];
}

#pragma mark - Request
- (void)getUserInfo
{
    WEAKSELF
    [[HETAuthorize shareManager] getUserInformationSuccess:^(id responseObject) {
        OPLog(@"responseObject ==%@",responseObject);
        OPLog(@"[NSThread currentThread] = %@",[NSThread currentThread]);
        STRONGSELF
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject allKeys] containsObject:@"data"]) {
                strongSelf.userInfoDict = [responseObject valueForKey:@"data"];
            }
        }
    } failure:^(NSError *error) {
        OPLog(@"error ==%@",error);
        [HETCommonHelp showHudAutoHidenWithMessage:@"获取用户信息失败"];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataSource[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == self.dataSource.count - 1 ){
        HETExitTableViewCell * cell = [HETExitTableViewCell initWithTableView:tableView];
        return cell;
    }else{
        
        static NSString *ID = @"myInfoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        NSArray *array = self.dataSource[indexPath.section];
        NSDictionary *dict = array[indexPath.row];
        NSString *imageName = dict[@"imageName"];
        NSString *titleName = dict[@"titleName"];
        
        cell.imageView.image = [UIImage imageNamed:imageName];
        cell.textLabel.text = titleName;
        cell.textLabel.textAlignment = imageName.length == 0? NSTextAlignmentCenter : NSTextAlignmentLeft;
        cell.accessoryType = imageName.length == 0? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
        
        //清理缓存数据量
        if (dict == self.clearCacheDict) {
            NSString *sizeString = nil;
            cell.detailTextLabel.text = sizeString;
        }else{
            cell.detailTextLabel.text = nil;
        }
        
        cell.textLabel.textColor = OPColor(@"363636");
        cell.textLabel.font = OPFont(15);
        cell.detailTextLabel.textColor = OPColor(@"888888");
        cell.detailTextLabel.font = OPFont(15);
        return cell;
    }
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = self.dataSource[indexPath.section];
    NSDictionary *dict = array[indexPath.row];
    
    if (dict == self.accountDict) {
        HETAccountSecurityVC *accountSafeVC = [HETAccountSecurityVC new];
        accountSafeVC.userInfoDict = self.userInfoDict;
        [self.navigationController pushViewController:accountSafeVC animated:YES];
    }
    
    if (dict == self.messageDict) {
        [HETCommonHelp showHudAutoHidenWithMessage:DeviceControlViewOndevelopment];
        //        HETMessageVC *messageVC = [HETMessageVC new];
        //        [self.navigationController pushViewController:messageVC animated:YES];
    }
    
    if (dict == self.questionDict) {
        HETFAQVC *commonIssuseVC = [HETFAQVC new];
        commonIssuseVC.issuseURL = @"https://cms.clife.cn/manages/mobile/cLife/faq/questions.html";
        [self.navigationController pushViewController:commonIssuseVC animated:YES];
    }
    
    if (dict == self.suggestionDict) {
        [self.navigationController pushViewController:[HETFeedbackVC new] animated:YES];
    }
    
    if (dict == self.clearCacheDict) {
        [HETCommonHelp showHudAutoHidenWithMessage:DeviceControlViewOndevelopment];
    }
    
    if (dict == self.aboutAppDict) {
        HETAboutVC *commonIssuseVC = [HETAboutVC new];
        [self.navigationController pushViewController:commonIssuseVC animated:YES];
    }
    
    if (dict == self.exitDict) {
        [self exitLoginAction];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10 *BasicHeight)];
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == self.dataSource.count - 1 ){
        return 30;
    }else{
        return 10;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

#pragma mark - Event response
- (void)exitLoginAction
{
    // 在授权登录成功的情况才执行操作
    if ([[HETAuthorize shareManager] isAuthenticated]) {
        [[HETAuthorize shareManager] unauthorize];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - getters and setters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = OPColor(@"e5e5e5");
        _tableView.bounces = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
