//
//  SDDatabase.m
//  IMService
//
//  Created by shansander on 16/4/25.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "SDDatabase.h"

#import "SDDBDefine.h"

@interface SDDatabase ()
{
    sqlite3 *dbPoint;
}

@end

@implementation SDDatabase
static SDDatabase * db = nil;

+ (SDDatabase * )database
{
    if (db == nil) {
        NSLog(@"错误信息，没有打开数据库");
        return nil;
    }
    return db;
}
+ (SDDatabase *)databaseWithPath:(NSString *)path
{
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        db = [[SDDatabase alloc] initWithPath:path];
    });
    return db;
}
- (id)initWithPath:(NSString * )path
{
    self = [super init];
    if (self) {
        NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString * dbPath = [docPath stringByAppendingPathComponent:path];
        NSLog(@"数据库－－－> %@",dbPath);
        int rsulte = sqlite3_open([dbPath UTF8String],&dbPoint);
        
        if (rsulte == SQLITE_OK) {
            NSLog(@"这个成功了吧 %d",rsulte);
        }else{
            NSLog(@"失败了 ---> %d",rsulte);
            sqlite3_close(dbPoint);
        }
    }
    return self;
}
//执行sql语句
- (int)execSQL:(NSString * )sql
{
    char * errorMsg;
    int result = sqlite3_exec(dbPoint,[sql UTF8String],NULL,NULL,&errorMsg);
    NSLog(@"%@",sql);
    if (result == SQLITE_OK) {
        NSLog(@"我们成功了");
    }else{
        NSLog(@"失败 -> %s -> %d",errorMsg,result);
    }
    return result;
}

- (NSArray * )fetchSQL:(NSString * )sql
{
    
    NSMutableArray * dataList = [NSMutableArray array];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(dbPoint, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *chatID = (char*)sqlite3_column_text(statement, 1);
            NSString *chatIDstr = [[NSString alloc]initWithUTF8String:chatID];
            
            char * friendname = (char *)sqlite3_column_text(statement, 2);
            NSString * friendnamestr = [[NSString alloc] initWithUTF8String:friendname];
            
            char * chatContent = (char *)sqlite3_column_text(statement, 3);
            NSString * chatContentstr = [[NSString alloc] initWithUTF8String:chatContent];
            
            char * chatTime = (char *)sqlite3_column_text(statement, 4);
            NSString * chatTimeStr = [[NSString alloc] initWithUTF8String:chatTime];
            
            NSDictionary * state = @{K_chatID:chatIDstr,K_friendID:friendnamestr,K_chatContent:chatContentstr,K_chatTime:chatTimeStr};
            NSLog(@"name:%@ %@ %@",chatIDstr,friendnamestr,chatContentstr);
            [dataList addObject:state];
        }
    }
    sqlite3_close(dbPoint);
    return dataList;
}


@end
