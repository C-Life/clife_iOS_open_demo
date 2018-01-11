//
//  ModeSelectView.m
//  SmartHome
//
//  Created by Jerry on 14-7-15.
//  Copyright (c) 2014年 Het. All rights reserved.
//

#import "ModeSelectView.h"

#define ButtonTag 20000
#define LabelTag  20100

@interface ModeSelectView ()
{
    NSArray *selectedImagesArr;
    NSArray *unselectedImagesArr;
    
}

@end

@implementation ModeSelectView

@synthesize normalImage, selectedImage, defaultIndex, typeButtons, type, timingModeSwitchs;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        modeTitles = [[NSMutableArray alloc] init];
        typeButtons = [[NSMutableArray alloc] init];
        timingModeSwitchs = [[NSMutableArray alloc] init];
        selectedImagesArr = [[NSArray alloc] init];
        unselectedImagesArr = [[NSArray alloc] init];
    }
    return self;
}

- (ModeSelectView *)createModeSelectViewWithModelTitle:(NSString *)title modeTypeTitles:(NSArray *)typeTitles defaultMode:(long)defaultMode{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 60, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorFromHexRGB:@"989e9d"];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLabel];
    
    if (!typeTitles || typeTitles.count == 0) {
        return nil;
    }
    
    modeTitles = [NSMutableArray arrayWithArray:typeTitles];
    _currentIndex = defaultMode;
    
    normalImage = [UIImage imageNamed:@"btn_changjing"];
    selectedImage = [UIImage imageNamed:@"btn_changjing_press"];
    CGSize imageSize = normalImage.size;
    CGFloat space = 0;
    if (typeTitles.count == 2) {
        space = 80;
    }
    else if (typeTitles.count == 3) {
        space = 40;
    }
    else if (typeTitles.count == 4) {
        space = 20;
    }
    else if (typeTitles.count == 5) {
        space = 20;
    }
    CGFloat modeBetweenSpace = (CGRectGetWidth(self.frame)-30 - typeTitles.count*imageSize.width - space*2)/(typeTitles.count-1);
    
    if (typeButtons) {
        [typeButtons removeAllObjects];
    }
    for (int i = 0; i < typeTitles.count; i++) {
        UIButton *modeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        modeBtn.frame = CGRectMake(50+(imageSize.width+modeBetweenSpace)*i, 10, imageSize.width, imageSize.height);
        modeBtn.backgroundColor = [UIColor clearColor];
        if (defaultMode == (long)i) {
            [modeBtn setImage:selectedImage forState:UIControlStateNormal];
            [modeBtn setTitle:[typeTitles objectAtIndex:i] forState:UIControlStateNormal];
            [modeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _currentIndex = i;
        }
        else {
            [modeBtn setImage:normalImage forState:UIControlStateNormal];
            [modeBtn setTitle:[typeTitles objectAtIndex:i] forState:UIControlStateNormal];
            [modeBtn setTitleColor:[UIColor colorFromHexRGB:@"989e9d"] forState:UIControlStateNormal];
        }
        modeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        modeBtn.tag = ButtonTag+i;
        [typeButtons addObject:modeBtn];
        [modeBtn addTarget:self action:@selector(changeMode:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:modeBtn];
    }
    return self;
}

- (ModeSelectView *)createModeSelectViewTypeTitles:(NSArray *)typeTitles defaultMode:(int)defaultMode type:(int)deviceType {
    if (!typeTitles || typeTitles.count == 0) {
        return nil;
    }
    _currentIndex = defaultMode;
    if (deviceType == 3) {
        selectedImagesArr = @[[UIImage imageNamed:@"airAutoMode_sel"], [UIImage imageNamed:@"airColdMode_sel"], [UIImage imageNamed:@"airDryMode_sel"], [UIImage imageNamed:@"airWindMode_sel"], [UIImage imageNamed:@"airHeatMode_sel"]];
        unselectedImagesArr = @[[UIImage imageNamed:@"airAutoMode"], [UIImage imageNamed:@"airColdMode"], [UIImage imageNamed:@"airDryMode"], [UIImage imageNamed:@"airWindMode"], [UIImage imageNamed:@"airHeatMode"]];
    }
    
    CGSize imageSize = CGSizeMake(30, 30);
    CGFloat space = 0;
    if (typeTitles.count == 2) {
        space = 80;
    }
    else if (typeTitles.count == 3) {
        space = 40;
    }
    else if (typeTitles.count == 4) {
        space = 30;
    }
    else if (typeTitles.count == 5) {
        space = 20;
    }
    CGFloat modeBetweenSpace = (CGRectGetWidth(self.frame) - typeTitles.count*imageSize.width - space*2)/(typeTitles.count-1);
    
    if (typeButtons) {
        [typeButtons removeAllObjects];
    }
    for (int i = 0; i < typeTitles.count; i++) {
        UIButton *modeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        modeBtn.frame = CGRectMake(ScreenWidth/typeTitles.count * i+space, 0, ScreenWidth/typeTitles.count, CGRectGetHeight(self.frame));
        modeBtn.backgroundColor = [UIColor clearColor];
        UIImage *modeImage = [UIImage imageNamed:@"airAutoMode_sel"];
        modeBtn.imageEdgeInsets = UIEdgeInsetsMake((self.frame.size.height-30-modeImage.size.height)> 0?(self.frame.size.height-30-modeImage.size.height):0, (ScreenWidth/typeTitles.count-modeImage.size.width)/3, 30, (ScreenWidth/typeTitles.count-modeImage.size.width)/3);
        if (defaultMode == i) {
            [modeBtn setImage:[selectedImagesArr objectAtIndex:i] forState:UIControlStateNormal];
            _currentIndex = i;
        }
        else {
            [modeBtn setImage:[unselectedImagesArr objectAtIndex:i] forState:UIControlStateNormal];
            
        }
        
        modeBtn.tag = ButtonTag+i;
        [typeButtons addObject:modeBtn];
        [modeBtn addTarget:self action:@selector(changeLedMode:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:modeBtn];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame)-35, CGRectGetWidth(modeBtn.frame), 35)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [typeTitles objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:14];
        if (defaultMode == i) {
            label.textColor = [UIColor colorFromHexRGB:@"62acee"];
        }
        else {
            label.textColor = [UIColor colorFromHexRGB:@"d3d3d3"];//[UIColor colorFromHexRGB:@"EEEEF0"];
        }
        [modeTitles addObject:label];
        [modeBtn addSubview:label];
    }
    return self;
}
- (ModeSelectView *)createModeSelectViewWithTitlesAndPics:(NSArray *)titles backgroundPic:(NSArray *)pictures type:(int)deviceType
{
    if (!titles || titles.count == 0) {
        return nil;
    }
    _currentIndex = titles.count;
    if (deviceType == 3) {
        selectedImagesArr = @[[UIImage imageNamed:@"btn_reading_sel"], [UIImage imageNamed:@"btn_rest_sel"], [UIImage imageNamed:@"btn_light_sel"],[UIImage imageNamed:@"btn_light_sel"]];
        unselectedImagesArr = @[[UIImage imageNamed:@"btn_reading"], [UIImage imageNamed:@"btn_rest"], [UIImage imageNamed:@"btn_light"],[UIImage imageNamed:@"btn_light"]];
    }
    
    CGSize imageSize = CGSizeMake(30, 30);
    CGFloat space = 0;
    if (titles.count == 2) {
        space = 80;
    }
    else if (titles.count == 3) {
        space = 40;
    }
    else if (titles.count == 4) {
        space = 30;
    }
    else if (titles.count == 5) {
        space = 20;
    }
    
    for(NSInteger i=1; i<titles.count;i++)
    {
        UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/(titles.count)*i-.25, 0, 1, 80)];
        vLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:vLine];
    }
    
    if (typeButtons) {
        [typeButtons removeAllObjects];
    }
    for (int i = 0; i < titles.count; i++) {
        UIButton *modeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        modeBtn.frame = CGRectMake(ScreenWidth/titles.count * i, 0, ScreenWidth/titles.count, CGRectGetHeight(self.frame));
        modeBtn.backgroundColor = [UIColor clearColor];
        UIImage *modeImage = [UIImage imageNamed:@"btn_reading"];
        modeBtn.imageEdgeInsets = UIEdgeInsetsMake((self.frame.size.height-30-modeImage.size.height)> 0?(self.frame.size.height-30-modeImage.size.height):0, (ScreenWidth/titles.count-modeImage.size.width)/2, 30, (ScreenWidth/titles.count-modeImage.size.width)/2);
        //        if (defaultMode == i) {
        //            [modeBtn setImage:[selectedImagesArr objectAtIndex:i] forState:UIControlStateNormal];
        //            _currentIndex = i;
        //        }
        //        else {
        [modeBtn setImage:[unselectedImagesArr objectAtIndex:i] forState:UIControlStateNormal];
        
        //        }
        
        modeBtn.tag = ButtonTag+i;
        [typeButtons addObject:modeBtn];
        [modeBtn addTarget:self action:@selector(changeLedMode:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:modeBtn];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame)-35, CGRectGetWidth(modeBtn.frame), 35)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [titles objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:14];
        //        if (defaultMode == i) {
        //            label.textColor = [UIColor colorFromHexRGB:@"62acee"];
        //            label.textColor = [UIColor
        //                               colorWithRed: 253.0 / 0xff
        //                               green: 178.0/ 0xff
        //                               blue: 82.0 / 0xff
        //                               alpha:1.0];
        //        }
        //        else {
        label.textColor = [UIColor colorFromHexRGB:@"d3d3d3"];//[UIColor colorFromHexRGB:@"EEEEF0"];
        //        }
        [modeTitles addObject:label];
        [modeBtn addSubview:label];
    }
    return self;
}

