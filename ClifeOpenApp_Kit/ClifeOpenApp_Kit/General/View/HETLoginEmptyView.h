//
//  UnLoginEmptyView.h
//  ClifeOpenApp_Kit
//
//  Created by Miao on 2018/7/26.
//  Copyright © 2018年 het. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ NetWorkBlock)(void);
typedef void (^ LoginBlock)(void);
@interface HETLoginEmptyView : UIView
@property (nonatomic,strong) NetWorkBlock netWorkBlock;
@property (nonatomic,strong) LoginBlock loginBlock;
@end
