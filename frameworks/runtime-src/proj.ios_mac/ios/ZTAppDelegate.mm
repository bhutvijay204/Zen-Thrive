//
//  ZTAppDelegate.m
//  Zen Thrive
//
//  Created by Hitesh Mac on 18/05/24.
//

#import "ZTAppDelegate.h"
#import "cocos2d.h"
#import "AppDelegate.h"
#import "ZTSpinVC.h"
#import "SDKWrapper.h"
#import "platform/ios/CCEAGLView-ios.h"
#import "ZTInterface.h"
#import "AppsFlyer.h"
#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>

using namespace cocos2d;
@interface ZTAppDelegate ()

@property(nonatomic, readwrite, strong) ZTSpinVC* spinVC;

@end
@implementation ZTAppDelegate

Application* app = nullptr;
@synthesize window;
UIViewController* g_view_controller;
std::string g_deep_link_url = "";
std::string g_push_token = "";
int currScreenOrientation = UIInterfaceOrientationMaskLandscapeRight;
ZTAppDelegate* g_app_controller;
UIImageView* g_splash_image;
#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[SDKWrapper getInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    // Add the view controller's view to the window and display.
    float scale = [[UIScreen mainScreen] scale];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    window = [[UIWindow alloc] initWithFrame: bounds];
    [self Defaults];
    // cocos2d application instance
    app = new AppDelegate(bounds.size.width * scale, bounds.size.height * scale);
    app->setMultitouch(true);
    
    // Use RootViewController to manage CCEAGLView
    self.spinVC = [[ZTSpinVC alloc]init];
    self.spinVC.automaticallyAdjustsScrollViewInsets = NO;
    self.spinVC.extendedLayoutIncludesOpaqueBars = NO;
    self.spinVC.edgesForExtendedLayout = UIRectEdgeAll;
    [window setRootViewController:self.spinVC];
    [window makeKeyAndVisible];
        
    //run the cocos2d-x game scene
    app->start();
    
    g_view_controller = _spinVC;
    g_app_controller = self;
    [AppsFlyer init];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [[FBSDKSettings sharedSettings] setAutoLogAppEventsEnabled:true];
    [[FBSDKSettings sharedSettings] setAdvertiserTrackingEnabled:true];
    [[FBSDKSettings sharedSettings] setAdvertiserIDCollectionEnabled:true];
    [ZTInterface boyaaShowSplash:@"str"];
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *) options {
    [AppsFlyer handleOpenUrl:url options:options];
    [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url options:options];
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return currScreenOrientation;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    [AppsFlyer continueUserActivity:userActivity restorationHandler:restorationHandler];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [AppsFlyer handlePushNotification:userInfo];
}

-(void)Defaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [dict objectForKey:@"CFBundleShortVersionString"];
    
    NSString* isFirstLaunch = [defaults objectForKey:[NSString stringWithFormat:@"%@%@",@"FirstLaunch",appVersion]];
    if(isFirstLaunch == nil || [isFirstLaunch isEqualToString:@"true"]){
        std::string strFilePath = cocos2d::FileUtils::getInstance()->getWritablePath();
        strFilePath += "/galaxy-remote-asset";
        [ZTInterface deleteFolder:[NSString stringWithUTF8String:strFilePath.c_str()]];
        [defaults setObject:@"false" forKey:[NSString stringWithFormat:@"%@%@",@"FirstLaunch",appVersion]];
    }
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    NSMutableString *valueString = [NSMutableString string];
    const void *tokenBytes = deviceToken.bytes;
    const char* kkk = (char*)tokenBytes;
    NSInteger count = deviceToken.length;
    for (int i = 0; i < count; i++) {
        [valueString appendFormat:@"%02x", kkk[i]&0x000000FF];
    }
    g_push_token = [valueString UTF8String];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error:(NSData *)deviceToken {
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    app->onPause();
    [[SDKWrapper getInstance] applicationWillResignActive:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    app->onResume();
    [[SDKWrapper getInstance] applicationDidBecomeActive:application];
    [[FBSDKAppEvents shared] activateApp];
    [AppsFlyer start];
    if (@available(iOS 14.0, *)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            }];
        });
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [[SDKWrapper getInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    [[SDKWrapper getInstance] applicationWillEnterForeground:application];    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[SDKWrapper getInstance] applicationWillTerminate:application];
    delete app;
    app = nil;
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

@end
