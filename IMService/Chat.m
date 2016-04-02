//
//  Chat.m
//  IMService
//
//  Created by shansander on 16/3/17.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "Chat.h"

#import "IMService.h"

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
- (void)sendMessage:(NSString * )message
{
    IMService * im = [IMService initService];
    [im sendMessage:message toFriendJID:self.FriendJID];
}



@end
