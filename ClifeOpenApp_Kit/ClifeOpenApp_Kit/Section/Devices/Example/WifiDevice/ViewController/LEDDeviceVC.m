//
//  LedDeviceManagerViewController.m
//  SmartBed
//
//  Created by Sandy wu on 14-8-31.
//  Copyright (c) 2014年 Het. All rights reserved.
//

#import "LEDDeviceVC.h"
#import "HETShareDevcieVC.h"

#import "SleepBoxWithSliderCell.h"
#import "ModeSelectView.h"
#import "GradientColorView.h"
#import "BNRSelectView.h"
#import "BNRSlider.h"

#define viewBgColor [UIColor colorWithRed:235/255.0 green:238/255.0 blue:245/255.0 alpha:1.0]
#define AnimationDuration  0.5

@interface LEDDeviceVC ()<UITableViewDelegate,UITableViewDataSource, ModeSelectViewDelegate, UIAlertViewDelegate, UIScrollViewDelegate,BNRSelectViewDelegate>
/** 底色 **/
@property (nonatomic,strong) GradientColorView    *gradientView;
/** 灯 **/
@property (nonatomic,strong) UIImageView          *ledImageView;
/** 灯光 **/
@property (nonatomic,strong) UIImageView          *lightnessView;
/** 关灯按钮 **/
@property (nonatomic,strong) UIButton             *powerStatusOnBtn;
/** 模式 **/
@property (nonatomic,strong) ModeSelectView       *modeSelectView;
/** 控制面板 **/
@property (nonatomic,strong) UITableView          *ledTableView;
/** 亮度调节开关 **/
@property (nonatomic,strong) UISlider             *lightnessSlider;
/** 颜色开关 **/
@property (nonatomic,strong) UISlider             *colorSlider;
/** 关机底色 **/
@property (nonatomic,strong) UIView               *coverView;
/** 关机led **/
@property (nonatomic,strong) UIImageView          *coverImageView;
/** 电源按键 **/
@property (nonatomic,strong) UIButton             *coverPowerBtn;

@property (nonatomic,strong) HETDeviceControlBusiness *controlBusiness;
@property (nonatomic,assign) NSNumber *              colorTemp;
@property (nonatomic,assign) NSNumber *              lightness;
@property (nonatomic,strong) NSNumber *           sceneMode;
@property (nonatomic,strong) NSNumber *           switchStatus;

/** 是否关灯 **/
@property (nonatomic,assign) BOOL                 isPowerOff;
/** 0:no animation of power on/off is exected ,1: executing power on animation, 2:executing power off animation **/
@property (nonatomic,assign) int                  powerStatus;
@property (nonatomic,strong) NSMutableDictionary   *refreshDic;

@property (nonatomic, assign) BOOL                isOnline;

@end

@implementation LEDDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];

    // 2.设置导航栏
    [self createNavViews];

    // 3.初始化界面
    [self createSubView];

    self.refreshDic = [[NSMutableDictionary alloc] init];

    _isOnline = true;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.controlBusiness start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.controlBusiness stop];
}

- (void)createNavViews {
    // 1.中间标题
    self.navigationItem.title = LEDDeviceTitle;

    // 2.添加设备按妞
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];

    if (self.device.share.integerValue == 2) {
        // 3.设备详情按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_DeviceShare"] style:UIBarButtonItemStylePlain target:self action:@selector(shareDevice)];
    }

}

