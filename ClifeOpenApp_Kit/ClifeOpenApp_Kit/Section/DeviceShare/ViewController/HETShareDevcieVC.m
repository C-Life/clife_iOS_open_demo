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

@interface HETShareDevcieVC ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) NSString *deviceId;
///分享用户列表
@property (nonatomic,strong) UITableView *shareUserTableView;
///分享用户数组
@property (nonatomic,strong) NSMutableArray *shareUserArr;

@end

@implementation HETShareDevcieVC

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavViews];
    [self createSubView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 获取当前已经分享设备的用户
    [self getShareUserList];
}

#pragma mark - Init
- (void)createNavViews
{
    // 1.导航栏标题
    self.navigationItem.title = ShareFriendNavTitle;
    
    // 2.添加返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    // 3.求解按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"deviceListVC_nav_addDevcie"] style:UIBarButtonItemStylePlain target:self action:@selector(addShareUser)];
}

- (void)createSubView
{
    // 分享用户列表
    [self.view addSubview:self.shareUserTableView];
    [self.shareUserTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - Request
- (void)getShareUserList
{
    WEAKSELF
    [HETDeviceShareBusiness deviceGetAuthUserWithDeviceId:self.deviceId success:^(id responseObject) {
        STRONGSELF
        [strongSelf.shareUserTableView.mj_header endRefreshing];
        OPLog(@"responseObject == %@",responseObject);
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject allKeys] containsObject:@"data"]) {
                NSArray *shareUserListArr = [responseObject valueForKey:@"data"];
                strongSelf.shareUserArr = [shareUserListArr mutableCopy];
                [strongSelf.shareUserTableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        STRONGSELF
        OPLog(@"error == %@",error);
        [HETCommonHelp showHudAutoHidenWithMessage:PuLLDownRefresh];
        [strongSelf.shareUserTableView.mj_header endRefreshing];
    }];
}

- (void)getShareCode{
    [HETDeviceShareBusiness getShareCodeWithDeviceId:self.deviceId shareType:HETDeviceShareType_ThirthShare success:^(id responseObject) {
        OPLog(@"responseObject == %@",responseObject);

        NSString *h5Url = @"";
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject allKeys] containsObject:@"data"]) {
                NSDictionary *dict = [responseObject valueForKey:@"data"];
                h5Url = [dict valueForKey:@"h5Url"];
            }
        }
        
        UIImage *codeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.deviceModel.productIcon]]];
        CGSize imageSize = codeImage.size;
        if (imageSize.width > 310 || imageSize.height > 310) {
            codeImage = [self scaleToSize:codeImage size:CGSizeMake(300, 300)];
        }
        
        ShareAction *shareAction = [[ShareAction alloc] init];
        shareAction.codeImage = codeImage;
        shareAction.webpageUrl = h5Url;
        [shareAction show];
        
    } failure:^(NSError *error) {
        OPLog(@"error == %@",error);
        [HETCommonHelp showHudAutoHidenWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
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
    
    static NSString *ID = @"kShareUserCellIdentifier";
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
    
    return 72.0f;
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

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - Event response
- (void)addShareUser
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:CommonCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    WEAKSELF
    [alert addAction:[UIAlertAction actionWithTitle:ShareFunctionFaceToFace style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONGSELF
        HETShareCodeVC *shareCodeVc = [HETShareCodeVC new];
        shareCodeVc.deviceId = strongSelf.deviceId;
        [strongSelf.navigationController pushViewController:shareCodeVc animated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:ShareFunctionThird style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONGSELF
        [strongSelf getShareCode];
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
    self.shareUserTableView.mj_header = [HETComRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getShareUserList];
    }];
}

- (void)deleteShareUser:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.shareUserArr[indexPath.row];
    NSString *userId = [dict valueForKey:@"userId"];
    
    WEAKSELF
    [HETDeviceShareBusiness deviceAuthDelWithDeviceId:self.deviceId userId:userId success:^(id responseObject) {
        STRONGSELF
        // 删除数据源的数据,self.cellData是你自己的数据
        [strongSelf.shareUserArr removeObjectAtIndex:indexPath.row];
        // 删除列表中数据
        [strongSelf.shareUserTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [strongSelf getShareUserList];
        [HETCommonHelp showHudAutoHidenWithMessage:CommonDeleteSuccess];
    } failure:^(NSError *error) {
        STRONGSELF
        [HETCommonHelp showHudAutoHidenWithMessage:CommonDeleteFailed];
        [strongSelf.shareUserTableView endEditing:YES];
    }];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - getters and setters
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

- (void)setDeviceModel:(HETDevice *)deviceModel
{
    if (_deviceModel != deviceModel) {
        _deviceModel = deviceModel;
        _deviceId = deviceModel.deviceId;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
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
