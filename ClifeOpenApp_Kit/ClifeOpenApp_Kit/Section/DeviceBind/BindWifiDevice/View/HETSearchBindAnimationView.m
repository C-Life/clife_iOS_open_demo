//
//  searchBindAnimationView.m
//  圆圈辐射动画
//
//  Created by hcc on 2016/11/7.
//  Copyright © 2016年 Hancc. All rights reserved.
//

#import "HETSearchBindAnimationView.h"
#import "HETWaterView.h"

#define fontW  31
#define fontH  63
#define fontM  5

@interface HETSearchBindAnimationView()
@property(nonatomic,strong)UIView       *searchingView;
@property(strong,nonatomic)UIImageView  *progressImageView;
@property(nonatomic,strong)UILabel      *progressLable;
@property(nonatomic,strong)UIImageView  *percentageImageview;
@property(nonatomic,strong)UILabel      *searchingLable;

@property(nonatomic,strong)UIView       *bindingView;
@property(nonatomic,strong)UIImageView  *CicleImageView;
@property(nonatomic,strong)UILabel      *productNameLable;
@property(nonatomic,strong)UILabel      *productCodeLable;
@property(nonatomic,strong)UILabel      *bindingLable;
@property(nonatomic,strong)HETWaterView *waterView;

@property(nonatomic,strong)UIView       *bindSuccessView;
@property(nonatomic,strong)UIView       *successImageView;
@property(nonatomic,strong)UILabel      *bindSuccessLable;

@property(nonatomic,strong)NSTimer      *timer;
@property(nonatomic,strong)CABasicAnimation      *rotationAnimation;
@end

@implementation HETSearchBindAnimationView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self configSearchingUI];
        [self configBindingUI];
        [self configBindSuccessUI];

    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continueAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
    return  self;
}

- (void)configSearchingUI
{
    self.searchingView = [[UIView alloc]init];
    [self addSubview:self.searchingView];
    [self.searchingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    self.progressImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_progress"]];
    [self.searchingView addSubview:self.progressImageView];
    [self.progressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-95 *BasicHeight);
    }];

    self.progressLable = [[UILabel alloc]init];
    self.progressLable.backgroundColor = [UIColor clearColor];
    self.progressLable.textColor = UIColorFromRGB(0x3285ff);
    self.progressLable.text = @"0";
    self.progressLable.textAlignment = NSTextAlignmentCenter;
    self.progressLable.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:60];// TrebuchetMS-Italic
    [self.searchingView addSubview:self.progressLable];
    [self.progressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.progressImageView);
    }];

    self.percentageImageview = [[UIImageView alloc]init];
    self.percentageImageview.image = [UIImage imageNamed:@"icon_percentage"];
    [self.searchingView addSubview:self.percentageImageview];
    [self.percentageImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressLable.mas_right);
        make.top.equalTo(self.progressLable);
    }];

    self.searchingLable = [[UILabel alloc]init];
    self.searchingLable = [[UILabel alloc]init];
    self.searchingLable.backgroundColor = [UIColor clearColor];
    self.searchingLable.textColor = UIColorFromRGB(0x919191);
    self.searchingLable.text = ScanDeiveLoading;
    self.searchingLable.textAlignment = NSTextAlignmentCenter;
    self.searchingLable.font = [UIFont systemFontOfSize:14];
    [self.searchingView addSubview:self.searchingLable];
    [self.searchingLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressImageView.mas_bottom).offset(12);
        make.centerX.equalTo(self);
    }];
}

- (void)configBindingUI
{
    self.bindingView = [[UIView alloc]init];
    [self addSubview:self.bindingView];
    [self.bindingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    self.CicleImageView=[[UIImageView alloc]init];
    self.CicleImageView.backgroundColor=[UIColor whiteColor];
    self.CicleImageView.image = [UIImage imageNamed:@"blueCircle"];
    self.CicleImageView.layer.cornerRadius= (self.CicleImageView.image.size.height)/2.0;
    [self.bindingView addSubview:self.CicleImageView];
    [self.CicleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-95 *BasicHeight);
    }];

    self.productNameLable = [[UILabel alloc]init];
    self.productNameLable.backgroundColor = [UIColor clearColor];
    self.productNameLable.textColor = UIColorFromRGB(0x3285ff);
    self.productNameLable.text = @"";
    self.productNameLable.textAlignment = NSTextAlignmentCenter;
    self.productNameLable.font = [UIFont systemFontOfSize:24];
    self.productNameLable.numberOfLines = 0;
    [self.CicleImageView addSubview:self.productNameLable];
    [self.productNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.CicleImageView.mas_centerY).offset(-12);
        make.centerX.equalTo(self.CicleImageView.mas_centerX);
        make.width.equalTo(@(self.CicleImageView.image.size.width-10));
    }];

    self.productCodeLable = [[UILabel alloc]init];
    self.productCodeLable.backgroundColor = [UIColor whiteColor];
    self.productCodeLable.textColor = UIColorFromRGB(0x919191);
    self.productCodeLable.text = @"";
    self.productCodeLable.textAlignment = NSTextAlignmentCenter;
    self.productCodeLable.font = [UIFont systemFontOfSize:16];
    [self.CicleImageView addSubview:self.productCodeLable];
    [self.productCodeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.CicleImageView);
        make.top.equalTo(self.productNameLable.mas_bottom).offset(12);
    }];

    self.bindingLable = [[UILabel alloc]init];
    self.bindingLable = [[UILabel alloc]init];
    self.bindingLable.backgroundColor = [UIColor clearColor];
    self.bindingLable.textColor = UIColorFromRGB(0x919191);
    self.bindingLable.text = ScanDeiveReigesterToCloud;
    self.bindingLable.textAlignment = NSTextAlignmentCenter;
    self.bindingLable.font = [UIFont systemFontOfSize:14];
    [self.bindingView addSubview:self.bindingLable];
    [self.bindingLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CicleImageView.mas_bottom).offset(12);
        make.centerX.equalTo(self);
    }];
}

