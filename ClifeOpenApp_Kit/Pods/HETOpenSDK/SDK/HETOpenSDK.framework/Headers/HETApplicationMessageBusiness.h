//
//  HETApplicationMessageBusiness.h
//  HETOpenPlatformSDKDemo
//
//  Created by yuan yunlong on 2017/9/8.
//  Copyright © 2017年 het. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HETNetWorkRequestHeader.h"

typedef NS_ENUM(NSUInteger, HETApplicationMessageType){
    HETApplicationMessageTypeSystem=0,
    HETApplicationMessageTypeAddFriend=1,
    HETApplicationMessageTypeInviteControlDevice=2,
    HETApplicationMessageTypeViewNote=3,

};

@interface HETApplicationMessageBusiness : NSObject

/* 消息接口 */

/**
 *  消息列表
 *
 *  @param messageId          消息标识，只有上拉时传值，下拉时传0
 *  @param messageType        0-系统消息；1-添加好友；2-邀请控制设备；3-查看帖子评论；5-运营互动
 *  @param pageRows           每页数据大小
 *  
 *  正确的Json返回结果：
 *    {
 *    "data":
 *        {
 *        "pager":
 *           {"totalRows":0,
 *            "pageRows":1,
 *            "pageIndex":1,
 *            "paged":false,
 *            "defaultPageRows":20,
 *            "currPageRows":0,
 *            "pageStartRow":0,
 *            "hasPrevPage":false,
 *            "hasNextPage":false,
 *            "totalPages":0,
 *            "pageEndRow":0},
 *
 *        "list": [{
 *            "messageId":1,
 *            "title":"特特特特",
 *            "description":"大声答答",
 *            "businessParam":"11111",
 *            "sender":1,
 *            "icon":"http://www.test.com",
 *            "createTime":1434014367000,
 *            "messageType":1,
 *            "status":1，
 *            "level2":3,
 *            "content":"http://200.200.200.50/clife_app/page/topic-view.html?type=2&id=927",
 *            "readed":0,
 *            "readonly":0,
 *            "summary":null,
 *            "pictureUrl":null
 *            }]
 *        },
 *    "code": 0
 *    }
 *
 *  字段名称          字段类型      字段说明
 *  messageId       number      消息标识
 *  title           string      标题
 *  description     string      描述
 *  businessParam	string      业务参数的值(系统推送消息对应消息详情URL(businessParam为空时不要跳转)；添加好友消息对应用户Id，控制设备消息对应设备ID，查看帖子评论对应帖子详情URL。）
 *  sender          number      发送者ID
 *  icon            string      图标URL
 *  messageType     number      消息类型：0-系统消息；1-添加好友；2-邀请控制设备；3-查看帖子评论；5-运营互动；其他后续补充
 *  createTime      number      时间戳
 *  status          number      消息状态(0-删除；1-未处理；2-已处理)
 *  level2          number      (系统消息的时候如果操作类标识)系统消息下的二级分类：1-无正文；2-文本H5；3-外链；4-设备
 *  content         String      (表示设备信息时候建议接口调用时传json格式值)系统消息内容
 *  readed          number      消息是否已读（0-已读 1-未读）
 *  readonly        number      消息是否只读（0-只读类 1-操作类）
 *  summary         String      简要描述
 *  pictureUrl      String      简图路径
 */

+ (void)messgaeGetListWithMessageId:(NSInteger)messageId
                     messageType:(HETApplicationMessageType)messageType
                        pageRows:(NSUInteger)pageRows
                    success:(void(^)(id responseObject))success
                    failure:(void(^)( NSError *error))failure;


/**
 *  删除某条消息
 *
 *  @param messageId          消息标识
 *
 */

+ (void)messgaeDeleteWithMessageId:(NSInteger)messageId
                            success:(void(^)(id responseObject))success
                            failure:(void(^)( NSError *error))failure;

/**
 *  标记单个消息为已读
 *
 *  @param messageId          消息标识
 *
 */

+ (void)messgaeReadedWithMessageId:(NSInteger)messageId
                           success:(void(^)(id responseObject))success
                           failure:(void(^)( NSError *error))failure;

/**
 *  标记一组消息为已读
 *
 *  @param messageIds          消息ID集合（id之间用逗号“，”隔开）
 *
 */

+ (void)messgaeReadedWithMessageIdArray:(NSString *)messageIds
                           success:(void(^)(id responseObject))success
                           failure:(void(^)( NSError *error))failure;

/**
 *  消息详情
 *
 *  @param messageId          消息标识
 *
 */

+ (void)messgaeDetailInfoWithMessageId:(NSInteger )messageId
                                success:(void(^)(id responseObject))success
                                failure:(void(^)( NSError *error))failure;

/**
 *  未读消息列表
 *
 *
 *
 */

+ (void)messgaeGetUnReadedWithSuccess:(void(^)(id responseObject))success
                               failure:(void(^)( NSError *error))failure;

@end
