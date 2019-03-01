//
//  NetWorkErrorEmptyView.h
//  ClifeOpenApp_Kit
//
//  Created by Miao on 2018/7/27.
//  Copyright © 2018年 het. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ BtnBlock)(void);
@interface NetWorkErrorEmptyView : UIView
@property (nonatomic,strong) BtnBlock btnBlock;
@end
