//
//  WifiPasswordInfo.m
//  SmartHome
//
//  Created by luojie on 14/11/21.
//  Copyright (c) 2014年 Het. All rights reserved.
//

#import "CLWifiPasswordInfo.h"
#import "HTDataBase.h"

@implementation CLWifiPasswordInfo

+(BOOL)initWifiPasswordInfoList{
    [[HTDataBase shareInstance] openDB];
    NSString* tableName=@"WifiPasswordInfo";
    NSString* sql=[NSString stringWithFormat:@"CREATE TABLE if not exists %@ ("
                   "SSID TEXT DEFAULT NULL,"
                   "MACAddr TEXT DEFAULT NULL,"
                   "Password TEXT DEFAULT NULL);",tableName];
    
    if (![[HTDataBase shareInstance] checkTableIsExist:tableName]) {
        // 不存在
        if ([[HTDataBase shareInstance ] execDBWithSQLString:sql]) {
            return YES;
        }
        else{
            return NO;
        }
    }
    return YES;
}

+(BOOL)saveOrUpdateWifiPasswordInfoList:(NSString *)SSID MacAddr:(NSString *)macaddr Password:(NSString *)password{
    
    if (!SSID||[SSID isEqualToString:@""]||!macaddr||[macaddr isEqualToString:@""]) {
        return NO;
    }
    
    NSString* tableName=@"WifiPasswordInfo";
    NSString* sql=[NSString stringWithFormat:@"select MACAddr from %@ where MACAddr ='%@'; ",
                   tableName,macaddr];
    NSArray *staArr = [[HTDataBase shareInstance] queryTablewithSql:sql];
    //NSString *md5str = [password MD5AndBase64String];
    if (staArr!=nil&&staArr.count>0) {
        sql = [NSString stringWithFormat:
               @"update %@ "
               "set Password='%@',"
               "SSID='%@' "
               "where MACAddr='%@' ",
               tableName,
               password,
               SSID,
               macaddr];
    }
    else{
        sql = [NSString stringWithFormat:
               @"Insert into %@ "
               "(Password,"
               "SSID,"
               "MACAddr) "
               "values('%@','%@','%@');",
               tableName,
               password,
               SSID,
               macaddr];
    }
    
    if ([[HTDataBase shareInstance ] execDBWithSQLString:sql]) {
        return YES;
    }
    return NO;
}

+ (BOOL)DeletePasswordWith:(NSString *)macaddr{
    if (!macaddr||[macaddr isEqualToString:@""]) {
        return NO;
    }
    NSString* tableName=@"WifiPasswordInfo";
    NSString* sql=[NSString stringWithFormat:@"delete from %@ where MACAddr ='%@'; ",
                   tableName,macaddr];
    if ([[HTDataBase shareInstance ] execDBWithSQLString:sql]) {
        return YES;
    }
    return NO;
}

+ (NSString*)getWifiPasswordInfoListlByMacAddr:(NSString *)MacAddr
{
    if (!MacAddr || [MacAddr isEqualToString:@""]) {
        return nil;
    }
    NSString* tableName=@"WifiPasswordInfo";
    NSString* sql=nil;
    sql=[NSString stringWithFormat:@"select Password from %@ where MACAddr ='%@'; ",
                   tableName,MacAddr];
    NSArray *staArr = [[HTDataBase shareInstance] queryTablewithSql:sql];
    if (staArr.count == 1) {
        NSString *passwordStr = [[staArr objectAtIndex:0] objectForKey:@"Password"];
        if (passwordStr && ![passwordStr isEqualToString:@""]) {
           // NSString *tempstr = [NSString sam_stringWithBase64String:passwordStr];
            
            return passwordStr;
        }
    }
    return nil;
}

@end
