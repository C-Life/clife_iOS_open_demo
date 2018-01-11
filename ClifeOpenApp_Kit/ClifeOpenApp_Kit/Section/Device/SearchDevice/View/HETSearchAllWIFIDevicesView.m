//
//  HETSearchAllWIFIDevicesView.m
//  HETPublicSDK_DeviceBind
//
//  Created by hcc on 16/8/30.
//  Copyright © 2016年 HET. All rights reserved.
//

#import "HETSearchAllWIFIDevicesView.h"
#import "CLWIFIBindBusiness.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HETAlertView.h"
#import "GloablMacro.h"
#import "HETBindingBusinessView.h"
#import "ReactiveCocoa.h"
#import "HETSearchAllWIFIDevicesCell.h"
#import "Masonry.h"
#import "AFNetworking.h"
@interface HETSearchAllWIFIDevicesView ()<CLWIFIBindBusinessDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray      *selectedDevArray;//选择的需要绑定的设备
    CLWIFIBindBusiness  *manager;
}
@property(strong,nonatomic)UIView               *bottomView;
@property(strong,nonatomic)UIView               *headerView;
@end

@implementation HETSearchAllWIFIDevicesView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self configUI];
    }
    return self;
}
- (void)configUI
{
    manager=[CLWIFIBindBusiness sharedInstance];
    manager.delegate=self;
    
    @weakify(self);
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.scanDeviceTableView];
    [self.scanDeviceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.mas_top);
    }];
}
- (void)bindAction
{
    if(selectedDevArray.count)
    {
        HETBindingBusinessView *bindView=[[HETBindingBusinessView alloc]init];
        bindView.bindType=1;
        bindView.deviceTypeId=self.deviceTypeId;
        bindView.deviceSubtypeId=self.deviceSubtypeId;
        bindView.objArray=selectedDevArray;
        [bindView configBasic];
        
// 绑定失败
        @weakify(bindView);
        bindView.newBindFail = ^{
          @strongify(bindView);
          [bindView bindFailFun];
        };
// 绑定成功
        @weakify(self);
        bindView.newBindSuccess = ^{
          @strongify(self);
        };
        
        for (UIView *obj in self.subviews)
        {
            if ([obj isKindOfClass:[HETBindingBusinessView class]])
            {
                [obj removeFromSuperview];
            }
        }
        [self addSubview:bindView];
        [self bringSubviewToFront:bindView];
    }
    else
    {
        HETAlertView *alert= [HETAlertView alertTitle:nil message:@"请选择设备" cancelButtonTitle:nil otherButtonTitle:@"确定"];
        @weakify(self);
        [alert showInView:self buttonClick:^{
            @strongify(self);
            
        }];
    }
}
- (void)startBinding
{
    CLWIFICommonReform *obj=_devicesDataSource[0];
    selectedDevArray = [[NSMutableArray alloc] init];
    [_devicesDataSource replaceObjectAtIndex:0 withObject:obj];
    [selectedDevArray addObject:obj];

    if(selectedDevArray.count)
    {
        HETBindingBusinessView *bindView=[[HETBindingBusinessView alloc]init];
        bindView.bindType=1;
        bindView.deviceTypeId=self.deviceTypeId;
        bindView.deviceSubtypeId=self.deviceSubtypeId;
        bindView.objArray=selectedDevArray;
        [bindView configBasic];
        
        // 绑定失败
        @weakify(bindView);
        bindView.newBindFail = ^{
            @strongify(bindView);
            [bindView bindFailFun];
            !self.bindFailure?:self.bindFailure();
        };
        // 绑定成功
        @weakify(self);
        bindView.newBindSuccess = ^{
            @strongify(self);
            !self.bindSuccess?:self.bindSuccess();
        };
        
        for (UIView *obj in self.subviews)
        {
            if ([obj isKindOfClass:[HETBindingBusinessView class]])
            {
                [obj removeFromSuperview];
            }
        }
        [self addSubview:bindView];
        [self bringSubviewToFront:bindView];
    }
    else
    {
        HETAlertView *alert= [HETAlertView alertTitle:nil message:@"请选择设备" cancelButtonTitle:nil otherButtonTitle:@"确定"];
        @weakify(self);
        [alert showInView:self buttonClick:^{
            @strongify(self);
            
        }];
    }
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _devicesDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 148 /2;
}
//单选
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HETSearchAllWIFIDevicesCell *cell=[HETSearchAllWIFIDevicesCell initWithTableView:tableView];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    CLWIFICommonReform *obj=_devicesDataSource[indexPath.row];
    [cell setChecked:obj.setChecked];
    [cell setDeviceMacLable:obj.device_mac ProductId:@(self.productId)];
    [cell setDeviceIconImageView:self.deviceIcon];
    [cell setDeviceNameLable:self.productName];

