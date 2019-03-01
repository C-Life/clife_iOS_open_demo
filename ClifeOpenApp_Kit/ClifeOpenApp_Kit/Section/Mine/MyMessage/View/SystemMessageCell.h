//
//  SystemMessageCell.h
//  ClifeOpenApp_Kit
//
//  Created by miao on 2017/10/9.
//  Copyright © 2017年 het. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemMessageCell : UITableViewCell
@property (nonatomic,copy)void (^deleteBtnClick)();
+ (instancetype)initWithTableView:(UITableView *)tabbleView;
@end
