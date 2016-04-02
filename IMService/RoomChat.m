//
//  RoomChat.m
//  IMService
//
//  Created by shansander on 16/4/2.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "RoomChat.h"

#import "IMService.h"

@implementation RoomChat

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark - 用户通过Disco查询聊天服务是否支持MUC
- (void)CheckIMServiceIsSupportMUC
{
    IMService * im = [IMService initService];
    [im CheckIMServiceIsSupportMUC];
}
#pragma mark - 发现房间
- (void)fetchRoomChat
{
    IMService * im = [IMService initService];
    [im fetchRoomChatList];
}
@end
