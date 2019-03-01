//
//  HTDataBase.h
//  SmartBed
//
//  Created by Jerry on 14-8-29.
//  Copyright (c) 2014年 Het. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTDataBase : NSObject

+(HTDataBase *)shareInstance;

// 获取数据库路径
- (NSString *)getDateBasePath;

// 打开数据库
- (BOOL)openDB;

// 判断数据表是否存在
- (BOOL)checkTableIsExist:(NSString *)tableName;

/**
 *  创建数据表
 *
 *  @param tbName    表名
 *  @param fieldsArr 字段
 *  @param typesArr  字段类型 --- Text, Integer, float, double, bool
 *
 *  @return 返回成功或失败
 */
- (BOOL)createTableWithName:(NSString *)tbName andFields:(NSArray *)fieldsArr andTypes:(NSArray *)typesArr;

/**
 *  插入数据表
 *
 *  @param tbName    表名
 *  @param fieldsArr 字段
 *  @param valuesArr 字段的值
 *
 *  @return 返回成功或失败
 */
- (BOOL)insertToTable:(NSString *)tbName andFields:(NSArray *)fieldsArr andValues:(NSArray *)valuesArr;

/**
 *  查询数据库(只有一个字段)
 *
 *  @param tbName        表名
 *  @param fieldStr      要查询的字段
 *  @param condsArr      条件 (> = <)
 *  @param condValuesArr 字段的值
 *  @param andOrsArr     and 或者 or
 *  @param orderField    排序字段
 *  @param orderStr      排序情况
 *
 *  @return 返回查询的所有结果
 */
- (NSArray *)queryTable:(NSString *)tbName andField:(NSString *)fieldStr andConditions:(NSArray *)condsArr andCondValues:(NSArray *)condValuesArr andOr:(NSArray *)andOrsArr andOrderField:(NSString *)orderField andOrderby:(NSString *)orderStr;


/**
 *  通过SQL获取查询的结果
 *
 *  @param sql   SQL语句
 *
 *  @return 返回包含结果的数组
 */
- (NSArray *)queryTablewithSql: (NSString *)sql;

/**
 *  查询数据库(多个字段)
 *
 *  @param tbName        表名
 *  @param fieldsArr     要查询的多个字段
 *  @param condsArr      条件 (> = <)
 *  @param condValuesArr 字段的值
 *  @param andOrsArr      and 或者 or
 *  @param orderField    排序字段
 *  @param orderStr      排序情况
 *
 *  @return 返回查询的所有结果
 */
- (NSArray *)queryTable:(NSString *)tbName andFields:(NSArray *)fieldsArr andConditions:(NSArray *)condsArr andCondValues:(NSArray *)condValuesArr andOr:(NSArray *)andOrsArr andOrderField:(NSString *)orderField andOrderby:(NSString *)orderStr;


// 更新
//- (BOOL)updateTable:(NSString *)tbName andFields:(NSArray *)fieldsArr andValues:(NSArray *)valuesArr;

/**
 *  删除表数据
 *
 *  @param tbName 表名
 */
- (BOOL)deleteAllRecordsByTableName:(NSString *)tbName;

// 关闭数据库
- (void)closeDB;


//执行操作: 创建表、插入、删除、更新的操作
- (BOOL)execDBWithSQLString:(NSString *)str;
@end
