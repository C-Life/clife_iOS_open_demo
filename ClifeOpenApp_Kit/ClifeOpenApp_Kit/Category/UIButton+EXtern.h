//
//  UIButton+EXtern.h
//  CSuperAppliances
//
//  Created by starlueng on 16/3/28.
//  Copyright © 2016年 starlueng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EXtern)
//单一button只有title
+ (instancetype)setButtonWith:(NSString *)title AndNomalColor:(UIColor *)nomalColor AndSelectColor:(UIColor *)selectColor AndFont:(UIFont *)font AndFrame:(CGRect)frame;
//单一button只有image
+ (instancetype)setButtonWithNomalImage:(UIImage *)nomalImage AndSelectImage:(UIImage *)selectImage AndFrame:(CGRect)frame;
//button有title和image
+ (instancetype)setButtonWith:(NSString *)title AndNomalColor:(UIColor *)nomalColor AndSelectColor:(UIColor *)selectColor AndFont:(UIFont *)font AndFrame:(CGRect)frame AndNomalImage:(UIImage *)nomalImage AndSelectImage:(UIImage *)selectImage AndImageEdgeInset:(UIEdgeInsets)imageInset AndTitleEdgeInset:(UIEdgeInsets)titleInset;
@end
