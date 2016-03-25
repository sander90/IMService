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

- (void)XMPPdidReceiveMessage:(NSString * )message;

@end

@interface Chat : NSObject

@property (nonatomic, strong) id <ChatDelegate>delegate;

@property(nonatomic,strong,readonly) XMPPJID * FriendJID;

- (void)sendMessage:(NSString * )message;

@end
