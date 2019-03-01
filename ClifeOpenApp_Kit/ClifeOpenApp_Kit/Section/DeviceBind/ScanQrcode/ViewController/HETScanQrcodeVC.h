//
//  HETScanQrcodeVC.h
//  HETOpenPlatformSDKDemo
//
//  Created by miao on 2017/9/1.
//  Copyright © 2017年 het. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ GetH5PathBlock)(NSString *h5Path);
@interface HETScanQrcodeVC : UIViewController
/** 设备信息 **/
@property (nonatomic,strong) GetH5PathBlock h5PathBlock;
@end
