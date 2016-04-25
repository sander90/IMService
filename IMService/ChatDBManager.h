//
//  ChatDBManager.h
//  IMService
//
//  Created by shansander on 16/4/21.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define SQLITE_OK 0

@interface ChatDBManager : NSObject
{
    sqlite3 *dbPoint;
}




+ (nonnull ChatDBManager *)defineDBManager;

- (void)saveChatContent:(nonnull NSString* )content friengID:(nonnull NSString * )friendID chatID:(nonnull NSString * )chatID;

- (nonnull NSArray * )fetchChatContentWithChatID:(nonnull NSString * )ChatID;

- (void)openDBWithDBname:(NSString *)name;

@end
