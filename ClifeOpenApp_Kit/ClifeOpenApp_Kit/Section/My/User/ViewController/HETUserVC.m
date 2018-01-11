//
//  HETUserVC.m
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/8/29.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETUserVC.h"
#import "HETFeedbackOpinionVC.h"
#import "HETCommonIssuseVC.h"
#import "HETMessageVC.h"

#define cellH 44

@interface HETUserVC ()<UITableViewDataSource,UITableViewDelegate>
/** 个人信息列表 **/
@property (nonatomic,strong) UITableView                                           *myInfoTableView;
/** 退出登录按钮 **/
@property (nonatomic,strong) UIButton                                              *exitLoginBtn;
/** 个人信息数组 **/
@property (nonatomic,strong) NSMutableArray                                        *myInfoArr;
/** 授权登录manager **/
@property (nonatomic,strong) HETAuthorize                                          *auth;
/** 手机号码 **/
@property (nonatomic,copy) NSString                                                *phoneNum;
@end

@implementation HETUserVC
- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.设置背景颜色
    self.view.backgroundColor = VCBgColor;

    // 2.设置导航栏
    [self createNavViews];

    // 3.初始化界面
    [self createSubView];

    // 4.获取用户信息
    [self getUserInfo];

    self.myInfoArr =  [@[@[CurrentAccountStr,ChangePassWordStr],@[MyNewsStr],@[FAQStr,FeedbackStr,PrivacyPolicyStr,CopyrightStatementStr]]mutableCopy];
}

- (void)createNavViews
{
    // 1.中间标题
    self.navigationItem.title = MyVCTitle;

    // 2.添加返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

- (void)createSubView
{
    // 1.myInfo列表
    [self.view addSubview:self.myInfoTableView];
    [self.myInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    // 2.退出登录按钮
    // 退出按钮的高度
    CGFloat exitLoginBtnH = 44.0f *BasicHeight;
    [self.view addSubview:self.exitLoginBtn];
    [self.exitLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@(exitLoginBtnH));
    }];

    // 3.按钮上面的分割线
    UIView *line = [UIView new];
    [self.view addSubview:line];
    line.backgroundColor = [UIColor colorFromHexRGB:@"e2e2e2"];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.exitLoginBtn.mas_top);
        make.height.equalTo(@(0.5*BasicHeight));
    }];
}

- (void)getUserInfo
{
    WEAKSELF
    [HETAuthorize getUserInformationSuccess:^(id responseObject) {
        OPLog(@"responseObject ==%@",responseObject);
        OPLog(@"[NSThread currentThread] = %@",[NSThread currentThread]);
        STRONGSELF
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject allKeys] containsObject:@"data"]) {
                NSDictionary *dataDict = [responseObject valueForKey:@"data"];
                if ([[dataDict allKeys] containsObject:@"account"]) {
                    strongSelf.phoneNum = [dataDict valueForKey:@"account"];
                }
                [strongSelf.myInfoTableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        OPLog(@"error ==%@",error);
        [HETCommonHelp showHudAutoHidenWithMessage:@"获取用户信息失败"];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.myInfoArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.myInfoArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *ID = @"myInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
    }

    NSArray *arr = self.myInfoArr[indexPath.section];
    NSString *cellName = arr[indexPath.row];
    cell.textLabel.text = cellName;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = self.phoneNum;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"";
        }
    }

    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"";
    }

    if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"";
    }

    cell.textLabel.textColor = [UIColor colorFromHexRGB:@"000000"];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.textColor = [UIColor colorFromHexRGB:@"888888"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];


    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0 && indexPath.row == 1) {
        [self.auth changePasswordSuccess:^(id responseObject) {
            [HETCommonHelp showHudAutoHidenWithMessage:@"修改成功"];
        } failure:^(NSError *error) {
            [HETCommonHelp showHudAutoHidenWithMessage:@"修改失败"];
        }];
        return;
    }

    if (indexPath.section == 1 && indexPath.row == 0) {
        [HETCommonHelp showHudAutoHidenWithMessage:DeviceControlViewOndevelopment];
        return;
        HETMessageVC *messageVC = [HETMessageVC new];
        [self.navigationController pushViewController:messageVC animated:YES];
    }

    if (indexPath.section == 2 && indexPath.row == 0) {
        [HETCommonHelp showHudAutoHidenWithMessage:DeviceControlViewOndevelopment];
        return;
        HETCommonIssuseVC *commonIssuseVC = [HETCommonIssuseVC new];
        commonIssuseVC.issuseURL = @"https://cms.clife.cn/manages/mobile/cLife/faq/questions.html";
        [self.navigationController pushViewController:commonIssuseVC animated:YES];
    }

    if (indexPath.section == 2 && indexPath.row == 1) {
        [self.navigationController pushViewController:[HETFeedbackOpinionVC new] animated:YES];
    }

    if (indexPath.section == 2 && indexPath.row == 2) {
        [HETCommonHelp showHudAutoHidenWithMessage:DeviceControlViewOndevelopment];
        return;
        HETCommonIssuseVC *commonIssuseVC = [HETCommonIssuseVC new];
        commonIssuseVC.issuseURL = @"https://cms.clife.cn/manages/mobile/cLife/faq/questions.html";
        [self.navigationController pushViewController:commonIssuseVC animated:YES];
    }

    if (indexPath.section == 2 && indexPath.row == 3) {
        [HETCommonHelp showHudAutoHidenWithMessage:DeviceControlViewOndevelopment];
        return;
        HETCommonIssuseVC *commonIssuseVC = [HETCommonIssuseVC new];
        commonIssuseVC.issuseURL = @"https://cms.clife.cn/manages/mobile/cLife/faq/questions.html";
        [self.navigationController pushViewController:commonIssuseVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20 *BasicHeight)];
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 17*BasicHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

#pragma mark - BtnAction
- (void)exitLoginAction
{
    // 在授权登录成功的情况才执行操作
    if ([self.auth isAuthenticated]) {
        [self.auth unauthorize];
        if (![self.auth isAuthenticated])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (UITableView *)myInfoTableView
{
    if (!_myInfoTableView) {
        _myInfoTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myInfoTableView.backgroundColor = [UIColor clearColor];
        _myInfoTableView.dataSource = self;
        _myInfoTableView.delegate = self;
        _myInfoTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _myInfoTableView.bounces = NO;
        _myInfoTableView.tableFooterView = [UIView new];
    }
    return _myInfoTableView;
}

- (UIButton *)exitLoginBtn
{
    if (!_exitLoginBtn) {
        _exitLoginBtn = [UIButton new];
        [_exitLoginBtn setTitle:ExitLoginBtnTitle forState:UIControlStateNormal];
        _exitLoginBtn.backgroundColor = [UIColor whiteColor];
        [_exitLoginBtn setTitleColor:[UIColor colorFromHexRGB:@"ef4f4f"] forState:UIControlStateNormal];
        _exitLoginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_exitLoginBtn addTarget:self action:@selector(exitLoginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitLoginBtn;
}

- (NSMutableArray *)myInfoArr
{
    if (!_myInfoArr) {
        _myInfoArr = [NSMutableArray array];
    }
    return _myInfoArr;
}

- (HETAuthorize *)auth
{
    if (!_auth) {
        _auth = [[HETAuthorize alloc]init];
    }
    return _auth;
}

- (void)dealloc
{
    OPLog(@"%@ dealloc！！！",[self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
