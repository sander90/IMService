//
//  RoomChat.m
//  IMService
//
//  Created by shansander on 16/4/2.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "RoomChat.h"

#import "IMService.h"
#import "XMPPRoom.h"
#import "SDPrintLog.h"

@interface RoomChat ()<XMPPRoomDelegate>

@end


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
//    IMService * im = [IMService initService];
//    [im fetchRoomChatList];
}

- (void)createRetentionRoomWithRoomname:(NSString * )roomName andnickName:(NSString * )nickName
{
    
    _roomname = roomName;
    _nickname = nickName;
    IMService * im = [IMService initService];
//    [im joinRoomWithRoomNiceName:roomName];
//    [im createRetentionRoomWithroomname:roomName andNickname:nickName];
    NSString * roomFullname = [NSString stringWithFormat:@"%@@conference.%@",roomName,im.myHostName];
    self.xmpproom = [[XMPPRoom alloc] initWithRoomName:roomFullname nickName:nickName];
    [self.xmpproom activate:[im getXMPPStream]];
    [self.xmpproom createOrJoinRoom];
//    [self.xmpproom inviteUser:im.myJID withMessage:@"请求"];
    [self.xmpproom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

- (void)sendRoomMessage:(NSString* )message
{
    [self.xmpproom sendMessage:message];
}
- (void)sendInstantRoomConfig
{
    
}

- (void)getChatRoomConfigurationInformation
{
    IMService * im  =[IMService initService];
    [im getConfigurationInformationForallWithRoom:self.roomname];
}

- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    [SDPrintLog printLog:@"" WithTag:@"xmppRoomDidCreate"];
}
- (void)xmppRoomDidEnter:(XMPPRoom *)sender
{
    [SDPrintLog printLog:@"" WithTag:@"xmppRoomDidEnter"];

}
- (void)xmppRoomDidLeave:(XMPPRoom *)sender
{
    [SDPrintLog printLog:@"" WithTag:@"xmppRoomDidLeave"];

}
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromNick:(NSString *)nick
{
//    [SDPrintLog printLog:message.description WithTag:@"didReceiveMessage"];
    NSString *body = [[message elementForName:@"body"] stringValue];
    XMPPJID * fromjid = [message from];
    NSString * fromeName = fromjid.user;
    NSString * receviceMessage = [NSString stringWithFormat:@"%@---%@",fromeName,body];
    [SDPrintLog printLog:receviceMessage WithTag:@"didReceiveMessage"];

}
- (void)xmppRoom:(XMPPRoom *)sender didChangeOccupants:(NSDictionary *)occupants
{
    [SDPrintLog printLog:occupants.description WithTag:@"didChangeOccupants"];
}
@end
