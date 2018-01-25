//
//  HETSQRCodeScanningVC.h
//  ClifeOpenApp_Kit
//
//  Created by miao on 2018/1/23.
//  Copyright © 2018年 het. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ GetH5PathBlock)(NSString *h5Path);
@interface HETSQRCodeScanningVC : UIViewController
/** 设备信息 **/
@property (nonatomic,strong) GetH5PathBlock h5PathBlock;
@end
