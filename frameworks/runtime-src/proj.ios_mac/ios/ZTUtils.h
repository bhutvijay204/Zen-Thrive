#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZTUtils : NSObject


+ (UIImage *)getImageWithFullScreenshot;


+ (UIImage *)getScreenShot:(UIImage *)screenShot withDesc:(NSString*)desc url:(NSString*)url lan:(NSString*)lan;

+ (UIImage *)createImageWithQRString:(NSString*)qrString;

+ (UIImage *)getShareImage:(NSNumber*)reward qrString:(NSString*)qrString countryID:(NSString*)countryID;


+ (void)saveImage:(UIImage *)image : (NSString*)fileName;


+ (UIImage *)getImage: (NSString*)fileName;


+ (void)saveImageToPhotoGraph:(UIImage *)image ;


+ (int) isInstallApp:(NSString*)scheme;

+(UIImage *)HoldemClickkwalaPhotoPlyerResige:(UIImage *)image toSize:(CGSize)size;

+(void) httpPost :(NSURL*)url params:(NSString*) params;

+(void) requestSKAdNetwork;

+(int) getSKAdNetworkEnable;

+(void) registerPushNotification;

@end

