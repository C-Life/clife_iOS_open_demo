//
//  YJSelectionView.m
//  YJSelectionView
//
//  Created by Jake on 2017/5/25.
//  Copyright © 2017年 Jake. All rights reserved.
//

#import "DeviceSelectionView.h"
#import "AppDelegate.h"
#import "AddDevcieCell.h"
#define kRootWindow  ((AppDelegate*)([UIApplication sharedApplication].delegate)).window

static const CGFloat tableViewMaxHeight = 300;
static const CGFloat rowHeight = 45;

@interface DeviceSelectionView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *bgView;
@end

@implementation DeviceSelectionView
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self configUI];
    }
    return self;
}
- (void)configUI
{
    self.bgView = [[UIView alloc]initWithFrame:self.bounds];
    self.bgView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView:)];
    [self.bgView addGestureRecognizer:tap];
    [self addSubview:self.bgView];

    self.devicesTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 720/2 *BasicHeight/*self.bounds.size.height - 326/2*/) style:UITableViewStylePlain];
    self.devicesTableView.dataSource = self;
    self.devicesTableView.delegate = self;
    self.devicesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_devicesTableView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSubTypeDeviceArr:(NSArray *)subTypeDeviceArr
{
    _subTypeDeviceArr = subTypeDeviceArr;
    [self.devicesTableView reloadData];
}

#pragma mark - TableViewDelegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subTypeDeviceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    AddDevcieCell *cell =  [AddDevcieCell initWithTableView:tableView];
    NSDictionary  *deviceDict = self.subTypeDeviceArr[indexPath.row];
    [cell refreshData1:deviceDict];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.completeSelection(indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}

#pragma mark - Action
- (void)tapBgView:(UITapGestureRecognizer *)sender {
    self.closeDevicesListView();
}
@end
