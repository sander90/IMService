//
//  RoomChat.h
//  IMService
//
//  Created by shansander on 16/4/2.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chat.h"
@class XMPPRoom;
@interface RoomChat : Chat

@property (nonatomic, strong,readonly) NSString* roomname;

@property (nonatomic, strong,readonly) NSString* nickname;

@property (nonatomic, strong)XMPPRoom * xmpproom;
/**
 * 用户通过Disco查询聊天服务是否支持MUC
 */
- (void)CheckIMServiceIsSupportMUC;
/**
 * 发现房间
 */
- (void)fetchRoomChat;
/**
 * 创建保留房间
 */
- (void)createRetentionRoomWithRoomname:(NSString * )roomName andnickName:(NSString * )nickName;

- (void)getChatRoomConfigurationInformation;
/**
 * 发送
 */
- (void)sendRoomMessage:(NSString* )message;
@end
