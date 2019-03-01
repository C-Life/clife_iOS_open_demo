//
//  ModeSelectView.h
//  SmartHome
//
//  Created by Jerry on 14-7-15.
//  Copyright (c) 2014年 Het. All rights reserved.
//

/* 该类用于创建 模式选择视图 */

#import <UIKit/UIKit.h>

@protocol ModeSelectViewDelegate <NSObject>

- (void)changeWorkMode:(NSNumber *)changedMode;

@optional
- (void)changeTimgingModeSwitchAtIndex:(NSArray *)statusAndIndex;
@end

@interface ModeSelectView : UIView
{
    //   NSString *modeTitle;
    NSMutableArray *modeTitles;
}

@property (nonatomic) NSInteger type;
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, assign) NSUInteger defaultIndex;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *typeButtons;
@property (nonatomic, weak)   id<ModeSelectViewDelegate> modeDelegate;
@property (nonatomic, strong) NSMutableArray *timingModeSwitchs;

- (ModeSelectView *)createModeSelectViewWithModelTitle:(NSString *)modeTitle modeTypeTitles:(NSArray *)typeTitles defaultMode:(long)defaultMode;

- (ModeSelectView *)createModeSelectViewTypeTitles:(NSArray *)typeTitles defaultMode:(int)defaultMode type:(int)deviceType;

- (ModeSelectView *)createModeSelectViewWithTitlesAndPics:(NSArray *)titles backgroundPic:(NSArray *)pictures defaultMode:(int)defaultMode type:(int)deviceType;

- (ModeSelectView *)createModeSelectViewWithTitlesAndPics:(NSArray *)titles backgroundPic:(NSArray *)pictures type:(int)deviceType;
- (void) setCurrentIndexForNoImg:(long)currentIndex;


- (void)setModeSwitch:(NSArray *)modeArr;
- (void)setSelectedMode:(NSArray *)modeArr;
@end