- (ModeSelectView *)createModeSelectViewWithTitlesAndPics:(NSArray *)titles backgroundPic:(NSArray *)pictures defaultMode:(int)defaultMode type:(int)deviceType
{
    if (!titles || titles.count == 0) {
        return nil;
    }
    _currentIndex = defaultMode;
    if (deviceType == 3) {
        selectedImagesArr = @[[UIImage imageNamed:@"btn_reading_sel"], [UIImage imageNamed:@"btn_rest_sel"], [UIImage imageNamed:@"btn_light_sel"],[UIImage imageNamed:@"btn_light_sel"]];
        unselectedImagesArr = @[[UIImage imageNamed:@"btn_reading"], [UIImage imageNamed:@"btn_rest"], [UIImage imageNamed:@"btn_light"],[UIImage imageNamed:@"btn_light"]];
    }
    
    CGSize imageSize = CGSizeMake(30, 30);
    CGFloat space = 0;
    if (titles.count == 2) {
        space = 80;
    }
    else if (titles.count == 3) {
        space = 40;
    }
    else if (titles.count == 4) {
        space = 30;
    }
    else if (titles.count == 5) {
        space = 20;
    }
    
    for(NSInteger i=1; i<titles.count;i++)
    {
        UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/(titles.count)*i-.25, 0, 1, 80)];
        vLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:vLine];
    }
    
    if (typeButtons) {
        [typeButtons removeAllObjects];
    }
    for (int i = 0; i < titles.count; i++) {
        UIButton *modeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        modeBtn.frame = CGRectMake(ScreenWidth/titles.count * i, 0, ScreenWidth/titles.count, CGRectGetHeight(self.frame));
        modeBtn.backgroundColor = [UIColor clearColor];
        UIImage *modeImage = [UIImage imageNamed:@"btn_reading"];
        modeBtn.imageEdgeInsets = UIEdgeInsetsMake((self.frame.size.height-30-modeImage.size.height)> 0?(self.frame.size.height-30-modeImage.size.height):0, (ScreenWidth/titles.count-modeImage.size.width)/2, 30, (ScreenWidth/titles.count-modeImage.size.width)/2);
        if (defaultMode == i) {
            [modeBtn setImage:[selectedImagesArr objectAtIndex:i] forState:UIControlStateNormal];
            _currentIndex = i;
        }
        else {
            [modeBtn setImage:[unselectedImagesArr objectAtIndex:i] forState:UIControlStateNormal];
            
        }
        
        modeBtn.tag = ButtonTag+i;
        [typeButtons addObject:modeBtn];
        [modeBtn addTarget:self action:@selector(changeLedMode:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:modeBtn];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame)-35, CGRectGetWidth(modeBtn.frame), 35)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [titles objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:14];
        if (defaultMode == i) {
            label.textColor = [UIColor colorFromHexRGB:@"62acee"];
            label.textColor = [UIColor
                               colorWithRed: 253.0 / 0xff
                               green: 178.0/ 0xff
                               blue: 82.0 / 0xff
                               alpha:1.0];
        }
        else {
            label.textColor = [UIColor colorFromHexRGB:@"d3d3d3"];//[UIColor colorFromHexRGB:@"EEEEF0"];
        }
        [modeTitles addObject:label];
        [modeBtn addSubview:label];
    }
    return self;
}

