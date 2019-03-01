//
//  NSDate+SSToolkitAdditions.m
//  SSToolkit
//
//  Created by Sam Soffes on 5/26/10.
//  Copyright 2010-2011 Sam Soffes. All rights reserved.
//

#import "NSDate+SSToolkitAdditions.h"
#include <time.h>
#include <xlocale.h>
#define ISO8601_MAX_LEN 25

@implementation NSDate (SSToolkitAdditions)
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

#pragma clang diagnostic ignored"-Wshorten-64-to-32"
#pragma clang diagnostic ignored"-Wformat"

+ (NSDate *)dateFromISO8601String:(NSString *)iso8601 {
    if (!iso8601) {
        return nil;
    }
    
    const char *str = [iso8601 cStringUsingEncoding:NSUTF8StringEncoding];
    char newStr[ISO8601_MAX_LEN];
    bzero(newStr, ISO8601_MAX_LEN);
    
    size_t len = strlen(str);
    if (len == 0) {
        return nil;
    }
    
    // UTC dates ending with Z
    if (len == 20 && str[len - 1] == 'Z') {
        memcpy(newStr, str, len - 1);
        strncpy(newStr + len - 1, "+0000\0", 6);
    }
    
    // Timezone includes a semicolon (not supported by strptime)
    else if (len == 25 && str[22] == ':') {
        memcpy(newStr, str, 22);
        memcpy(newStr + 22, str + 23, 2);
    }
    
    // Fallback: date was already well-formatted OR any other case (bad-formatted)
    else {
        memcpy(newStr, str, len > ISO8601_MAX_LEN - 1 ? ISO8601_MAX_LEN - 1 : len);
    }
    
    // Add null terminator
    newStr[sizeof(newStr) - 1] = 0;
    
    struct tm tm = {
        .tm_sec = 0,
        .tm_min = 0,
        .tm_hour = 0,
        .tm_mday = 0,
        .tm_mon = 0,
        .tm_year = 0,
        .tm_wday = 0,
        .tm_yday = 0,
        .tm_isdst = -1,
    };
    //2011-01-31T19:42:36Z
    if (strptime_l(newStr, "%Y-%m-%d %H:%M:%S", &tm, NULL) == NULL) {
        return nil;
    }
    
    return [NSDate dateWithTimeIntervalSince1970:mktime(&tm)];
}

+ (NSDate *)gmtDateFromISO8601String:(NSString *)iso8601 {
    if (!iso8601) {
        return nil;
    }
    
    const char *str = [iso8601 cStringUsingEncoding:NSUTF8StringEncoding];
    char newStr[ISO8601_MAX_LEN];
    bzero(newStr, ISO8601_MAX_LEN);
    
    size_t len = strlen(str);
    if (len == 0) {
        return nil;
    }
    
    // UTC dates ending with Z
    if (len == 20 && str[len - 1] == 'Z') {
        memcpy(newStr, str, len - 1);
        strncpy(newStr + len - 1, "+0000\0", 6);
    }
    
    // Timezone includes a semicolon (not supported by strptime)
    else if (len == 25 && str[22] == ':') {
        memcpy(newStr, str, 22);
        memcpy(newStr + 22, str + 23, 2);
    }
    
    // Fallback: date was already well-formatted OR any other case (bad-formatted)
    else {
        memcpy(newStr, str, len > ISO8601_MAX_LEN - 1 ? ISO8601_MAX_LEN - 1 : len);
    }
    
    // Add null terminator
    newStr[sizeof(newStr) - 1] = 0;
    
    struct tm tm = {
        .tm_sec = 0,
        .tm_min = 0,
        .tm_hour = 0,
        .tm_mday = 0,
        .tm_mon = 0,
        .tm_year = 0,
        .tm_wday = 0,
        .tm_yday = 0,
        .tm_isdst = -1,
    };
    //2011-01-31T19:42:36Z
    if (strptime_l(newStr, "%Y-%m-%d %H:%M:%S", &tm, NULL) == NULL) {
        return nil;
    }
    
    return [NSDate dateWithTimeIntervalSince1970:timegm(&tm)];
}


