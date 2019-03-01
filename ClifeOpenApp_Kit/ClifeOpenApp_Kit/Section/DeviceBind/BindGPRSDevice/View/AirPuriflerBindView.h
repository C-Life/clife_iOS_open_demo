//
//  AirPuriflerBindView.h
//  CSuperAppliances
//
//  Created by starlueng on 16/9/8.
//  Copyright © 2016年 starlueng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^buttonClick)(NSString *text,UIButton *button);
@interface AirPuriflerBindView : UIView

@property (copy,nonatomic)buttonClick block;

@property (strong,nonatomic)UITextField *IMEITextField;

@property (strong,nonatomic)UILabel *imelLabel;

- (instancetype)initWithFrame:(CGRect)frame AndDeviceName:(NSString *)deviceName AndButtonClick:(buttonClick)block ;
- (void)hiddenKeyBoard;

- (void)reloadDeviceName:(HETDevice *)device;
@end
