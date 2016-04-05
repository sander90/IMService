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
#import "SDXMPP.h"
#import "DDXML.h"

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
#pragma mark 添加好友
- (void)addOneFriendWithFriendName:(NSString * )name
{
    XMPPJID * friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",name,self.myHostName]];
    
    [self.xmppRoster addUser:friendJid withNickname:name];
}
#pragma mark 同意添加好友
- (void)agreeOneFriendRequestaddFriend:(NSString *)friendname
{
    XMPPJID * friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",friendname,self.myHostName]];
    [self.xmppRoster acceptPresenceSubscriptionRequestFrom:friendJid andAddToRoster:YES];
}
#pragma mark 拒绝添加好友的请求
- (void)unagreeOneFriendRequestaddFriend:(NSString *)name
{
    XMPPJID * friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",name,self.myHostName]];
    [self.xmppRoster rejectPresenceSubscriptionRequestFrom:friendJid];
}

#pragma mark 用户通过Disco查询聊天服务是否支持MUC
- (void)CheckIMServiceIsSupportMUC
{
    NSXMLElement *iqElement = [NSXMLElement elementWithName:@"iq"];
    [iqElement addAttributeWithName:@"to" stringValue:self.myHostName];
    [iqElement addAttributeWithName:@"type" stringValue:@"get"];
    NSXMLElement * queryElement = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"];
    [iqElement addChild:queryElement];
    [self sendXMPPStreamElement:iqElement];
}

#pragma mark 查询房间
- (void)fetchRoomChatListWithFinishReslut:(FinishResult)finish
{
    NSXMLElement *iqElement = [NSXMLElement elementWithName:@"iq"];
    [iqElement addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"conference.%@",self.myHostName]];
    [iqElement addAttributeWithName:@"type" stringValue:@"get"];
    NSXMLElement * queryElement = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#items"];
    [iqElement addChild:queryElement];
    [self sendXMPPStreamElement:iqElement];
    
    self.finish = finish;
}
#pragma mark - 创建保留房间
- (void)createRetentionRoom
{
  

}
- (void)getConfigurationInformationForallWithRoom:(NSString*)roomName
{
    NSXMLElement * iqElement = [[NSXMLElement alloc] initWithName:@"iq"];
    [iqElement addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@conference.%@",roomName,self.myHostName]];
    [iqElement addAttributeWithName:@"type" stringValue:@"get"];
    NSXMLElement * queryElement = [[NSXMLElement alloc] initWithName:@"query" xmlns:@"http://jabber.org/protocol/muc#owner"];
    [iqElement addChild:queryElement];
    [self sendXMPPStreamElement:iqElement];
}

#pragma mark - 服务
#pragma mark -
#pragma mark  连接成功
- (void)SDDidConnectXMPPStream:(XMPPStream * )sender
{
    if (self.xmppConnection.delegate && [self.xmppConnection.delegate respondsToSelector:@selector(XMPPDidConnect)]) {
        [self.xmppConnection.delegate XMPPDidConnect];
    }
}
#pragma mark 连接失败
- (void)SDFaildConnectXMPPStream:(XMPPStream * )sender andError:(NSXMLElement * )error
{
    if (self.xmppConnection.delegate && [self.xmppConnection.delegate respondsToSelector:@selector(XMPPNotConnect)]) {
        [self.xmppConnection.delegate XMPPNotConnect];
    }
}
#pragma mark 从某一个好友中获取信息。
- (void)IMServicedidReceiveMessage:(NSString *)messageContent from:(NSString *)fromName
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(IMServiceDidReviceAllChatMessage:from:)]) {
        // 这个是对于专属的chat通知。
        if (self.iMChat.delegate && [self.iMChat.delegate respondsToSelector:@selector(XMPPdidReceiveMessage:withFriendName:)]) {
            if ([fromName isEqualToString:self.iMChat.friendname]) {
                [self.iMChat.delegate XMPPdidReceiveMessage:messageContent withFriendName:fromName];
                return;
            }
        }
        //这个chat通知，剔除掉专属的通知。
        [self.delegate IMServiceDidReviceAllChatMessage:messageContent from:fromName];
    }
    
    
}
#pragma mark 请求发送信息
- (void)IMServicedidSendMessage:(NSString *)messageContent to:(NSString *)toName
{
    if (self.iMChat.delegate && [self.iMChat.delegate respondsToSelector:@selector(XMPPdidSendMessage:)]) {
        [self.iMChat.delegate XMPPdidSendMessage:messageContent];
    }
}
#pragma mark 获取iq 信息
- (void)IMservicedidReceiveIQ:(XMPPIQ *)iq
{
    if ([iq.type isEqualToString:@"set"]) {
        
    }else if ([iq.type isEqualToString:@"get"]){
        
    }else if ([iq.type isEqualToString:@"result"]){
        [self analysisReceviewIQByTypeisResult:iq];
    }
}

#pragma mark 获取订阅请求信息
- (void)IMServicedidReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //[self agreeOneFriendRequestaddFriend:presence.from.user];
//    [self unagreeOneFriendRequestaddFriend:presence.from.user];
}
#pragma mark 获取所有的信息
- (void)IMServicedidReceivePresence:(XMPPPresence *)presence
{
    //暂不做处理，
}


- (void)analysisReceviewIQByTypeisResult:(XMPPIQ *)iq
{
    NSXMLElement *element = [iq elementForName:@"query" xmlns:@"http://jabber.org/protocol/disco#items"];
    if (element) {
        [self ReceviewIQForqueryItems:element];
    }
}

- (void)ReceviewIQForqueryItems:(NSXMLElement *)element
{
    NSArray * items = [element elementsForName:@"item"];
   __block NSMutableArray * rooms = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSXMLElement * item = obj;
        NSString * roomname = [item attributeStringValueForName:@"name"];
        [rooms addObject:roomname];
    }];
    if (self.finish) {
        self.finish(rooms);
    }
}
@end