- (void)changeLedMode:(UIButton *)sender
{
    if (_currentIndex >= typeButtons.count) {
        NSUInteger index = [typeButtons indexOfObject:sender];
        [sender setImage:[selectedImagesArr objectAtIndex:index] forState:UIControlStateNormal];
        UILabel *selectedLabel = [modeTitles objectAtIndex:index];
        [selectedLabel setTextColor:[UIColor colorFromHexRGB:@"FDB252"]];
        _currentIndex = index;
    }else{
        UIButton *preButton = [typeButtons objectAtIndex:_currentIndex];
        NSUInteger index = [typeButtons indexOfObject:sender];
        if (index == _currentIndex) {
            return;
        }
        else {
            [sender setImage:[selectedImagesArr objectAtIndex:index] forState:UIControlStateNormal];
            UILabel *selectedLabel = [modeTitles objectAtIndex:index];
            [selectedLabel setTextColor:[UIColor colorFromHexRGB:@"FDB252"]];            
            [preButton setImage:[unselectedImagesArr objectAtIndex:_currentIndex] forState:UIControlStateNormal];
            UILabel *curLabel = [modeTitles objectAtIndex:_currentIndex];
            [curLabel setTextColor:[UIColor colorFromHexRGB:@"d3d3d3"]];
            _currentIndex = index;
        }
    }
    
    if (self.modeDelegate && [self.modeDelegate respondsToSelector:@selector(changeWorkMode:)]) {
        [self.modeDelegate performSelector:@selector(changeWorkMode:) withObject:@(_currentIndex)];
    }
}

