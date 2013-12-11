//
//  NSWindow+Blur.m
//  RSTransparentPlugin
//
//  Created by Closure on 12/9/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import "NSWindow+Blur.h"
@interface NSWindow ()
- (void)setBottomCornerRounded:(BOOL)flag;

@end

typedef int CGSConnectionID;
static const CGSConnectionID kCGSNullConnectionID = 0;
typedef NSUInteger CGSWindowID;


/*! DOCUMENTATION PENDING - verify this is Leopard only! */
CG_EXTERN CGError CGSSetLoginwindowConnection(CGSConnectionID cid) AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;
CG_EXTERN CGError CGSSetLoginwindowConnectionWithOptions(CGSConnectionID cid, CFDictionaryRef options) AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;

/*! Enables or disables updates on a connection. The WindowServer will forcibly reenable updates after 1 second. */
CG_EXTERN CGError CGSDisableUpdate(CGSConnectionID cid);
CG_EXTERN CGError CGSReenableUpdate(CGSConnectionID cid);

/*! Is there a menubar associated with this connection? */
CG_EXTERN bool CGSMenuBarExists(CGSConnectionID cid);



#pragma mark notifications
/*! Registers or removes a function to get notified when a connection is created. Only gets notified for connections created in the current application. */
typedef void (*CGSNewConnectionNotificationProc)(CGSConnectionID cid);
CG_EXTERN CGError CGSRegisterForNewConnectionNotification(CGSNewConnectionNotificationProc proc);
CG_EXTERN CGError CGSRemoveNewConnectionNotification(CGSNewConnectionNotificationProc proc);

/*! Registers or removes a function to get notified when a connection is released. Only gets notified for connections created in the current application. */
typedef void (*CGSConnectionDeathNotificationProc)(CGSConnectionID cid);
CG_EXTERN CGError CGSRegisterForConnectionDeathNotification(CGSConnectionDeathNotificationProc proc);
CG_EXTERN CGError CGSRemoveConnectionDeathNotification(CGSConnectionDeathNotificationProc proc);

/*! Creates a new connection to the window server. */
CG_EXTERN CGError CGSNewConnection(int unused, CGSConnectionID *outConnection);

/*! Releases a CGSConnection and all CGSWindows owned by it. */
CG_EXTERN CGError CGSReleaseConnection(CGSConnectionID cid);

/*! Gets the default connection for this process. `CGSMainConnectionID` is just a more modern name. */
CG_EXTERN CGSConnectionID _CGSDefaultConnection(void);
CG_EXTERN CGSConnectionID CGSMainConnectionID(void);

/*! Gets the default connection for the current thread. */
CG_EXTERN CGSConnectionID CGSDefaultConnectionForThread(void);

/* Gets the `pid` that owns this CGSConnection. */
CG_EXTERN CGError CGSConnectionGetPID(CGSConnectionID cid, pid_t *outPID);

/*! Gets the CGSConnection for the PSN. */
CG_EXTERN CGError CGSGetConnectionIDForPSN(CGSConnectionID cid, const ProcessSerialNumber *psn, CGSConnectionID *outOwnerCID);

/*! Gets and sets a connection's property. */
CG_EXTERN CGError CGSGetConnectionProperty(CGSConnectionID cid, CGSConnectionID targetCID, CFStringRef key, CFTypeRef *outValue);
CG_EXTERN CGError CGSSetConnectionProperty(CGSConnectionID cid, CGSConnectionID targetCID, CFStringRef key, CFTypeRef value);

/*! Closes ALL connections used by the current application. Essentially, it turns it into a console application. */
CG_EXTERN CGError CGSShutdownServerConnections(void);

/*! Only the owner of a window can manipulate it. So, Apple has the concept of a universal owner that owns all windows and can manipulate them all. There can only be one universal owner at a time (the Dock). */
CG_EXTERN CGError CGSSetUniversalOwner(CGSConnectionID cid);

/*! Sets a connection to be a universal owner. This call requires `cid` be a universal connection. */
CG_EXTERN CGError CGSSetOtherUniversalConnection(CGSConnectionID cid, CGSConnectionID otherConnection);


/*! DOCUMENTATION PENDING - verify this is Leopard only! */
CG_EXTERN CGError CGSSetLoginwindowConnection(CGSConnectionID cid) AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;
CG_EXTERN CGError CGSSetLoginwindowConnectionWithOptions(CGSConnectionID cid, CFDictionaryRef options) AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;

/*! Enables or disables updates on a connection. The WindowServer will forcibly reenable updates after 1 second. */
CG_EXTERN CGError CGSDisableUpdate(CGSConnectionID cid);
CG_EXTERN CGError CGSReenableUpdate(CGSConnectionID cid);

/*! Is there a menubar associated with this connection? */
CG_EXTERN bool CGSMenuBarExists(CGSConnectionID cid);



#pragma mark notifications
/*! Registers or removes a function to get notified when a connection is created. Only gets notified for connections created in the current application. */
//typedef void (*CGSNewConnectionNotificationProc)(CGSConnectionID cid);
CG_EXTERN CGError CGSRegisterForNewConnectionNotification(CGSNewConnectionNotificationProc proc);
CG_EXTERN CGError CGSRemoveNewConnectionNotification(CGSNewConnectionNotificationProc proc);

