//
//  DeviceCell.h
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/8/25.
//  Copyright © 2017年 het. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HETDeviceListCell : UITableViewCell
+ (instancetype)initWithTableView:(UITableView *)tabbleView;

- (void)refreshData:(HETDevice *)device;
@end
