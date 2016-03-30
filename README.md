#IMService
**添加链接库**

libresolv.tbd

libxml2.tbd

CoreData.framework

CoreGraphics.framework

CFNetwork.framework

**使用**

```objective-c
#import <IMService/AbstractXMPPConnection.h>
```

连接登录

```objective-c
AbstractXMPPConnection* connect = [[AbstractXMPPConnection alloc] initWithName:@"sander" andPassword:@"123456" andServiceName:hostname];
[connect setDelegate:self];
[connect connect];
```