- (void)createSubView {

    self.gradientView = [[GradientColorView alloc] initWithFrame:CGRectMake(0,64, ScreenWidth, ScreenHeight) withGradientColorArray:[NSMutableArray arrayWithArray:@[[UIColor colorFromHexRGB:@"a93d30"],[UIColor colorFromHexRGB:@"c97a4a"],[UIColor colorFromHexRGB:@"c97a4a"]]] withGradientType:GradientFromUpToDown];
    [self.view addSubview:self.gradientView];

    // 灯泡
    self.ledImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-(ScreenHeight/2 - 40)/1.7/2,0,(ScreenHeight/2 - 40)/1.7, ScreenHeight/2 - 40)];
    UIImage *ledImg = [UIImage imageNamed:@"ledNew_normal"];
    self.ledImageView.image = ledImg;
    self.ledImageView.backgroundColor = [UIColor clearColor];
    [self.gradientView addSubview:self.ledImageView];

    // 盒子灯光
    self.lightnessView = [[UIImageView alloc] initWithFrame:self.ledImageView.bounds];
    self.lightnessView.backgroundColor = [UIColor clearColor];
    self.lightnessView.alpha = 1.0;
    [self.ledImageView addSubview:self.lightnessView];

    // 控制面板
    self.ledTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, ScreenHeight/2-ScreenHeight/10,ScreenWidth, ScreenHeight - (ScreenHeight/2-ScreenHeight/10)) style:UITableViewStylePlain];
    self.ledTableView.delegate=self;
    self.ledTableView.dataSource=self;
    self.ledTableView.bounces = NO;
    self.ledTableView.alwaysBounceVertical = NO;
    self.ledTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.ledTableView.backgroundColor = [UIColor clearColor];
    [self.ledTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:self.ledTableView];

    // 电源
    self.powerStatusOnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *powerImage = [UIImage imageNamed:@"power"];
    self.powerStatusOnBtn.frame = CGRectMake(ScreenWidth-20-powerImage.size.width, ScreenHeight/2-20-powerImage.size.height, powerImage.size.width, powerImage.size.height);
    [self.powerStatusOnBtn setBackgroundImage:powerImage forState:UIControlStateNormal];
    [self.powerStatusOnBtn setBackgroundColor:[UIColor clearColor]];
    [self.powerStatusOnBtn addTarget:self action:@selector(closeLED:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.powerStatusOnBtn];

    NSArray *modeTypes = @[@"阅读", @"休息",@"夜灯"];
    self.modeSelectView = [[ModeSelectView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), (self.ledTableView.frame.size.height-ScreenHeight/10.-40*2)/3.)];
    self.modeSelectView = [self.modeSelectView createModeSelectViewWithTitlesAndPics:modeTypes backgroundPic:modeTypes defaultMode:1 type:3];
    self.modeSelectView.type = 1;    // 单选模式
    self.modeSelectView.modeDelegate = self;
    self.modeSelectView.currentIndex = 1;

}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = (self.ledTableView.frame.size.height-ScreenHeight/10.-40*2)/3.;
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
    {
        return ScreenHeight/10;
    }
    else{
        return 40.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight/10)];
        headView.backgroundColor = [UIColor clearColor];
        headView.alpha = 0.0;
        return headView;
    }
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    titleView.backgroundColor = viewBgColor;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 90, 20)];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];

    NSString *strTitle = nil;

    switch (section) {
        case 0:
            strTitle = nil;
            break;
        case 1:
            strTitle = LEDDeviceLightValue;
            break;
        case 2:
            strTitle = LEDDeviceColorTitle;
            break;
        default:
            break;
    }

    titleLabel.text= strTitle;
    [titleView addSubview:titleLabel];
    return titleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier;

    if(indexPath.section == 0){
        CellIdentifier = @"S0R0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.contentView addSubview:self.modeSelectView];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }

    if(indexPath.section == 1){
        CellIdentifier = @"lightnessSliderCell";
        SleepBoxWithSliderCell *cell0 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell0 == nil) {
            cell0 = [[SleepBoxWithSliderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell0.titleLabel.text=@"";
            self.lightnessSlider = cell0.slider;
            self.lightnessSlider.minimumValue = 0;
            self.lightnessSlider.maximumValue = 10;
            self.lightnessSlider.value = 8;
            [self changeColorImgByValue:2];
            [self changeLEDLightnessByValue:8];
            [self changeLEDLightnessByValue:(int)(self.lightnessSlider.value)];
            [self.lightnessSlider addTarget:self action:@selector(changeLedLightnessValue:) forControlEvents:UIControlEventTouchUpInside];
            cell0.imageView1.image=[UIImage imageNamed:@"icon_dlight"];
            cell0.imageView2.image=[UIImage imageNamed:@"icon_glight"];
            cell0.selectionStyle=UITableViewCellSelectionStyleNone;
        }

        return cell0;
    }

    if(indexPath.section == 2){

        CellIdentifier = @"S2R0";
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell1 == nil) {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell1.contentView addSubview:self.colorSlider];
            cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        return cell1;
    }

    return nil;
}

