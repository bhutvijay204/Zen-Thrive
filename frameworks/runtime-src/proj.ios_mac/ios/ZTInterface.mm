#import <Foundation/Foundation.h>
#include "ZTInterface.h"
#import "SAMKeychain.h"
#include "ZTUtils.h"
#include <AdSupport/AdSupport.h>
#import "cocos/scripting/js-bindings/jswrapper/SeApi.h"
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AppTrackingTransparency/ATTrackingManager.h>
#import <UserNotifications/UNUserNotificationCenter.h>
#import "AppDelegate.h"
#import "AFNetworkReachabilityManager.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "GameLoader.h"
#import "AppsFlyer.h"
#import <Masonry/Masonry.h>

extern std::string g_push_token;
extern std::string g_deep_link_url;
extern UIImage* g_screenshot_image;
extern UIViewController* g_view_controller;
extern AppDelegate* g_app_controller;
extern int currScreenOrientation;
extern UIImageView* g_splash_image;
extern NSString* g_appflyer_source;
extern BOOL g_appflyer_enabled;

@implementation ZTInterface

+(void)boyaaShowSplash:(NSString*)s1
{
    g_splash_image = [[UIImageView alloc] init];
    g_splash_image.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *image = [UIImage imageNamed:@"ZenThrive.bundle/background.png"];
    [g_splash_image setImage:image];
    [g_view_controller.view addSubview:g_splash_image];
    [g_splash_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

+(void)boyaaHideSplash:(NSString*)s1
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        if(g_splash_image != nil){
            [g_splash_image removeFromSuperview];
        }
    });
}

+(void)boyaaGetAppID:(NSString*)s1
{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *appID = [dict objectForKey:@"Bundle appid"];
    if(!appID){
        NSLog(@"app id is not set ,user default 6503437381");
        appID = @"6503437381";
    }
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').boyaaSetAppID(\"%@\");",[NSString stringWithFormat:@"%@",appID]];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
}


+(void)boyaaGetAppVersion:(NSString*)s1
{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [dict objectForKey:@"CFBundleShortVersionString"];
    if(!appVersion){
        appVersion = @"1.0.3";
    }
    appVersion = @"1.8.0";
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').boyaaSetAppVersion(\"%@\");",[NSString stringWithFormat:@"%@",appVersion]];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
    
}


+(void)boyaaGetSysVersion:(NSString*)s1
{
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').boyaaSetSystemVersion(\"%@\");",[NSString stringWithFormat:@"%@",sysVersion]];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
    
}

+(void)boyaaGetDeviceID:(NSString*)s1
{
    NSString* pass = [[NSBundle mainBundle] bundleIdentifier];
    NSString* acc = @"6503437381";
    NSString* strUUID = [SAMKeychain passwordForService:pass account:acc];
    if([strUUID isEqualToString:@""]|| !strUUID)
    {
        strUUID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
        if(strUUID.length ==0 || [strUUID isEqualToString:@"00000000-0000-0000-0000-000000000000"])
        {
            CFUUIDRef uuidRef= CFUUIDCreate(kCFAllocatorDefault);
            strUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault,uuidRef));
            CFRelease(uuidRef);
        }
        
        [SAMKeychain setPassword:strUUID forService:pass account:acc];
    }
    
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').boyaaSetDevId(\"%@\");",strUUID];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
}


+(void)boyaaGetDeviceInfo:(NSString*)s1
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    NSString* deviceInfo = [NSString stringWithFormat:@"%@|%@",platform,phoneVersion];
    
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').boyaaSetDeviceInfo(\"%@\");",[NSString stringWithFormat:@"%@",deviceInfo]];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
}

+(void)boyaaGetTimeZone:(NSString*)s1
{
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    NSInteger seconds = [zone secondsFromGMT];
    
    NSInteger timezone = seconds/3600;
    
   
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').boyaaSetTimeZone(\"%@\");",[NSString stringWithFormat:@"%ld",timezone]];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
}

+(void)boyaaGetDeviceTime:(NSString*)s1
{
    //获得系统时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HHmm"];
    NSString * locationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"device time = %@",locationString);
   
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').boyaaSetLocalTime(\"%@\");",[NSString stringWithFormat:@"%@",locationString]];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
}

