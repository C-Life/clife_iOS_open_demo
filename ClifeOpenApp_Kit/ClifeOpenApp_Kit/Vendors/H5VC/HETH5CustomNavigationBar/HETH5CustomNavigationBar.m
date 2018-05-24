//
//  HETH5CustomNavigationBar.m
//  HETPublicSDK_HETH5DeviceControl
//
//  Created by mr.cao on 2018/3/14.
//  Copyright © 2018年 HET. All rights reserved.
//

#import "HETH5CustomNavigationBar.h"
#import "sys/utsname.h"

#define kWRDefaultTitleSize 18
#define kWRDefaultTitleColor [UIColor blackColor]
#define kWRDefaultBackgroundColor [UIColor whiteColor]
#define kWRScreenWidth [UIScreen mainScreen].bounds.size.width

@interface HETH5CustomNavigationBar ()
@property (nonatomic, strong) UILabel     *titleLable;
@property (nonatomic, strong) UIButton    *leftButton;
@property (nonatomic, strong) UIButton    *rightButton;
@property (nonatomic, strong) UIView      *bottomLine;


@end
@implementation HETH5CustomNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)CustomNavigationBar {
    HETH5CustomNavigationBar *navigationBar = [[self alloc] initWithFrame:CGRectMake(0, 0, kWRScreenWidth, [HETH5CustomNavigationBar navBarBottom])];
    return navigationBar;
}
- (instancetype)init {
    if (self = [super init]) {
        [self setupView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)setupView {
    [self addSubview:self.backgroundView];
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.leftButton];
    [self addSubview:self.titleLable];
    [self addSubview:self.rightButton];
    [self addSubview:self.bottomLine];
    [self updateFrame];
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = kWRDefaultBackgroundColor;
}
-(void)updateFrame {
    NSInteger top = ([HETH5CustomNavigationBar isIphoneX]) ? 44 : 20;
    NSInteger margin = 0;
    NSInteger buttonHeight = 44;
    NSInteger buttonWidth = 70;
    NSInteger titleLabelHeight = 44;
    NSInteger titleLabelWidth = 180;
    
    self.backgroundView.frame = self.bounds;
    //self.backgroundImageView.frame = self.bounds;
//    self.leftButton.frame = CGRectMake(margin, top, buttonWidth, buttonHeight);
//    self.rightButton.frame = CGRectMake(kWRScreenWidth - buttonWidth - margin, top, buttonWidth, buttonHeight);
//    self.titleLable.frame = CGRectMake((kWRScreenWidth - titleLabelWidth) / 2, top, titleLabelWidth, titleLabelHeight);
//    self.bottomLine.frame = CGRectMake(0, (CGFloat)(self.bounds.size.height-0.5), kWRScreenWidth, 0.5);
    
   /* [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
        } else {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }
    }];*/
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
            make.top.equalTo(self.backgroundView.mas_top);
            make.left.equalTo(self.backgroundView.mas_left);
            make.right.equalTo(self.backgroundView.mas_right);
            make.bottom.equalTo(self.backgroundView.mas_bottom);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.backgroundView.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.backgroundView.mas_safeAreaLayoutGuideLeft).with.offset(margin);
            make.width.equalTo(@(buttonWidth));
            make.height.equalTo(@(buttonHeight));
        } else {
            make.top.equalTo(self.backgroundView.mas_top);
            make.left.equalTo(self.backgroundView.mas_left).with.offset(margin);
            make.width.equalTo(@(buttonWidth));
            make.height.equalTo(@(buttonHeight));
        }
        //        make.top.equalTo(self.backgroundView.mas_top).with.offset(top);
        //        make.left.equalTo(self.backgroundView.mas_left).with.offset(margin);
        //        make.width.equalTo(@(buttonWidth));
        //        make.height.equalTo(@(buttonHeight));
        
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.backgroundView.mas_safeAreaLayoutGuideTop);
            make.right.equalTo(self.backgroundView.mas_safeAreaLayoutGuideRight).with.offset(-margin);
            make.width.equalTo(@(buttonWidth));
            make.height.equalTo(@(buttonHeight));
        } else {
            make.top.equalTo(self.backgroundView.mas_top);
            make.right.equalTo(self.backgroundView.mas_right).with.offset(-margin);
            make.width.equalTo(@(buttonWidth));
            make.height.equalTo(@(buttonHeight));
        }
        //        make.top.equalTo(self.backgroundView.mas_top).with.offset(top);
        //        make.right.equalTo(self.backgroundView.mas_right).with.offset(-margin);
        //        make.width.equalTo(@(buttonWidth));
        //        make.height.equalTo(@(buttonHeight));
        
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backgroundView.mas_top).with.offset(top);
        make.centerX.equalTo(self.backgroundView.mas_centerX);
        make.width.equalTo(@(titleLabelWidth));
        make.height.equalTo(@(titleLabelHeight));
        
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backgroundView.mas_top).with.offset(0.5);
        make.left.equalTo(self.backgroundView.mas_left);
        make.right.equalTo(self.backgroundView.mas_right);
        make.height.equalTo(@(0.5));
        
    }];

 
    
}

#pragma mark - 导航栏左右按钮事件
-(void)clickBack:(UIButton *)sender {
    if (self.onClickLeftButton) {
        self.onClickLeftButton(sender.tag,sender.currentTitle);
    }
}
-(void)clickRight:(UIButton *)sender {
    if (self.onClickRightButton) {
        self.onClickRightButton(sender.tag,sender.currentTitle);
    }
}

