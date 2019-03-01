//
//  HETAccountSecurityViewController.m
//  HETPublicSDK_Setting
//
//  Created by Newman on 16/2/19.
//  Copyright © 2016年 HET. All rights reserved.
//

#import "HETAccountSecurityVC.h"

@interface HETAccountSecurityVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * dataSource;

@end

@implementation HETAccountSecurityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"账号与安全";
    [self.view addSubview:self.tableView];
}

#pragma mark --UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    
    cell.accessoryType = indexPath.section > 1? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    if(indexPath.section == 0){
        if ([[self.userInfoDict allKeys] containsObject:@"userName"]) {
            cell.detailTextLabel.text = [self.userInfoDict valueForKey:@"userName"];
        } else{
            cell.detailTextLabel.text = @"";
        }
    }
    
    if(indexPath.section == 1){
        if ([[self.userInfoDict allKeys] containsObject:@"account"]) {
            cell.detailTextLabel.text = [self.userInfoDict valueForKey:@"account"];
        } else{
            cell.detailTextLabel.text = @"";
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1 && self.dataSource.count == 2) {
        return 60.f;
    }
    return 15.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 2){
        [self modifyPassword];
    }
}

#pragma mark - Event response
/**
 *  修改密码
 */
- (void)modifyPassword{
    [[HETAuthorize shareManager] changePasswordSuccess:^(id responseObject) {
        [HETCommonHelp showHudAutoHidenWithMessage:@"修改成功"];
    } failure:^(NSError *error) {
        OPLog(@"error = %@",error);
        [HETCommonHelp showHudAutoHidenWithMessage:@"修改失败"];
    }];
}

#pragma mark - getters and setters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStyleGrouped];
        _tableView.tableFooterView.frame = CGRectZero;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        UIView *vi = [UIView new];
        vi.frame = CGRectMake(0, 0, 1, 15.f);
        _tableView.tableHeaderView = vi;
        _tableView.separatorColor = OPColor(@"c6c6c6");
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(NSArray *)dataSource{
    if (!_dataSource) {
        NSMutableArray<NSMutableArray *> *arry = [NSMutableArray arrayWithObject:@[@"会员名"].mutableCopy];
        [arry addObject:@[@"当前账户"].mutableCopy];
        [arry addObject:@[@"设置密码"].mutableCopy];
        _dataSource = [arry copy];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
