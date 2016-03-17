//
//  AbstractXMPPConnection.m
//  IMService
//
//  Created by shansander on 16/3/14.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "AbstractXMPPConnection.h"
#import "IMService.h"

#import "SDPrintLog.h"


@interface AbstractXMPPConnection ()<IMServiceDelegate>

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
        IMService * im = [IMService initIMService];
        [im setStreamHoatName:serviceName andHostPort:5222];
        _username = userName;
        _userpassword = password;
        _hostName = serviceName;
        XMPPJID * myjid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",userName,serviceName]];
        [im.xmppStream setMyJID:myjid];

        NSError * error;
        
        if ([im.xmppStream isConnected]) {
            [SDPrintLog printLog:@"已经连接了，我要断掉"];
            [im.xmppStream disconnect];
        }
        
        BOOL reslut = [im.xmppStream connect:&error];
        if (reslut) {
            [SDPrintLog printLog:@"连接服务器成功"];
        }else{
            [SDPrintLog printLog:[NSString stringWithFormat:@"连接服务器失败 %@",error]];
        }
        //不知道为什么，这里会出现错误，错误的缘由还不清楚是什么
//        [im.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];

    }
    return self;
}




#pragma mark - xmppstream delegate

-(void)IMServiceDidConnect
{
    
    IMService * im = [IMService initIMService];

    NSError * error = nil;
    [im.xmppStream authenticateWithPassword:self.userpassword error:&error];
    
    if (error) {
        [SDPrintLog printLog:[NSString stringWithFormat:@"%@",error]];
    }
    
    
}






@end
