//
//  HETLocationManager.m
//  YFLCoreLocation
//
//  Created by mr.cao on 2018/8/13.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "HETLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "HETLocationConverter.h"
typedef void(^HETLocationBlock)(NSDictionary * location,NSError *error);
@interface HETLocationManager()<CLLocationManagerDelegate>
{
    NSString *_gpsType;
    NSString *_altitude;
}
/**
 * locationManager
 */
@property(nonatomic, strong)CLLocationManager *locationManager;
@property(nonatomic, copy) HETLocationBlock locationBlock;
@end

@implementation HETLocationManager
- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static HETLocationManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[HETLocationManager alloc]init];
    });
    return manager;
}
- (void)getUserLocationWithGPSType:(NSString *)type  withAltitude:(NSString *)altitude completeBlock:(void (^)(NSDictionary *location,NSError *error))completeBlock
{
    _gpsType=type;
    _altitude=altitude;
    self.locationBlock = [completeBlock copy];
    [self startUpdateLocation];
}
#pragma mark- Public
- (void)startUpdateLocation
{
    //判断是否是iOS8
    if ([[UIDevice currentDevice].systemVersion doubleValue] >=8.0)
    {
        //主动要求用户打开定位授权,授权状态改变就会通知代理
        [self.locationManager requestWhenInUseAuthorization];//请求前台和后台定位权限(退出程序和打开程序,权限大一点)
        //[self.mgr requestAlwaysAuthorization];//请求前台定位(程序出狱打开状态)
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways ||
                                                        [CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            //NSLog(@"已经授权成功");
            //已经授权成功的程序，不会重复多次弹出提示授权的窗口（可以改变bundle identifier调试）
            //iOS8授权成功后，开始定位
           // [self.locationManager startUpdatingLocation];
        }
        
    }else
    {
        //3.开始监听
        [self.locationManager startUpdatingLocation];
    }
//    [self.locationManager requestAlwaysAuthorization];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.locationManager startUpdatingLocation];
//    });
    
}



- (void)stopUpdateLocation
{
    [self.locationManager stopUpdatingLocation];
  
}
#pragma mark  ----CLLocationManagerDelegate代理方法

