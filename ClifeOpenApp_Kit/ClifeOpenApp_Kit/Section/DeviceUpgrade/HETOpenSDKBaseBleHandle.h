//
//  HETOpenSDKBaseBleHandle.h
//  HETPublicSDK_DeviceUpgrade
//
//  Created by mr.cao on 2018/2/8.
//  Copyright © 2018年 HET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HETDUProcessProtocol.h"
@interface HETOpenSDKBaseBleHandle : NSObject<HETDUProcessProtocol>
{
    HETBLEBusiness *_bleHandle;
}

//蓝牙指定初始化方法
+(instancetype)deviceInfo:(HETDevice *)deviceInfo version:(HETDeviceVersionModel *)versionModel;
@end
