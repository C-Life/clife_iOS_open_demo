//
//  HTDataBase.m
//  SmartBed
//
//  Created by Jerry on 14-8-29.
//  Copyright (c) 2014年 Het. All rights reserved.
//

#import "HTDataBase.h"
#import "FMDatabase.h"

static HTDataBase *htDataBase;
static FMDatabase *fmDB;

#define DataFileName    @"SmartHome.sqlite3"

@implementation HTDataBase

+ (HTDataBase *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        htDataBase = [[self alloc] init];
        [htDataBase openDB];
    });
    return htDataBase;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
/**
 *  数据库路径
 *
 *  @return 返回数据库文件名
 */
- (NSString *)getDateBasePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathName = [paths firstObject];
    return [pathName stringByAppendingPathComponent:DataFileName];
}

/**
 *  打开数据库
 *
 *  @return 返回打开成功或失败
 */
- (BOOL)openDB {
    BOOL isSuccess = NO;
    if (!fmDB) {
        if (![self getDateBasePath]) {
            OPLog(@"数据库的文件路径为空!");
            return isSuccess;
        }
        OPLog(@"数据库的文件路径: %@", [self getDateBasePath]);
        fmDB = [FMDatabase databaseWithPath:[self getDateBasePath]];
        [fmDB setShouldCacheStatements:YES];
    }
    if ([fmDB open]) {
        isSuccess = YES;
    }
    return isSuccess;
}

/**
 *  判断某个数据表是否存在
 *
 *  @param tableName 表名
 *
 *  @return 返回YES/NO
 */
- (BOOL)checkTableIsExist:(NSString *)tableName {
    tableName = [tableName lowercaseString];
    FMResultSet *result = [fmDB executeQuery:@"select [sql] from sqlite_master where [type] = 'table' and lower(name) = ?", tableName];
    BOOL isExist = [result next];
    [result close];
    return isExist;
}

/**
 *  创建数据表
 *
 *  @param tbName    表名
 *  @param fieldsArr 字段
 *  @param typesArr  字段类型 --- Text, Integer
 *
 *  @return 返回成功或失败
 */
- (BOOL)createTableWithName:(NSString *)tbName andFields:(NSArray *)fieldsArr andTypes:(NSArray *)typesArr {
    if (!tbName || !fieldsArr || !typesArr) {
        return NO;
    }
    if ([fieldsArr count] != [typesArr count]) {
        return NO;
    }
    NSMutableString *sqlString = [[NSMutableString alloc] init];
    // @"CREATE TABLE User (Name text,Age integer)"
    for (int index = 0; index < fieldsArr.count; index++) {
        if (index == 0) {
            [sqlString appendString:[NSString stringWithFormat:@"%@ %@ %@%@", [fieldsArr objectAtIndex:index], [typesArr objectAtIndex:index], @"primary key",@","]];
        }
        else if (index < fieldsArr.count - 1) {
            [sqlString appendString:[NSString stringWithFormat:@"%@ %@%@", [fieldsArr objectAtIndex:index], [typesArr objectAtIndex:index], @","]];
        }
        else {
            [sqlString appendString:[NSString stringWithFormat:@"%@ %@", [fieldsArr objectAtIndex:index], [typesArr objectAtIndex:index]]];
        }
    }
    NSString *tableSql = [[NSString alloc] initWithFormat:@"create table if not exists %@ %@%@%@", tbName, @"(", sqlString, @")"];
    OPLog(@"tableSql = %@",tableSql);

    // 开始执行
    return [self execDBWithSQLString:tableSql];
}

/**
 *  插入数据表
 *
 *  @param tbName    表名
 *  @param fieldsArr 字段
 *  @param valuesArr 字段的值
 *
 *  @return 返回成功或失败
 */