/**该方法调用频率很高，不断更新(一直不断的刷行位置可能造成电池的损耗)
 marager:出发事件的对象
 locations:获取到的位置
 **/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    //如果想获取一次位置，可以获取一次位置后就停掉
    //[manager stopUpdatingLocation];//(设置此属性后，位置信息只会更新一次,然后停止)
    /*
     // CLLocation
     location.coordinate; 坐标, 包含经纬度
     location.altitude; 设备海拔高度 单位是米
     location.course; 设置前进方向 0表示北 90东 180南 270西
     location.horizontalAccuracy; 水平精准度
     location.verticalAccuracy; 垂直精准度
     location.timestamp; 定位信息返回的时间
     location.speed; 设备移动速度 单位是米/秒, 适用于行车速度而不太适用于不行
     */
    //获取用户最后一次位置的信息
    CLLocation *currentLocation=[locations lastObject];
    CLLocationCoordinate2D wgsPt = currentLocation.coordinate;
    CLLocationCoordinate2D gcjPt = [HETLocationConverter wgs84ToGcj02:wgsPt];
    CLLocationCoordinate2D currentPt=wgsPt;
    if([[_altitude uppercaseString] rangeOfString:@"WGS84"].location!=NSNotFound)
    {
        currentPt=gcjPt;
    }
    //CLLocationCoordinate2D bdPt = [HETLocationConverter wgs84ToBd09:wgsPt];
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             
             //NSDictionary *test = [placemark addressDictionary];
             
             
             
             //NSLog(@"%@",placemark);
             //NSLog(@"%@",placemark);//具体位置
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             
             //NSLog(@"Dictionary:%@",placemark.addressDictionary);
             //NSString *detaiAddress=[NSString stringWithFormat:@"%@:%@:%@--%@--%@",[placemark.addressDictionary valueForKey:@"CountryCode"],[placemark.addressDictionary valueForKey:@"Country"],[placemark.addressDictionary valueForKey:@"City"],[placemark.addressDictionary valueForKey:@"FormattedAddressLines"],[placemark.addressDictionary valueForKey:@"Name"]];
             
             //NSArray *streetArr=[placemark.addressDictionary valueForKey:@"FormattedAddressLines"];
             NSString *address =[[NSString alloc]init];
             NSArray *formattedAddressLines =placemark.addressDictionary[@"FormattedAddressLines"];
             for (NSString *addersslines in formattedAddressLines) {
                 address = [address stringByAppendingString:addersslines];
             };
             
             //NSLog(@"详细地址：%@",address);
             //NSLog(@"streetArr:%@",streetArr);
             //NSLog(@"%@", [NSString stringWithFormat:@"WGS-84(国际标准坐标)：\n %f,%f",wgsPt.latitude,wgsPt.longitude]);
             //NSLog(@"%@", [NSString stringWithFormat:@"GCJ-02(中国国测局坐标(火星坐标))：\n %f,%f",gcjPt.latitude,gcjPt.longitude]);
            // NSLog(@"%@", [NSString stringWithFormat:@"BD-09(百度坐标)：\n %f,%f",bdPt.latitude,bdPt.longitude]);
             
             NSMutableDictionary *mutableDic=[[NSMutableDictionary alloc]init];
             [mutableDic setObject:@(currentPt.latitude) forKey:@"latitude"];//string 纬度，浮点数，范围为-90~90，负数表示南纬
             [mutableDic setObject:@(currentPt.longitude) forKey:@"longitude"];//string 经度，浮点数，范围为-180~180，负数表示西经
             [mutableDic setObject:@(currentLocation.speed) forKey:@"speed"];//string 速度，浮点数，单位m/s
             [mutableDic setObject:@(self.locationManager.desiredAccuracy>0?self.locationManager.desiredAccuracy:0) forKey:@"accuracy"];//string 位置的精确度
     
             [mutableDic setObject:@(currentLocation.altitude) forKey:@"altitude"];//string 高度，单位 m
             [mutableDic setObject:@(currentLocation.verticalAccuracy) forKey:@"verticalAccuracy"];//string 垂直精度，单位 m（Android 无法获取，返回 0）
             [mutableDic setObject:@(currentLocation.horizontalAccuracy) forKey:@"horizontalAccuracy"];//string 水平精度，单位 m
             [mutableDic setObject:address forKey:@"address"];//详细地址
             [mutableDic setObject:placemark.name forKey:@"name"];//位置名称
             [mutableDic setObject:city forKey:@"cityName"];//城市名称
             !self.locationBlock?:self.locationBlock(mutableDic,nil);
             self.locationBlock =nil;
             //NSLog(@"city:-->%@",city);
             //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
             [manager stopUpdatingLocation];
         }else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
    
    
    
    
    
    
    
    
    
}
/*
 授权状态发生变化时候，开始调用
 manager: 出发事件的对象
 status:当前授权的状态
 
 */
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    /*
     用户从未选择过权限
     kCLAuthorizationStatusNotDetermined ,
     无法使用定位服务，该状态用户无法改变
     kCLAuthorizationStatusRestricted,
     用户拒绝使用定位服务，或者定位服务总开关出狱关闭状态
     kCLAuthorizationStatusDenied,
     用户允许程序无论何时都可以使用地理位置
     kCLAuthorizationStatusAuthorizedAlways
     用户同意程序在可见时使用地理位置
     kCLAuthorizationStatusAuthorizedWhenInUse
     已经授权（已经废弃不使用）
     kCLAuthorizationStatusAuthorized
     
     */
    
    if (status==kCLAuthorizationStatusNotDetermined)
    {
        NSLog(@"等待用户授权");
    }else if (status==kCLAuthorizationStatusAuthorizedAlways ||
              status==kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        NSLog(@"授权成功");
        
        
        //已经授权成功的程序，不会重复多次弹出提示授权的窗口（可以改变bundle identifier调试）
        //iOS8授权成功后，开始定位
        [self.locationManager startUpdatingLocation];
        
        
        
    }else
    {
        NSLog(@"授权失败");
        //提示用户无法进行定位操作
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前定位不成功 ,请打开定位功能" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alertView show];
        !self.locationBlock?:self.locationBlock(nil,[NSError errorWithDomain:@"" code:0 userInfo:@{@"error":@"location services are disabled in Settings"}]);
    }
}
-(void)dealloc
{
    NSLog(@"HETLocationManager dealloc");
}
#pragma mark- getter
- (CLLocationManager *)locationManager
{
    if (_locationManager == nil)
    {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //_locationManager.allowsBackgroundLocationUpdates = YES;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}
@end
