//
//  PlaceholderTextView.h
//  SaleHelper
//
//  Created by gitBurning on 14/12/8.
//  Copyright (c) 2014年 Burning_git. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CL_PlaceholderTextView : UITextView

@property(copy,nonatomic)   NSString *placeholder;
@property(strong,nonatomic) UIColor *placeholderColor;
@property(strong,nonatomic) UIFont * placeholderFont;

//更新高度的时候
@property(assign,nonatomic) float updateHeight;

@property(strong,nonatomic)  UILabel *PlaceholderLabel;


-(void)addMaxTextLengthWithMaxLength:(NSInteger)maxLength andEvent:(void(^)(CL_PlaceholderTextView*))limit;

-(void)addTextViewBeginEvent:(void(^)(CL_PlaceholderTextView*text))begin;
-(void)addTextViewEndEvent:(void(^)(CL_PlaceholderTextView*text))End;

@end
