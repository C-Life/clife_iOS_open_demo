//
//  HETCommonHelp.h
//  HETPublic
//
//  Created by mr.cao on 15/4/10.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface HETCommonHelp : NSObject


+(MBProgressHUD *)showCustomHudtitle:(NSString *)title;

+(void)showAutoDissmissWithMessage:(NSString *)message;

+ (void)showHudAutoHidenWithMessage: (NSString *)message;

+ (void)showMessage:(NSString *)message toView: (UIView *)view;

+ (void)showHudAutoHidenWithMessage: (NSString *)message toView: (UIView *)view;

+(void)HidHud;

+ (void)hideHudFromView:(UIView *)view;

@end