+(void)boyaaGetDeviceLanguage:(NSString*)s1
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * local = [allLanguages objectAtIndex:0];
    NSLog(@"language = %@",local);
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').boyaaSetLocalLanguage(\"%@\");",[NSString stringWithFormat:@"%@",local]];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
}

+(void)boyaaSetScreenOrentation:(NSNumber*)s1
{
    int orientation = [s1 intValue];
    NSLog(@"boyaaSetScreenOrentation = %d",orientation);
    if(orientation == 1){
        currScreenOrientation = UIInterfaceOrientationMaskPortrait;
        if (@available(iOS 16.0, *)) {
            [g_view_controller setNeedsUpdateOfSupportedInterfaceOrientations];
             NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
             UIWindowScene *scene = [array firstObject];
             UIInterfaceOrientationMask orientation = UIInterfaceOrientationMaskPortrait;
             UIWindowSceneGeometryPreferencesIOS *geometryPreferencesIOS = [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:orientation];
             [scene requestGeometryUpdateWithPreferences:geometryPreferencesIOS errorHandler:^(NSError * _Nonnull error) {
             }];
        }else{
            if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
                SEL selector = NSSelectorFromString(@"setOrientation:");
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:[UIDevice currentDevice]];
                int val = UIInterfaceOrientationPortrait;
                [invocation setArgument:&val atIndex:2];
                [invocation invoke];
                [UIViewController attemptRotationToDeviceOrientation];
            }
        }
    }
    else{
        currScreenOrientation = UIInterfaceOrientationMaskLandscapeRight;
        if (@available(iOS 16.0, *)) {
            [g_view_controller setNeedsUpdateOfSupportedInterfaceOrientations];
             NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
             UIWindowScene *scene = [array firstObject];
             UIInterfaceOrientationMask orientation = UIInterfaceOrientationMaskLandscapeRight;
             UIWindowSceneGeometryPreferencesIOS *geometryPreferencesIOS = [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:orientation];
             [scene requestGeometryUpdateWithPreferences:geometryPreferencesIOS errorHandler:^(NSError * _Nonnull error) {
                 
             }];
        }else{
            if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
                   SEL selector = NSSelectorFromString(@"setOrientation:");
                   NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
                   [invocation setSelector:selector];
                   [invocation setTarget:[UIDevice currentDevice]];
                   int val = UIInterfaceOrientationLandscapeRight;
                   [invocation setArgument:&val atIndex:2];
                   [invocation invoke];
                    [UIViewController attemptRotationToDeviceOrientation];
            }
        }
    }

}

+(void)boyaaGetClipBoardStr:(NSString*)s1
{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    NSLog(@"clip str 11 = %@",pasteboard.string);
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"\n\r"];
    NSString *str = [[pasteboard.string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    NSLog(@"clip str = %@",str);
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').setClipBoardText(\"%@\");",str];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
    
}

+(void)boyaaCopyStr:(NSString*)s1
{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = s1;
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').alert(\"%@\");",@"copySuccess"];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
}


+(void) getPushToken:(NSString*)s1
{
    NSLog(@"push token %@",  [NSString stringWithUTF8String:g_push_token.c_str()]);
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').setPushToken(\"%@\");",[NSString stringWithUTF8String:g_push_token.c_str()]];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
}

+(void)isInstallFacebook:(NSString*)s1
{
    bool install = [ZTUtils isInstallApp:@"fb://"];
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').setIsInstallFacebook(\"%@\");",[NSString stringWithFormat:@"%d",install]];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
}

+(void) isInstallMessager:(NSString*)s1
{
    bool install = [ZTUtils isInstallApp:@"fb-messenger://"];
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').setIsInstallMessenger(\"%@\");",[NSString stringWithFormat:@"%d",install]];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
}

+(void) openSystemShare:(NSString*)shareContent
{
    NSArray* array = [shareContent componentsSeparatedByString:@"?"];
    NSLog(@"urlparams = %@",shareContent);
    NSString* urlStr = [array objectAtIndex:0];
    NSString* content = [array objectAtIndex:1];
    NSString *textToShare = [NSString stringWithFormat:@"%@%@",content,urlStr] ;
    NSArray *activityItems = @[textToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    UIPopoverPresentationController *popover = activityVC.popoverPresentationController;
    if (popover) {
        popover.sourceView = g_view_controller.view;
        popover.sourceRect = CGRectMake(0,0,g_view_controller.view.bounds.size.width,40);
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [g_view_controller presentViewController:activityVC animated:YES completion:nil];
    
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"app share completed");
   
        } else  {
            NSLog(@"app share cancled");
    
        }
    };
}