- (void)changeWorkMode:(UIButton *)sender {
    //只能同时选择一种模式
    if (_currentIndex > typeButtons.count-1) {
        [sender setImage:[selectedImagesArr objectAtIndex:index] forState:UIControlStateNormal];
        [sender setTitle:[modeTitles objectAtIndex:sender.tag-ButtonTag] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _currentIndex = sender.tag-ButtonTag;
    }
    else {
        UIButton *preButton = [typeButtons objectAtIndex:_currentIndex];
        NSUInteger index = [typeButtons indexOfObject:sender];
        if (index == _currentIndex) {
            return;
        }
        else {
            [sender setImage:[selectedImagesArr objectAtIndex:index] forState:UIControlStateNormal];
            UILabel *selectedLabel = [modeTitles objectAtIndex:index];
            [selectedLabel setTextColor:[UIColor colorFromHexRGB:@"62acee"]];
            
            [preButton setImage:[unselectedImagesArr objectAtIndex:_currentIndex] forState:UIControlStateNormal];
            UILabel *curLabel = [modeTitles objectAtIndex:_currentIndex];
            [curLabel setTextColor:[UIColor colorFromHexRGB:@"d3d3d3"]];
            //                [preButton setTitle:[modeTitles objectAtIndex:_currentIndex] forState:UIControlStateNormal];
            //                [preButton setTitleColor:[UIColor colorFromHexRGB:@"6cbf47"] forState:UIControlStateNormal];
            _currentIndex = index;
        }
    }
    if (self.modeDelegate && [self.modeDelegate respondsToSelector:@selector(changeWorkMode:)]) {
        [self.modeDelegate performSelector:@selector(changeWorkMode:) withObject:@(_currentIndex)];
    }
}


- (void)changeMode:(UIButton *)sender {
    if (type == 2) {    // 可以多选模式 热水器的3种定时方式
        if (sender.tag == ButtonTag) {
            int mode1 = [[timingModeSwitchs objectAtIndex:0] intValue];
            // 1
            if (mode1 == 0) {   // 关闭 --> 打开
                [[typeButtons objectAtIndex:0] setImage:selectedImage forState:UIControlStateNormal];
                [[typeButtons objectAtIndex:0] setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
                mode1 = 1;
            }
            else if (mode1 == 1) {  // 打开 --> 关闭
                [[typeButtons objectAtIndex:0] setImage:normalImage forState:UIControlStateNormal];
                [[typeButtons objectAtIndex:0] setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
                mode1 = 0;
            }
            NSArray *array = @[@(mode1), @(0)]; //状态 + 索引
            [timingModeSwitchs replaceObjectAtIndex:0 withObject:@(mode1)];
            if (self.modeDelegate && [self.modeDelegate respondsToSelector:@selector(changeTimgingModeSwitchAtIndex:)]) {
                [self.modeDelegate performSelector:@selector(changeTimgingModeSwitchAtIndex:) withObject:array];
            }
        }
        if (sender.tag == ButtonTag + 1) {
            int mode2 = [[timingModeSwitchs objectAtIndex:1] intValue];
            // 1
            if (mode2 == 0) {   // 关闭 --> 打开
                [[typeButtons objectAtIndex:1] setImage:selectedImage forState:UIControlStateNormal];
                [[typeButtons objectAtIndex:1] setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
                mode2 = 1;
            }
            else if (mode2 == 1) {  // 打开 --> 关闭
                [[typeButtons objectAtIndex:1] setImage:normalImage forState:UIControlStateNormal];
                [[typeButtons objectAtIndex:1] setTitleColor:[UIColor colorFromHexRGB:@"989e9d"] forState:UIControlStateNormal];
                mode2 = 0;
            }
            [timingModeSwitchs replaceObjectAtIndex:1 withObject:@(mode2)];
            NSArray *array = @[@(mode2), @(1)]; //状态 + 索引
            if (self.modeDelegate && [self.modeDelegate respondsToSelector:@selector(changeTimgingModeSwitchAtIndex:)]) {
                [self.modeDelegate performSelector:@selector(changeTimgingModeSwitchAtIndex:) withObject:array];
            }
        }
        if (sender.tag == ButtonTag + 2) {
            int mode3 = [[timingModeSwitchs objectAtIndex:2] intValue];
            // 1
            if (mode3 == 0) {   // 关闭 --> 打开
                [[typeButtons objectAtIndex:2] setImage:selectedImage forState:UIControlStateNormal];
                [[typeButtons objectAtIndex:2] setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
                mode3 = 1;
            }
            else if (mode3 == 1) {  // 打开 --> 关闭
                [[typeButtons objectAtIndex:2] setImage:normalImage forState:UIControlStateNormal];
                [[typeButtons objectAtIndex:2] setTitleColor:[UIColor colorFromHexRGB:@"80c5fb"] forState:UIControlStateNormal];
                mode3 = 0;
            }
            [timingModeSwitchs replaceObjectAtIndex:2 withObject:@(mode3)];
            NSArray *array = @[@(mode3), @(2)]; //状态 + 索引
            if (self.modeDelegate && [self.modeDelegate respondsToSelector:@selector(changeTimgingModeSwitchAtIndex:)]) {
                [self.modeDelegate performSelector:@selector(changeTimgingModeSwitchAtIndex:) withObject:array];
            }
        }
    }
    else {          //只能同时选择一种模式
        if (_currentIndex > typeButtons.count-1) {
            [sender setImage:selectedImage forState:UIControlStateNormal];
            [sender setTitle:[modeTitles objectAtIndex:sender.tag-ButtonTag] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _currentIndex = sender.tag-ButtonTag;
        }
        else {
            UIButton *preButton = [typeButtons objectAtIndex:_currentIndex];
            NSInteger index = [typeButtons indexOfObject:sender];
            if ((long)index == _currentIndex) {
                
            }
            else {
                [sender setImage:selectedImage forState:UIControlStateNormal];
                [sender setTitle:[modeTitles objectAtIndex:index] forState:UIControlStateNormal];
                [sender setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
                
                [preButton setImage:normalImage forState:UIControlStateNormal];
                [preButton setTitle:[modeTitles objectAtIndex:_currentIndex] forState:UIControlStateNormal];
                [preButton setTitleColor:[UIColor colorFromHexRGB:@"989e9d"] forState:UIControlStateNormal];
                _currentIndex = (long)index;
            }
        }
        if (self.modeDelegate && [self.modeDelegate respondsToSelector:@selector(changeWorkMode:)]) {
            [self.modeDelegate performSelector:@selector(changeWorkMode:) withObject:@(_currentIndex)];
        }
    }
}

// 热水器的3种定时方式
- (void)setModeSwitch:(NSArray *)modeArr {
    if (timingModeSwitchs) {
        timingModeSwitchs = nil;
    }
    timingModeSwitchs = [NSMutableArray arrayWithArray:modeArr];
    
    int mode1 = [[modeArr objectAtIndex:0] intValue];
    int mode2 = [[modeArr objectAtIndex:1] intValue];
    int mode3 = [[modeArr objectAtIndex:2] intValue];
    
    if (mode1 == 0) {
        [[typeButtons objectAtIndex:0] setImage:normalImage forState:UIControlStateNormal];
        [[typeButtons objectAtIndex:0] setTitleColor:[UIColor colorFromHexRGB:@"80c5fb"] forState:UIControlStateNormal];
    }
    else if (mode1 == 1) {
        [[typeButtons objectAtIndex:0] setImage:selectedImage forState:UIControlStateNormal];
        [[typeButtons objectAtIndex:0] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if (mode2 == 0) {
        [[typeButtons objectAtIndex:1] setImage:normalImage forState:UIControlStateNormal];
        [[typeButtons objectAtIndex:1] setTitleColor:[UIColor colorFromHexRGB:@"80c5fb"] forState:UIControlStateNormal];
    }
    else if (mode2 == 1) {
        [[typeButtons objectAtIndex:1] setImage:selectedImage forState:UIControlStateNormal];
        [[typeButtons objectAtIndex:1] setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    }
    
    if (mode3 == 0) {
        [[typeButtons objectAtIndex:2] setImage:normalImage forState:UIControlStateNormal];
        [[typeButtons objectAtIndex:2] setTitleColor:[UIColor colorFromHexRGB:@"80c5fb"] forState:UIControlStateNormal];
    }
    else if (mode3 == 1) {
        [[typeButtons objectAtIndex:2] setImage:selectedImage forState:UIControlStateNormal];
        [[typeButtons objectAtIndex:2] setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    }
}

- (void)setSelectedMode:(NSArray *)modeArr {
    NSUInteger modeCount = modeArr.count;
    for (int i = 0; i < modeCount; i++) {
        int modeType = [[modeArr objectAtIndex:i] intValue];
        if (modeType == 0) {
            [[typeButtons objectAtIndex:i] setImage:normalImage forState:UIControlStateNormal];
            [[typeButtons objectAtIndex:i] setTitleColor:[UIColor colorFromHexRGB:@"80c5fb"] forState:UIControlStateNormal];
        }
        else if (modeType == 1) {
            _currentIndex = i;
            [[typeButtons objectAtIndex:i] setImage:selectedImage forState:UIControlStateNormal];
            [[typeButtons objectAtIndex:i] setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        }
    }
}
- (void)setCurrentIndex:(long)currentIndex{
    //    currentIndex = currentIndex % typeButtons.count;
    if (currentIndex >= typeButtons.count) {
        return ;
    }
    if (currentIndex == _currentIndex) {
        return;
    }
    
    UIButton *preButton = [typeButtons objectAtIndex:_currentIndex];
    UIButton *currentBtn = [typeButtons objectAtIndex:currentIndex];
    [currentBtn setImage:[selectedImagesArr objectAtIndex:currentIndex] forState:UIControlStateNormal];
    UILabel *selectedLabel = [modeTitles objectAtIndex:currentIndex];
    [selectedLabel setTextColor:[UIColor colorFromHexRGB:@"80c5fb"]];
    
    [preButton setImage:[unselectedImagesArr objectAtIndex:_currentIndex] forState:UIControlStateNormal];
    UILabel *curLabel = [modeTitles objectAtIndex:_currentIndex];
    [curLabel setTextColor:[UIColor colorFromHexRGB:@"d3d3d3"]];
    
    _currentIndex = currentIndex;
    
}
- (void) setCurrentIndexForNoImg:(long)currentIndex{
    //    currentIndex = currentIndex % typeButtons.count;
    //    if (currentIndex == _currentIndex) {
    //        return;
    //    }
    //    UIButton *preButton = [typeButtons objectAtIndex:_currentIndex];
    //    UIButton *currentBtn = [typeButtons objectAtIndex:currentIndex];
    //    [currentBtn setImage:selectedImage forState:UIControlStateNormal];
    //    [currentBtn setTitle:[modeTitles objectAtIndex:currentIndex] forState:UIControlStateNormal];
    //    [currentBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    //
    //    [preButton setImage:normalImage forState:UIControlStateNormal];
    //    [preButton setTitle:[modeTitles objectAtIndex:_currentIndex] forState:UIControlStateNormal];
    //    [preButton setTitleColor:[UIColor colorFromHexRGB:@"989e9d"] forState:UIControlStateNormal];
    //    _currentIndex = currentIndex;
    currentIndex = currentIndex % typeButtons.count;
    if (currentIndex == _currentIndex) {
        return;
    }
    
    UIButton *preButton = [typeButtons objectAtIndex:_currentIndex];
    UIButton *currentBtn = [typeButtons objectAtIndex:currentIndex];
    [currentBtn setImage:[selectedImagesArr objectAtIndex:currentIndex] forState:UIControlStateNormal];
    UILabel *selectedLabel = [modeTitles objectAtIndex:currentIndex];
    [selectedLabel setTextColor:[UIColor
                                 colorWithRed: 253.0 / 0xff
                                 green: 178.0/ 0xff
                                 blue: 82.0 / 0xff
                                 alpha:1.0]];
    
    [preButton setImage:[unselectedImagesArr objectAtIndex:_currentIndex] forState:UIControlStateNormal];
    UILabel *curLabel = [modeTitles objectAtIndex:_currentIndex];
    [curLabel setTextColor:[UIColor colorFromHexRGB:@"d3d3d3"]];
    
    _currentIndex = currentIndex;
    
    
}

- (void)dealloc
{
    
}

@end