#pragma mark - led open/close Control
- (void)showOffUI{

    if (self.isPowerOff == YES || self.powerStatus != 0) {
        return;
    }
    self.powerStatus = 2;
    self.isPowerOff = YES;

    [UIView animateWithDuration:AnimationDuration animations:^(){
        CGRect frame = self.ledTableView.frame;
        frame.origin.y = self.view.frame.size.height;
        self.ledTableView.frame = frame;
        self.powerStatusOnBtn.alpha = 0.0;
    }completion:^(BOOL finished){

        // 覆盖一层
        self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, ScreenWidth, self.view.frame.size.height)];
        self.coverView.backgroundColor = [UIColor colorFromHexRGB:@"707f96"];
        [self.view addSubview:self.coverView];

        // 助眠盒子
        UIImage *sleepBoxImage = [UIImage imageNamed:@"led-off"];

        if (ScreenHeight == 480) {
            self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2- 240/1.7/2, 84, 240/1.7, 240)];
        }
        else if(ScreenHeight == 568)
            self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2- 280/1.7/2, 84, 280/1.7, 280)];
        else
            self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-320/1.7/2, 84, 320/1.7, 320)];
        self.coverImageView.image = sleepBoxImage;
        self.coverImageView.backgroundColor = [UIColor clearColor];
        self.coverImageView.alpha = 0.0;
        [self.coverView addSubview:self.coverImageView];

        // 电源开关
        self.coverPowerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *powerImage = [UIImage imageNamed:@"switch"];
        if (ScreenHeight == 480) {
            self.coverPowerBtn.frame = CGRectMake((ScreenWidth-powerImage.size.width*2)/2, self.view.frame.size.height-300/2+20, 2*powerImage.size.width, 2*powerImage.size.height);
        }
        else {
            self.coverPowerBtn.frame = CGRectMake((ScreenWidth-powerImage.size.width*2)/2, self.view.frame.size.height-300/2, 2*powerImage.size.width, 2*powerImage.size.height);
        }
        [self.coverPowerBtn setBackgroundColor:[UIColor clearColor]];
        [self.coverPowerBtn setBackgroundImage:powerImage forState:UIControlStateNormal];
        [self.coverPowerBtn addTarget:self action:@selector(openLED:) forControlEvents:UIControlEventTouchUpInside];
        [self.coverView addSubview:self.coverPowerBtn];
        [UIView animateWithDuration:AnimationDuration animations:^(){
            [self.coverView setFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height)];
        }completion:^(BOOL finished) {

            [UIView animateWithDuration:AnimationDuration animations:^(){
                // 按钮逐渐缩小
                if (ScreenHeight == 480) {
                    self.coverPowerBtn.frame = CGRectMake((ScreenWidth-powerImage.size.width)/2, self.view.frame.size.height-300/2+20, powerImage.size.width, powerImage.size.height);
                }
                else {
                    self.coverPowerBtn.frame = CGRectMake((ScreenWidth-powerImage.size.width)/2, self.view.frame.size.height-300/2, powerImage.size.width, powerImage.size.height);
                }
                // 空气盒子渐显
                self.coverImageView.alpha = 1.0;
            } completion:^(BOOL finished){
                self.powerStatus = 0;
            }];
        }];
    }];
}

