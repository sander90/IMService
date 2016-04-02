//
//  RoomChat.h
//  IMService
//
//  Created by shansander on 16/4/2.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chat.h"
@interface RoomChat : Chat
/**
 * 用户通过Disco查询聊天服务是否支持MUC
 */
- (void)CheckIMServiceIsSupportMUC;
/**
 * 发现房间
 */
- (void)fetchRoomChat;
@end
