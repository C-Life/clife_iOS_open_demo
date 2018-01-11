//
//  LHShareAction.m
//  fenxiang
//
//  Created by HeT on 15/5/29.
//  Copyright (c) 2015年 HeT. All rights reserved.
//
#import <TencentOpenAPI/TencentOAuth.h>
#import "ShareAction.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "UIImage+DiplomatResize.h"

#define rowHeight  75
#define rowSpace   10
#define Space   8

@interface ShareAction ()

@property (nonatomic, strong) UIView           *shareView;
@property (nonatomic, strong) UIButton         *cancleBtn;
@property (nonatomic, strong) NSMutableArray   *items;
@property (nonatomic, strong) NSDictionary     *infoDic;

@property (nonatomic, strong) UIView           *backgroundMask;    //背景
@property (nonatomic, strong) UIView           *contentView;       //内容

@end

@implementation ShareAction

@synthesize shareView;
@synthesize items;

static ShareAction *lhShare = nil;

- (id)init
{
    self = [self initWithFrame:[UIScreen mainScreen].bounds];

    if (self) {

//        self.items = [[NSMutableArray alloc] initWithObjects:
//                      ShareFunctionWeiXin,
//                      ShareFunctionQQ,
//                      ShareFunctionWeibo,
//                      nil];
        self.items = [[NSMutableArray alloc] initWithObjects:
                      ShareFunctionWeiXin,
                      ShareFunctionQQ,
                      nil];

        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        self.backgroundMask = [[UIView alloc]initWithFrame:self.bounds];
        self.backgroundMask.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundMask.backgroundColor = [UIColor blackColor];
        self.backgroundMask.alpha = 0.5;
        [self addSubview:self.backgroundMask];

        [self creatContentView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        [self.backgroundMask addGestureRecognizer:tap];

        self.windowLevel = UIWindowLevelAlert;
    }

    return self;
}

- (instancetype)initWithItems:(NSArray *)shareItems {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.items = [NSMutableArray arrayWithArray:shareItems];
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        self.backgroundMask = [[UIView alloc]initWithFrame:self.bounds];
        self.backgroundMask.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundMask.backgroundColor = [UIColor blackColor];
        self.backgroundMask.alpha = 0.5;
        [self addSubview:self.backgroundMask];

        [self creatContentView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        [self.backgroundMask addGestureRecognizer:tap];

        self.windowLevel = UIWindowLevelAlert;
    }
    return self;
}

- (void)creatContentView
{
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];

    // 分享
    self.shareView = [[UIView alloc]initWithFrame:CGRectMake(Space, 0, CGRectGetWidth(self.contentView.frame)-2*Space, rowHeight*2+rowSpace)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    self.shareView.alpha = 0.9;
    self.shareView.clipsToBounds = YES;
    self.shareView.layer.cornerRadius = 5;
    [self.contentView addSubview:self.shareView];

    // 取消按钮
    self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleBtn.frame = CGRectMake(Space, CGRectGetMaxY(shareView.frame) + 10, CGRectGetWidth(self.contentView.frame) - Space*2, 44);
    [self.cancleBtn setTitle:CommonCancel forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:[UIColor colorWithRed:0.22 green:0.45 blue:1 alpha:1] forState:UIControlStateNormal];
    [self setBtn:self.cancleBtn backgroundColor:[UIColor colorWithWhite:1 alpha:0.9]];
    self.cancleBtn.layer.cornerRadius = 5;
    self.cancleBtn.clipsToBounds = YES;
    [self.cancleBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancleBtn];

}

// button 背景色
- (void)setBtn:(UIButton*)btn backgroundColor:(UIColor*)color
{
    [btn setBackgroundImage:[self singleColor:color size:CGSizeMake(5, 5)] forState:UIControlStateNormal];
}

- (UIImage*)singleColor:(UIColor*)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark ---------------------
- (void)show{

    [self reloadData];

    lhShare = self;
    lhShare.hidden = NO;

    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundMask.alpha = 0.6;
        CGFloat frameY = CGRectGetHeight(self.bounds) - CGRectGetHeight(self.contentView.frame);
        CGRect frame = self.contentView.frame;
        frame.origin.y = frameY;
        self.contentView.frame = frame;

    } completion:^(BOOL finished) {

    }];
}
// 取消
- (void)dismissView
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.backgroundMask.alpha = 0;

        CGRect frame = self.contentView.frame;
        frame.origin.y = CGRectGetHeight(self.bounds);
        self.contentView.frame = frame;

    } completion:^(BOOL finished) {
        lhShare.hidden = YES;
        lhShare = nil;
    }];
}
- (void)reloadData {

    NSArray *images = @[
                        @"icon_share_wx",
                        @"icon_share_qq",
                        @"icon_share_sina"];

    self.shareView.frame = CGRectMake(Space, 0, CGRectGetWidth(self.contentView.frame)-2*Space, rowHeight*(self.items.count>3?2:1)+rowSpace);
    self.cancleBtn.frame = CGRectMake(Space, CGRectGetMaxY(shareView.frame) + 10, CGRectGetWidth(self.contentView.frame) - Space*2, 44);
    // contentView大小
    CGFloat height = CGRectGetMaxY(self.cancleBtn.frame)+10;
    CGRect frame = self.contentView.frame;
    frame.size.height = height;
    self.contentView.frame = frame;


    for (int i = 0; i < self.items.count; i++) {

        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBtn.frame = CGRectMake(self.shareView.frame.size.width/3*(i%3), self.shareView.frame.size.height/(self.items.count>3?2:1)*(i/3), self.shareView.frame.size.width/3, self.shareView.frame.size.height/(self.items.count>3?2:1));
        iconBtn.backgroundColor = [UIColor clearColor];
        [iconBtn setImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
        iconBtn.imageEdgeInsets = UIEdgeInsetsMake(-15, 0, 0, 0);
        iconBtn.tag = (int)i+100;
        [iconBtn addTarget:self action:@selector(actionForItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:iconBtn];

        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(iconBtn.frame)-35, CGRectGetWidth(iconBtn.frame), 35)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = [self.items objectAtIndex:i];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [iconBtn addSubview:titleLabel];
    }
}
// item点击事件
- (void)actionForItem:(UIButton *)btn {
    [self dismissView];
    switch (btn.tag - 100) {
        case 0:
            [self shareToWeixin:0];
            break;
        case 1:
            [self shareToQQ];
            break;
        case 2:
            [self shareWithWeiBo];
            break;

        default:
            break;
    }
}

#pragma mark- shareToWeixin
- (void)shareToWeixin:(int)index
{
    OPLog(@"shareToWeixin");
    BOOL isInstallWX = [WXApi isWXAppInstalled];
    if (!isInstallWX) {
        [HETCommonHelp showHudAutoHidenWithMessage:ShareFuntionWeiXinAlert];
        return;
    }

    if (index == SHARE_TO_THIRD_WECHAT_SESSION || index == SHARE_TO_THIRD_WECHAT_TIMELINE) {
        // 文本
        //创建发送对象实例
        //        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        //        //        sendReq.bText = NO;//不使用文本信息
        //        sendReq.text = self.webpageUrl;
        //        sendReq.bText = YES;
        //        sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        //
        //        [WXApi sendReq:sendReq];

        // webpage
        //        //创建发送对象实例
        //        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        //        sendReq.bText = NO;//不使用文本信息
        //        sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        //
        //        //创建分享内容对象
        //        WXMediaMessage *urlMessage = [WXMediaMessage message];
        //        urlMessage.title = @"设备分享";//分享标题
        //        urlMessage.description = @"设备权限分享";//分享描述
        //        [urlMessage setThumbImage:[self.codeImage resizedImage:CGSizeMake(120, 120) interpolationQuality:kCGInterpolationMedium]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        //
        //        //创建多媒体对象
        //        WXWebpageObject *webObj = [WXWebpageObject object];
        //        webObj.webpageUrl = self.webpageUrl;//分享链接
        //
        //        WXImageObject * imageObject = [WXImageObject object];
        //        imageObject.imageData = UIImageJPEGRepresentation([self.codeImage resizedImage:CGSizeMake(120, 120) interpolationQuality:kCGInterpolationMedium], 0.65);;
        //        urlMessage.mediaObject = imageObject;
        //
        //        //完成发送对象实例
        //        urlMessage.mediaObject = webObj;
        //        sendReq.message = urlMessage;
        //
        //        //发送分享信息
        //        [WXApi sendReq:sendReq];


        // 图片
        //创建分享内容对象
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:[self.codeImage resizedImage:CGSizeMake(120, 120) interpolationQuality:kCGInterpolationMedium]];

        WXImageObject * imageObject = [WXImageObject object];
        imageObject.imageData = UIImageJPEGRepresentation([self.codeImage resizedImage:CGSizeMake(120, 120) interpolationQuality:kCGInterpolationMedium], 0.65);
        message.mediaObject = imageObject;

        //创建发送对象实例
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;//不使用文本信息

        //完成发送对象实例
        sendReq.message = message;

        // 微信分享场景的选择：朋友圈（WXSceneTimeline）、好友（WXSceneSession）、收藏（WXSceneFavorite）
        sendReq.scene = WXSceneSession;

        //发送分享信息
        [WXApi sendReq:sendReq];
    }
}
#pragma mark- shareToQQ && shareToQQZone
- (void)shareToQQ
{
    OPLog(@"shareToQQ");
    if (![TencentOAuth iphoneQQInstalled]) {
        [HETCommonHelp showHudAutoHidenWithMessage:ShareFuntionQQAlert];
        return;
    }


    // 新闻分享:
    //    NSString *imgPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"test.gif"];
    //    NSData *imgData = [NSData dataWithContentsOfFile:imgPath];
    //    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
    //                                               previewImageData:imgData
    //                                                          title:@"QQ互联测试"
    //                                                    description:@"QQ互联测试分享"];
    //    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    //    //将内容分享到qq
    //    QQApiSendResultCode sent = [QQApiInterface sendReq:req];

    // 纯图片分享:
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImageJPEGRepresentation([self.codeImage resizedImage:CGSizeMake(300, 300) interpolationQuality:kCGInterpolationMedium], 0.65)
                                               previewImageData:UIImageJPEGRepresentation([self.codeImage resizedImage:CGSizeMake(300, 300) interpolationQuality:kCGInterpolationMedium], 0.65)
                                                          title:@"QQ互联测试"
                                                    description:@"QQ互联测试分享"];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];

    // 纯文本分享:
    //    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:self.webpageUrl];
    //    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    //    //将内容分享到qq
    //    QQApiSendResultCode sent = [QQApiInterface sendReq:req];


}



#pragma mark- shareWithWeiBo
- (void)shareWithWeiBo
{
    OPLog(@"shareWithWeiBo");
    BOOL isInstallWb = [WeiboSDK isWeiboAppInstalled];
    if (!isInstallWb) {
        [HETCommonHelp showHudAutoHidenWithMessage:ShareFunctionWeiboAlert];
        return;
    }
    //    if ([self.shareActiondelegate respondsToSelector: @selector(shareWithType:)]) {
    //        [self.shareActiondelegate shareWithType: SHARE_TO_THIRD_WEIBO];
    //    }

    WBAuthorizeRequest *wbRequest = [WBAuthorizeRequest request];
    wbRequest.redirectURI =  @"https://api.weibo.com/oauth2/default.html";
    wbRequest.scope = @"all";

    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation([self.codeImage resizedImage:CGSizeMake(300, 300) interpolationQuality:kCGInterpolationMedium], 0.65);

    WBMessageObject *messageObject = [WBMessageObject message];
    messageObject.text = [NSString stringWithFormat:@"%@ %@",ShareFuntionTitle ,self.webpageUrl];
    messageObject.imageObject = imageObject;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:messageObject authInfo:wbRequest access_token:nil];
    [WeiboSDK sendRequest:request];
    
}
@end

