//
//  HETShareDevcieVC.m
//  ClifeOpenApp_Kit
//
//  Created by miao on 2017/9/29.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETShareDevcieVC.h"
#import "HETShareCodeVC.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ShareAction.h"
#import "SGQRCodeGenerateManager.h"

#define cellH  72.0f
@interface HETShareDevcieVC ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
/** 分享用户列表 **/
@property (nonatomic,strong) UITableView                                           *shareUserTableView;

/** 分享用户数组 **/
@property (nonatomic,strong) NSMutableArray                                        *shareUserArr;

@end

@implementation HETShareDevcieVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.设置背景颜色
    self.view.backgroundColor = VCBgColor;

    // 2.设置导航栏
    [self createNavViews];

    // 3.初始化界面
    [self createSubView];
}

- (void)createNavViews
{
    // 1.导航栏标题
    self.navigationItem.title = ShareFriendNavTitle;

    // 2.添加返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];

    // 3.求解按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_addDevcie"] style:UIBarButtonItemStylePlain target:self action:@selector(addShareUser)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 获取当前已经分享设备的用户
    [self getShareUserList];
}

- (void)getShareUserList
{
    WEAKSELF
    [HETDeviceShareBusiness deviceGetAuthUserWithDeviceId:self.deviceId success:^(id responseObject) {
        STRONGSELF
        [strongSelf.shareUserTableView.mj_header endRefreshing];
        OPLog(@"responseObject == %@",responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            strongSelf.shareUserArr = [responseObject mutableCopy];
            [strongSelf.shareUserTableView reloadData];
        }
    } failure:^(NSError *error) {
        OPLog(@"error == %@",error);
        [HETCommonHelp showHudAutoHidenWithMessage:PuLLDownRefresh];
        [weakSelf.shareUserTableView.mj_header endRefreshing];
    }];
}

- (void)createSubView
{
    // 分享用户列表
    [self.view addSubview:self.shareUserTableView];
    [self.shareUserTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shareUserArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *ID = @"ShareUserCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.text = [self.shareUserArr[indexPath.row] valueForKey:@"phone"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [self deleteShareUser:indexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CommonDelete;
}

#pragma mark - DZNEmptyDataSetSource
//无数据占位
//无数据占位
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"deviceListVC_noData"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -64 *BasicHeight;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 16 *BasicHeight;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = ShareNoFriendAlert;

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f],NSForegroundColorAttributeName: [UIColor colorFromHexRGB:@"b9b9b9"]};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//是否显示空白页，默认YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)addShareUser
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [alert addAction:[UIAlertAction actionWithTitle:CommonCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];

    WEAKSELF
    [alert addAction:[UIAlertAction actionWithTitle:ShareFunctionFaceToFace style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        HETShareCodeVC *shareCodeVc = [HETShareCodeVC new];
        shareCodeVc.deviceId = weakSelf.deviceId;
        [weakSelf.navigationController pushViewController:shareCodeVc animated:YES];
    }]];
#warning 远程分享延期，暂时不提供
    [alert addAction:[UIAlertAction actionWithTitle:ShareFunctionThird style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HETDeviceShareBusiness getShareCodeWithDeviceId:self.deviceId shareType:HETDeviceShareType_ThirthShare success:^(id responseObject) {
            OPLog(@"responseObject == %@",responseObject);
            NSString *h5Url = [responseObject valueForKey:@"h5Url"];

            UIImage *shareCodeImage = [weakSelf setupGenerateQRCode:h5Url];

            ShareAction *shareAction = [[ShareAction alloc] init];
            shareAction.codeImage = shareCodeImage;
            shareAction.webpageUrl = h5Url;
            [shareAction show];

        } failure:^(NSError *error) {
            OPLog(@"error == %@",error);
            [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
        }];
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

// 生成二维码
- (UIImage *)setupGenerateQRCode:(NSString *)h5Url{
    // 将CIImage转换成UIImage，并放大显示
    return [SGQRCodeGenerateManager generateWithDefaultQRCodeData:h5Url imageViewWidth:300];
}

- (void)addTableViewRefreshHeader
{
    WEAKSELF
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf getShareUserList];
    }];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"XiaoC_loading@2x.gif" ofType:nil];
    UIImage *xiaoC_refresh = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:filePath]];
    [header setImages:xiaoC_refresh.images forState:MJRefreshStateIdle];
    [header setImages:xiaoC_refresh.images forState:MJRefreshStatePulling];
    [header setImages:xiaoC_refresh.images forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;

    self.shareUserTableView.mj_header = header;
}

- (void)deleteShareUser:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.shareUserArr[indexPath.row];
    NSString *userId = [dict valueForKey:@"userId"];

    WEAKSELF
    [HETDeviceShareBusiness deviceAuthDelWithDeviceId:self.deviceId userId:userId success:^(id responseObject) {
        // 删除数据源的数据,self.cellData是你自己的数据
        [weakSelf.shareUserArr removeObjectAtIndex:indexPath.row];
        // 删除列表中数据
        [weakSelf.shareUserTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        [weakSelf getShareUserList];
        [HETCommonHelp showHudAutoHidenWithMessage:CommonDeleteSuccess];
    } failure:^(NSError *error) {
        [HETCommonHelp showHudAutoHidenWithMessage:CommonDeleteFailed];
        [weakSelf.shareUserTableView endEditing:YES];
    }];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (UITableView *)shareUserTableView
{
    if (!_shareUserTableView) {
        _shareUserTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _shareUserTableView.backgroundColor = [UIColor clearColor];
        _shareUserTableView.dataSource = self;
        _shareUserTableView.delegate = self;
        _shareUserTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _shareUserTableView.separatorColor = [UIColor colorFromHexRGB:@"c6c6c6"];
        _shareUserTableView.emptyDataSetSource = self;
        _shareUserTableView.emptyDataSetDelegate = self;

        //去掉TableView中的默认横线
        _shareUserTableView.tableFooterView = [UIView new];

        [self addTableViewRefreshHeader];
    }
    return _shareUserTableView;
}

- (NSMutableArray *)shareUserArr
{
    if (!_shareUserArr) {
        _shareUserArr = [NSMutableArray array];
    }
    return _shareUserArr;
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