- (BOOL)insertToTable:(NSString *)tbName andFields:(NSArray *)fieldsArr andValues:(NSArray *)valuesArr {
    if (!tbName || !fieldsArr || !valuesArr) {
        return NO;
    }
    if (fieldsArr.count != valuesArr.count) {
        return NO;
    }
    
    NSMutableString *fieldString = [[NSMutableString alloc] init];
    NSMutableString *valueString = [[NSMutableString alloc] init];
    // @"INSERT INTO User (Name,Age) VALUES (?,?)",@"张三",[NSNumber numberWithInt:20]
    for (int index = 0; index < fieldsArr.count; index++) {
        if (index < fieldsArr.count - 1) {
            [fieldString appendString:[NSString stringWithFormat:@"%@%@", [fieldsArr objectAtIndex:index], @","]];
            if ([[valuesArr objectAtIndex:index] isKindOfClass:[NSString class]]) {  // ''
                [valueString appendString:[NSString stringWithFormat:@"'%@'%@", [valuesArr objectAtIndex:index], @","]];
            }
            else {
                [valueString appendString:[NSString stringWithFormat:@"%@%@", [valuesArr objectAtIndex:index], @","]];
            }
        }
        else {
            [fieldString appendString:[NSString stringWithFormat:@"%@", [fieldsArr objectAtIndex:index]]];
            if ([[valuesArr objectAtIndex:index] isKindOfClass:[NSString class]]) {  // ''
                [valueString appendString:[NSString stringWithFormat:@"'%@'", [valuesArr objectAtIndex:index]]];
            }
            else {
                [valueString appendString:[NSString stringWithFormat:@"%@", [valuesArr objectAtIndex:index]]];
            }
        }
    }
    NSString *tableSql = [[NSString alloc] initWithFormat:@"insert into %@ %@%@%@ values %@%@%@", tbName, @"(", fieldString, @")", @"(", valueString, @")"];
    OPLog(@"tableSql = %@",tableSql);
    
    // 开始执行
    return [self execDBWithSQLString:tableSql];
}

/**
 *  查询数据库(只有一个字段)
 *
 *  @param tbName        表名
 *  @param fieldStr      要查询的字段
 *  @param condsArr      条件 (> = <)
 *  @param condValuesArr 字段的值
 *  @param andOrStr      and 或者 or
 *  @param orderField    排序字段
 *  @param orderStr      排序情况
 *
 *  @return 返回查询的所有结果
 */
- (NSArray *)queryTable:(NSString *)tbName
               andField:(NSString *)fieldStr
          andConditions:(NSArray *)condsArr
          andCondValues:(NSArray *)condValuesArr
                  andOr:(NSArray *)andOrsArr
          andOrderField:(NSString *)orderField
             andOrderby:(NSString *)orderStr {
    NSMutableArray *resultsArr = [NSMutableArray array];
    if (!tbName || !fieldStr || !condValuesArr ) {
        return nil;
    }
    if (condValuesArr.count > 1) {
        if (!andOrsArr || andOrsArr.count != condValuesArr.count - 1) {
            return nil;
        }
    }
    if (condsArr.count != condValuesArr.count) {
        return nil;
    }
    NSMutableString *queryString = [[NSMutableString alloc] init];
    // "select * from people where people_id = ? and(or) ..."
    if (condValuesArr.count == 1) {
        [queryString appendString:[NSString stringWithFormat:@"%@ %@ %@",fieldStr, [condsArr objectAtIndex:0],[condValuesArr objectAtIndex:0]]];
    }
    else {
        for (int index = 0; index < condsArr.count; index++) {
            if (index < condValuesArr.count - 1) {
                [queryString appendString:[NSString stringWithFormat:@"%@ %@ %@ %@",fieldStr, [condsArr objectAtIndex:index],[condValuesArr objectAtIndex:index], [andOrsArr objectAtIndex:index]]];
            }
            else {
                [queryString appendString:[NSString stringWithFormat:@"%@ %@ %@",fieldStr, [condsArr objectAtIndex:index],[condValuesArr objectAtIndex:index]]];
            }
        }
    }
    if (orderStr && ![orderStr isEqualToString:@""] && orderField && ![orderField isEqualToString:@""]) {
        [queryString appendString:[NSString stringWithFormat:@" order by %@ %@", orderField,orderStr]];
    }
    
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where %@", tbName, queryString];
    OPLog(@"sqlString = %@", sqlString);
    FMResultSet *fmResult = [fmDB executeQuery:sqlString];

    [resultsArr removeAllObjects];
    while ([fmResult next]) {
        [resultsArr addObject:[fmResult resultDictionary]];
    }
    
    return  resultsArr;
}


