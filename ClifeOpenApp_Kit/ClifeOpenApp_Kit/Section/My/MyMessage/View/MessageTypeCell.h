//
//  MessageTypeCell.h
//  ClifeOpenApp_Kit
//
//  Created by miao on 2017/9/30.
//  Copyright © 2017年 het. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HETMessageTypeModel.h"

@interface MessageTypeCell : UITableViewCell
+ (instancetype)initWithTableView:(UITableView *)tabbleView;

- (void)refreshData:(HETMessageTypeModel *)model;
@end
