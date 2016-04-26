//
//  ChatDBManager.m
//  IMService
//
//  Created by shansander on 16/4/21.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "ChatDBManager.h"
#import "SDDatabase.h"

// 数据库的版本号
#define DBLEVEL 1
#define DBSAVEDLEVELUSER @"sqlitesavelaveuserinfo"




@interface ChatDBManager ()

@property(nonatomic,strong,readonly)SDDatabase * db;

@end


@implementation ChatDBManager

+ (ChatDBManager *)defineDBManager
{
    static ChatDBManager * cdbManager = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        cdbManager = [[ChatDBManager alloc] init];
    });
    return cdbManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _db = [SDDatabase databaseWithPath:@"dabase.db"];
    }
    return self;
}

- (void)initializeDB
{
    NSNumber * db_level = [[NSUserDefaults standardUserDefaults] objectForKey:DBSAVEDLEVELUSER];
    if (db_level) {
        NSInteger newDBLevel = DBLEVEL;
        NSInteger oldDBLevel = [db_level integerValue];
        if (newDBLevel == oldDBLevel) {
            //版本一样，我不需要做什么东西
        }else if (newDBLevel>oldDBLevel){
            [self updateDB];
        }else{
            NSLog(@"这里不能经过");
        }
    }else{
        [self createDB];
        //需要创建
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:DBLEVEL] forKey:DBSAVEDLEVELUSER];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void)createDB
{
    NSString *sql = @"create table if not exists testTable(ID INTEGER PRIMARY KEY AUTOINCREMENT, chatID text,fromName text,chatcontent text)";
    [self.db execSQL:sql];
}
- (void)updateDB
{
    
}

- (void)saveChatContent:(NSString* )content friengID:(NSString * )friendID chatID:(NSString * )chatID
{

}

- (NSArray * )fetchChatContentWithChatID:(NSString * )ChatID
{
    return @[];
}

@end
