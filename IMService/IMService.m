//
//  IMService.m
//  IMService
//
//  Created by shansander on 16/3/19.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "IMService.h"
#import "AbstractXMPPConnection.h"
#import "Chat.h"

@interface IMService ()
@property (nonatomic, strong)AbstractXMPPConnection * xmppConnection;

@property (nonatomic, strong)Chat * iMChat;
@end

@implementation IMService

+ (id)initService
{
    static dispatch_once_t once = 0;
    static IMService * im = nil;
    dispatch_once(&once, ^{
        im = [[IMService alloc] init];
    });
    return im;
}

- (id) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setupWithMyname:(NSString *)myname andMyPassword:(NSString *)passWord andMyHostname:(NSString *)hostName andPort:(UInt16)port
{
    self.myName = myname;
    self.myHostName = hostName;
    self.myPassword = passWord;
    self.myPort = port;
}
- (void)setupXmpp
{
    [super setupXmpp];
}
- (void)sendMessage:(NSString * )message toFriendJID:(XMPPJID *)friendJid
{
    [super sendMessage:message toFriendJID:friendJid];
}

#pragma mark - 设置connectXMPP
- (void)setXmppConnection:(AbstractXMPPConnection *)xmppConnection
{
    _xmppConnection = xmppConnection;
}
#pragma mark - 设置Chat
- (void)setIMChat:(Chat *)IMChat
{
    _iMChat = IMChat;
}

#pragma mark - 功能
#pragma mark - 添加好友
- (void)addOneFriendWithFriendName:(NSString * )name
{
    XMPPJID * friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",name,self.myHostName]];
    
    [self.xmppRoster addUser:friendJid withNickname:name];
}
#pragma mark - 同意添加好友
- (void)agreeOneFriendRequestaddFriend:(XMPPIQ *)iq
{
    XMPPJID * friendJid = iq.from;
    [self.xmppRoster acceptPresenceSubscriptionRequestFrom:friendJid andAddToRoster:YES];
}
#pragma mark - 服务
#pragma mark - 连接成功
- (void)SDDidConnectXMPPStream:(XMPPStream * )sender
{
    if (self.xmppConnection.delegate && [self.xmppConnection.delegate respondsToSelector:@selector(XMPPDidConnect)]) {
        [self.xmppConnection.delegate XMPPDidConnect];
    }
}
#pragma mark - 连接失败
- (void)SDFaildConnectXMPPStream:(XMPPStream * )sender andError:(NSXMLElement * )error
{
    if (self.xmppConnection.delegate && [self.xmppConnection.delegate respondsToSelector:@selector(XMPPNotConnect)]) {
        [self.xmppConnection.delegate XMPPNotConnect];
    }
}
#pragma mark -  从某一个好友中获取信息。
- (void)IMServicedidReceiveMessage:(NSString *)messageContent from:(NSString *)fromName
{
    // 这个是对于专属的chat通知。
    if (self.iMChat.delegate && [self.iMChat.delegate respondsToSelector:@selector(XMPPdidReceiveMessage:withFriendName:)]) {
        if ([fromName isEqualToString:self.iMChat.FriendJID.user]) {
            [self.iMChat.delegate XMPPdidReceiveMessage:messageContent withFriendName:fromName];
        }else{
            // 不是当前聊天对象来了通知怎么办
            
        }
    }
}
#pragma mark - 请求发送信息
- (void)IMServicedidSendMessage:(NSString *)messageContent to:(NSString *)toName
{
    if (self.iMChat.delegate && [self.iMChat.delegate respondsToSelector:@selector(XMPPdidSendMessage:)]) {
        [self.iMChat.delegate XMPPdidSendMessage:messageContent];
    }
}
- (void)IMservicedidReceiveIQ:(XMPPIQ *)iq
{
    if ([iq.type isEqualToString:@"set"]) {
        [self agreeOneFriendRequestaddFriend:iq];
    }else if ([iq.type isEqualToString:@"get"]){
        
    }
}

#pragma mark - 获取
- (void)IMServicedidReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    
}
@end