+(void)isPadDevice:(NSString*)s1
{
    NSString* isPad = @"false";
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"]) {
        //iPhone
        isPad = @"false";
    }
    else if([deviceType isEqualToString:@"iPod touch"]) {
        //iPod Touch
        isPad = @"false";
    }
    else if([deviceType isEqualToString:@"iPad"]) {
        //iPad
        isPad = @"true";
    }
    
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').setIsPad(\"%@\");",[NSString stringWithFormat:@"%@",isPad]];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
}

+(void) requestSKAdNetwork:(NSString*)s1
{
    if (@available(iOS 14, *)) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                    NSLog(@"idfa == %@",idfa);
                } else {
                }
            }];
        } else {
            if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
                NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                NSLog(@"idfa == %@",idfa);
            } else {
            }
        }
}


+(void) registerPushNotification:(NSString*)s1
{
    NSLog(@"registerPushNotification!");
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Request authorization succeeded!");
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }];
}

+(void)checkIfRegesterPushNotification:(NSString*)s1
{
     NSString* __block isRegester = @"false";
         [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {

        }];
}

+(void)getDeepLinkUrl:(NSString*)s1
{
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('FirebaseInterface').setDeepLink(\"%@\");",[NSString stringWithUTF8String:g_deep_link_url.c_str()]];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
    
}


+(void)boyaaGetNetStatus:(NSString*)s1
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSString *netconnType = @"Network Invalid";
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    netconnType = @"unknown";
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    netconnType = @"Network Invalid";
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    netconnType = @"3G|4G";
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    netconnType = @"WiFi";
                    break;
                default:
                    break;
            }
            NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').setNetworkEnvironment(\"%@\");",netconnType];
            se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
        }];
}

+(void) boyaaGetLocalHost:(NSString*)s1{
    
}

+(void) getSIMLocation:(NSString*)s1{
    
    NSString *isoCountryCode = @"";
    
    if (@available(iOS 12.0, *)) {
        
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        NSDictionary<NSString *,CTCarrier *>  *carrier = networkInfo.serviceSubscriberCellularProviders;
        for (NSString *key in carrier) {
            CTCarrier *value = carrier[key];
            if([isoCountryCode isEqualToString:@""]){
                isoCountryCode = value.mobileCountryCode;
            }
            else{
                isoCountryCode = [isoCountryCode stringByAppendingString:@"|"];
                isoCountryCode = [isoCountryCode stringByAppendingString:value.mobileCountryCode];
            }
        }
        
    }
    else{
        
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = networkInfo.subscriberCellularProvider;
        isoCountryCode = carrier.isoCountryCode;

    }
    NSLog(@"countrycode: %@", isoCountryCode);

    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').setSimLocation(\"%@\");",isoCountryCode];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
    
}


+(void) boyaaShowGameLoading:(NSNumber*)portrait{
    
    NSLog(@"GameLoader boyaaShowGameLoading portrait = %@",portrait);
    [GameLoader boyaaShowGameLoading:portrait];
    
}

+(void) boyaaHideGameLoading:(NSString*)str{
    
    NSLog(@"GameLoader boyaaHideGameLoading = %@",str);
    [GameLoader boyaaHideGameLoading:str];
    
}

+(void) boyaaShowGamePage:(NSString*)url portrait:(NSNumber*)portrait{
    
    NSLog(@"GameLoader boyaaShowGamePage url = %@",url);
    NSLog(@"GameLoader boyaaShowGamePage portrait = %@",portrait);
    [GameLoader boyaaShowGamePage:url uid:portrait];
    
}

+(void) boyaaHideGameHomeBtn:(NSString*)str{
    
    NSLog(@"GameLoader boyaaHideGameHomeBtn = %@",str);
    [GameLoader boyaaHideGameHomeBtn:str];
    
}


+(void) gotoComment:(NSString*)s1{
    
    NSString *url = @"itms-apps://itunes.apple.com/cn/app/id6503437381?mt=8&action=write-review";
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url] options:{} completionHandler:nil];
    
}

+(void) openStore:(NSString*)url{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url] options:{} completionHandler:nil];
}

