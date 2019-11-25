//
//  HETDUBaseWifi.h
//  HETPublicSDK_DeviceUpgrade
//
//  Created by tl on 16/5/17.
//  Copyright © 2016年 HET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HETDUProcessProtocol.h"
@interface HETDUBaseWifiHandle : NSObject<HETDUProcessProtocol>{
    /**
     *  when check upgrade progress fail , this value plus 1 , if checkProgressFailCount greater than 60 , then consider upgrade fail
     */
    NSInteger _checkProgressFailCount;
    
    NSTimer *_getProgressTime;
}

@end
