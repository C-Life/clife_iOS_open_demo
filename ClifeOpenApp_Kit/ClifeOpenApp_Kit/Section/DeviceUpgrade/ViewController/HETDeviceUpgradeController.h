//
//  HETDeviceUpgradeController.h
//  HETPublic
//
//  Created by tl on 15/8/17.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HETBaseViewController.h"
#import "HETDUProcessProtocol.h"
@interface HETDeviceUpgradeController : HETBaseViewController
@property (nonatomic, strong)id<HETDUProcessProtocol> viewModel;
/**
 *  升级成功
 */
@property (nonatomic,copy)void (^upgradeSuccess)();

/**
 *  升级失败
 */
@property (nonatomic,copy)void (^upgradeFailure)();
@end