//    if(indexPath.row==0)//第一个默认选中
//    {
//        selectedDevArray = [[NSMutableArray alloc] init];
//        obj.setChecked=YES;
//        [_devicesDataSource replaceObjectAtIndex:indexPath.row withObject:obj];
//        [selectedDevArray addObject:obj];
//        [cell setChecked:YES];
//        
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HETSearchAllWIFIDevicesCell *cell = (HETSearchAllWIFIDevicesCell *)[tableView cellForRowAtIndexPath:indexPath];
    CLWIFICommonReform *obj=_devicesDataSource[indexPath.row];
    BOOL bSelected=obj.setChecked;
    
    for (int i = 0; i<[tableView numberOfRowsInSection:0]; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        HETSearchAllWIFIDevicesCell *cell = (HETSearchAllWIFIDevicesCell *)[tableView cellForRowAtIndexPath:indexPath];
        CLWIFICommonReform *obj=_devicesDataSource[indexPath.row];
        obj.setChecked=NO;
        [_devicesDataSource replaceObjectAtIndex:indexPath.row withObject:obj];
        [cell setChecked:NO];
    }
    if(!bSelected)
    {
        selectedDevArray = [[NSMutableArray alloc] init];
        obj.setChecked=YES;
        [_devicesDataSource replaceObjectAtIndex:indexPath.row withObject:obj];
        [selectedDevArray addObject:obj];
        [cell setChecked:YES];
        
        // 去绑定
        [self bindAction];
    }
    else
    {
        obj.setChecked=NO;
        [_devicesDataSource replaceObjectAtIndex:indexPath.row withObject:obj];
        [selectedDevArray removeObject:obj];
        [cell setChecked:NO];
    }
}
-(void)viewDidLayoutSubviews
{
    if ([self.scanDeviceTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.scanDeviceTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.scanDeviceTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.scanDeviceTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}


#pragma mark WIFIBindBusinessDelegate
//绑定失败
-(void)CLWIFIBindBusinessFail:(CLWIFICommonReform *)obj
{
    
}
//绑定成功
-(void)CLWIFIBindBusinessSuccess:(CLWIFICommonReform *)obj
{
    
}
//扫描到的设备
- (void)scanWIFIDevice:(id)CLWIFIBindBusiness BindDeviceInfo:(CLWIFICommonReform *)obj
{
    NSLog(@"obj:%@,%@",obj,obj.device_mac);
    if(!obj)
    {
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"device_mac == %@", obj.device_mac];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[_devicesDataSource filteredArrayUsingPredicate:predicate]];
    
    if(array.count==0||!array)
    {
        obj.productId=self.productId;
        obj.deviceID=self.deviceId;
        [_devicesDataSource addObject:obj];
       
        [self.scanDeviceTableView reloadData];
    }
}
- (void)textFieldEditChanged:(NSNotification *)obj
{
//    UITextField *textField = (UITextField *)obj.object;
//    UITextRange *selectedRange = [textField markedTextRange];
//    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];//获取高亮部分
//    if (!position)
//    {
//        NSInteger len = self.passwordField.text.length;
//        if (len != 0 && len <8)
//        {
//            self.nextBindButton.enabled = NO;
//            [self.nextBindButton setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.2]];
//        }
//        else
//        {
//            self.nextBindButton.enabled = YES;
//        }
//    }
}
#pragma mark 初始化UITableView
-(UITableView *)scanDeviceTableView
{
    if(!_scanDeviceTableView)
    {
        _scanDeviceTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _scanDeviceTableView.delegate = self;
        _scanDeviceTableView.dataSource = self;
        _scanDeviceTableView.scrollEnabled = NO;
        _scanDeviceTableView.backgroundColor = [UIColor clearColor];
        _scanDeviceTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _scanDeviceTableView;
}
//得到当前view所在的viewController
- (UIViewController *)currentViewController
{
    for (UIView* next = [self superview]; next; next =  next.superview)
    {         UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController  class]])
        {
            return (UIViewController*)nextResponder;
        }
    }     return nil;
}
@end
