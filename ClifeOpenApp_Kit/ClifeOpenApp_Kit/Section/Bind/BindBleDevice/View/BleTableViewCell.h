//
//  BleTableViewCell.h
//  ClifeOpenApp_Kit
//
//  Created by miao on 2017/9/19.
//  Copyright © 2017年 het. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BleTableViewCell : UITableViewCell
+ (instancetype)initWithTableView:(UITableView *)tabbleView;

- (void)refreshData:(CBPeripheral *)cbp productIcon:(NSString *)productIcon productName:(NSString*)productName;

@end
