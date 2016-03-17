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

-(void)IMServiceDidConnect;

@end


@interface IMService : NSObject

@property (nonatomic, strong) id<IMServiceDelegate>delegate;

@property (nonatomic, readonly) XMPPStream *xmppStream;

@property (nonatomic, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;


+ (void)printdescription;


+ (IMService *)initIMService;

- (void)setStreamHoatName:(NSString * )hostname andHostPort:(UInt16)newHostPort;

@end
