//
//  HETNetWorkRequestHeader.h
//  HETOpenSDK
//
//  Created by mr.cao on 16/3/16.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#ifndef HETNetWorkRequestHeader_h
#define HETNetWorkRequestHeader_h


typedef NS_ENUM(NSInteger , HETRequestMethod) {
    HETRequestMethodGet = 0,
    HETRequestMethodPost,
    HETRequestMethodHead,
    HETRequestMethodPut,
    HETRequestMethodDelete,
    HETRequestMethodPatch,
    HETRequestMethodMultipart
};

typedef NS_ENUM(NSInteger, HETWiFiDeviceState) {
    HETWiFiDeviceOnState      = 1,  //设备在线状态
    HETWiFiDeviceOffState    //设备离线状态
};

typedef void(^HETSuccessBlock)(id responseObject);
typedef void(^HETFailureBlock)(NSError *error);
typedef void(^HETDeviceRunDataBlock)(id responseObject);
typedef void(^HETDeviceConfigDataBlock)(id responseObject);
typedef void(^HETDeviceErrorDataBlock)(id responseObject);
typedef void(^HETWifiDeviceStateBlock)(HETWiFiDeviceState state);



#endif /* HETNetWorkRequestHeader_h */
