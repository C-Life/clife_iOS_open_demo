//
//  NSDate+SSToolkitAdditions.h
//  SSToolkit
//
//  Created by Sam Soffes on 5/26/10.
//  Copyright 2010-2011 Sam Soffes. All rights reserved.
//

/**
 Provides extensions to `NSDate` for various common tasks.
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSDate (SSToolkitAdditions)

///---------------
/// @name ISO 8601
///---------------

/**
 Returns a new date represented by an ISO8601 string.
 
 @param iso8601String An ISO8601 string
 
 @return Date represented by the ISO8601 string
 */
+ (NSDate *)dateFromISO8601String:(NSString *)iso8601String;


/**
 Returns a string representation of the receiver in ISO8601 format.
 
 UTC Time
 
 @return A string representation of the receiver in ISO8601 format.
 */
- (NSString *)ISO8601String;

/**
 Returns a string representation of the receiver in ISO8601 format.
 
 Local Time
 
 @return A string representation of the receiver in ISO8601 format.
 */

-(NSString*)LocalTimeISO8601String;

-(NSString*)GMTDayISO8601String;
-(NSString *)GMTDayISO8601StringByAddDays:(int)days;
-(NSString*)LocalDayISO8601String;

-(NSString *)LocalDayISO8601StringByAddDays:(int)addDay;

- (NSString *)LocalTimeISO8601StringByAddDays:(int)addDay;

- (NSString *)LocalTimeISO8601StringFromDate:(NSString *)beginDate addDays:(int)addDay;

-(NSString*)getAddTime:(NSString*)preTime AddDays:(int)addDay;

-(int)dayCountFrom:(NSString*)fromDay toDay:(NSString*)toDay;

-(time_t)GMTSecond;

+(NSString*)chinesDayStringByDateString:(NSString*)inputString;

+ (NSDate *)gmtDateFromISO8601String:(NSString *)iso8601 ;

+(NSString*)localTimeToGMTString:(NSString*)localTimeString;
+(NSString*)GMTTimeToLocalTimeString:(NSString*)gmtTimeString;
+(NSString*)ChineseWeekString:(NSString*)inputString;

+(NSString*)getDayOfCurrentDay;

+ (NSString *)ISO8601String_Withobliqueline;

+(NSString *)changeMonthValueToMonthStr:(int)monthValue withCapital:(BOOL)cap;

+(NSString*)LastDayOfMonth:(int)iMonth year:(int)iYear;

+(NSString*)firstDayOfMonth:(int)iMonth year:(int)iYear;

+(NSDictionary*)getFirstAndLastDayOfMonth:(NSString*)monthDate;
+(NSDictionary*)getFirstAndLastDayOfWeek:(NSString *)weekDate;
///--------------------
/// @name Time In Words
///--------------------

/**
 Returns a string representing the time interval from now in words (including seconds).
 
 The strings produced by this method will be similar to produced by Twitter for iPhone or Tweetbot in the top right of
 the tweet cells.
 
 Internally, this does not use `timeInWordsFromTimeInterval:includingSeconds:`.
 
 @return A string representing the time interval from now in words
 */
+ (NSString *)briefUpdateTimeInWords:(NSString*)updateString isV1:(BOOL)isV1;

/**
 Returns a string representing the time interval from now in words (including seconds).
 
 The strings produced by this method will be similar to produced by ActiveSupport's `time_ago_in_words` helper method.
 
 @return A string representing the time interval from now in words
 
 @see timeInWordsIncludingSeconds:
 @see timeInWordsFromTimeInterval:includingSeconds:
 */
- (NSString *)timeInWords;

/**
 Returns a string representing the time interval from now in words.
 
 The strings produced by this method will be similar to produced by ActiveSupport's `time_ago_in_words` helper method.
 
 @param includeSeconds `YES` if seconds should be included. `NO` if they should not.
 
 @return A string representing the time interval from now in words
 
 @see timeInWordsIncludingSeconds:
 @see timeInWordsFromTimeInterval:includingSeconds:
 */
- (NSString *)timeInWordsIncludingSeconds:(BOOL)includeSeconds;

/**
 Returns a string representing a time interval in words.
 
 The strings produced by this method will be similar to produced by ActiveSupport's `time_ago_in_words` helper method.
 
 @param intervalInSeconds The time interval to convert to a string
 
 @param includeSeconds `YES` if seconds should be included. `NO` if they should not.
 
 @return A string representing the time interval in words
 
 @see timeInWords
 @see timeInWordsIncludingSeconds:
 */
+ (NSString *)timeInWordsFromTimeInterval:(NSTimeInterval)intervalInSeconds includingSeconds:(BOOL)includeSeconds;

//- (NSString *)getMonthEndTimeWithMonthStart:(NSString *)startTime;
//周几
-(int) dayOfWeek:(NSString *)startTime;
//周几---大写
+(NSString *)weekWithTime:(NSString *)startTime;
//周几(大写)
+(NSString *)myCapWeekday:(NSString *)startTime;
//卡片页日期显示
+(NSString *)dayOfWeekStr:(NSString *)startTime;
// 返回间隔多少分钟
-(int)minutesCountFrom:(NSString*)fromDay toDay:(NSString*)toDay;

+(NSString*)getLoadingTitleFromTime:(NSString*)startLoadTime;

