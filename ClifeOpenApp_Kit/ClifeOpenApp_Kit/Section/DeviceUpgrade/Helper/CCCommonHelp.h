//
//  CCCommonHelp.h
//  CCLoginAndRegistCommon
//
//  Created by mr.cao on 15/4/10.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD/MBProgressHUD.h"
#import "HETPublicUIConfig.h"
@interface CCCommonHelp : NSObject

#pragma mark ----loading框，公共模块中所有的loading均调用如下3个方法

+(MBProgressHUD *)showCustomHudtitle:(NSString *)title;
/*!
 *   请忽略title，信息用msg~！！！！
 */
+(void)showAutoDissmissAlertView:(NSString *)title msg:(NSString *)msg;
+(void)HidHud;


/**
 每个模块的string文件名
 */
+(NSString *)LocalizedTableNameWithModule:(NSString *)moduleName;
@end
