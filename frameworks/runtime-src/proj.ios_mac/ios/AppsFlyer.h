

#import <Foundation/Foundation.h>
#import <AppsFlyerLib/AppsFlyerLib.h>
NS_ASSUME_NONNULL_BEGIN

@interface AppsFlyer : NSObject<AppsFlyerLibDelegate,AppsFlyerDeepLinkDelegate>
+ (AppsFlyer *_Nullable)shareInstance;

+(void) init;
+(void) start;

+(void) setCUID:(NSString*_Nullable)cuid;

+(void) handleOpenUrl:(NSURL *_Nullable)url options:(NSDictionary *_Nullable) options;

+(void) continueUserActivity:(NSUserActivity *_Nullable)userActivity restorationHandler:(void (^_Nullable)(NSArray * _Nullable))restorationHandler;

+(void) handlePushNotification:(NSDictionary *_Nullable)userInfo;
@end

NS_ASSUME_NONNULL_END
