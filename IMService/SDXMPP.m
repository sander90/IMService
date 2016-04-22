//
//  SDXMPP.m
//  IMService
//
//  Created by shansander on 16/3/19.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "SDXMPP.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPRosterMemoryStorage.h"
//#import "DDLog.h"
#import "XMPPFramework.h"
#import "DDXML.h"


#import <CFNetwork/CFNetwork.h>

#import "SDPrintLog.h"


#define SDAPIVERSION @"1.1"

@interface SDXMPP ()<XMPPStreamDelegate,XMPPRosterDelegate>

@property (nonatomic)  XMPPRosterMemoryStorage * xmppRosterMenoryStorage;

//@property (nonatomic) XMPPMessage
@property (nonatomic,strong, readonly) XMPPStream * xmppStream;

@property (nonatomic, readonly) XMPPReconnect * xmppReconnect;

@property (nonatomic, readonly) XMPPRoster * xmppRoster;

@property (nonatomic, strong)XMPPJID * myJID;


@end


@implementation SDXMPP
- (id)init
{
    self = [super init];
    if (self) {
        [SDPrintLog printLog:SDAPIVERSION WithTag:@"version"];

        [self setupXmpp];
    }
    return self;
}
- (id)initWithMyname:(NSString * )myname andMyPassword:(NSString * )passWord andMyHostname:(NSString * )hostName andPort:(UInt16)port;
{
    
    self = [super init];
    if (self) {
        _myName = myname;
        _myHostName = hostName;
        _myPort = port;
        _myPassword = passWord;
        [self setupXmpp];
    }
    return self;
   
}

- (XMPPStream * )getXMPPStream
{
    return self.xmppStream;
}
- (XMPPRoster*)getXMPPRoster
{
    return self.xmppRoster;
}
- (XMPPJID *)getMyXMPPJID
{
    return self.myJID;
}
#pragma mark - 初始化 xmpp
- (void)setupXmpp
{
    _xmppStream = [[XMPPStream alloc] init];
    
    //接入断线重连模块
    _xmppReconnect = [[XMPPReconnect alloc] init];
    [self.xmppReconnect setAutoReconnect:YES];
    [self.xmppReconnect activate:self.xmppStream];
    
    
    //接入好友列表,可以获取好友列表
    _xmppRosterMenoryStorage = [[XMPPRosterMemoryStorage alloc] init];
    
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterMenoryStorage];
    
    [self.xmppRoster activate:self.xmppStream];
    
    [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    
    if ([self.xmppStream isConnected]) {
        [self.xmppStream disconnect];
        [SDPrintLog printLog:@"" WithTag:@"不应该出现连接，断开连接"];
    }
    
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

- (void)initChatDBWithDBUrl:(NSURL * )dburl
{
    self.chatManager = [ChatDBManager defineDBManagerWithDBBundle:dburl];
}

#pragma mark - 登录
- (void)connect
{
    XMPPJID * myjid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",self.myName,self.myHostName]];
    _myJID = myjid;
    [self.xmppStream setMyJID:myjid];
    NSError * error;
    BOOL reslut = [self.xmppStream connect:&error];
    if (reslut) {
        [SDPrintLog printLog:@"连接服务器成功"];
    }else{
        [SDPrintLog printLog:[NSString stringWithFormat:@"连接服务器失败 %@",error]];
    }
    
}

#pragma mark 功能
#pragma mark - 在线
- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence elementWithName:@"presence"];
    [self.xmppStream sendElement:presence];
}
#pragma mark - 发送信息给好友
- (void)sendMessage:(NSString * )message toFriendJID:(XMPPJID *)friendJid
{
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:message];
    
    NSXMLElement *messageElement = [NSXMLElement elementWithName:@"message"];
    [messageElement addAttributeWithName:@"type" stringValue:@"chat"];
    [messageElement addAttributeWithName:@"to" stringValue:[friendJid full]];
    [messageElement addChild:body];
    [self.xmppStream sendElement:messageElement];
}
#pragma mark - 普通的发送协议信息
- (void)sendXMPPStreamElement:(NSXMLElement *)element
{
    [self.xmppStream sendElement:element];
}

