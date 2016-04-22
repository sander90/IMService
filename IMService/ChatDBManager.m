//
//  ChatDBManager.m
//  IMService
//
//  Created by shansander on 16/4/21.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "ChatDBManager.h"



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
        
    }
    return self;
}



- (void)saveChatContent:(NSString* )content friengID:(NSString * )friendID chatID:(NSString * )chatID
{

}

- (NSArray * )fetchChatContentWithChatID:(NSString * )ChatID
{
    return @[];
}

@end
