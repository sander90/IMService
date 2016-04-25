//
//  Chat.m
//  IMService
//
//  Created by shansander on 16/3/17.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "Chat.h"

#import "IMService.h"
#import "XMPPJID.h"

@interface Chat ()

@property(nonatomic,strong,readonly) XMPPJID * FriendJID;
@end

@implementation Chat


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark - 初始化聊天界面，没有聊天内容
- (id)initWithFriendName:(NSString * )frineName
{
    self = [super init];
    if (self) {
        IMService * im = [IMService initService];
        _friendname = frineName;
        NSString * jidName = [NSString stringWithFormat:@"%@@%@",frineName,im.myHostName];
        _FriendJID = [XMPPJID jidWithString:jidName];
        [im setIMChat:self];
        
    }
    return self;
}
#pragma mark - 初始化聊天界面，初始化聊天记录的条数，得到的是聊天记录的数量
- (id)initWithFriendName:(NSString *)frineName chatContentCount:(NSInteger)count finish:(void(^)(id data))finish
{
    self = [super init];
    if (self) {
        IMService * im = [IMService initService];
        _friendname = frineName;
        NSString * jidName = [NSString stringWithFormat:@"%@@%@",frineName,im.myHostName];
        _FriendJID = [XMPPJID jidWithString:jidName];
        [im setIMChat:self];
        NSArray * chatList = [im.chatManager fetchChatContentWithChatID:frineName];
        finish(chatList);
    }
    return self;
}
- (void)sendMessage:(NSString * )message
{
    IMService * im = [IMService initService];
    [im sendMessage:message toFriendJID:self.FriendJID];
}
- (void)exitChat
{
    IMService * im = [IMService initService];
    [im setIMChat:nil];
}



@end
