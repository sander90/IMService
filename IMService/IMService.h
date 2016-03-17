//
//  IMService.h
//  IMService
//
//  Created by shansander on 16/3/13.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#import "XMPPFramework.h"

@protocol IMServiceDelegate <NSObject>

// xmpp 连接成功返回
- (void)IMServiceDidConnect;
// xmpp 认证成功后返回
- (void)IMServiceDidAuthenticate;
// xmpp 回收消息
- (void)IMServicedidReceiveMessage:(NSString * )messageContent from:(NSString * )fromName;

@end


@interface IMService : NSObject
{
   
}

@property (nonatomic, strong) id<IMServiceDelegate>delegate;

@property (nonatomic, readonly) XMPPStream *xmppStream;

@property (nonatomic, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;


+ (IMService *)initIMService;

- (void)setStreamHoatName:(NSString * )hostname andHostPort:(UInt16)newHostPort;

@end
