//
//  HETChangNetWorkState.h
//  ClifeOpenApp_Kit
//
//  Created by miao on 2018/1/8.
//  Copyright © 2018年 het. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ ChangeBlock)();
@interface HETChangNetWorkState : UIView
@property (nonatomic,strong) ChangeBlock changeBlock;
@end