- (void)configBindSuccessUI
{
    self.bindSuccessView = [[UIView alloc]init];
    [self addSubview:self.bindSuccessView];
    [self.bindingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    self.successImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bindsuccess"]];
    [self.bindSuccessView addSubview:self.successImageView];
    [self.successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-95 *BasicHeight);
    }];

    self.bindSuccessLable = [[UILabel alloc]init];
    self.bindSuccessLable = [[UILabel alloc]init];
    self.bindSuccessLable.backgroundColor = [UIColor clearColor];
    self.bindSuccessLable.textColor = UIColorFromRGB(0x919191);
    self.bindSuccessLable.text = BindDeviceSuccess;
    self.bindSuccessLable.textAlignment = NSTextAlignmentCenter;
    self.bindSuccessLable.font = [UIFont systemFontOfSize:14];
    [self.bindSuccessView addSubview:self.bindSuccessLable];
    [self.bindSuccessLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.successImageView.mas_bottom).offset(12);
        make.centerX.equalTo(self);
    }];
}

- (void)setProductName:(NSString *)productName
{
    _productName = productName;
    //    // 显示前5个字
    //    NSString *str1 = [productName substringToIndex:5];
    //    self.productNameLable.text = str1;
    // 显示全部内容
    self.productNameLable.text = productName;
}

- (void)setProductCode:(NSString *)productCode
{
    _productCode = productCode;
    self.productCodeLable.text = productCode;
}

- (void)setProgressStr:(NSString *)progressStr
{
    _progressStr = progressStr;
    self.progressLable.text = progressStr;
}

// 搜索
-(void)startSearchProgressing
{
    self.bindingView.alpha = 0.0;
    self.bindSuccessView.alpha = 0.0;
    self.searchingView.alpha = 1.0;
    if (self.timer)
    {
        [self.timer invalidate];
    }

    self.rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    self.rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    self.rotationAnimation.duration = 2.0f;
    self.rotationAnimation.cumulative = YES;
    self.rotationAnimation.repeatCount = MAXFLOAT;
    self.rotationAnimation.removedOnCompletion = NO;
    [self.progressImageView.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopSearchProgressing
{
    [self.progressImageView.layer removeAllAnimations];
}

// 绑定中
-(void)startBinding
{
    self.searchingView.alpha = 0.0;
    self.bindSuccessView.alpha = 0.0;
    self.bindingView.alpha = 1.0;

    if (self.timer)
    {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showWave) userInfo:nil repeats:YES];
}
// 绑定成功
-(void)startBindsuccess
{
    self.searchingView.alpha = 0.0;
    self.bindingView.alpha = 0.0;
    self.bindSuccessView.alpha = 1.0;
    if (self.timer)
    {
        [self.timer invalidate];
    }
}

- (void)showWave
{
    __block HETWaterView *waterView = [[HETWaterView alloc]initWithFrame:CGRectMake(0, 0,self.center.x *2, 238.75 *2 * BasicHeight)];
    waterView.backgroundColor = [UIColor clearColor];
    waterView.bkcolor = [UIColor colorWithRed:140/255.0 green:168/255.0 blue:249/255.0 alpha:1.0];
    waterView.centerPoint = CGPointMake(self.center.x,238.75 *BasicHeight);
    [self addSubview:waterView];
    [self bringSubviewToFront:self.bindingView];
    [UIView animateWithDuration:2 animations:^{
        waterView.transform = CGAffineTransformScale(waterView.transform, 2, 2);
        waterView.alpha = 0;
    } completion:^(BOOL finished) {
        [waterView removeFromSuperview];
    }];
}

// 隐藏
- (void)hiddeView
{
    self.searchingView.alpha = 0.0;
    self.bindingView.alpha = 0.0;
    self.bindSuccessView.alpha = 0.0;
    if (self.timer)
    {
        [self.timer invalidate];
    }
}

// 进入后台，在进入前台时调用
- (void)continueAnimation
{
    if (self.timer)
    {
        [self.timer invalidate];
    }

    if (self.searchingView.alpha !=0) {
        return;
    }

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showWave) userInfo:nil repeats:YES];
}

- (void)dealloc
{
    if (self.timer)
    {
        [self.timer invalidate];
    }
}
@end
