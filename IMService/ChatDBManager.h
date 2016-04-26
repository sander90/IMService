//
//  ChatDBManager.h
//  IMService
//
//  Created by shansander on 16/4/21.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatDBManager : NSObject


+ (nonnull ChatDBManager *)defineDBManager;

- (void)saveChatContent:(nonnull NSString* )content friengID:(nonnull NSString * )friendID chatID:(nonnull NSString * )chatID;

- (nonnull NSArray * )fetchChatContentWithChatID:(nonnull NSString * )ChatID;

@end
