//
//  LEDDeviceModel.h
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/9/5.
//  Copyright © 2017年 het. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEDDeviceModel : NSObject
@property (nonatomic,strong) NSNumber *colorTemp;
@property (nonatomic,strong) NSNumber *directHour;
@property (nonatomic,strong) NSNumber *directMinute;
@property (nonatomic,strong) NSNumber *directWeek;
@property (nonatomic,strong) NSNumber *lightness;
@property (nonatomic,strong) NSNumber *sceneMode;
@property (nonatomic,strong) NSNumber *sourceFlag;
@property (nonatomic,strong) NSNumber *sunWeek;
@property (nonatomic,strong) NSNumber *sunriseHour;
@property (nonatomic,strong) NSNumber *sunriseMinute;
@property (nonatomic,strong) NSNumber *sunsetHour;
@property (nonatomic,strong) NSNumber *sunsetMinute;
@property (nonatomic,strong) NSNumber *switchStatus;
@property (nonatomic,strong) NSNumber *updateFlag;
@property (nonatomic,strong) NSNumber *wakeMode;
@end
