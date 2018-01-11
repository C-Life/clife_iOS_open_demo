//
//  HETThirdAuthApiRequest.h
//  HETOpenSDKDemo
//
//  Created by boyu on 2017/8/25.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HETThirdAuthApiRequestType) {
    HETThirdAuthApiRequest_Unknown  = 0,
    HETThirdAuthApiRequest_WeChat   = 1,
    HETThirdAuthApiRequest_WeiBo    = 2,
    HETThirdAuthApiRequest_QQ       = 3,
    HETThirdAuthApiRequest_Twitter  = 4,
    HETThirdAuthApiRequest_Facebook = 5,
};

@class HETThirdAuth;
@interface HETThirdAuthApiRequest : NSObject

/** 查询第三方账号是否第一次登录 */


/**
 查询第三方账号是否第一次登录

 @param appId
 @param thirdId 第三方openId
 @param type    类型(1、weixin 2、微博  3、QQ  4、Twitter 5、Facebook)
 @param completedBlock isFirst是否第一次登录
 */
- (void)sendRequestCheckFistTimeLoginThirdId:(NSString *)thirdId
                                        type:(HETThirdAuthApiRequestType)type
                                   completed:(void(^)(BOOL isFirst, NSError *error))completedBlock;

/** 第三方用户登录 */
- (void)sendRequestThirdLogin:(HETThirdAuth *)thirdAuth completed:(void(^)(id responseObject, NSError *error))completedBlock;

// 解除第三方绑定
- (void)sendRequestUnBindCompleted:(void(^)(id responseObject, NSError *error))completedBlock;

@end

@interface HETThirdAuth : NSObject

// 必须参数
@property (nonatomic, copy) NSString *thirdId; // 第三方账号ID
@property (nonatomic, assign) HETThirdAuthApiRequestType type; // 类型(1、weixin 2、微博  3、QQ  4、Twitter 5、Facebook)
@property (nonatomic, copy) NSString *sync; // 同步资料(1、同步 0、不同步) 默认0

// 非必须参数
@property (nonatomic, copy) NSString *userName; // 用户名称
@property (nonatomic, copy) NSString *avatar; // 头像
@property (nonatomic, copy) NSString *sex; // 性别（1-男，2-女）
@property (nonatomic, copy) NSString *birthday; // 生日（yyyy-MM-dd）
@property (nonatomic, copy) NSString *weight; // 体重（克）
@property (nonatomic, copy) NSString *height; // 身高（厘米）
@property (nonatomic, copy) NSString *city; // 城市名

@end