/*! Registers or removes a function to get notified when a connection is released. Only gets notified for connections created in the current application. */
//typedef void (*CGSConnectionDeathNotificationProc)(CGSConnectionID cid);
CG_EXTERN CGError CGSRegisterForConnectionDeathNotification(CGSConnectionDeathNotificationProc proc);
CG_EXTERN CGError CGSRemoveConnectionDeathNotification(CGSConnectionDeathNotificationProc proc);

/*! Creates a new connection to the window server. */
CG_EXTERN CGError CGSNewConnection(int unused, CGSConnectionID *outConnection);

/*! Releases a CGSConnection and all CGSWindows owned by it. */
CG_EXTERN CGError CGSReleaseConnection(CGSConnectionID cid);

/*! Gets the default connection for this process. `CGSMainConnectionID` is just a more modern name. */
CG_EXTERN CGSConnectionID _CGSDefaultConnection(void);
CG_EXTERN CGSConnectionID CGSMainConnectionID(void);

/*! Gets the default connection for the current thread. */
CG_EXTERN CGSConnectionID CGSDefaultConnectionForThread(void);

/* Gets the `pid` that owns this CGSConnection. */
CG_EXTERN CGError CGSConnectionGetPID(CGSConnectionID cid, pid_t *outPID);

/*! Gets the CGSConnection for the PSN. */
CG_EXTERN CGError CGSGetConnectionIDForPSN(CGSConnectionID cid, const ProcessSerialNumber *psn, CGSConnectionID *outOwnerCID);

/*! Gets and sets a connection's property. */
CG_EXTERN CGError CGSGetConnectionProperty(CGSConnectionID cid, CGSConnectionID targetCID, CFStringRef key, CFTypeRef *outValue);
CG_EXTERN CGError CGSSetConnectionProperty(CGSConnectionID cid, CGSConnectionID targetCID, CFStringRef key, CFTypeRef value);

/*! Closes ALL connections used by the current application. Essentially, it turns it into a console application. */
CG_EXTERN CGError CGSShutdownServerConnections(void);

/*! Only the owner of a window can manipulate it. So, Apple has the concept of a universal owner that owns all windows and can manipulate them all. There can only be one universal owner at a time (the Dock). */
CG_EXTERN CGError CGSSetUniversalOwner(CGSConnectionID cid);

/*! Sets a connection to be a universal owner. This call requires `cid` be a universal connection. */
CG_EXTERN CGError CGSSetOtherUniversalConnection(CGSConnectionID cid, CGSConnectionID otherConnection);

CG_EXTERN CGError CGSSetWindowBackgroundBlurRadius(CGSConnectionID cid, CGSWindowID wid, NSUInteger blur);

@implementation NSWindow (Blur)
+ (void)load {
    NSLog(@"%@ - %@", [self class], NSStringFromSelector(_cmd));
}
static void *GetFunctionByName(NSString *library, char *func) {
    CFBundleRef bundle;
    CFURLRef bundleURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef) library, kCFURLPOSIXPathStyle, true);
    CFStringRef functionName = CFStringCreateWithCString(kCFAllocatorDefault, func, kCFStringEncodingASCII);
    bundle = CFBundleCreate(kCFAllocatorDefault, bundleURL);
    void *f = NULL;
    if (bundle) {
        f = CFBundleGetFunctionPointerForName(bundle, functionName);
        CFRelease(bundle);
    }
    CFRelease(functionName);
    CFRelease(bundleURL);
    return f;
}

typedef CGError CGSSetWindowBackgroundBlurRadiusFunction(CGSConnectionID cid, CGSWindowID wid, NSUInteger blur);
CGSSetWindowBackgroundBlurRadiusFunction* GetCGSSetWindowBackgroundBlurRadiusFunction(void);
CGSSetWindowBackgroundBlurRadiusFunction* GetCGSSetWindowBackgroundBlurRadiusFunction(void) {
    static BOOL tried = NO;
    static CGSSetWindowBackgroundBlurRadiusFunction *function = NULL;
    if (!tried) {
        function  = GetFunctionByName(@"/System/Library/Frameworks/ApplicationServices.framework",
                                      "CGSSetWindowBackgroundBlurRadius");
        tried = YES;
    }
    return function;
}

- (void)enableBlur:(CGFloat)radius
{
#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_4
    // Only works in Leopard (or hopefully later)
    
    CGSConnectionID con = CGSMainConnectionID();
    if (!con) {
        return;
    }
    // If CGSSetWindowBackgroundBlurRadius() is available (10.6 and up) use it because it works
    // right in Exposé.
    CGSSetWindowBackgroundBlurRadiusFunction* function = GetCGSSetWindowBackgroundBlurRadiusFunction();
    if (function) function(con, [self windowNumber], (int)radius);
#endif
}

- (void)prepareForBlur
{
    [self setCollectionBehavior:0x80];
    [self setBottomCornerRounded:0];
    [self setAlphaValue:0.9999];
}

@end
