//
//  HETMessageVC.m
//  ClifeOpenApp_Kit
//
//  Created by miao on 2017/9/30.
//  Copyright © 2017年 het. All rights reserved.
//

#import "HETMessageVC.h"
#import "HETSystemMessageVC.h"

#import "MessageTypeCell.h"

#import "HETMessageTypeModel.h"

#define cellH  72.0f

@interface HETMessageVC ()<UITableViewDataSource,UITableViewDelegate>
/** 消息类型列表 **/
@property (nonatomic,strong) UITableView                                           *messageTypeTableView;
/** 消息类型数组 **/
@property (nonatomic,strong) NSMutableArray                                        *messageTypeArr;
@end

@implementation HETMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.设置背景颜色
    self.view.backgroundColor = VCBgColor;

    // 2.设置导航栏
    [self createNavViews];

    // 3.初始化界面
    [self createSubView];

    self.messageTypeArr = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取消息类型
    [self getMessageTypeList];
}

- (void)createNavViews
{
    // 1.中间标题
    self.navigationItem.title = MessageCenterNavTitle;

    // 2.添加返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

- (void)createSubView
{
    [self.view addSubview:self.messageTypeTableView];
    [self.messageTypeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)getMessageTypeList{
    WEAKSELF
//    [HETApplicationMessageBusiness messageGetMsgTypeListSuccess:^(id responseObject) {
//        [weakSelf.messageTypeTableView.mj_header endRefreshing];
//        OPLog(@"responseObject ==%@",responseObject);
//        if ([[responseObject allKeys] containsObject:@"data"]) {
//            weakSelf.messageTypeArr = [HETMessageTypeModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
//            if (weakSelf.messageTypeArr.count>0) {
//                [weakSelf.messageTypeTableView reloadData];
//            }
//        }
//    } failure:^(NSError *error) {
//         [weakSelf.messageTypeTableView.mj_header endRefreshing];
//         OPLog(@"error ==%@",error);
//    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageTypeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MessageTypeCell *cell = [MessageTypeCell initWithTableView:tableView];
    [cell refreshData:self.messageTypeArr[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return cellH;
}

//大于3即各app独有类型，由各app去处理   /*0：系统消息，1：添加好友，2：邀请控制设备，3：帖子*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    HETMessageTypeModel *model = self.messageTypeArr[indexPath.row];
    if(model.messageType > 3) {
        return;
    }

//    HET *messageListVC = [HET new];
//    messageListVC.messageType = model.messageType;
//    [self.navigationController pushViewController:messageListVC animated:YES];
}

- (void)addTableViewRefreshHeader
{
    WEAKSELF
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf getMessageTypeList];
    }];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"XiaoC_loading@2x.gif" ofType:nil];
    UIImage *xiaoC_refresh = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:filePath]];
    [header setImages:xiaoC_refresh.images forState:MJRefreshStateIdle];
    [header setImages:xiaoC_refresh.images forState:MJRefreshStatePulling];
    [header setImages:xiaoC_refresh.images forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;

    self.messageTypeTableView.mj_header = header;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (UITableView *)messageTypeTableView
{
    if (!_messageTypeTableView) {
        _messageTypeTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _messageTypeTableView.backgroundColor = [UIColor clearColor];
        _messageTypeTableView.dataSource = self;
        _messageTypeTableView.delegate = self;
        _messageTypeTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _messageTypeTableView.separatorColor = [UIColor colorFromHexRGB:@"c6c6c6"];

        //去掉TableView中的默认横线
        _messageTypeTableView.tableFooterView = [UIView new];

        [self addTableViewRefreshHeader];
    }
    return _messageTypeTableView;
}

- (NSMutableArray *)messageTypeArr
{
    if (!_messageTypeArr) {
        _messageTypeArr = [NSMutableArray array];
    }
    return _messageTypeArr;
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
