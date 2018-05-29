//
//  HETH5CustomNavigationBar.h
//  HETPublicSDK_HETH5DeviceControl
//
//  Created by mr.cao on 2018/3/14.
//  Copyright © 2018年 HET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"


@interface HETH5CustomNavigationBar : UIView
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) UIColor  *titleLabelColor;
@property (nonatomic, strong) UIFont   *titleLabelFont;
@property (nonatomic, strong) UIView   *backgroundView;
@property (nonatomic, strong) UIColor  *barBackgroundColor;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImage  *barBackgroundImage;
@property (nonatomic, copy) void(^onClickLeftButton)(NSUInteger index,NSString *title);
@property (nonatomic, copy) void(^onClickRightButton)(NSUInteger index,NSString *title);

+ (instancetype)CustomNavigationBar;

- (void)wr_setBottomLineHidden:(BOOL)hidden;
- (void)wr_setBackgroundAlpha:(CGFloat)alpha;
- (void)wr_setTintColor:(UIColor *)color;

// 默认返回事件
//- (void)wr_setLeftButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted title:(NSString *)title titleColor:(UIColor *)titleColor;
//- (void)wr_setLeftButtonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor;
//- (void)wr_setLeftButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted;
//- (void)wr_setLeftButtonWithImage:(UIImage *)image;
//- (void)wr_setLeftButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;
//
////- (void)wr_setRightButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted title:(NSString *)title titleColor:(UIColor *)titleColor;
////- (void)wr_setRightButtonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor;
//- (void)wr_setRightButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted;
//- (void)wr_setRightButtonWithImage:(UIImage *)image;
//- (void)wr_setRightButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;
- (void)wr_setLeftButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted title:(NSString *)title titleColor:(UIColor *)titleColor backBroundColor:(UIColor *)backgroundColor;

- (void)wr_setRightButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted title:(NSString *)title titleColor:(UIColor *)titleColor backBroundColor:(UIColor *)backgroundColor;

@end