- (void)showWorkUI{

    if (self.isPowerOff == NO || self.powerStatus != 0) {
        return;
    }
    self.isPowerOff = NO;
    self.powerStatus = 1;
    [UIView animateWithDuration:AnimationDuration animations:^(){
        // 睡眠盒子逐渐消失
        self.coverImageView.alpha = 0.0;
        // 按钮逐渐扩大
        UIImage *powerImage = [UIImage imageNamed:@"switch"];
        self.coverPowerBtn.frame = CGRectMake((ScreenWidth-powerImage.size.width*2)/2, self.view.frame.size.height-300/2, 2*powerImage.size.width, 2*powerImage.size.height);
        // 空气盒子逐渐消失
    }completion:^(BOOL finished) {
        self.coverPowerBtn.alpha = 0.0;
        // bottom view 逐渐下拉
        [UIView animateWithDuration:AnimationDuration animations:^(){
            [self.coverView setFrame:CGRectMake(0, self.view.frame.size.height, ScreenWidth, self.view.frame.size.height)];
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:AnimationDuration animations:^(){
                self.powerStatusOnBtn.alpha = 1.0;
                self.ledTableView.frame = CGRectMake(0, ScreenHeight/2-ScreenHeight/10,ScreenWidth, ScreenHeight - (ScreenHeight/2-ScreenHeight/10));
            } completion:^(BOOL finished){
                self.powerStatus = 0;
            }];
        }];
    }];
}

- (void)updateViews {

    if (!self.refreshDic) {
        return;
    }
    self.colorSlider.value = [[self.refreshDic objectForKey:@"colorTemp"] intValue];
    int switchStatus = [[self.refreshDic objectForKey:@"switchStatus"] intValue];
    self.lightnessSlider.value = [[self.refreshDic objectForKey:@"lightness"] intValue];
    [self changeLEDLightnessByValue:(int)self.lightnessSlider.value];
    int sceneMode = [[self.refreshDic objectForKey:@"sceneMode"] intValue];
    if (sceneMode != 0) {
        [self.modeSelectView setCurrentIndexForNoImg:(sceneMode-1)];
        if (sceneMode == 1) {
            self.colorSlider.alpha = 0.5;
        }else{
            self.colorSlider.alpha = 1;
        }
    }
    if (sceneMode == 1) {
        [self changeColorImgByValue:0];
    }else{
        [self changeColorImgByValue:self.colorSlider.value];
    }
    if (switchStatus==90) {
        [self showOffUI];
    }else if (switchStatus == 165){
        [self showWorkUI];
    }
}

#pragma mark - 改变场景模式
// 选择场景 0:睡眠,1:看书,2:养生,3:关闭
- (void)changeWorkMode:(NSNumber *)changedMode {
    NSLog(@"you choose mode %@",changedMode);

    int lightLevel = 0;
    int colorTemp = 0;

    switch (changedMode.intValue) {
        case 0:
            lightLevel = 10;
            colorTemp = 0;
            self.colorSlider.alpha = 0.5;
            break;
        case 1:
            lightLevel = 8;
            colorTemp = 2;
            self.colorSlider.alpha = 1;
            break;
        case 2:
            lightLevel = 2;
            colorTemp = 1;
            self.colorSlider.alpha = 1;
            break;
        case 3:
            lightLevel = 0;
            colorTemp = 0;
            self.colorSlider.alpha = 0;
            break;
        default:
            break;
    }

    self.lightnessSlider.value = lightLevel;
    [self changeLEDLightnessByValue:((int)(lightLevel))];
    self.colorSlider.value = colorTemp;
    [self changeColorImgByValue:colorTemp];

    self.colorTemp = @(colorTemp);
    self.lightness = @(lightLevel);
    self.sceneMode = @(changedMode.intValue+1);
    [self changeConfigDict:@{@"sceneMode":self.sceneMode,@"colorTemp":self.colorTemp,@"lightness":self.lightness}];
}

