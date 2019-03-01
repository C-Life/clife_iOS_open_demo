//
//  HETChangNetWorkState.h
//  ClifeOpenApp_Kit
//
//  Created by miao on 2018/1/8.
//  Copyright © 2018年 het. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ChangeBlock)(void);
@interface HETChangNetWorkState : UIView

@property (nonatomic,strong) UISegmentedControl                                    *netWorkSeg;
@property (nonatomic,strong) UISegmentedControl                                    *loginUISeg;
@property (nonatomic,strong) ChangeBlock changeBlock;

- (void)updateParams:(HETNetWorkConfigType)netWorkConfigType loginUIVersion:(NSString *)loginUIVersion;
@end
