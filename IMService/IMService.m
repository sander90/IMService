//
//  IMService.m
//  IMService
//
//  Created by shansander on 16/3/13.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "IMService.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

#import <CFNetwork/CFNetwork.h>

#import "SDPrintLog.h"

@interface IMService ()
{
    
}

@property (nonatomic)NSManagedObjectContext *managedObjectContext_roster;
@property (nonatomic)XMPPCapabilities *xmppCapabilities;
@property (nonatomic)XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic)    XMPPvCardCoreDataStorage *xmppvCardStorage;
@property (nonatomic) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic)NSManagedObjectContext *managedObjectContext_capabilities;



@end


@implementation IMService


+ (IMService *)initIMService
{
    static dispatch_once_t once = 0;
    static IMService * im = nil;
    dispatch_once(&once, ^{
        im = [[IMService alloc] init];
    });
    return im;
}
- (id)init
{
    self = [super init];
    if (self) {
        [self setupStream];
    }
    return self;
}

#pragma mark - 初始化
- (void)setupStream
{
    _xmppStream = [[XMPPStream alloc] init];
    
    _xmppReconnect = [[XMPPReconnect alloc] init];
    
    _xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterStorage];
    self.xmppRoster.autoFetchRoster = YES;
    self.xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    
//    _xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
//    _xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:self.xmppvCardStorage];
//    
//    _xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:self.xmppvCardTempModule];
//    
//    _xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
//    _xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:self.xmppCapabilitiesStorage];
//    _xmppCapabilities.autoFetchHashedCapabilities = YES;
//    _xmppCapabilities.autoFetchNonHashedCapabilities = NO;
//    
//    // Activate xmpp modules
//    
//    [_xmppReconnect         activate:self.xmppStream];
//    [_xmppRoster            activate:self.xmppStream];
//    [_xmppvCardTempModule   activate:self.xmppStream];
//    [_xmppvCardAvatarModule activate:self.xmppStream];
//    [_xmppCapabilities      activate:self.xmppStream];
    
    // Add ourself as a delegate to anything we may be interested in
    
//    [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)setStreamHoatName:(NSString * )hostname andHostPort:(UInt16)newHostPort
{
    self.xmppStream.hostName = hostname;
    self.xmppStream.hostPort = newHostPort;
}

- (void)sendMessageContent:(NSString * )content
{
    XMPPJID * toFriend = [XMPPJID jidWithString:@"sander1@117.158.46.13"];
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:content];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[toFriend full]];
    [message addChild:body];
    
    [_xmppStream sendElement:message];
}

- (NSManagedObjectContext *)managedObjectContext_roster
{
    NSAssert([NSThread isMainThread],
             @"NSManagedObjectContext is not thread safe. It must always be used on the same thread/queue");
    
    if (_managedObjectContext_roster == nil)
    {
        _managedObjectContext_roster = [[NSManagedObjectContext alloc] init];
        
        NSPersistentStoreCoordinator *psc = [self.xmppRosterStorage persistentStoreCoordinator];
        [_managedObjectContext_roster setPersistentStoreCoordinator:psc];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];
    }
    
    return _managedObjectContext_roster;
}

- (void)contextDidSave:(NSNotification *)notification
{
    NSManagedObjectContext *sender = (NSManagedObjectContext *)[notification object];
    
    if (sender != self.managedObjectContext_roster &&
        [sender persistentStoreCoordinator] == [self.managedObjectContext_roster persistentStoreCoordinator])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.managedObjectContext_roster mergeChangesFromContextDidSaveNotification:notification];
        });
    }
    
    if (sender !=self.managedObjectContext_capabilities &&
        [sender persistentStoreCoordinator] == [self.managedObjectContext_capabilities persistentStoreCoordinator])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.managedObjectContext_capabilities mergeChangesFromContextDidSaveNotification:notification];
        });
    }
}

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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(IMServiceDidConnect)]) {
        [self.delegate IMServiceDidConnect];
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
    //登录成功
    if (self.delegate && [self.delegate respondsToSelector:@selector(IMServiceDidAuthenticate)]) {
        [self.delegate IMServiceDidAuthenticate];
    }
}

/**
 * This method is called if authentication fails.
 **/
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    [SDPrintLog printLog:@"" WithTag:@"didNotAuthenticate"];
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
    [SDPrintLog printLog:@"" WithTag:@"didReceiveIQ"];
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
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(IMServicedidReceiveMessage:from:)]) {
            [self.delegate IMServicedidReceiveMessage:body from:fromeName];
        }
        
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
    [SDPrintLog printLog:@"" WithTag:@"didReceivePresence"];
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
    [SDPrintLog printLog:@"" WithTag:@"didSendMessage"];
    
}
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence
{
    [SDPrintLog printLog:@"" WithTag:@"didSendPresence"];
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
    [SDPrintLog printLog:@"" WithTag:@"willSendP2PFeatures"];
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
- (void)xmppStream:(XMPPStream *)sender willUnregisterModule:(id)module
{
    [SDPrintLog printLog:@"" WithTag:@"willUnregisterModule"];
}
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    [SDPrintLog printLog:@"" WithTag:@"didReceivePresenceSubscriptionRequest"];
}
@end
