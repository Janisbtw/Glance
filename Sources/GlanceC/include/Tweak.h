#include <CoreFoundation/CFNotificationCenter.h>
#include <Foundation/Foundation.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSUUID.h>
#include <UIKit/UIApplication.h>
#include <UIKit/UIImage.h>
#include <UIKit/UIKit.h>
#include <UIKit/UIDevice.h>
#include <UIKit/UIDevice+Private.h>
#include <UIKit/UIViewController.h>
#include <RemoteLog.h>
#include <BulletinBoard/BBBulletin.h>
#include <BulletinBoard/BBServer.h>
#include <SpringBoard/SpringBoard.h>
#include <SpringBoard/SBIconController.h>
#include <SpringBoard/SBUserAgent.h>
#include <SpringBoard/SBLockScreenManager.h>
#include <SpringBoard/SBLockScreenView.h>
#include <SpringBoard/SBIconView.h>
#include <SpringBoard/SBIconModel.h>
#include <SpringBoard/SBIcon.h>
#include <SpringBoard/SBApplicationController.h>
#include <SpringBoard/SBApplication.h>
#include <AltList/LSApplicationProxy+AltList.h>
#include <MobileCoreServices/LSApplicationProxy.h>
#include <MobileCoreServices/LSApplicationWorkspace.h>
#include <UIKit/UIWindow.h>
#include <UserNotificationsKit/NCNotificationRequest.h>
#include <Contacts/CNContactStore.h>
#include <SpringBoard/SBOrientationLockManager.h>
#include <objc/NSObject.h>

#ifndef DEBUG
#define DEBUG 1
#endif

@interface SBDisplayBrightnessController: NSObject
-(void) noteValueUpdatesWillBegin;
-(void) setBrightnessLevel:(float)brightness animated:(BOOL)animated;
-(void) noteValueUpdatesDidEnd;
@end

@interface NCBulletinNotificationSource
-(void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned long long)arg3 playLightsAndSirens:(BOOL)arg4 withReply:(/*^block*/id)arg5 ;
@end

@interface NCNotificationOptions

@end

@interface BBObserver

@end

@interface SpringBoard()
-(void)_turnScreenOnOnDashBoardWithCompletion:(/*^block*/id)arg1 ;
@end

@interface UIDevice()
-(void)setOrientation:(long long)arg1 animated:(BOOL)arg2 ;
@end

@interface SBOrientationLockManager()
-(void)lock;
-(void)unlock;
-(void)setLockOverrideEnabled:(BOOL)arg1 forReason:(id)arg2 ;
-(void)_removeLockOverrideReason:(id)arg1 ;
-(void)enableLockOverrideForReason:(id)arg1 forceOrientation:(long long)arg2 ;
@end

@interface CPDistributedNotificationCenter : NSObject
+(CPDistributedNotificationCenter*)centerNamed:(NSString*)centerName;
-(void)runServer;
-(void)postNotificationName:(id)arg1 userInfo:(id)arg2 ;
@end

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

@interface DNDModeConfiguration
@end

@interface _FCActivity
-(NSUUID*) activityUniqueIdentifier;
-(NSString*) activityDisplayName;
@end

@interface FCActivityManager
// iOS x >= 15.2 +
+(FCActivityManager*) sharedActivityManager;

// iOS 15.0 <= x < 15.2
+(id)newActivityManager;
+(id)newActivityManagerWithIdentifier:(id)arg0 ;
+(void)initialize;
-(id)_initWithIdentifier:(id)arg0 ;

-(NSArray<_FCActivity*>*) _availableActivities;

// null when no focus is active
-(_FCActivity *_Nullable) activeActivity;
@end

@interface SBCoverSheetWindow : UIWindow

@end

@interface SBWindow : UIWindow
-(id)initWithWindowScene:(id)arg1 rootViewController:(id)arg2 layoutStrategy:(id)arg3 role:(id)arg4 debugName:(id)arg5 ;
@end

