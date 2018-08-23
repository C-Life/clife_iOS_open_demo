//
//  HETLocationManager.h
//  YFLCoreLocation
//
//  Created by mr.cao on 2018/8/13.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HETLocationManager : NSObject
+ (instancetype)shareManager;

- (void)getUserLocationWithGPSType:(NSString *)type  withAltitude:(NSString *)altitude completeBlock:(void (^)(NSDictionary *location,NSError *error))completeBlock;
@end
