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
- (void)setXmppConnection:(AbstractXMPPConnection *)xmppConnection
{
    _xmppConnection = xmppConnection;
}
- (void)setIMChat:(Chat *)IMChat
{
    _iMChat = IMChat;
}

/**
 * 连接成功
 */
- (void)SDDidConnectXMPPStream:(XMPPStream * )sender
{
    if (self.xmppConnection.delegate && [self.xmppConnection.delegate respondsToSelector:@selector(XMPPDidConnect)]) {
        [self.xmppConnection.delegate XMPPDidConnect];
    }
}
/**
 * 连接失败
 */
- (void)SDFaildConnectXMPPStream:(XMPPStream * )sender andError:(NSXMLElement * )error
{
    if (self.xmppConnection.delegate && [self.xmppConnection.delegate respondsToSelector:@selector(XMPPNotConnect)]) {
        [self.xmppConnection.delegate XMPPNotConnect];
    }
}
/**
 * 从某一个好友中获取信息。
 */
- (void)IMServicedidReceiveMessage:(NSString *)messageContent from:(NSString *)fromName
{
    if (self.iMChat.delegate && [self.iMChat.delegate respondsToSelector:@selector(XMPPdidReceiveMessage:withFriendName:)]) {
        if ([fromName isEqualToString:self.iMChat.FriendJID.user]) {
            [self.iMChat.delegate XMPPdidReceiveMessage:messageContent withFriendName:fromName];
        }
    }
}
@end
