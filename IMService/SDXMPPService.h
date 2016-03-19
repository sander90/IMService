//
//  SDXMPPService.h
//  IMService
//
//  Created by shansander on 16/3/19.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "XMPPFramework.h"

@interface SDXMPPService : NSObject

@property (nonatomic, readonly) XMPPStream * xmppStream;

@property (nonatomic, strong) NSString * myName;

@property (nonatomic, strong) NSString * myHostName;

@property (nonatomic, assign) UInt16 myPort;


/**
 * 连接服务器，登录
 */
- (void)connect;
/**
 * 连接成功
 */
- (void)SDDidConnectXMPPStream:(XMPPStream * )sender;
/**
 * 连接失败
 */
- (void)SDFaildConnectXMPPStream:(XMPPStream * )sender andError:(NSError * )error;




@end
