//
//  HETDeviceUpgradeModule.m
//  HETPublic
//
//  Created by tl on 15/8/17.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import "HETDeviceUpgradeModule.h"
#import "HETDeviceUpgradeManager.h"
@implementation HETDeviceUpgradeModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[HETDeviceUpgradeManager class] toProtocol:@protocol(HETDeviceUpgradeProtocol)];
}
@end
