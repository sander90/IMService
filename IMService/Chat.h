//
//  Chat.h
//  IMService
//
//  Created by shansander on 16/3/17.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IMService.h"

@protocol ChatDelegate <NSObject>
@optional
- (void)XMPPdidReceiveMessage:(NSString * )message withFriendName:(NSString * )user;
@optional
- (void)XMPPdidSendMessage:(NSString* )message;
@end

@interface Chat : NSObject

@property (nonatomic, strong) id <ChatDelegate>delegate;

@property(nonatomic,strong,readonly) XMPPJID * FriendJID;

- (void)sendMessage:(NSString * )message;
- (id)initWithFriendName:(NSString * )frineName;
@end