@interface SBDoNotDisturbStateMonitor
-(void)_noteNewDNDState:(id)arg1 ;
@end

@interface DNDMode
-(NSUUID*) identifier;
@end

@interface DNDStateService
-(BOOL)addStateUpdateListener:(id)arg1 error:(id*)arg2 ;
-(void)addStateUpdateListener:(id)arg1 withCompletionHandler:(/*^block*/id)arg2 ;
@end

@interface DNDMutableModeConfiguration
-(DNDMode*) mode;
@end

@interface DNDState
-(id)initWithSuppressionState:(unsigned long long)arg1 activeModeAssertionMetadata:(id)arg2 startDate:(id)arg3 userVisibleTransitionDate:(id)arg4 userVisibleTransitionLifetimeType:(unsigned long long)arg5 activeModeConfiguration:(id)arg6 ;
-(NSString *)activeModeIdentifier;
-(BOOL)isActive;
-(DNDMutableModeConfiguration*) activeModeConfiguration;
@end

@protocol CMWakeGestureDelegate <NSObject>
@optional
-(void)wakeGestureManager:(id)arg1 didUpdateWakeGesture:(long long)arg2;
-(void)wakeGestureManager:(id)arg1 didUpdateWakeGesture:(long long)arg2 orientation:(int)arg3;
@end

@class CSEvent;
@interface CSEvent : NSObject
+(id)eventWithType:(long long)arg1 ;
-(void)setType:(long long)arg1 ;
-(void)setValue:(NSNumber *)arg1 ;
-(id)succinctDescription;
-(NSNumber *)value;
-(BOOL)isConsumable;
-(void)setConsumable:(BOOL)arg1 ;
-(id)description;
-(long long)type;
-(void)setStateless:(BOOL)arg1 ;
-(id)descriptionBuilderWithMultilinePrefix:(id)arg1 ;
-(id)succinctDescriptionBuilder;
-(id)descriptionWithMultilinePrefix:(id)arg1 ;
-(BOOL)isStateless;
@end

@interface SBLiftToWakeController: NSObject<CMWakeGestureDelegate>
-(void)addObserver:(id)arg1 ;
-(void)_startObservingIfNecessary;
-(BOOL)_isObservingWakeGestureManager;
-(void)_stopObservingIfNecessary;
@end

@interface SBLiftToWakeManager: NSObject
-(BOOL)_gestureWokeScreen;
-(BOOL)handleEvent:(id)arg1 ;
@end

@interface  CMWakeGestureManager : NSObject
-(void)forceDetected;
@end

@interface LSApplicationProxy()
+(id) applicationProxyForIdentifier:(id)arg1 placeholder:(BOOL)arg2;
@end

@interface SBUserAgent()
-(void)lockAndDimDevice;
@end

@interface SBDashBoardIdleTimerProvider: NSObject
@end

@interface UIStatusBarWindow: UIWindow
-(void)setStatusBar:(id)arg1;
@end


@interface SBDashBoardIdleTimerController
-(void)setIdleTimerCoordinator:(id) arg1 ;
-(void)idleTimerDidExpire:(SBDashBoardIdleTimerProvider*)arg1 ;
-(void)addIdleTimerDisabledAssertionReason:(id)arg1 ;
-(void)removeIdleTimerDisabledAssertionReason:(id)arg1 ;
@end

@interface SBLockScreenManager()
-(void)tapToWakeControllerDidRecognizeWakeGesture:(id)arg1 ;
-(id)_tapToWakeController;
@end

@interface UIImage (Private)
+ (instancetype)_applicationIconImageForBundleIdentifier:(NSString*)bundleIdentifier format:(int)format scale:(CGFloat)scale;
@end

@interface UIViewController (Private)
- (BOOL)_canShowWhileLocked;
@end

@interface BBServer()
-(id) initWithQueue:(id)arg1;
// -(void) publishBulletin:(id)arg1 destinations:(unsigned long long)arg2;
@end

@interface BBBulletin()
-(BOOL)isCallNotification;
@end