#pragma mark 服务

#pragma mark - 连接成功
- (void)SDDidConnectXMPPStream:(XMPPStream * )sender
{
    int a = 0;
}
#pragma mark - 连接失败
- (void)SDFaildConnectXMPPStream:(XMPPStream * )sender andError:(NSXMLElement * )error
{
    int a = 0;
}
#pragma mark - 获取聊天信息
- (void)IMServicedidReceiveMessage:(NSString *)messageContent from:(NSString *)fromName
{
    
}
#pragma mark - 发送聊天信息
- (void)IMServicedidSendMessage:(NSString *)messageContent to:(NSString *)toName
{
    
}
#pragma mark - 获取订阅请求有关的信息
- (void)IMServicedidReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    
}
#pragma mark - 获取iq开头的信息
- (void)IMservicedidReceiveIQ:(XMPPIQ *)iq
{
    
}
#pragma mark - 获取信息
- (void)IMServicedidReceivePresence:(XMPPPresence *)presence
{
    
}
#pragma mark - XMPPStreamDelegate
/**
 * This method is called before the stream begins the connection process.
 *
 * If developing an iOS app that runs in the background, this may be a good place to indicate
 * that this is a task that needs to continue running in the background.
 **/
- (void)xmppStreamWillConnect:(XMPPStream *)sender
{
    [SDPrintLog printLog:@"" WithTag:@"xmppStreamWillConnect"];
}

/**
 * This method is called after the tcp socket has connected to the remote host.
 * It may be used as a hook for various things, such as updating the UI or extracting the server's IP address.
 *
 * If developing an iOS app that runs in the background,
 * please use XMPPStream's enableBackgroundingOnSocket property as opposed to doing it directly on the socket here.
 **/
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    [SDPrintLog printLog:@"" WithTag:@"socketDidConnect"];
}

/**
 * This method is called after a TCP connection has been established with the server,
 * and the opening XML stream negotiation has started.
 **/
- (void)xmppStreamDidStartNegotiation:(XMPPStream *)sender
{
    [SDPrintLog printLog:@"" WithTag:@"xmppStreamDidStartNegotiation"];
}

/**
 * This method is called immediately prior to the stream being secured via TLS/SSL.
 * Note that this delegate may be called even if you do not explicitly invoke the startTLS method.
 * Servers have the option of requiring connections to be secured during the opening process.
 * If this is the case, the XMPPStream will automatically attempt to properly secure the connection.
 *
 * The possible keys and values for the security settings are well documented.
 * Some possible keys are:
 * - kCFStreamSSLLevel
 * - kCFStreamSSLAllowsExpiredCertificates
 * - kCFStreamSSLAllowsExpiredRoots
 * - kCFStreamSSLAllowsAnyRoot
 * - kCFStreamSSLValidatesCertificateChain
 * - kCFStreamSSLPeerName
 * - kCFStreamSSLCertificates
 *
 * Please refer to Apple's documentation for associated values, as well as other possible keys.
 *
 * The dictionary of settings is what will be passed to the startTLS method of ther underlying AsyncSocket.
 * The AsyncSocket header file also contains a discussion of the security consequences of various options.
 * It is recommended reading if you are planning on implementing this method.
 *
 * The dictionary of settings that are initially passed will be an empty dictionary.
 * If you choose not to implement this method, or simply do not edit the dictionary,
 * then the default settings will be used.
 * That is, the kCFStreamSSLPeerName will be set to the configured host name,
 * and the default security validation checks will be performed.
 *
 * This means that authentication will fail if the name on the X509 certificate of
 * the server does not match the value of the hostname for the xmpp stream.
 * It will also fail if the certificate is self-signed, or if it is expired, etc.
 *
 * These settings are most likely the right fit for most production environments,
 * but may need to be tweaked for development or testing,
 * where the development server may be using a self-signed certificate.
 **/
- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    
    [SDPrintLog printLog:@"" WithTag:@"willSecureWithSettings"];
    
}

/**
 * This method is called after the stream has been secured via SSL/TLS.
 * This method may be called if the server required a secure connection during the opening process,
 * or if the secureConnection: method was manually invoked.
 **/
- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
    [SDPrintLog printLog:@"" WithTag:@"xmppStreamDidSecure"];
}

/**
 * This method is called after the XML stream has been fully opened.
 * More precisely, this method is called after an opening <xml/> and <stream:stream/> tag have been sent and received,
 * and after the stream features have been received, and any required features have been fullfilled.
 * At this point it's safe to begin communication with the server.
 **/
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    [SDPrintLog printLog:@"" WithTag:@"xmppStreamDidConnect"];
    NSError * error;
    [self.xmppStream authenticateWithPassword:self.myPassword error:&error];
    if (error) {
        [SDPrintLog printLog:@"" WithTag:@"登录失败"];
    }
    
}

/**
 * This method is called after registration of a new user has successfully finished.
 * If registration fails for some reason, the xmppStream:didNotRegister: method will be called instead.
 **/
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    [SDPrintLog printLog:@"" WithTag:@"xmppStreamDidRegister"];
}

/**
 * This method is called if registration fails.
 **/
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    [SDPrintLog printLog:@"" WithTag:@"didNotRegister"];
}

/**
 * This method is called after authentication has successfully finished.
 * If authentication fails for some reason, the xmppStream:didNotAuthenticate: method will be called instead.
 **/
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    [SDPrintLog printLog:@"" WithTag:@"xmppStreamDidAuthenticate"];
    [self goOnline];
    [self SDDidConnectXMPPStream:sender];
}

/**
 * This method is called if authentication fails.
 **/
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    [SDPrintLog printLog:@"" WithTag:@"didNotAuthenticate"];
    
    [self SDFaildConnectXMPPStream:sender andError:error];
}

/**
 * These methods are called after their respective XML elements are received on the stream.
 *
 * In the case of an IQ, the delegate method should return YES if it has or will respond to the given IQ.
 * If the IQ is of type 'get' or 'set', and no delegates respond to the IQ,
 * then xmpp stream will automatically send an error response.
 **/
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    [SDPrintLog printLog:iq.description WithTag:@"didReceiveIQ"];
    [self IMservicedidReceiveIQ:iq];
    return YES;
}
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
    if ([message isChatMessageWithBody])
    {
        
        NSString *body = [[message elementForName:@"body"] stringValue];
        XMPPJID * fromjid = [message from];
        NSString * fromeName = fromjid.user;
        
        [SDPrintLog printLog:[NSString stringWithFormat:@"%@--->%@",fromeName,body] WithTag:@"didReceiveMessage"];
        [self.chatManager saveChatContent:body friengID:fromeName chatID:fromeName];

        [self IMServicedidReceiveMessage:body from:fromeName];
        
        // 不能载这里写。
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
        {
            
        }
        else
        {
            // We are not active, so use a local notification instead
            //用户本地推送
            //            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            //            localNotification.alertAction = @"Ok";
            //            localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
            //            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        }
    }
    
    
    
}
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    [SDPrintLog printLog:presence.description WithTag:@"didReceivePresence"];
}

/**
 * This method is called if an XMPP error is received.
 * In other words, a <stream:error/>.
 *
 * However, this method may also be called for any unrecognized xml stanzas.
 *
 * Note that standard errors (<iq type='error'/> for example) are delivered normally,
 * via the other didReceive...: methods.
 **/
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error
{
    [SDPrintLog printLog:@"" WithTag:@"didReceiveError"];
}

/**
 * These methods are called before their respective XML elements are sent over the stream.
 * These methods can be used to customize elements on the fly.
 * (E.g. add standard information for custom protocols.)
 **/
