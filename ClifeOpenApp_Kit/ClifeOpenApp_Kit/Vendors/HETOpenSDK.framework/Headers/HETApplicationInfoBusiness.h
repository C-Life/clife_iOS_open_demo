//
//  HETApplicationInfoBusiness.h
//  HETOpenPlatformSDKDemo
//
//  Created by yuan yunlong on 2017/9/8.
//  Copyright © 2017年 het. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HETNetWorkRequestHeader.h"

typedef NS_ENUM(NSInteger, HETFeedbackType) {
    HETFeedbackTypeApp=1,
    HETFeedbackTypeHardware=2,
    HETFeedbackTypeNetWork=3,
    HETFeedbackTypeSuggest=4,
    HETFeedbackTypeOther=5
};

typedef NS_ENUM(NSInteger, HETFeedbackSource) {
    HETFeedbackSourceWeb=1,
    HETFeedbackSourceApp=2,
    HETFeedbackSourceWechart=3,
};

typedef NS_ENUM(NSInteger, HETApplicationInfoType) {
    HETApplicationInfoTypeCommon=1,        //常见问题
    HETApplicationInfoTypePrivacy=2,       //隐私政策
    HETApplicationInfoTypeCopyRight=3,     //版权声明
};

@interface HETApplicationInfoBusiness : NSObject


/**
 *  意见反馈
 *
 *  @param content  意见反馈内容
 *  @param contact  意见反馈联系方式    (非必传递参数)
 *  @param success  意见反馈成功的回调
 *  @param failure  意见反馈失败的回调
 *
 *  成功 Json: { "code":0 }
 *
 */

+ (void)feedbackWithContent:(NSString *)content
                withContact:(NSString *)contact
                    success:(void(^)(id responseObject))success
                    failure:(void(^)( NSError *error))failure;


/**
 *  获取用户信息
 *
 *  @param success  获取用户信息成功的回调
 *  @param failure  获取用户信息失败的回调
 *
 * 成功的Json
 * {
 *   "code":0,
 *   "data":{
 *       "userId": "d09f572c60ffced144d6cfc55a6881b9",
 *       "userName": "葫芦娃",
 *       "email":"",
 *       "phone":"",
 *       "sex": 1,
 *       "birthday": "2014-12-31",
 *       "weight": 48000,
 *       "height": 163,
 *       "avatar": "",
 *       "city": "深圳"
 *   }
 * }
 * 
 *  字段名称         字段类型	字段说明
 *  userName        string	用户名称
 *  phone           string	用户手机
 *  email           string	用户邮箱
 *  sex             number  性别（1-男，2-女）
 *  birthday        string	生日（yyyy-MM-dd）
 *  weight          number	体重（克）
 *  height          number	身高（厘米）
 *  avatar          string	头像URL
 *  city            string	城市名
 *
 *  未登录，调用该接口
 *  UserInfo={msg=未登录, code=1200}
 */

+ (void)userInfoWithSuccess:(void(^)(id responseObject))success
                    failure:(void(^)( NSError *error))failure;


/**
 *  获取应用信息
 *
 *  @param type     业务类型
 *  @param success  获取用户信息成功的回调
 *  @param failure  获取用户信息失败的回调
 *
 *  成功json
 *  {
 *      "code":"0"
 *      "data":"faq"
 *  }
 */
+ (void)applicationInfoWithType:(HETApplicationInfoType)type
                        success:(void(^)(id responseObject))success
                        failure:(void(^)( NSError *error))failure;


@end
