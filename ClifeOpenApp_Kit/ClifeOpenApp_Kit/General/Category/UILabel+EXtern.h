//
//  UILabel+EXtern.h
//  CSuperAppliances
//
//  Created by starlueng on 16/3/28.
//  Copyright © 2016年 starlueng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (EXtern)
+ (instancetype)setLabelWith:(NSString *)text AndFont:(UIFont *)font AndIsNumberOfLines:(BOOL)numberOfLine AndtextColor:(UIColor *)TextColor AndFrame:(CGRect)frame AndAlignment:(NSTextAlignment)alignment;
@end
