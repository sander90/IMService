//
//  Chat.m
//  IMService
//
//  Created by shansander on 16/3/17.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "Chat.h"


@interface Chat ()<IMServiceDelegate>

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
        
    }
    return self;
}

- (void)IMServicedidReceiveMessage:(NSString *)messageContent from:(NSString *)fromName
{
    
}



@end
