//
//  IMService.h
//  IMService
//
//  Created by shansander on 16/3/19.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDXMPP.h"

// 用来请求数据 这里使用block
typedef void(^FinishResult)(id data);

@protocol IMServiceDelegate <NSObject>
@optional
/**
 * 作为外部的信息获取，排除掉当前正在聊天的对象
 */
- (void)IMServiceDidReviceAllChatMessage:(NSString *)message from:(NSString* )fromName;

@end


@class AbstractXMPPConnection;
@class Chat;

@interface IMService : SDXMPP

@property (nonatomic, strong)id <IMServiceDelegate> delegate;

@property (nonatomic, assign) FinishResult finish;

/**
 * 创建IMService单例
 */
+ (id)initService;
/**
 * 设置基础信息。本地信息，这个是在登录的时候进行设置。
 */
- (void)setupWithMyname:(NSString *)myname andMyPassword:(NSString *)passWord andMyHostname:(NSString *)hostName andPort:(UInt16)port;
/**
 * 设置登录对象
 */
- (void)setXmppConnection:(AbstractXMPPConnection *)xmppConnection;

/**
 * 设置登录聊天的对象
 */
- (void)setIMChat:(Chat *)IMChat;

/**
 * 发送信息给friend
 */
- (void)sendMessage:(NSString * )message toFriendJID:(XMPPJID *)friendJid;
/**
 * 添加一个好友
 */
- (void)addOneFriendWithFriendName:(NSString * )name;
/**
 * 拒绝 添加好友的请求
 */
- (void)unagreeOneFriendRequestaddFriend:(NSString *)name;
/**
 *  用户通过Disco查询聊天服务是否支持MUC
 */
- (void)CheckIMServiceIsSupportMUC;
/**
 * 发现房间
 */
- (void)fetchRoomChatList;
/**
 * 创建保留房间
 */
- (void)createRetentionRoom;

@end