- (NSString *)LocalTimeISO8601StringByAddMins:(int)addMins;
/**
 *  获取一个时间对应的小时
 *
 *  @param dateString 需要获取的时间字符
 *
 *  @return 返回小时的值
 */
+(int)getDateHour:(NSString*)dateString;

/**
 *  获取一个时间对应的分钟
 *
 *  @param dateString 需要获取的时间字符
 *
 *  @return 返回分钟的值
 */
+(int)getDateMitune:(NSString*)dateString;
/**
 *  获取当前时区的偏移量
 */
+ (NSTimeInterval)offsetAboutTime:(NSDate *)anyDate;

/**
 *  获取一个时间对应的秒
 *
 *  @param dateString 需要获取的时间字符
 *
 *  @return 返回秒的值
 */
+(int)getDateSecond:(NSString*)dateString;

//获取当前时间
+(NSString *)getCurrentTime;
+(NSString *)getCurrentDate;
+(NSArray*)getBetweenHourByBeginTime:(NSString*)beginTime EndTime:(NSString*)endTime;
+(NSArray*)getBetweenDayByBeginTime:(NSString*)beginTime EndTime:(NSString*)endTime;

+(NSString *)currentTimeOffset;

+(int)betweenSecondWithStartTime:(NSString*)startTime EndTime:(NSString*)endTime;

-(int)getCurrentHour;
-(int)getCurrentMinus;
-(int)getCurrentSecond;
/**
 *  获取当前传入的字符串是日期是今年的第几周
 *
 *  @param dateString 传入的日期
 *
 *  @return 第几周
 */
-(int)getWhichWeekOfDateString:(NSString *)dateString;

/**
 *  加上多少分钟
 *
 *  @param beginDate <#beginDate description#>
 *  @param mins      <#mins description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)LocalTimeISO8601StringFromDate:(NSString *)beginDate addMins:(int)mins;

/**
 *  判断字符串是否为时间格式(xxxx-xx-xx xx:xx:xx)
 *
 *  @param date 传入的时间格式
 *
 *  @return 
 */
+(BOOL)isValidDateStr:(NSString *)date;

/**
 *  根据时间字符串得到NSDate时间
 *
 *  @param date     格式 xxxx-xx-xx xx:xx:xx
 *  @param timezone 时区
 *
 *  @return <#return value description#>
 */
+(NSDate *)getDateStr:(NSString *)date withTimeZone:(NSTimeZone *)timezone;


-(long)secondCountFrom:(NSString *)fromTime toTime:(NSString *)toTime;

/**
 *  得到低当前的时区
 *
 *  @return 返回当前的时区，
 */
+(NSInteger) currentTimeZone;
+ (NSString *)getLocalFormateUTCDate:(NSString *)utcDate formate:(NSString *)formate;
/**
 *  得到当前的时间的天数
 *  @prama date  当前的时间
 *  @return 返回当前月的天数，
 */
+ (NSInteger)getDaysByDate:(NSDate *)date;

/**
 * NSDate convenience methods which shortens some of frequently used formatting and date altering methods.
 */

/**
 * Returns current (self) date without time components. Effectively, it's just a beginning of a day.
 */
- (NSDate *) dateWithoutTime;

/**
 * Returns a date object shifted by a given number of days from the current (self) date.
 */
- (NSDate *) dateByAddingDays:(NSInteger) days;

/**
 * Returns a date object shifted by a given number of months from the current (self) date.
 */
- (NSDate *) dateByAddingMonths:(NSInteger) months;

/**
 * Returns a date object shifted by a given number of years from the current (self) date.
 */
- (NSDate *) dateByAddingYears:(NSInteger) years;

/**
 * Returns a date object shifted by a given number of days, months and years from the current (self) date.
 */
- (NSDate *) dateByAddingDays:(NSInteger) days months:(NSInteger) months years:(NSInteger) years;

/**
 * Returns start of month for the current (self) date.
 */
- (NSDate *) monthStartDate;

/**
 * Returns the number of days in the current (self) month.
 */
- (NSUInteger) numberOfDaysInMonth;

/**
 * Returns the weekday of the current (self) date.
 *
 * Returns 1 for Sunday, 2 for Monday ... 7 for Saturday
 */
- (NSUInteger) weekday;

/**
 * Returns the number of days since given date.
 */
- (NSInteger) daysSinceDate:(NSDate *) date;

/**
 * Returns string representation of the current (self) date formatted with given format.
 *
 * i.e. "dd-MM-yyyy" will return "14-07-2012"
 */
- (NSString *) dateStringWithFormat:(NSString *) format;

/**
 *	@brief	从NSString转成NSDate
 *
 *	@param 	str 	NSString格式日期
 *	@param 	formating 	格式字符串
 *
 *	@return	NSDate格式日期
 */
+ (NSDate *)dateWithString:(NSString *)str format:(NSString *)formating isUTC:(BOOL)isUTC;


/**
 *	@brief	从NSDate转成NSString
 *
 *	@param 	date 	NSDate格式日期
 *	@param 	formating 	格式字符串
 *
 *	@return	NSString格式日期
 */
+ (NSString *)dateToString:(NSDate *)date format:(NSString *)formating isUTC:(BOOL)isUTC;

/**
 *	@brief	获取上个月的时间
 *
 *  @param  currentDate 目前日期
 *
 *	@return	NSDate格式日期
 */
+ (NSDate *)getLastMonthDateWithDate:(NSDate *)currentDate;
@end