+(void) saveQRToLocal:(NSNumber*)reward qrString:(NSString*)qrString countryID:(NSString*)countryID{
    
    UIImage* imageShare = [ZTUtils getShareImage:reward qrString:qrString countryID:countryID];
    [ZTUtils saveImageToPhotoGraph:imageShare];
    
}

+(void) shareImageWithFacebook:(NSNumber*)reward qrString:(NSString*)qrString countryID:(NSString*)countryID{
    
    NSLog(@"share shareImageWithFacebook url");

    UIImage *imageToShare = [UIImage imageNamed:@"ZenThrive.bundle/share_bg.jpg"];
    
    UIActivityItemProvider *imageItem = [[UIActivityItemProvider alloc] initWithPlaceholderItem:imageToShare];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[imageItem] applicationActivities:nil];
    
    activityViewController.popoverPresentationController.sourceView = g_view_controller.view;
    
    [g_view_controller presentViewController:activityViewController animated:YES completion:nil];

}

+(void) shareWithOS:(NSString*)shareContent{
    
    NSString *textToShare = shareContent;
    NSArray *activityItems = @[textToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    UIPopoverPresentationController *popover = activityVC.popoverPresentationController;
    if (popover) {
        popover.sourceView = g_view_controller.view;
        popover.sourceRect = CGRectMake(0,0,g_view_controller.view.bounds.size.width,40);
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [g_view_controller presentViewController:activityVC animated:YES completion:nil];
    
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"app fx completed");
   
        } else  {
            NSLog(@"app fx cancled");
     
        }
    };
    
}

+(void) shareWithFacebook:(NSString*)title content:(NSString*)content{
    
    NSString *textToShare = content;
    
    UIActivityItemProvider *textItem = [[UIActivityItemProvider alloc] initWithPlaceholderItem:textToShare];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[textItem] applicationActivities:nil];
    
    activityViewController.popoverPresentationController.sourceView = g_view_controller.view;
    
    
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypeAirDrop, UIActivityTypeOpenInIBooks];

    
    [g_view_controller presentViewController:activityViewController animated:YES completion:nil];
    
}

+(void) shareWithWhatsApp:(NSString*)title content:(NSString*)content{
    
    NSLog(@"app share shareWithWhatsApp");
    NSString *textToShare =  [NSString stringWithFormat:@"whatsapp://send?text=%@",content];
    NSURL *whatsappURL = [NSURL URLWithString:textToShare];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]){
        NSLog(@"app share canOpenURL");
        [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:nil];
    }
    else{
        [ZTInterface alert:@"whatsAppnotInstalled"];
    }

}

+(void) shareWithLine:(NSString*)title content:(NSString*)content{
    
    NSString *textToShare = content;
    
    UIActivityItemProvider *textItem = [[UIActivityItemProvider alloc] initWithPlaceholderItem:textToShare];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[textItem] applicationActivities:nil];
    
    activityViewController.popoverPresentationController.sourceView = g_view_controller.view;
    
    [g_view_controller presentViewController:activityViewController animated:YES completion:nil];

}

+(void) alert:(NSString*)content{
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').alert(\"%@\");",content];
        se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
    });
    
}


+(void) setCUID:(NSString*)uid{
    
    [AppsFlyer setCUID:uid];
    
}

+(void) boyaaGetInstallSource:(NSString*)source{
    
    if(g_appflyer_enabled){
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_async(queue, ^{
            NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').setInstallSource(\"%@\");",g_appflyer_source];
            se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
        });
    }
    else{
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_async(queue, ^{
            NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').setInstallSource(\"%@\");",@"unsupported"];
            se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
        });
    }
    
}

+(void) setInstallSource:(NSString*)source{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').setInstallSource(\"%@\");",source];
        se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
    });

}

+(void) setLaunchAttrs:(NSString*)attrs{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').setLaunchAttrs(\"%@\");",attrs];
        se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
    });
}

+(void) deleteFolder: (NSString*)folderPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:folderPath]) {
        NSError *error = nil;
        
        BOOL success = [fileManager removeItemAtPath:folderPath error:&error];
        if (success) {
            NSLog(@"delete success");
        } else {
            NSLog(@"delete failed: %@", error.localizedDescription);
        }
    } else {
        NSLog(@"delete none");
    }
    
}
@end
