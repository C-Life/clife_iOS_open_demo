//
//  DeviceDetailsCell.h
//  ClifeOpenApp_Kit
//
//  Created by Miao on 2018/5/17.
//  Copyright © 2018年 het. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceDetailsCell : UITableViewCell
+ (instancetype)initWithTableView:(UITableView *)tableView;

- (void)refreshData:(HETDevice *)device;
@end
