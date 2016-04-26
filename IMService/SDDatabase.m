//
//  SDDatabase.m
//  IMService
//
//  Created by shansander on 16/4/25.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "SDDatabase.h"

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
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString * dbPath = [docPath stringByAppendingString:path];
        int rsulte = sqlite3_open([dbPath UTF8String],&dbPoint);
        
        if (rsulte == SQLITE_OK) {
            NSLog(@"这个成功了吧 %d",rsulte);
        }
    }
    return self;
}
//执行sql语句
- (int)execSQL:(NSString * )sql
{
    char * errorMsg;
    int result = sqlite3_exec(dbPoint,[sql UTF8String],NULL,NULL,&errorMsg);
    return result;
}

- (void)createTableWithTableHeader:(NSDictionary *)header
{
    NSMutableString * createheader = [[NSMutableString alloc] init];
    
    [createheader appendString:@"CREATE TABLE IF NOT EXISTS STUDENT(###)"];
    
    
}



@end