- (void)wr_setBottomLineHidden:(BOOL)hidden {
    self.bottomLine.hidden = hidden;
}

- (void)wr_setBackgroundAlpha:(CGFloat)alpha {
    self.backgroundView.alpha = alpha;
    self.backgroundImageView.alpha = alpha;
    self.bottomLine.alpha = alpha;
}

- (void)wr_setTintColor:(UIColor *)color {
    [self.leftButton setTitleColor:color forState:UIControlStateNormal];
    [self.rightButton setTitleColor:color forState:UIControlStateNormal];
    [self.titleLable setTextColor:color];
}

#pragma mark - 左右按钮
- (void)wr_setLeftButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted title:(NSString *)title titleColor:(UIColor *)titleColor backBroundColor:(UIColor *)backgroundColor {
    self.leftButton.hidden = NO;
    
    [self.leftButton setImage:normal forState:UIControlStateNormal];
   
    [self.leftButton setImage:highlighted forState:UIControlStateHighlighted];
    
    [self.leftButton setTitle:title forState:UIControlStateNormal];
    [self.leftButton setTitleColor:titleColor forState:UIControlStateNormal];
    self.leftButton.backgroundColor=backgroundColor;
}
//- (void)wr_setLeftButtonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor {
//    [self wr_setLeftButtonWithNormal:image highlighted:image title:title titleColor:titleColor backBroundColor:nil];
//}
//- (void)wr_setLeftButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted {
//    [self wr_setLeftButtonWithNormal:normal highlighted:highlighted title:nil titleColor:nil backBroundColor:nil];
//}
//- (void)wr_setLeftButtonWithImage:(UIImage *)image {
//    [self wr_setLeftButtonWithNormal:image highlighted:image title:nil titleColor:nil];
//}
//- (void)wr_setLeftButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor {
//    [self wr_setLeftButtonWithNormal:nil highlighted:nil title:title titleColor:titleColor];
//}

- (void)wr_setRightButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted title:(NSString *)title titleColor:(UIColor *)titleColor backBroundColor:(UIColor *)backgroundColor
{
    self.rightButton.hidden = NO;
  
    [self.rightButton setImage:normal forState:UIControlStateNormal];

    [self.rightButton setImage:highlighted forState:UIControlStateHighlighted];
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    [self.rightButton setTitleColor:titleColor forState:UIControlStateNormal];
    self.rightButton.backgroundColor=backgroundColor;
}
//- (void)wr_setRightButtonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor {
//    [self wr_setRightButtonWithNormal:image highlighted:image title:title titleColor:titleColor];
//}
//- (void)wr_setRightButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted {
//    [self wr_setRightButtonWithNormal:normal highlighted:highlighted title:nil titleColor:nil];
//}
//- (void)wr_setRightButtonWithImage:(UIImage *)image {
//    [self wr_setRightButtonWithNormal:image highlighted:image title:nil titleColor:nil];
//}
//- (void)wr_setRightButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor {
//    [self wr_setRightButtonWithNormal:nil highlighted:nil title:title titleColor:titleColor];
//}

#pragma mark - setter
-(void)setTitle:(NSString *)title {
    _title = title;
    self.titleLable.hidden = NO;
    self.titleLable.text = _title;
}
- (void)setTitleLabelColor:(UIColor *)titleLabelColor {
    _titleLabelColor = titleLabelColor;
    self.titleLable.textColor = _titleLabelColor;
}
- (void)setTitleLabelFont:(UIFont *)titleLabelFont {
    _titleLabelFont = titleLabelFont;
    self.titleLable.font = _titleLabelFont;
}
-(void)setBarBackgroundColor:(UIColor *)barBackgroundColor {
    self.backgroundImageView.hidden = YES;
    _barBackgroundColor = barBackgroundColor;
    self.backgroundView.hidden = NO;
    self.backgroundView.backgroundColor = _barBackgroundColor;
}
- (void)setBarBackgroundImage:(UIImage *)barBackgroundImage {
    self.backgroundView.hidden = YES;
    _barBackgroundImage = barBackgroundImage;
    self.backgroundImageView.hidden = NO;
    self.backgroundImageView.image = _barBackgroundImage;
}

#pragma mark - getter
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.imageView.contentMode = UIViewContentModeCenter;
        _leftButton.hidden = YES;
        _leftButton.titleLabel.adjustsFontSizeToFitWidth=YES;
    }
    return _leftButton;
}
-(UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton addTarget:self action:@selector(clickRight:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.imageView.contentMode = UIViewContentModeCenter;
        _rightButton.hidden = YES;
         _rightButton.titleLabel.adjustsFontSizeToFitWidth=YES;
    }
    return _rightButton;
}
-(UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = kWRDefaultTitleColor;
        _titleLable.font = [UIFont systemFontOfSize:kWRDefaultTitleSize];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.hidden = YES;
    }
    return _titleLable;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithRed:(CGFloat)(218.0/255.0) green:(CGFloat)(218.0/255.0) blue:(CGFloat)(218.0/255.0) alpha:1.0];
    }
    return _bottomLine;
}
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
}
-(UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.hidden = YES;
    }
    return _backgroundImageView;
}

+ (int)navBarBottom {
    return 44 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}
+ (BOOL)isIphoneX {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
        // judgment by height when in simulators
        return (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)) ||
                CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)));
    }
    BOOL isIPhoneX = [platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"];
    return isIPhoneX;
}
@end
