//
//  CLBLEDataSource.h
//  HETMattressDeviceSDK
//
//  Created by mr.cao on 2017/12/11.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LGPeripheral;

@protocol CLBLEDataSource <NSObject>

@required

-(NSArray*)scanServiceArray;

-(NSString*)readSeriveID;

-(NSString*)readCharacteristicID;

-(NSString*)writeSeriveID;

-(NSString*)writeCharacteristicID;


-(NSString *)broadName;

@optional


-(LGPeripheral*)connectedPeripheral;

@end
