//
//  AbstractXMPPConnection.m
//  IMService
//
//  Created by shansander on 16/3/14.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "AbstractXMPPConnection.h"
#import "SDPrintLog.h"
#import "IMService.h"


@interface AbstractXMPPConnection ()



@end

@implementation AbstractXMPPConnection

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithName:(NSString *)userName andPassword:(NSString * )password andServiceName:(NSString *)serviceName
{
    
    self = [super init];
    if (self) {
        IMService * im = [IMService initService];
        [im setupWithMyname:userName andMyPassword:password andMyHostname:serviceName andPort:5222];
        [im setXmppConnection:self];
        [im setupXmpp];        
    }
    return self;
}

- (void)connect{
    IMService * im = [IMService initService];
    [im connect];
}





@end