/**
 *  通过SQL获取查询的结果
 *
 *  @param sql   SQL语句
 *
 *  @return 返回包含结果的数组
 */
- (NSArray *)queryTablewithSql: (NSString *)sql{
    if (!sql||sql.length==0) {
        return nil;
    }
    NSMutableArray *resultsArr = [NSMutableArray array];
    
    FMResultSet *fmResult = [fmDB executeQuery:sql];
    [resultsArr removeAllObjects];
    while ([fmResult next]) {
        [resultsArr addObject:[fmResult resultDictionary]];
    }
    
    return  resultsArr;
}


/**
 *  查询数据库(多个字段)
 *
 *  @param tbName        表名
 *  @param fieldsArr     要查询的多个字段
 *  @param condsArr      条件 (> = <)
 *  @param condValuesArr 字段的值
 *  @param andOrsArr     and 或者 or
 *  @param orderField    排序字段
 *  @param orderStr      排序情况
 *
 *  @return 返回查询的所有结果
 */
- (NSArray *)queryTable:(NSString *)tbName andFields:(NSArray *)fieldsArr andConditions:(NSArray *)condsArr andCondValues:(NSArray *)condValuesArr andOr:(NSArray *)andOrsArr andOrderField:(NSString *)orderField andOrderby:(NSString *)orderStr {
    NSMutableArray *resultsArr = [NSMutableArray array];
    if (!tbName || !fieldsArr || !condsArr || !condValuesArr) {
        return nil;
    }
    if (condValuesArr.count > 1) {
        if (!andOrsArr || andOrsArr.count != condValuesArr.count - 1) {
            return nil;
        }
    }
    if (condsArr.count != condValuesArr.count || fieldsArr.count != condsArr.count) {
        return nil;
    }
    NSMutableString *queryString = [[NSMutableString alloc] init];
    // "select * from people where a = ? and(or) b = ? and(or)..."

    for (int index = 0; index < condsArr.count; index++) {
        if (index < condValuesArr.count - 1) {
            [queryString appendString:[NSString stringWithFormat:@"%@ %@ %@ %@ ",[fieldsArr objectAtIndex:index], [condsArr objectAtIndex:index],[condValuesArr objectAtIndex:index], [andOrsArr objectAtIndex:index]]];
        }
        else {
            [queryString appendString:[NSString stringWithFormat:@"%@ %@ %@",[fieldsArr objectAtIndex:index], [condsArr objectAtIndex:index],[condValuesArr objectAtIndex:index]]];
        }
    }

    if (orderStr && ![orderStr isEqualToString:@""] && orderField && ![orderField isEqualToString:@""]) {
        [queryString appendString:[NSString stringWithFormat:@" order by %@ %@", orderField,orderStr]];
    }
    
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where %@", tbName, queryString];
    OPLog(@"sqlString = %@", sqlString);
    FMResultSet *fmResult = [fmDB executeQuery:sqlString];
    
    [resultsArr removeAllObjects];
    while ([fmResult next]) {
        [resultsArr addObject:[fmResult resultDictionary]];
    }
    
    return  resultsArr;
}

/**
 *  删除表数据
 *
 *  @param tbName 表名
 */
- (BOOL)deleteAllRecordsByTableName:(NSString *)tbName {
    if (!tbName) {
        return NO;
    }
    NSString *sqlString = [[NSString alloc] initWithFormat:@"delete from %@",tbName];
    OPLog(@"sqlString = %@",sqlString);
    
    // 开始执行
    return [self execDBWithSQLString:sqlString];
}

//执行操作: 创建表、插入、删除、更新的操作
- (BOOL)execDBWithSQLString:(NSString *)str {
    @synchronized(fmDB) {
		[fmDB beginTransaction];
		[fmDB executeUpdate:str];
        [fmDB commit];
        
		if ([fmDB hadError]) {
			NSString * errStr = [fmDB lastErrorMessage];
			OPLog(@"%@",errStr);
			return NO;
		}
		else {
			return YES;
		}
	}
}

/**
 *  关闭数据库
 */
- (void)closeDB {
    if (fmDB) {
        [fmDB close];
    }
}

@end