- (void)xmppStream:(XMPPStream *)sender willSendIQ:(XMPPIQ *)iq
{
    [SDPrintLog printLog:@"" WithTag:@"willSendIQ"];
}
- (void)xmppStream:(XMPPStream *)sender willSendMessage:(XMPPMessage *)message
{
    [SDPrintLog printLog:@"" WithTag:@"willSendMessage"];
}
- (void)xmppStream:(XMPPStream *)sender willSendPresence:(XMPPPresence *)presence
{
    [SDPrintLog printLog:@"" WithTag:@"willSendPresence"];
}

/**
 * These methods are called after their respective XML elements are sent over the stream.
 * These methods may be used to listen for certain events (such as an unavailable presence having been sent),
 * or for general logging purposes. (E.g. a central history logging mechanism).
 **/
- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq
{
    
    [SDPrintLog printLog:@"" WithTag:@"didSendIQ"];
}
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    NSString *body = [[message elementForName:@"body"] stringValue];
    XMPPJID * fromjid = [message from];
    NSString * fromeName = fromjid.user;
    [SDPrintLog printLog:[NSString stringWithFormat:@"%@--->%@",fromeName,body] WithTag:@"didSendMessage"];
    [self IMServicedidSendMessage:body to:fromeName];
    
    [self.chatManager saveChatContent:body friengID:fromeName chatID:fromeName];
}
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence
{
    [SDPrintLog printLog:presence.description WithTag:@"didSendPresence"];
}

/**
 * This method is called if the disconnect method is called.
 * It may be used to determine if a disconnection was purposeful, or due to an error.
 **/
- (void)xmppStreamWasToldToDisconnect:(XMPPStream *)sender
{
    [SDPrintLog printLog:@"" WithTag:@"xmppStreamWasToldToDisconnect"];
}

/**
 * This method is called after the stream is closed.
 *
 * The given error parameter will be non-nil if the error was due to something outside the general xmpp realm.
 * Some examples:
 * - The TCP socket was unexpectedly disconnected.
 * - The SRV resolution of the domain failed.
 * - Error parsing xml sent from server.
 **/
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    [SDPrintLog printLog:@"" WithTag:@"xmppStreamDidDisconnect"];
}

/**
 * This method is only used in P2P mode when the connectTo:withAddress: method was used.
 *
 * It allows the delegate to read the <stream:features/> element if/when they arrive.
 * Recall that the XEP specifies that <stream:features/> SHOULD be sent.
 **/
- (void)xmppStream:(XMPPStream *)sender didReceiveP2PFeatures:(NSXMLElement *)streamFeatures
{
    [SDPrintLog printLog:@"" WithTag:@"didReceiveP2PFeatures"];
}

/**
 * This method is only used in P2P mode when the connectTo:withSocket: method was used.
 *
 * It allows the delegate to customize the <stream:features/> element,
 * adding any specific featues the delegate might support.
 **/
- (void)xmppStream:(XMPPStream *)sender willSendP2PFeatures:(NSXMLElement *)streamFeatures
{
    [SDPrintLog printLog:streamFeatures.description WithTag:@"willSendP2PFeatures"];
}

/**
 * These methods are called as xmpp modules are registered and unregistered with the stream.
 * This generally corresponds to xmpp modules being initailzed and deallocated.
 *
 * The methods may be useful, for example, if a more precise auto delegation mechanism is needed
 * than what is available with the autoAddDelegate:toModulesOfClass: method.
 **/
- (void)xmppStream:(XMPPStream *)sender didRegisterModule:(id)module
{
    [SDPrintLog printLog:@"" WithTag:@"didRegisterModule"];
}
//- (void)xmppStream:(XMPPStream *)sender willUnregisterModule:(id)module
//{
//    [SDPrintLog printLog:@"" WithTag:@"willUnregisterModule"];
//}
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    [SDPrintLog printLog:presence.description WithTag:@"didReceivePresenceSubscriptionRequest"];
    [self IMServicedidReceivePresenceSubscriptionRequest:presence];
}



@end
