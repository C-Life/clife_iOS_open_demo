//
//  HETMessageTypeModel.h
//  ClifeOpenApp_Kit
//
//  Created by miao on 2017/9/30.
//  Copyright © 2017年 het. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HETMessageTypeModel : NSObject
//"title": "",
//"description": "您已失去了设备[睡眠监测器_18]的控制权限。",
//"icon": "http://200.200.200.58:8981/group2/M01/04/81/yMjIOldg8uyAcHHGAATJofHKpXc222.png",
//"createTime": 1469504004000,
//"messageType": 4,
//"unreadCount": 1

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *theDescription;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,assign) NSTimeInterval createTime;
@property (nonatomic,assign) NSInteger unreadCount;
@property (nonatomic,assign) NSInteger messageType;
@end
