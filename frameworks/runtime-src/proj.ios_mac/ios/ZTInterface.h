

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTInterface : NSObject
+(void) boyaaShowSplash:(NSString*)s1;

+(void) boyaaHideSplash:(NSString*)s1;

+(void) boyaaGetAppID:(NSString*)s1;

+(void) boyaaGetAppVersion:(NSString*)s1;

+(void) boyaaGetSysVersion:(NSString*)s1;

+(void) boyaaGetDeviceID:(NSString*)s1;

+(void) boyaaGetDeviceInfo:(NSString*)s1;

+(void) boyaaGetTimeZone:(NSString*)s1;

+(void) boyaaGetDeviceTime:(NSString*)s1;

+(void) boyaaGetDeviceLanguage:(NSString*)s1;

+(void) boyaaSetScreenOrentation:(NSNumber*)s1;

+(void) boyaaGetClipBoardStr:(NSString*)s1;

+(void) boyaaCopyStr:(NSString*)s1;

+(void) boyaaGetNetStatus:(NSString*)s1;

+(void) boyaaGetLocalHost:(NSString*)s1;

+(void) getSIMLocation:(NSString*)s1;

+(void) getPushToken:(NSString*)s1;

+(void) isInstallFacebook:(NSString*)s1;

+(void) isInstallMessager:(NSString*)s1;

+(void) openSystemShare:(NSString*)s1;

+(void) requestSKAdNetwork:(NSString*)s1;

+(void) registerPushNotification:(NSString*)s1;

+(void) checkIfRegesterPushNotification:(NSString*)s1;

+(void) getDeepLinkUrl:(NSString*)s1;

+(void) gotoComment:(NSString*)s1;

+(void) openStore:(NSString*)s1;

+(void) boyaaShowGameLoading:(NSNumber*)portrait;

+(void) boyaaHideGameLoading:(NSString*)str;

+(void) boyaaShowGamePage:(NSString*)url portrait:(NSNumber*)portrait;

+(void) boyaaHideGameHomeBtn:(NSString*)str;

+(void) saveQRToLocal:(NSNumber*)reward qrString:(NSString*)qrString countryID:(NSString*)countryID;

+(void) shareImageWithFacebook:(NSNumber*)reward qrString:(NSString*)qrString countryID:(NSString*)countryID;

+(void) shareWithOS:(NSString*)content;

+(void) shareWithFacebook:(NSString*)title content:(NSString*)content;

+(void) shareWithWhatsApp:(NSString*)title content:(NSString*)content;

+(void) shareWithLine:(NSString*)title content:(NSString*)content;

+(void) alert:(NSString*)content;

+(void) setCUID:(NSString*)str;

+(void) boyaaGetInstallSource:(NSString*)source;

+(void) setInstallSource:(NSString*)source;

+(void) setLaunchAttrs:(NSString*)source;

+(void) deleteFolder: (NSString*)folderPath;

@end

NS_ASSUME_NONNULL_END
