//
//  ChatDBManager.h
//  IMService
//
//  Created by shansander on 16/4/21.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ChatDBManager : NSObject


@property (nonatomic, strong,nonnull) NSManagedObjectContext * context;

@property (nonatomic, strong,nonnull) NSManagedObjectModel * managedModel;

+ (nonnull ChatDBManager *)defineDBManager;

- (void)saveChatContent:(nonnull NSString* )content friengID:(nonnull NSString * )friendID chatID:(nonnull NSString * )chatID;

- (nonnull NSArray * )fetchChatContentWithChatID:(nonnull NSString * )ChatID;

@end
