//
//  BNRSelectView.m
//  CSleep
//
//  Created by JustinYang on 15/4/16.
//  Copyright (c) 2015年 HeT.com. All rights reserved.
//

#import "BNRSelectView.h"
#define BottomOfView(view) (view.frame.origin.y+view.frame.size.height)
@interface BNRSelectView()
@property(nonatomic,strong)NSArray *selectedImg;
@property(nonatomic,strong)NSArray *normalImg;
@property(nonatomic,strong)NSArray *title;

//@property(nonatomic,strong)NSMutableArray *viewArray;

@end
@implementation BNRSelectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame imageSelected:(NSArray *)selectedImgArray imageNormal:(NSArray *)imageArray title:(NSArray *)titleArray{
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert((selectedImgArray.count == imageArray.count && selectedImgArray.count == titleArray.count), @"all of the array(selectedImgArray,imageArray and titleArray) count must be equal");
        _currentIndex = -1;
        _selectedImg = selectedImgArray;
        _normalImg = imageArray;
        _title = titleArray;
        _viewArray = [NSMutableArray arrayWithCapacity:titleArray.count];
        _btnArray = [NSMutableArray arrayWithCapacity:titleArray.count];
        _titleLabelArray = [NSMutableArray arrayWithCapacity:titleArray.count];
        int count = (int)titleArray.count;
        float width = (float)frame.size.width/count;
        
        for (int i = 0; i < titleArray.count; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*width, 0, width, frame.size.height)];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width/4.0, 15, width/2., width/2.)];
            [btn setBackgroundImage:_normalImg[i] forState:UIControlStateNormal];
            [btn setBackgroundImage:_selectedImg[i] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 100+i;
            [_btnArray addObject:btn];
            [view addSubview:btn];
            
            UILabel *label = [[UILabel alloc] init];
            label.text = titleArray[i];
            label.textColor = [UIColor colorFromHexRGB:@"bababa"];
            label.font = [UIFont systemFontOfSize:15];
            [label sizeToFit];
            label.center = CGPointMake(width/2.0, BottomOfView(btn)+10+label.bounds.size.height/2.0);
            [_titleLabelArray addObject:label];
            [view addSubview:label];
            
            [_viewArray addObject:view];
            [self addSubview:view];
        }
    }
    return self;
}

- (void)setInitialDataWith:(NSInteger)index
{
    _currentIndex = (int)index;
    for (int i = 0; i < self.btnArray.count; i++) {
        UIButton *button = self.btnArray[i];
        UILabel *label = self.titleLabelArray[i];
        if (button.tag == index+100 ) {
            button.selected = YES;
            label.textColor = [UIColor colorFromHexRGB:@"1ab0d4"];
        }else{
            button.selected = NO;
            label.textColor = [UIColor colorFromHexRGB:@"bababa"];
        }
    }
    if ([self.delegate respondsToSelector:@selector(selectView:changedSelectedIndex:)]) {
        [self.delegate selectView:self changedSelectedIndex:(int)index];
    }
}

- (void)buttonAction:(UIButton *)btn{
    int index = (int)btn.tag - 100;
    _currentIndex = index;
    for (int i = 0; i < self.btnArray.count; i++) {
        UIButton *button = self.btnArray[i];
        UILabel *label = self.titleLabelArray[i];
        if (button.tag == btn.tag ) {
            button.selected = YES;
            label.textColor = [UIColor colorFromHexRGB:@"1ab0d4"];
        }else{
            button.selected = NO;
            label.textColor = [UIColor colorFromHexRGB:@"bababa"];
        }
    }
    if ([self.delegate respondsToSelector:@selector(selectView:changedSelectedIndex:)]) {
        [self.delegate selectView:self changedSelectedIndex:index];
    }
}

-(void)setCurrentIndex:(int)currentIndex{
//    NSAssert((currentIndex<self.btnArray.count && currentIndex>=0), @"property currentIndex range is wrong ");
    if (_currentIndex == currentIndex) {
        return;
    }
    _currentIndex = currentIndex;
    if (currentIndex>self.btnArray.count) {
        for (int i = 0; i < self.btnArray.count; i++) {
            UIButton *button = self.btnArray[i];
            UILabel *label = self.titleLabelArray[i];
            button.selected = NO;
            label.textColor = [UIColor colorFromHexRGB:@"bababa"];
        }
        return ;
    }
    for (int i = 0; i < self.btnArray.count; i++) {
        UIButton *button = self.btnArray[i];
        UILabel *label = self.titleLabelArray[i];
        if (i == currentIndex) {
            button.selected = YES;
            label.textColor = [UIColor colorFromHexRGB:@"1ab0d4"];
        }else{
            button.selected = NO;
            label.textColor = [UIColor colorFromHexRGB:@"bababa"];
        }
    }
    
}
@end
