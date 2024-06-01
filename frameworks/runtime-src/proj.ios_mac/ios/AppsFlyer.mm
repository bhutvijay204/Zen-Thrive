
#import "AppsFlyer.h"
#import "ZTInterface.h"

@implementation AppsFlyer
NSString* g_appflyer_source = @"none";
NSString* g_appflyer_deepLink = @"none";
BOOL g_appflyer_enabled = YES;

static AppsFlyer * instance;

+ (AppsFlyer *) shareInstance {
    @synchronized(self) {
        if (!instance)
            instance=[[AppsFlyer alloc] init];
    }
    return instance;
}

+(void)init{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@".plist"];
   NSDictionary* properties = [NSDictionary dictionaryWithContentsOfFile:path];
    NSNumber* enabled = [properties objectForKey:@"AppsFlyerEnabled"];
    g_appflyer_enabled = [enabled boolValue];
    if(!g_appflyer_enabled){
        return;
    }
    
   if (properties == nil || path == nil) {
       [NSException raise:@"Error" format:@"Cannot find .plist file"];
   }
   NSString* appsFlyerDevKey = [properties objectForKey:@"appsFlyerDevKey"];
   NSString* appleAppID = [properties objectForKey:@"appleAppID"];

   if (appsFlyerDevKey == nil || appleAppID == nil) {
       [NSException raise:@"Error" format:@"Cannot find appsFlyerDevKey or appleAppID"];
   }

    [[AppsFlyerLib shared] setAppsFlyerDevKey:appsFlyerDevKey];
    [[AppsFlyerLib shared] setAppleAppID:appleAppID];
    [[AppsFlyerLib shared] setDeepLinkDelegate:[AppsFlyer shareInstance]];
    [[AppsFlyerLib shared] setDelegate:[AppsFlyer shareInstance]];
}

+(void) setCUID:(NSString*)cuid{
    
    if(!g_appflyer_enabled){
        return;
    }
    
    [AppsFlyerLib shared].customerUserID = cuid;

}


+(void) start{
    
//    [[AppsFlyerLib shared] start];
    if(!g_appflyer_enabled){
        return;
    }
    [[AppsFlyerLib shared] startWithCompletionHandler:^(NSDictionary<NSString *,id> *dictionary, NSError *error) {
            if (error) {
                [ZTInterface setInstallSource:@"error"];
                return;
            }
            if (dictionary) {
                return;
            }
        }];

}

+(void) handleOpenUrl:(NSURL *)url options:(NSDictionary *) options{

    if(!g_appflyer_enabled){
        return;
    }
    [[AppsFlyerLib shared] handleOpenUrl:url options:options];

}

+(void) continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
    if(!g_appflyer_enabled){
        return;
    }
    [[AppsFlyerLib shared] continueUserActivity:userActivity restorationHandler:restorationHandler];
    
}

+(void) handlePushNotification:(NSDictionary *)userInfo{

    if(!g_appflyer_enabled){
        return;
    }
    [[AppsFlyerLib shared] handlePushNotification:userInfo];
    
}

-(void)onConversionDataSuccess:(NSDictionary*) installData {
    id status = [installData objectForKey:@"af_status"];
    if([status isEqualToString:@"Non-organic"]) {
        id sourceID = [installData objectForKey:@"media_source"];
        id campaign = [installData objectForKey:@"campaign"];
        g_appflyer_source = [sourceID description];
    } else if([status isEqualToString:@"Organic"]) {
        g_appflyer_source = [status description];
    }
    [ZTInterface setInstallSource:g_appflyer_source];
}

-(void)onConversionDataFail:(NSError *) error {
    NSLog(@"%@",error);
}

//Handle Direct Deep Link
- (void) onAppOpenAttribution:(NSDictionary*) attributionData {
    NSLog(@"%@",attributionData);
}

- (void) onAppOpenAttributionFailure:(NSError *)error {
    NSLog(@"%@",error);
}

- (void)didResolveDeepLink:(AppsFlyerDeepLinkResult *)result{
    switch (result.status) {
        case AFSDKDeepLinkResultStatusNotFound:
            NSLog(@"%@",@"[AFSDK] Deep link not found");
            return ;
        case AFSDKDeepLinkResultStatusFailure:
            NSLog(@"Error %@", result.error.description);
            return;
        default:
            NSLog(@"%@",@"[AFSDK] Deep link found");
            break;
    }
    
    AppsFlyerDeepLink* deepLinkObj = result.deepLink;
    if( deepLinkObj.isDeferred == true) {
    }
    else {
    }
    
    NSString* deepLink = deepLinkObj.description;
    
    NSData *data = [deepLink dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];

    g_appflyer_deepLink = base64String;
    

    [ZTInterface setLaunchAttrs:g_appflyer_deepLink];
}

@end
