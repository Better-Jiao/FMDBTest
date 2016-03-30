//
//  DBManager.m
//  DataBase
//
//  Created by 焦星星 on 16/3/29.
//  Copyright © 2016年 jxx. All rights reserved.
//

#import "DBManager.h"
#import "FMDB.h"

@implementation DBManager


+ (instancetype)dbManager
{
    return [[self alloc]init];
}


- (instancetype)init
{
    static DBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super init];
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *filePath = [path stringByAppendingPathComponent:@"test.db"];
        FMDatabase *db =  [self createDBWithPath:filePath];
        manager.dataBase = db;
    });
    return manager;
}


- (FMDatabase *)createDBWithPath:(NSString *)path
{
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    [db open];
    BOOL success = [db executeUpdate:@"create table if not exists myTest (id integer primary key autoincrement, x text)"];
    if (success) {
        NSLog(@"建表成功");
       
    }else{
        NSLog(@"建表不成功");
        NSLog(@"%@",[db lastError]);
    }
    return db;
}

@end
