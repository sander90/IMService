//
//  AbstractXMPPConnection.m
//  IMService
//
//  Created by shansander on 16/3/14.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "AbstractXMPPConnection.h"
#import "SDPrintLog.h"


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
    self = [super initWithMyname:userName andMyPassword:password andMyHostname:serviceName andPort:5222];
    if (self) {
        
    }
    return self;
}

- (void)connect{
    [super connect];
}





@end
