//
//  ChatDBManager.m
//  IMService
//
//  Created by shansander on 16/4/21.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "ChatDBManager.h"
#import "ChatContent.h"

@implementation ChatDBManager

+ (ChatDBManager *)defineDBManager
{
    static dispatch_once_t once = 0;
    
    static ChatDBManager * cdbManager = nil;
    
    dispatch_once(&once, ^{
        cdbManager = [[ChatDBManager alloc] init];
    });
    return cdbManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ChatcontentsDB" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
        // 实例化持久化储存
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSURL *dbURL = [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
        NSString* dbName = @"chatv1.db";
        
        dbURL = [dbURL URLByAppendingPathComponent:dbName];
        [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbURL options:nil error:NULL];
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [self.context setPersistentStoreCoordinator:psc];
        self.managedModel = model;
        
        
    }
    return self;
}

- (void)saveChatContent:(NSString* )content friengID:(NSString * )friendID chatID:(NSString * )chatID
{
    ChatContent * cc = [NSEntityDescription insertNewObjectForEntityForName:@"ChatContent" inManagedObjectContext:self.context];
    
    NSDate * nowdate = [NSDate date];
    cc.content = content;
    cc.chatid = chatID;
    cc.fromid = friendID;
    cc.createdata = nowdate;
    
    NSError * error;
    if (![self.context save:&error]) {
        NSLog(@"存储失败了 %@",error);
    }
}

- (NSArray * )fetchChatContentWithChatID:(NSString * )ChatID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChatContent" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chatid == %@", ChatID];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdata" ascending:NO];
    
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSError *error = nil;
    
    NSArray * fetchObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchObjects != nil) {
        return fetchObjects;
    }
    return @[];
}

@end
