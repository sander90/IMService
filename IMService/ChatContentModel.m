//
//  ChatContentModel.m
//  IMService
//
//  Created by shansander on 16/4/27.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "ChatContentModel.h"
#import "SDDBDefine.h"

@implementation ChatContentModel

- (id)initWithContent:(NSDictionary * )content
{
    self = [super init];
    if (self) {
        NSString * chatID = content[K_chatID];
        NSString * friendname = content[K_friendID];
        NSString * chatcontent = content[K_chatContent];
        NSString * chattime = content[K_chatTime];
        
        self.chatID = chatID;
        self.friendname = friendname;
        self.chatContent = chatcontent;
        
        NSTimeInterval timev = [chattime doubleValue];
        
        self.time = timev;
//        [NSDate dateWithTimeIntervalSince1970:<#(NSTimeInterval)#>]
        
    }
    return self;
}



@end
