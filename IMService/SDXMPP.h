//
//  SDXMPP.h
//  IMService
//
//  Created by shansander on 16/3/19.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define presence_type @"subscribe"

#import "DDXML.h"
#import "ChatDBManager.h"
@class XMPPStream;
@class XMPPIQ;
@class XMPPPresence;
@class XMPPJID;
@class XMPPRoster;
@interface SDXMPP : NSObject
{
    
}



@property (nonatomic, strong) NSString * myName;

@property (nonatomic, strong) NSString * myPassword;

@property (nonatomic, strong) NSString * myHostName;

@property (nonatomic, assign) UInt16 myPort;

@property (nonatomic, strong)ChatDBManager *chatManager;





- (id)initWithMyname:(NSString * )myname andMyPassword:(NSString * )passWord andMyHostname:(NSString * )hostName andPort:(UInt16)port;

#pragma mark - 服务
/**
 * 连接成功
 */
- (void)SDDidConnectXMPPStream:(XMPPStream * )sender;
/**
 * 连接失败
 */
- (void)SDFaildConnectXMPPStream:(XMPPStream * )sender andError:(NSXMLElement * )error;

/**
 *  获取朋友的信息
 */
- (void)IMServicedidReceiveMessage:(NSString *)messageContent from:(NSString *)fromName;
/**
 * 成功发送信息给好友
 */
- (void)IMServicedidSendMessage:(NSString* )messageContent to:(NSString * )toName;

/*
 * 这个是个请求
 */
- (void)IMservicedidReceiveIQ:(XMPPIQ *)iq;

/**
 * 乱七八糟的各种信息汇总
 */
- (void)IMServicedidReceivePresenceSubscriptionRequest:(XMPPPresence *)presence;

- (void)IMServicedidReceivePresence:(XMPPPresence *)presence;


#pragma mark - 功能
/**
 * 连接服务器，登录
 */
- (void)connect;
/**
 * 初始化 XMPPStream
 */
- (void)setupXmpp;
/**
 * 发送信息给好友
 */
- (void)sendMessage:(NSString * )message toFriendJID:(XMPPJID *)friendJid;

- (void)sendXMPPStreamElement:(NSXMLElement *)element;

- (XMPPStream * )getXMPPStream;
- (XMPPRoster *)getXMPPRoster;
- (XMPPJID *)getMyXMPPJID;

- (void)initChatDB;

@end
