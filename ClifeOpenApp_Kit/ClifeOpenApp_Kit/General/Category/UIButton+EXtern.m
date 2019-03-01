//
//  UIButton+EXtern.m
//  CSuperAppliances
//
//  Created by starlueng on 16/3/28.
//  Copyright © 2016年 starlueng. All rights reserved.
//

#import "UIButton+EXtern.h"

@implementation UIButton (EXtern)

+ (instancetype)setButtonWith:(NSString *)title AndNomalColor:(UIColor *)nomalColor AndSelectColor:(UIColor *)selectColor AndFont:(UIFont *)font AndFrame:(CGRect)frame{
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:nomalColor forState:UIControlStateNormal];
    [button setTitleColor:selectColor forState:UIControlStateSelected];
    button.titleLabel.font =font;
    button.frame = frame;
    return button;
}

+ (instancetype)setButtonWithNomalImage:(UIImage *)nomalImage AndSelectImage:(UIImage *)selectImage AndFrame:(CGRect)frame{
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:nomalImage forState:UIControlStateNormal];
    [button setImage:selectImage forState:UIControlStateSelected];
    button.frame = frame;
    return button;

}

+ (instancetype)setButtonWith:(NSString *)title AndNomalColor:(UIColor *)nomalColor AndSelectColor:(UIColor *)selectColor AndFont:(UIFont *)font AndFrame:(CGRect)frame AndNomalImage:(UIImage *)nomalImage AndSelectImage:(UIImage *)selectImage AndImageEdgeInset:(UIEdgeInsets)imageInset AndTitleEdgeInset:(UIEdgeInsets)titleInset{
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:nomalColor forState:UIControlStateNormal];
    [button setTitleColor:selectColor forState:UIControlStateSelected];
    [button setImage:nomalImage forState:UIControlStateNormal];
    [button setImage:selectImage forState:UIControlStateSelected];
    button.imageEdgeInsets =imageInset;
    button.titleEdgeInsets = titleInset;
    button.titleLabel.font =font;
    button.frame = frame;
    return button;
}
@end
