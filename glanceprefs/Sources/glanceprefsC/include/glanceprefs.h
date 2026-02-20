#include <UIKit/UIKit.h>
#include <RemoteLog.h>
#include <Foundation/NSArray.h>
#include <CoreFoundation/CoreFoundation.h>
#include <UIKit/UIImage.h>

@interface CPDistributedNotificationCenter : NSObject
+(CPDistributedNotificationCenter*)centerNamed:(NSString*)centerName;
-(void)startDeliveringNotificationsToMainThread;
-(void)stopDeliveringNotifications;
@end

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

@interface _FCActivity
-(id) activityUniqueIdentifier;
-(id) activityDisplayName;
-(id)initWithMode:(id)arg1 ;
@end

@interface FSUIFocusActivationManager
-(void)modeSelectionService:(id)arg1 didReceiveAvailableModesUpdate:(id)arg2 ;
@end

@interface FCActivityManager
+(FCActivityManager*) sharedActivityManager;
-(NSArray<_FCActivity*>*) _availableActivities;
-(id) identifier;
@end

@interface FSUICopyDisplayIdentifiers : NSObject
+(id)displayIdentifiers;
@end

@interface UIImage (Private)
+ (instancetype)_applicationIconImageForBundleIdentifier:(NSString*)bundleIdentifier format:(int)format scale:(CGFloat)scale;
@end