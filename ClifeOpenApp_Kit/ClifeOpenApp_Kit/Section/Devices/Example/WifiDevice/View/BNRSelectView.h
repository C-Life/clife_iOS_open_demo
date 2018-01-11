//
//  BNRSelectView.h
//  CSleep
//
//  Created by JustinYang on 15/4/16.
//  Copyright (c) 2015年 HeT.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRSelectView;

@protocol BNRSelectViewDelegate <NSObject>

- (void)selectView:(BNRSelectView *)selectView changedSelectedIndex:(int) index;

@end
@interface BNRSelectView : UIView

- (void)setInitialDataWith:(NSInteger)index;

@property(nonatomic,weak) id<BNRSelectViewDelegate> delegate;
@property(nonatomic)int currentIndex;
//this property is used for re-layout according to your mind
@property(nonatomic,strong)NSMutableArray *btnArray;
@property(nonatomic,strong)NSMutableArray *viewArray;
@property(nonatomic,strong)NSMutableArray *titleLabelArray;
//all of the array count in this method must be equal , and plase ensure frame is engouh
-(instancetype)initWithFrame:(CGRect)frame imageSelected:(NSArray *)selectedImgArray imageNormal:(NSArray *)imageArray title:(NSArray *)titleArray;
@end
