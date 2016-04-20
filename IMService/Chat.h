//
//  Chat.h
//  IMService
//
//  Created by shansander on 16/3/17.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMService;

@protocol ChatDelegate <NSObject>
@optional
- (void)XMPPdidReceiveMessage:(NSString * )message withFriendName:(NSString * )user;
@optional
- (void)XMPPdidSendMessage:(NSString* )message;
@end

@interface Chat : NSObject

@property (nonatomic, strong) id <ChatDelegate>delegate;

@property (nonatomic, strong,readonly) NSString* friendname;

//发送信息
- (void)sendMessage:(NSString * )message;
//初始化聊天室
- (id)initWithFriendName:(NSString * )frineName;
//离开聊天室
- (void)exitChat;
@end