#pragma mark - 关灯
- (void)closeLED:(UIButton *)btn{
    [self showOffUI];
    self.switchStatus = @90;
    [self changeConfigDict:@{@"switchStatus":self.switchStatus}];
}

#pragma mark - 开灯
- (void)openLED:(UIButton *)btn{

    if(_isOnline == false){
        [HETCommonHelp showHudAutoHidenWithMessage:DeviceOffLineState];
        return;
    }
    [self showWorkUI];

    self.switchStatus = @165;
    [self changeConfigDict:@{@"switchStatus":self.switchStatus}];
}

#pragma mark - 亮度调节
- (void)changeLedLightnessValue:(UISlider *)sSlider {
    int lightness = (int)(sSlider.value+0.5);
    [self changeLEDLightnessByValue:lightness];
    self.lightness = @(lightness);
    [self changeConfigDict:@{@"lightness":self.lightness}];
}

- (void)changeLEDLightnessByValue:(int)lightness {
    self.lightnessView.alpha = lightness/12.5+0.2;
}

#pragma mark - 颜色调节
- (void)changeColorTemp:(UISlider *)slider{
    if (self.modeSelectView.currentIndex == 0) {
        slider.value = 0;
        [HETCommonHelp showHudAutoHidenWithMessage:LEDDeviceReadModeAlert];
        return;
    }
    float colorTemp = slider.value;
    int tmp;
    if (colorTemp <= 1.5) {
        tmp = 1;
    }else if (colorTemp > 12.5){
        tmp = 13;
    }else{
        int value = (int)colorTemp;
        if (fabsf(colorTemp - value) >= 0.5) {
            tmp = value + 1;
        }else{
            tmp = value;
        }
    }
    [self changeColorImgByValue:colorTemp];

    self.colorTemp = @(tmp);
    [self changeConfigDict:@{@"colorTemp":self.colorTemp}];
}

- (void)changeColorImgByValue:(CGFloat)color{
    int tmp;
    if (color <= 1.5&&color>0) {
        tmp = 1;
    }else if (color > 12.5){
        tmp = 13;
    }else{
        int value = (int)color;
        if (fabsf(color - value) >= 0.5) {
            tmp = value + 1;
        }else{
            tmp = value;
        }
    }
    self.lightnessView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ledNew%d",tmp]];
    if (tmp == 0) {
        self.lightnessView.image = [UIImage imageNamed:@"ledNew_normal"];
    }
}

- (void)shutOffLight
{
    self.switchStatus = @(90);
    [self changeConfigDict:@{@"switchStatus":self.switchStatus}];
}

- (void)powerOnLight
{
    self.switchStatus = @(165);
    [self changeConfigDict:@{@"switchStatus":self.switchStatus}];
}

- (void)changeConfigDict:(NSDictionary *)dict
{
    NSInteger updateFlag = [self caculationUpdateFlag:dict];
    NSMutableDictionary *changeDict = [NSMutableDictionary dictionary];
    [changeDict setValue:self.colorTemp forKey:@"colorTemp"];
    [changeDict setValue:self.switchStatus forKey:@"switchStatus"];
    [changeDict setValue:self.lightness forKey:@"lightness"];
    [changeDict setValue:self.sceneMode forKey:@"sceneMode"];
    [changeDict setValue:@(updateFlag) forKey:@"updateFlag"];
    [self configDataSetWithColorTemp:changeDict];
}

- (NSInteger)caculationUpdateFlag:(NSDictionary *)dict
{
    NSDictionary *postionDic = @{@"switchStatus":@(0),@"sceneMode":@(1),@"wakeMode":@(2),@"colorTemp":@(3),@"lightness":@(4)};

    unsigned long flag = 0;
    for (NSString *key in dict) {
        NSInteger index = [[postionDic objectForKey:key] integerValue];
        flag |= 0x0001<<index;
    }
    return (NSInteger)flag;
}

