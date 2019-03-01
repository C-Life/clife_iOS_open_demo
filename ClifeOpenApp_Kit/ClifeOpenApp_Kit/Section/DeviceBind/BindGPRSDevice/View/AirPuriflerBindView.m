//
//  AirPuriflerBindView.m
//  CSuperAppliances
//
//  Created by starlueng on 16/9/8.
//  Copyright © 2016年 starlueng. All rights reserved.
//

#import "AirPuriflerBindView.h"
#import "UILabel+EXtern.h"
#import "UIButton+EXtern.h"
@implementation AirPuriflerBindView
{
    NSString *devicename;
    UILabel *noticeLabel;
}
@synthesize IMEITextField;
@synthesize imelLabel;

- (instancetype)initWithFrame:(CGRect)frame AndDeviceName:(NSString *)deviceName AndButtonClick:(buttonClick)block
{
    self = [super initWithFrame:frame];
    if (self) {
        devicename = deviceName;
        self.block = block;
        [self createUI];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)createUI{

    UILabel *label = [UILabel setLabelWith:@"温馨提示" AndFont:
                  OPFont(14) AndIsNumberOfLines:NO AndtextColor:[UIColor colorFromHexRGB:@"848484"] AndFrame:CGRectMake(16 *BasicWidth, 48 *BasicHeight, ScreenWidth, 15) AndAlignment:NSTextAlignmentLeft];
    [self addSubview:label];

    noticeLabel = [UILabel setLabelWith:@"" AndFont:OPFont(14) AndIsNumberOfLines:YES AndtextColor:[UIColor colorFromHexRGB:(@"848484")] AndFrame:CGRectZero AndAlignment:NSTextAlignmentLeft];

    [self addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16 *BasicWidth);
        make.right.equalTo(self).offset(-16 *BasicWidth);
        make.top.equalTo(label.mas_bottom).offset(20 *BasicHeight);
    }];

    NSString *noticeStr = [NSString stringWithFormat:@"1、请确保%@当前为待机或者工作中\r\n2、请确保%@网络正常",devicename,devicename];
    NSMutableParagraphStyle  *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 12 *BasicHeight;

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:noticeStr attributes:@{NSParagraphStyleAttributeName:style}];
    noticeLabel.attributedText = string;
    
    imelLabel = [UILabel setLabelWith:@"请输入设备的IMEI码或者MAC地址" AndFont:OPFont(14) AndIsNumberOfLines:NO AndtextColor:[UIColor colorFromHexRGB:@"848484"] AndFrame:CGRectZero AndAlignment:NSTextAlignmentCenter];
    [self addSubview:imelLabel];
    [imelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16 *BasicWidth);
        make.right.equalTo(self).offset(-16 *BasicWidth);
        make.top.equalTo(noticeLabel.mas_bottom).offset(70 *BasicHeight);
        make.height.equalTo(@(15 *BasicHeight));
    }];
    
    IMEITextField = [[UITextField alloc]initWithFrame:CGRectZero];
    [self addSubview:IMEITextField];
    IMEITextField.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    IMEITextField.layer.borderColor = [UIColor colorFromHexRGB:@"848484"].CGColor;
    IMEITextField.layer.cornerRadius = 5 *BasicHeight;
    IMEITextField.layer.masksToBounds = YES;
    IMEITextField.textAlignment = NSTextAlignmentCenter;
    IMEITextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    IMEITextField.keyboardType = UIKeyboardTypeASCIICapable;
    IMEITextField.textColor = [UIColor colorFromHexRGB:@"848484"];
    IMEITextField.font = OPFont(18);

    [IMEITextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset((ScreenWidth-230 *BasicWidth)/2);
        make.right.equalTo(self).offset(-(ScreenWidth-230 *BasicWidth)/2);
        make.top.equalTo(imelLabel.mas_bottom).offset(12 *BasicHeight);
        make.height.equalTo(@(44 *BasicHeight));
    }];
    
    UIButton *bindBtn = [UIButton setButtonWith:@"开始绑定" AndNomalColor:[UIColor colorFromHexRGB:@"848484"] AndSelectColor:[UIColor colorFromHexRGB:@"848484"] AndFont:OPFont(18) AndFrame:CGRectZero];
    bindBtn.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    bindBtn.layer.borderColor = [UIColor colorFromHexRGB:@"848484"].CGColor;
    bindBtn.layer.cornerRadius = 5 *BasicHeight;
    bindBtn.layer.masksToBounds = YES;
    [self addSubview:bindBtn];

    [bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset((ScreenWidth-230 *BasicWidth)/2);
        make.right.equalTo(self).offset(-(ScreenWidth-230 *BasicWidth)/2);
        make.top.equalTo(IMEITextField.mas_bottom).offset(45 *BasicHeight);
        make.height.equalTo(@(44 *BasicHeight));
    }];

    [bindBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)];
 
    [self addGestureRecognizer:tap];
}
- (void)reloadDeviceName:(HETDevice *)device{
    
    NSString *noticeStr = [NSString stringWithFormat:@"1、请确保%@当前为待机或者工作中\r\n2、请确保%@网络正常",device.productName,device.productName];
    NSMutableParagraphStyle  *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 12 *BasicHeight;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:noticeStr attributes:@{NSParagraphStyleAttributeName:style}];
 
    noticeLabel.attributedText = string;
}
#pragma mark-=====================Action===============
- (void)buttonAction:(UIButton *)sender{

    if (self.block) {
        self.block(IMEITextField.text,sender);
    }
}
- (void)hiddenKeyBoard{
    
    if ([IMEITextField isFirstResponder]) {
        [IMEITextField resignFirstResponder];
    }

}
@end