- (NSString *)ISO8601String {
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = (time_t)[self timeIntervalSince1970];
    timeinfo = gmtime(&rawtime);
    
    strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

-(time_t)GMTSecond
{
    time_t rawtime = (time_t)[self timeIntervalSince1970];
    return rawtime;
}

-(int)getCurrentHour{
    struct tm *timeinfo;
    time_t rawtime = (time_t)[self timeIntervalSince1970];
    timeinfo = localtime(&rawtime);
    return timeinfo->tm_hour;
}
-(int)getCurrentMinus{
    struct tm *timeinfo;
    time_t rawtime = (time_t)[self timeIntervalSince1970];
    timeinfo = localtime(&rawtime);
    return timeinfo->tm_min;
}
-(int)getCurrentSecond{
    struct tm *timeinfo;
    time_t rawtime = (time_t)[self timeIntervalSince1970];
    timeinfo = localtime(&rawtime);
    return timeinfo->tm_sec;
}
/**
 *  获取一个时间对应的小时
 *
 *  @param dateString 需要获取的时间字符
 *
 *  @return 返回小时的值
 */
+(int)getDateHour:(NSString*)dateString{
    struct tm *timeinfo;
    time_t rawtime = (time_t)[[NSDate dateFromISO8601String:dateString] timeIntervalSince1970];
    timeinfo = localtime(&rawtime);
    return timeinfo->tm_hour;
}

/**
 *  获取一个时间对应的分钟
 *
 *  @param dateString 需要获取的时间字符
 *
 *  @return 返回分钟的值
 */
+(int)getDateMitune:(NSString*)dateString{
    struct tm *timeinfo;
    time_t rawtime = (time_t)[[NSDate dateFromISO8601String:dateString] timeIntervalSince1970];
    timeinfo = localtime(&rawtime);
    return timeinfo->tm_min;
}

/**
 *  获取一个时间对应的秒
 *
 *  @param dateString 需要获取的时间字符
 *
 *  @return 返回秒的值
 */
+(int)getDateSecond:(NSString*)dateString{
    struct tm *timeinfo;
    time_t rawtime = (time_t)[[NSDate dateFromISO8601String:dateString] timeIntervalSince1970];
    timeinfo = localtime(&rawtime);
    return timeinfo->tm_sec;
}

/**
 *  获取指定的两个时间间隔的小时数组
 *
 *  @param beginTime 开始时间
 *  @param endTime   结束时间
 *
 *  @return 间隔多少个小时(整点)
 */
+(NSArray*)getBetweenHourByBeginTime:(NSString*)beginTime EndTime:(NSString*)endTime{
    
    time_t beginrawtime = (time_t)[[NSDate dateFromISO8601String:beginTime] timeIntervalSince1970];
    time_t endrawtime = (time_t)[[NSDate dateFromISO8601String:endTime] timeIntervalSince1970];
    
    time_t tempRawTime=beginrawtime;
    struct tm *timeinfo;
    NSMutableArray* resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    char buffer[80];
    while (tempRawTime<=endrawtime) {
        timeinfo = localtime(&tempRawTime);
        strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
        [resultArray addObject:[NSString stringWithCString:buffer encoding:NSUTF8StringEncoding] ];
        tempRawTime+=3600;
    }
    return resultArray;
    //    return nil;
}

/**
 *  获取指定的两个日期之间区间数组
 *
 *  @param beginTime 开始时间
 *  @param endTime   结束时间
 *
 *  @return 间隔多少天
 */
+(NSArray*)getBetweenDayByBeginTime:(NSString*)beginTime EndTime:(NSString*)endTime{
    
    time_t beginrawtime = (time_t)[[NSDate dateFromISO8601String:beginTime] timeIntervalSince1970];
    time_t endrawtime = (time_t)[[NSDate dateFromISO8601String:endTime] timeIntervalSince1970];
    
    time_t tempRawTime=beginrawtime;
    struct tm *timeinfo;
    NSMutableArray* resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    char buffer[80];
    while (tempRawTime<=endrawtime) {
        timeinfo = localtime(&tempRawTime);
        strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
        [resultArray addObject:[NSString stringWithCString:buffer encoding:NSUTF8StringEncoding] ];
        tempRawTime+=3600*24;
    }
    return resultArray;
    //    return nil;
}

/**
 *  获取指定时间N天前
 *
 *  @param preTime 指定时间
 *  @param addDay  指定的间隔天数
 *
 *  @return
 */
-(NSString*)getAddTime:(NSString*)preTime AddDays:(int)addDay
{
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = (time_t)[[NSDate dateFromISO8601String:preTime] timeIntervalSince1970]+addDay*24*3600;
    timeinfo = localtime(&rawtime);
    
    strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}


-(int)dayCountFrom:(NSString*)fromDay toDay:(NSString*)toDay
{
    time_t fromRawtime = (time_t)[[NSDate dateFromISO8601String:fromDay] timeIntervalSince1970];
    
    time_t toRawtime = (time_t)[[NSDate dateFromISO8601String:toDay] timeIntervalSince1970];
    
    time_t timeCount=toRawtime-fromRawtime;
    int dayCount=(int)timeCount/(24*3600);
    return dayCount;
}

-(int)minutesCountFrom:(NSString*)fromDay toDay:(NSString*)toDay {
    time_t fromRawtime = (time_t)[[NSDate dateFromISO8601String:fromDay] timeIntervalSince1970];
    
    time_t toRawtime = (time_t)[[NSDate dateFromISO8601String:toDay] timeIntervalSince1970];
    
    time_t timeCount = toRawtime-fromRawtime;
    int minuteCount = (int)timeCount/60;
    return minuteCount;
}
-(long)secondCountFrom:(NSString *)fromTime toTime:(NSString *)toTime{
    time_t fromRawtime = (time_t)[[NSDate dateFromISO8601String:fromTime] timeIntervalSince1970];
    
    time_t toRawtime = (time_t)[[NSDate dateFromISO8601String:toTime] timeIntervalSince1970];
    
    time_t timeCount = toRawtime-fromRawtime;
    return timeCount;
}
- (NSString *)LocalTimeISO8601StringByAddDays:(int)addDay {
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = (time_t)[self timeIntervalSince1970]+addDay*24*3600;
    timeinfo = localtime(&rawtime);
    
    strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

- (NSString *)LocalTimeISO8601StringByAddMins:(int)addMins {
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = (time_t)[self timeIntervalSince1970]+addMins*60;
    timeinfo = localtime(&rawtime);
    
    strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

- (NSString *)LocalTimeISO8601StringFromDate:(NSString *)beginDate addDays:(int)addDay
{
    struct tm *timeinfo;
    char buffer[80];
    // (time_t)[[NSDate dateFromISO8601String:tempString] timeIntervalSince1970]
    time_t rawtime = (time_t)[[NSDate dateFromISO8601String:beginDate] timeIntervalSince1970] + addDay*24*3600;
    timeinfo = localtime(&rawtime);
    strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

- (NSString *)LocalTimeISO8601String {
    struct tm *timeinfo;
    char buffer[80];

    time_t rawtime = (time_t)[self timeIntervalSince1970];
    timeinfo = localtime(&rawtime);
    
    strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}


+(NSString *)currentTimeOffset{
    time_t t = time(NULL);
    struct tm lt = {0};
    localtime_r(&t, &lt);
    int hour=lt.tm_gmtoff/3600;
    int minute=(lt.tm_gmtoff%3600)*60;
    
    if (hour<0) {
        return [NSString stringWithFormat:@"%05d",hour*100+minute];
    }
    return [NSString stringWithFormat:@"%04d",hour*100+minute];
}


+(int)betweenSecondWithStartTime:(NSString*)startTime EndTime:(NSString*)endTime{
    time_t fromRawtime = (time_t)[[NSDate dateFromISO8601String:startTime] timeIntervalSince1970];
    time_t endRawtime = (time_t)[[NSDate dateFromISO8601String:endTime] timeIntervalSince1970];
    return endRawtime-fromRawtime;
}

+ (NSString *)ISO8601String_Withobliqueline {
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = (time_t)[[NSDate date] timeIntervalSince1970];
    timeinfo = localtime(&rawtime);
    
    strftime(buffer, 80, "%Y/%m/%d %H:%M:%S", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

+(NSString*)chinesDayStringByDateString:(NSString*)inputString
{
    struct tm *timeinfo;
    char buffer[80];
    NSString* tempString=[NSString stringWithFormat:@"%@ 00:00:00",[inputString substringToIndex:10]];
    
    time_t fromRawtime = (time_t)[[NSDate dateFromISO8601String:tempString] timeIntervalSince1970];
    timeinfo = localtime(&fromRawtime);
    
    strftime(buffer, 80, "%m月%d日", timeinfo);
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}



+(NSString*)localTimeToGMTString:(NSString*)localTimeString
{
    struct tm *timeinfo;
    char buffer[80];
    time_t fromRawtime = (time_t)[[NSDate dateFromISO8601String:localTimeString] timeIntervalSince1970];
    timeinfo = gmtime(&fromRawtime);
    
    strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

+(NSString*)GMTTimeToLocalTimeString:(NSString*)gmtTimeString
{
    if (gmtTimeString==nil||gmtTimeString.length<=0) {
        return @"";
    }
    struct tm *timeinfo;
    char buffer[80];
    time_t fromRawtime = (time_t)[[NSDate gmtDateFromISO8601String:gmtTimeString] timeIntervalSince1970];
    timeinfo = localtime(&fromRawtime);
    
    strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

+(NSString*)ChineseWeekString:(NSString*)inputString
{
    if (!inputString || inputString.length < 10)
    {
        return @"";
    }
    
    NSString* tempString=[NSString stringWithFormat:@"%@ 00:00:00",[inputString substringToIndex:10]];
    struct tm *timeinfo;
    char buffer[80];
    time_t fromRawtime = (time_t)[[NSDate dateFromISO8601String:tempString] timeIntervalSince1970];
    timeinfo = localtime(&fromRawtime);
    
    strftime(buffer, 80, "%u", timeinfo);
    
    NSString* weekString= [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
    if ([weekString isEqualToString:@"1"]) {
        weekString=@"星期一";
        return weekString;
    }
    if ([weekString isEqualToString:@"2"]) {
        weekString=@"星期二";
        return weekString;
    }
    if ([weekString isEqualToString:@"3"]) {
        weekString=@"星期三";
        return weekString;
    }
    if ([weekString isEqualToString:@"4"]) {
        weekString=@"星期四";
        return weekString;
    }
    if ([weekString isEqualToString:@"5"]) {
        weekString=@"星期五";
        return weekString;
    }
    if ([weekString isEqualToString:@"6"]) {
        weekString=@"星期六";
        return weekString;
    }
    if ([weekString isEqualToString:@"7"]) {
        weekString=@"星期天";
        return weekString;
    }
    return nil;
}


+(NSString*)LastDayOfMonth:(int)iMonth year:(int)iYear
{
    //    struct tm when;
    time_t lastday;
    // Set up current month
    struct tm when = {
        .tm_sec = 0,
        .tm_min = 0,
        .tm_hour = 0,
        .tm_mday = 1,
        .tm_mon = 0,
        .tm_year = 0,
        .tm_wday = 0,
        .tm_yday = 0,
        .tm_isdst = -1,
    };
    
    
    // Next month 0=Jan
    if (iMonth == 12)
    {
        when.tm_mon = 0;
        when.tm_year = iYear - 1900 + 1;
    }
    else
    {
        when.tm_mon = iMonth;
        when.tm_year = iYear - 1900;
    }
    
    // Get the first day of the next month
    lastday = mktime (&when);
    
    // Subtract 1 day
    lastday -= 86400;
    
    
    // Convert back to date and time
    when = *localtime(&lastday);
    
    char buffer[80];
    strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", &when);
    //    return @"";
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

+(NSString *)getCurrentTime{
    time_t rawtime;
    struct tm * timeinfo;
    time ( &rawtime );
    timeinfo = localtime(&rawtime);
    char buffer[20]={0};
    strftime(buffer, 20, "%H%M", timeinfo);
    NSString * dateTime = [NSString stringWithFormat:@"%c%c:%c%c",buffer[0],buffer[1],buffer[2],buffer[3]];
    return dateTime;
}
+(NSString *)getCurrentDate
{
    time_t rawtime;
    struct tm * timeinfo;
    time ( &rawtime );
    timeinfo = localtime(&rawtime);
    char buffer[20]={0};
    strftime(buffer, 80, "%Y-%m-%d", timeinfo);
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}
+(NSString*)firstDayOfMonth:(int)iMonth year:(int)iYear
{
    struct tm when;
    
    // Set up current month
    when.tm_hour = 0;
    when.tm_min = 0;
    when.tm_sec = 0;
    when.tm_mday = 1;
    
    // Next month 0=Jan
    //    if (iMonth == 12)
    //    {
    //        when.tm_mon = 0;
    //        when.tm_year = iYear - 1900 + 1;
    //    }
    //    else
    //    {
    //        when.tm_mon = iMonth;
    //        when.tm_year = iYear - 1900;
    //    }
    
    when.tm_mon = iMonth-1;
    when.tm_year = iYear - 1900;
    // Get the first day of the next month
    //    lastday = mktime (&when);
    //
    //    // Subtract 1 day
    ////    lastday -= 86400;
    //
    //    // Convert back to date and time
    //    when = *localtime (&lastday);
    
    char buffer[80];
    strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", &when);
    //    return @"";
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

+(NSDictionary*)getFirstAndLastDayOfMonth:(NSString*)monthDate{
    monthDate=[NSString stringWithFormat:@"%@ 23:59:59",[monthDate substringToIndex:10]];
    NSString* yearString=[monthDate substringToIndex:4];
    NSString* monthString=[monthDate substringWithRange:NSMakeRange(5, 2)];
    int yearIntValue=[yearString intValue];
    int monthIntValue=[monthString intValue];
    
    NSString* firstDayOfMonth=[NSDate firstDayOfMonth:monthIntValue year:yearIntValue];
    NSString* lastDayOfMonth=[NSDate LastDayOfMonth:monthIntValue year:yearIntValue];
    
    
    //    lastDayOfMonth=[NSString stringWithFormat:@"%@ 23:59:59",[lastDayOfMonth substringToIndex:10]];
    //
    //    NSDate* monthDateObc=[NSDate dateFromISO8601String:monthDate];
    //    NSDate* lastDayDateObc=[NSDate dateFromISO8601String:lastDayOfMonth];
    //
    //    if ([monthDateObc earlierDate:lastDayDateObc]) {
    //        lastDayOfMonth=monthDate;
    //    }
    //
    //    NSString* currentDateTime=[[NSDate date] LocalTimeISO8601String];
    //    int currentDayValue=[[currentDateTime substringWithRange:NSMakeRange(8, 2)] intValue];
    //    int currentMonthValue=[[currentDateTime substringWithRange:NSMakeRange(5, 2)] intValue];
    //    if (currentDayValue<=5) {
    //        if (currentMonthValue==monthIntValue) {
    //            firstDayOfMonth=[NSDate firstDayOfMonth:monthIntValue-1 year:yearIntValue];
    //        }
    //    }
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:firstDayOfMonth,@"firstDay",lastDayOfMonth,@"lastDay", nil];
    return dic;
}

+(NSDictionary*)getFirstAndLastDayOfWeek:(NSString *)weekDate {
    
    int weekDay = [[NSDate date] dayOfWeek:weekDate];
    // weekDay-1  7-weekDay
    NSString *firstWeekDay = [[NSDate date] getAddTime:[NSString stringWithFormat:@"%@ 00:00:00", weekDate] AddDays:-(weekDay-1)];
    NSString *lastWeekDay = [[NSDate date] getAddTime:[NSString stringWithFormat:@"%@ 00:00:00", weekDate] AddDays:7-weekDay];
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:firstWeekDay,@"firstDay",lastWeekDay,@"lastDay", nil];
    
    return dic;
}

-(NSString*)GMTDayISO8601String
{
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = (time_t)[self timeIntervalSince1970];
    timeinfo = gmtime(&rawtime);
    
    strftime(buffer, 80, "%Y-%m-%d", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}
-(NSString *)GMTDayISO8601StringByAddDays:(int)days{
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = (time_t)[self timeIntervalSince1970]+days*24*3600;
    timeinfo = gmtime(&rawtime);
    
    strftime(buffer, 80, "%Y-%m-%d", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

-(NSString*)LocalDayISO8601String
{
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = (time_t)[self timeIntervalSince1970];
    timeinfo = localtime(&rawtime);
    
    strftime(buffer, 80, "%Y-%m-%d", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}
-(NSString *)LocalDayISO8601StringByAddDays:(int)addDay{
    NSString *time = [[NSDate date] LocalTimeISO8601StringByAddDays:addDay];
    return [time substringWithRange:NSMakeRange(0, 10)];
}
+(NSString*)getDayOfCurrentDay
{
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = (time_t)[[NSDate date] timeIntervalSince1970];
    timeinfo = gmtime(&rawtime);
    
    strftime(buffer, 80, "%d", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

+(NSString*)getLoadingTitleFromTime:(NSString*)startLoadTime
{
    if (startLoadTime==nil||startLoadTime.length<=0) {
        return @"";
    }
    time_t loadtime = (time_t)[[NSDate dateFromISO8601String:startLoadTime] timeIntervalSince1970];
    
    time_t nowtime = (time_t)[[NSDate date] timeIntervalSince1970];
    NSTimeInterval seconds = fabs([[NSDate date] timeIntervalSinceNow]);
    seconds=nowtime-loadtime;
    if (seconds<=30) {
        return @"";
    }
    else if(seconds<=60)
    {
        return @"数据有点多，请稍候...";
    }
    else if(seconds<=90)
    {
        return @"继续努力同步中...";
    }
    else if(seconds<=120)
    {
        return @"是不是有几天没上传了？";
    }
    else if(seconds<=150)
    {
        return @"数据真的不少啊...";
    }
    else if(seconds<=180)
    {
        return @"马上就结束了...";
    }
    else{
        return @"胜利就在眼前，坚持住...";
    }
    return @"";
}

+ (NSString *)briefUpdateTimeInWords:(NSString*)updateString isV1:(BOOL)isV1{
    if (updateString==nil||updateString.length<=0) {
        return @"";
    }
    NSTimeInterval seconds = fabs([[NSDate date] timeIntervalSinceNow]);
    
    time_t updateRawtime = (time_t)[[NSDate dateFromISO8601String:updateString] timeIntervalSince1970];
    
    time_t nowtime = (time_t)[[NSDate date] timeIntervalSince1970];
    
    seconds=nowtime-updateRawtime;
    static NSNumberFormatter *numberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        numberFormatter.currencySymbol = @"";
        numberFormatter.maximumFractionDigits = 0;
    });
    
    // Seconds
    if (seconds < 30.0) {
        if (isV1) {
            return NSLocalizedString(@"V1Just Update", nil);
        }
        return NSLocalizedString(@"Just Update", nil);
    }
    
    else if(seconds >= 30 && seconds < 60)
    {
        if (isV1) {
            return NSLocalizedString(@"V1Update 30s Before", nil);
        }
        return NSLocalizedString(@"Update 30s Before", nil);
    }
    
    else if(seconds >= 60 && seconds < 60*2)
    {
        if (isV1) {
            return NSLocalizedString(@"V1Update 1m Before", nil);
        }
        return NSLocalizedString(@"Update 1m Before", nil);
    }
    
    else if(seconds >= 60*2 && seconds < 60*3)
    {
        if (isV1) {
            return NSLocalizedString(@"V1Update 2m Before", nil);
        }
        return NSLocalizedString(@"Update 2m Before", nil);
    }
    
    else if(seconds >= 60*3 && seconds < 60*5)
    {
        if (isV1) {
            return NSLocalizedString(@"V1Update 3m Before", nil);
        }
        return NSLocalizedString(@"Update 3m Before", nil);
    }
    
    else if(seconds >= 60*5 && seconds < 60*10)
    {
        if (isV1) {
            return NSLocalizedString(@"V1Update 5m Before", nil);
        }
        return NSLocalizedString(@"Update 5m Before", nil);
    }
    
    else if(seconds >= 60*10 && seconds < 60*15)
    {
        if (isV1) {
            return NSLocalizedString(@"V1Update 10m Before", nil);
        }
        return NSLocalizedString(@"Update 10m Before", nil);
    }
    
    else if (seconds>=60*15  && seconds < 60*30)
    {
        if (isV1) {
            return NSLocalizedString(@"V1Update 15m Before", nil);
        }
        return NSLocalizedString(@"Update 15m Before", nil);
    }
    
    else if (seconds>=60*30  && seconds < 60*60)
    {
        if (isV1) {
            return NSLocalizedString(@"V1Update HalfHour Before", nil);
        }
        return NSLocalizedString(@"Update HalfHour Before", nil);
    }
    
    else if (seconds>=60*60  && seconds < 60*60*2)
    {
        if (isV1) {
            return NSLocalizedString(@"V1Update 1Hour Before", nil);
        }
        return NSLocalizedString(@"Update 1Hour Before", nil);
    }
    
    else if (seconds>=60*60*2 && seconds < 60*60*3)
    {
        if (isV1) {
            return NSLocalizedString(@"V1Update 2Hour Before", nil);
        }
        return NSLocalizedString(@"Update 2Hour Before", nil);
    }
    
    else if (seconds>=60*60*3 && seconds < 60*60*24)
    {
        if (isV1) {
            return NSLocalizedString(@"V1Update Several Before", nil);
        }
        return NSLocalizedString(@"Update Several Before", nil);
    }
    
    else if (seconds>=60*60*24 && seconds < (60*60*24)*2) {
        if (isV1) {
            return NSLocalizedString(@"V1Update 1Day Before", nil);
        }
        return NSLocalizedString(@"Update 1Day Before", nil);
    }
    
    else if (seconds>=60*60*24*2 && seconds < (60*60*24)*3)
    {
        if (isV1) {
            return NSLocalizedString(@"V1Update 2Day Before", nil);
        }
        return NSLocalizedString(@"Update 2Day Before", nil);
    }
    else
    {
        if (isV1) {
            return NSLocalizedString(@"V1Update Several Day Before", nil);
        }
        return NSLocalizedString(@"Update Several Day Before", nil);
    }
    return updateString;
}


+ (NSString *)timeInWordsFromTimeInterval:(NSTimeInterval)intervalInSeconds includingSeconds:(BOOL)includeSeconds {
    NSTimeInterval intervalInMinutes = round(intervalInSeconds / 60.0f);
    
    if (intervalInMinutes >= 0 && intervalInMinutes <= 1) {
        if (!includeSeconds) {
            return intervalInMinutes <= 0 ? @"less than a minute" : @"1 minute";
        }
        if (intervalInSeconds >= 0 && intervalInSeconds < 5) {
            return [NSString stringWithFormat:@"less than %d seconds", 5];
        } else if (intervalInSeconds >= 5 && intervalInSeconds < 10) {
            return [NSString stringWithFormat:@"less than %d seconds", 10];
        } else if (intervalInSeconds >= 10 && intervalInSeconds < 20) {
            return [NSString stringWithFormat:@"%d seconds", 20];
        } else if (intervalInSeconds >= 20 && intervalInSeconds < 40) {
            return @"half a minute";
        } else if (intervalInSeconds >= 40 && intervalInSeconds < 60) {
            return @"less than a minute";
        } else {
            return @"1 minute";
        }
    } else if (intervalInMinutes >= 2 && intervalInMinutes <= 44) {
        return [NSString stringWithFormat:@"%d minutes", (NSInteger)intervalInMinutes];
    } else if (intervalInMinutes >= 45 && intervalInMinutes <= 89) {
        return @"about 1 hour";
    } else if (intervalInMinutes >= 90 && intervalInMinutes <= 1439) {
        return [NSString stringWithFormat:@"about %d hours", (NSInteger)round(intervalInMinutes / 60.0f)];
    } else if (intervalInMinutes >= 1440 && intervalInMinutes <= 2879) {
        return @"1 day";
    } else if (intervalInMinutes >= 2880 && intervalInMinutes <= 43199) {
        return [NSString stringWithFormat:@"%d days", (NSInteger)round(intervalInMinutes / 1440.0f)];
    } else if (intervalInMinutes >= 43200 && intervalInMinutes <= 86399) {
        return @"about 1 month";
    } else if (intervalInMinutes >= 86400 && intervalInMinutes <= 525599) {
        return [NSString stringWithFormat:@"%d months", (NSInteger)round(intervalInMinutes / 43200.0f)];
    } else if (intervalInMinutes >= 525600 && intervalInMinutes <= 1051199) {
        return @"about 1 year";
    } else {
        return [NSString stringWithFormat:@"over %d years", (NSInteger)round(intervalInMinutes / 525600.0f)];
    }
    return nil;
}


- (NSString *)timeInWords {
    return [self timeInWordsIncludingSeconds:YES];
}


- (NSString *)timeInWordsIncludingSeconds:(BOOL)includeSeconds {
    return [[self class] timeInWordsFromTimeInterval:fabs([self timeIntervalSinceNow]) includingSeconds:includeSeconds];
}

+(NSString *)changeMonthValueToMonthStr:(int)monthValue withCapital:(BOOL)cap
{
    NSString *monthStr = @"";
    
    if(cap)//大写
    {
        switch (monthValue)
        {
            case 1:
                monthStr = @"一月";
                break;
            case 2:
                monthStr = @"二月";
                break;
            case 3:
                monthStr = @"三月";
                break;
            case 4:
                monthStr = @"四月";
                break;
            case 5:
                monthStr = @"五月";
                break;
            case 6:
                monthStr = @"六月";
                break;
            case 7:
                monthStr = @"七月";
                break;
            case 8:
                monthStr = @"八月";
                break;
            case 9:
                monthStr = @"九月";
                break;
            case 10:
                monthStr = @"十月";
                break;
            case 11:
                monthStr = @"十一月";
                break;
            case 12:
                monthStr = @"十二月";
                break;
                
            default:
                break;
        }
    }
    else //小写
    {
        switch (monthValue)
        {
            case 1:
                monthStr = NSLocalizedString(@"JAN.", nil);
                break;
            case 2:
                monthStr = NSLocalizedString(@"FEB.", nil);
                break;
            case 3:
                monthStr = NSLocalizedString(@"MAR.", nil);
                break;
            case 4:
                monthStr = NSLocalizedString(@"APR.", nil);
                break;
            case 5:
                monthStr = NSLocalizedString(@"MAY.", nil);
                break;
            case 6:
                monthStr = NSLocalizedString(@"JUN.", nil);
                break;
            case 7:
                monthStr = NSLocalizedString(@"JUL.", nil);
                break;
            case 8:
                monthStr = NSLocalizedString(@"AUG.", nil);
                break;
            case 9:
                monthStr = NSLocalizedString(@"SEP.", nil);
                break;
            case 10:
                monthStr = NSLocalizedString(@"OCT.", nil);
                break;
            case 11:
                monthStr = NSLocalizedString(@"NOV.", nil);
                break;
            case 12:
                monthStr = NSLocalizedString(@"DEC.", nil);
                break;
                
            default:
                break;
        }
    }
    return monthStr;
}



//周几
-(int) dayOfWeek:(NSString *)startTime
{
    int y = [[startTime substringWithRange:NSMakeRange(0, 4)] intValue];
    int m = [[startTime substringWithRange:NSMakeRange(5, 2)] intValue];
    int d = [[startTime substringWithRange:NSMakeRange(8, 2)] intValue];
    
    static int t[] = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    if(m < 3) y -= 1; //m小于3时y减1
    
    int returnT = (y + y/4 - y/100 + y/400 + t[m-1] + d) % 7;
        if(returnT == 0) returnT = 7;
//    if(returnT == 0) returnT = 0;
    
    return returnT;
}
+(NSString *)weekWithTime:(NSString *)startTime{
    NSString *dayStr=nil;
    int dWeek = [[NSDate date] dayOfWeek: startTime];
    switch (dWeek) {
        case 1:
            dayStr = @"一";
            break;
        case 2:
            dayStr = @"二";
            break;
        case 3:
            dayStr = @"三";
            break;
        case 4:
            dayStr = @"四";
            break;
        case 5:
            dayStr = @"五";
            break;
        case 6:
            dayStr = @"六";
            break;
        case 7:
            dayStr = @"日";
            break;
        default:
            break;
    }
    return dayStr;
}
+(NSString *)myCapWeekday:(NSString *)startTime
{
    NSString *darStr=nil;
    int dWeek = [[NSDate date] dayOfWeek: startTime];
    if(dWeek==1)
    {
        darStr=NSLocalizedString(@"MON", nil);
    }
    else if(dWeek == 2)
    {
        darStr=NSLocalizedString(@"TUE", nil);
    }
    else if(dWeek == 3)
    {
        darStr=NSLocalizedString(@"WED", nil);
    }
    else if(dWeek == 4)
    {
        darStr=NSLocalizedString(@"THU", nil);
    }
    else if(dWeek == 5)
    {
        darStr=NSLocalizedString(@"FRI", nil);
    }
    else if(dWeek == 6)
    {
        darStr=NSLocalizedString(@"SAT", nil);
    }
    else if(dWeek == 7)
    {
        darStr=NSLocalizedString(@"SUN", nil);
    }
    else
    {
        darStr=@"";
    }
    
    return darStr;
}

+(NSString *)dayOfWeekStr:(NSString *)startTime
{
    NSString *darStr = @"";
    if(startTime==nil) return darStr;
    
    NSString* todayString=[[[NSDate date] LocalDayISO8601String] substringToIndex:10];
    if([[todayString substringToIndex:10] isEqualToString:[startTime substringToIndex:10]])
    {
        darStr=NSLocalizedString(@"Today", nil);
    }
    else if([[NSDate date] dayCountFrom:[NSString stringWithFormat:@"%@ 00:00:00",[startTime substringToIndex:10]] toDay:[NSString stringWithFormat:@"%@ 00:00:00",[todayString substringToIndex:10]]] == 1)
    {
        darStr=NSLocalizedString(@"Yesterday", nil);
    }
    else if([[NSDate date] dayCountFrom:[NSString stringWithFormat:@"%@ 00:00:00",[startTime substringToIndex:10]] toDay:[NSString stringWithFormat:@"%@ 00:00:00",[todayString substringToIndex:10]]] == 2)
    {

        darStr = [self myCapWeekday: startTime];
        
    }
    else
    {
        darStr = [self myCapWeekday: startTime];
        
    }
    
    return darStr;
}


-(int)getWhichWeekOfDateString:(NSString *)dateString{
    struct tm *timeinfo;
    time_t rawtime = (time_t)[[NSDate dateFromISO8601String:dateString] timeIntervalSince1970];
    timeinfo = localtime(&rawtime);
    int wd = timeinfo->tm_wday; /*今天是星期几。*/
    int yd = timeinfo->tm_yday; //今天是今年的第几天 范围0-365 所以yd也表示今天距1月1日的总天数
    
    //计算本年1月1日是周几
    int base = 7 - (yd + 1 - (wd + 1)) % 7;//yd+1表示到今天的总天数 wd+1表示到今天本周的总天数
    if (base == 7)
        base = 0; //0代表周日 一周的开始
    
    //计算本周是一年的第几周
   int nweek = (base + yd) / 7 + 1;
    return nweek;
}

- (NSString *)LocalTimeISO8601StringFromDate:(NSString *)beginDate addMins:(int)mins
{
    struct tm *timeinfo;
    char buffer[80];
    // (time_t)[[NSDate dateFromISO8601String:tempString] timeIntervalSince1970]
    time_t rawtime = (time_t)[[NSDate dateFromISO8601String:beginDate] timeIntervalSince1970] + mins*60;
    timeinfo = localtime(&rawtime);
    strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

+(BOOL)isValidDateStr:(NSString *)date{
        NSString *filter = @"^2[0-9]{3}-(0[1-9]|1[012])-[0-3][0-9] ([01][0-9]|2[0-4]):[0-5][0-9]:[0-5][0-9]";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",filter];
    if ([predicate evaluateWithObject:date]) {
        return YES;
    }else{
        return NO;
    }
}

+(NSDate *)getDateStr:(NSString *)date withTimeZone:(NSTimeZone *)timezone{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = timezone;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:date];
}
+ (NSString *)getLocalFormateUTCDate:(NSString *)utcDate formate:(NSString *)formate
{
    NSDate *localDate = [self getNowDateFromatAnDate:[self dateWithString:utcDate format:@"yyyy-MM-dd HH:mm:ss" isUTC:YES]];
    return [self dateToString:localDate format:formate isUTC:YES];
}
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    NSTimeInterval interval = [self offsetAboutTime:anyDate];
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
+ (NSTimeInterval)offsetAboutTime:(NSDate *)anyDate{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    return interval;
}
+(NSInteger) currentTimeZone{
    time_t t = time(NULL);
    struct tm lt = {0};
    localtime_r(&t, &lt);
    NSInteger offset=lt.tm_gmtoff/3600;
    return offset;
}

+ (NSInteger)getDaysByDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    return [components day];  // 当前的天数
}

+ (NSDate *)dateWithString:(NSString *)str format:(NSString *)formating isUTC:(BOOL)isUTC
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formating];
    if (isUTC) {
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    return [dateFormatter dateFromString:str];
}

+ (NSString *)dateToString:(NSDate *)date format:(NSString *)formating isUTC:(BOOL)isUTC
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formating];
    if (isUTC) {
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)getLastMonthDateWithDate:(NSDate *)currentDate{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:currentDate];
    if ([components month] == 1) {
        [components setMonth:12];
        [components setYear:([components year] - 1)];
    } else {
        [components setMonth:([components month] - 1)];
    }
    NSDate *lastMonth = [cal dateFromComponents:components];
    return lastMonth;
}

- (NSDate *)dateWithoutTime
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit
                                                         | NSMonthCalendarUnit
                                                         | NSDayCalendarUnit )
                                               fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *) dateByAddingDays:(NSInteger) days months:(NSInteger) months years:(NSInteger) years
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = days;
    dateComponents.month = months;
    dateComponents.year = years;
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                         toDate:self
                                                        options:0];
}

- (NSDate *) dateByAddingDays:(NSInteger) days
{
    return [self dateByAddingDays:days months:0 years:0];
}

- (NSDate *) dateByAddingMonths:(NSInteger) months
{
    return [self dateByAddingDays:0 months:months years:0];
}

- (NSDate *) dateByAddingYears:(NSInteger) years
{
    return [self dateByAddingDays:0 months:0 years:years];
}

- (NSDate *) monthStartDate
{
    NSDate *monthStartDate = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit
                                    startDate:&monthStartDate
                                     interval:NULL
                                      forDate:self];
    
    return monthStartDate;
}

- (NSUInteger) numberOfDaysInMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                              inUnit:NSMonthCalendarUnit
                                             forDate:self].length;
}

- (NSUInteger) weekday
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:self];
    
    return [weekdayComponents weekday];
}

- (NSString *) dateStringWithFormat:(NSString *) format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:self];
}

- (NSInteger) daysSinceDate:(NSDate *) date
{
    return [self timeIntervalSinceDate:date] / (60 * 60 * 24);
}

@end
