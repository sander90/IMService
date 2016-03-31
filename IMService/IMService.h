//
//  IMService.h
//  IMService
//
//  Created by shansander on 16/3/19.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDXMPP.h"

@class AbstractXMPPConnection;
@class Chat;

@interface IMService : SDXMPP



+ (id)initService;

- (void)setupWithMyname:(NSString *)myname andMyPassword:(NSString *)passWord andMyHostname:(NSString *)hostName andPort:(UInt16)port;

- (void)setXmppConnection:(AbstractXMPPConnection *)xmppConnection;

- (void)setIMChat:(Chat *)IMChat;

- (void)sendMessage:(NSString * )message toFriendJID:(XMPPJID *)friendJid;

@end
