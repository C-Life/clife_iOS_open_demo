//
//  UILabel+EXtern.m
//  CSuperAppliances
//
//  Created by starlueng on 16/3/28.
//  Copyright © 2016年 starlueng. All rights reserved.
//

#import "UILabel+EXtern.h"

@implementation UILabel (EXtern)
+ (instancetype)setLabelWith:(NSString *)text AndFont:(UIFont *)font AndIsNumberOfLines:(BOOL)numberOfLine AndtextColor:(UIColor *)TextColor AndFrame:(CGRect)frame AndAlignment:(NSTextAlignment)alignment{
    UILabel *label =[[UILabel alloc]initWithFrame:frame];
    label.text =text;
    label.font =font;
    label.textColor =TextColor;
    if (numberOfLine) {
        label.numberOfLines =0;
    }
    label.textAlignment =alignment;
    return label;
}
@end
