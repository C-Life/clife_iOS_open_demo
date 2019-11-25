//
//  HETAuthorize.h
//  HETOpenSDK
//
//  Created by peng on 6/25/15.
//  Copyright (c) 2015 peng All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HETNetWorkRequestHeader.h"

typedef void(^authenticationCompletedBlock)(NSString *openId, NSError *error);

@interface HETAuthorize : NSObject
+ (instancetype)shareManager;

/**
 *  1.是否授权认证
 *  @return   YES为已经授权登录
 */
- (BOOL)isAuthenticated;

/**
 *  2.授权认证
 *  @param completedBlock 授权认证回调
 */
- (void)authorizeWithCompleted:(authenticationCompletedBlock)completedBlock;

/**
 *  3.取消授权认证
 */
- (void)unauthorize;

/**
 *  4.获取用户信息
 @param success 成功
 @param failure 失败
 */
- (void)getUserInformationSuccess:(HETSuccessBlock)success
                         failure:(HETFailureBlock)failure;

/**
 *  5.修改密码
 @param success 成功
 @param failure 失败
 */
- (void)changePasswordSuccess:(HETSuccessBlock)success
                      failure:(HETFailureBlock)failure;

/**
 *  6.解绑当前授权第三方账号
 @param success 成功
 @param failure 失败
 */
- (void)thirdAuthUnBindSuccess:(HETSuccessBlock)success
                       failure:(HETFailureBlock)failure;

@end
