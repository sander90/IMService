//
//  ChatDBManager.m
//  IMService
//
//  Created by shansander on 16/4/21.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "ChatDBManager.h"
#import "SDDatabase.h"
#import "ChatContentModel.h"

// 数据库的版本号
#define DBLEVEL 2
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
        [self initializeDB];
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
    NSString *sql = @"create table if not exists ChatContent (ID INTEGER PRIMARY KEY AUTOINCREMENT, chatID text,fromName text,chatcontent text,createdata text)";
    [self.db execSQL:sql];
}
- (void)updateDB
{
    
}

- (void)saveChatContent:(NSString* )content friengID:(NSString * )friendID chatID:(NSString * )chatID
{
    NSDate * date = [NSDate date];
    long timelong = [date timeIntervalSince1970];
    NSString * timestr = [NSString stringWithFormat:@"%ld",(long)timelong];
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO ChatContent (chatID,fromName,chatcontent,createdata) VALUES('%@','%@','%@','%@')",chatID,friendID,content,timestr];
    [self.db execSQL:sql];
}

- (NSArray * )fetchChatContentWithChatID:(NSString * )ChatID
{
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM ChatContent Where chatID like '%@'",ChatID];
    
    NSArray * list = [self.db fetchSQL:sql];
    
    __block NSMutableArray * theChatList = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary * one = obj;
        ChatContentModel* dbmodel = [[ChatContentModel alloc] initWithContent:one];
        [theChatList addObject:dbmodel];
    }];
    return theChatList;
}

@end



