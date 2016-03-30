//
//  DBManager.h
//  DataBase
//
//  Created by 焦星星 on 16/3/29.
//  Copyright © 2016年 jxx. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;

@interface DBManager : NSObject
@property (nonatomic ,strong) FMDatabase *dataBase;

+ (instancetype)dbManager;
@end