#pragma mark - 设备控制
- (void)configDataSetWithColorTemp:(NSDictionary *)dict{

    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString * json1 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    [self.controlBusiness deviceControlRequestWithJson:json1 withSuccessBlock:^(id responseObject) {
        OPLog(@"responseObject = %@",responseObject);
        [HETCommonHelp showHudAutoHidenWithMessage:CommonSetSuccsss];
    } withFailBlock:^(NSError *error) {
        OPLog(@"error = %@",error);
        [HETCommonHelp showHudAutoHidenWithMessage:CommonSetFailed];
    }];
}

- (void)shareDevice
{
    HETShareDevcieVC *shareDeviceVC = [HETShareDevcieVC new];
    shareDeviceVC.self.deviceModel = self.device;
    [self.navigationController pushViewController:shareDeviceVC animated:YES];
}

// 返回按钮
- (void)backAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark setter getter
- (UISlider *)colorSlider{
    if (!_colorSlider) {
        _colorSlider = [[BNRSlider alloc] initWithFrame:CGRectMake(45, 35, ScreenWidth - 90, 20)];
        _colorSlider.minimumTrackTintColor= [UIColor colorFromHexRGB:@"ffffff" alpha:0.0];
        _colorSlider.maximumTrackTintColor = [UIColor clearColor];

        _colorSlider.minimumValue = 0.5;
        _colorSlider.maximumValue = 13.5;
        _colorSlider.value = 2;
        [_colorSlider addTarget:self action:@selector(changeColorTemp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _colorSlider;
}

- (HETDeviceControlBusiness *)controlBusiness
{
    if (!_controlBusiness) {
        WEAKSELF
        _controlBusiness = [[HETDeviceControlBusiness alloc]initWithHetDeviceModel:self.device deviceRunData:^(id responseObject) {

            OPLog(@"deviceRunData:%@ " ,responseObject);

            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {

                [weakSelf receiveAndUpdateView:responseObject];
            }

        } deviceCfgData:^(id responseObject) {

            OPLog(@"deviceCfgData:%@ " ,responseObject);
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                [weakSelf receiveAndUpdateView:responseObject];
            }

        } deviceErrorData:^(id responseObject) {
            OPLog(@"deviceErrorData:%@ " ,responseObject);
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                [weakSelf receiveAndUpdateView:responseObject];
            }

        } deviceState:^(HETWiFiDeviceState state) {
            OPLog(@"deviceState:%ld " ,(long)state);  //deviceState:2

            if (state == HETWiFiDeviceOffState) {
                weakSelf.isOnline = false;
                [weakSelf showOffUI];
            }else{
                weakSelf.isOnline = true;
                [weakSelf showWorkUI];
            }
        } failBlock:^(NSError *error) {
            OPLog(@"failBlock:%@ " ,error);  //deviceState:2

        }];
    }
    return _controlBusiness;
}

- (void)receiveAndUpdateView:(NSDictionary *)responseObject
{
    NSNumber *colorTemp     = [responseObject objectForKey:@"colorTemp"];
    NSNumber *lightness     = [responseObject objectForKey:@"lightness"];
    NSNumber *sceneMode     = [responseObject objectForKey:@"sceneMode"];
    NSNumber *switchStatus  = [responseObject objectForKey:@"switchStatus"];

    
    colorTemp==nil?:[self.refreshDic setObject:colorTemp forKey:@"colorTemp"];
    switchStatus==nil?:[self.refreshDic setObject:switchStatus forKey:@"switchStatus"];
    lightness==nil?:[self.refreshDic setObject:lightness forKey:@"lightness"];
    sceneMode==nil?:[self.refreshDic setObject:sceneMode forKey:@"sceneMode"];

    self.colorTemp =  colorTemp;
    self.lightness =  lightness;
    self.sceneMode =  sceneMode ;
    self.switchStatus =  switchStatus ;
    [self updateViews];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    OPLog(@"%@ dealloc！！！",[self class]);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
