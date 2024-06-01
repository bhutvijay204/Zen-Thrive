
#import <Photos/Photos.h>
#include "ZTUtils.h"
#import "cocos/scripting/js-bindings/jswrapper/SeApi.h"
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AppTrackingTransparency/ATTrackingManager.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UNUserNotificationCenter.h>
#import "AppDelegate.h"
#import <CoreImage/CoreImage.h>
#import "ZTInterface.h"

extern AppDelegate* g_app_controller;

@implementation ZTUtils
 
#pragma mark -
#pragma mark Application lifecycle
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)



+ (UIImage *)getImageWithFullScreenshot{
    
    
    BOOL ignoreOrientation = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0");
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    CGSize imageSize = CGSizeZero;
    if (UIInterfaceOrientationIsPortrait(orientation) || ignoreOrientation)
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        
        // Correct for the screen orientation
        if(!ignoreOrientation)
        {
            if(orientation == UIInterfaceOrientationLandscapeLeft)
            {
                CGContextRotateCTM(context, (CGFloat)M_PI_2);
                CGContextTranslateCTM(context, 0, -imageSize.width);
            }
            else if(orientation == UIInterfaceOrientationLandscapeRight)
            {
                CGContextRotateCTM(context, (CGFloat)-M_PI_2);
                CGContextTranslateCTM(context, -imageSize.height, 0);
            }
            else if(orientation == UIInterfaceOrientationPortraitUpsideDown)
            {
                CGContextRotateCTM(context, (CGFloat)M_PI);
                CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
            }
        }
        
        if([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
        else
            [window.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


+ (void)saveImage:(UIImage *)image : (NSString*)fileName {
    
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:fileName];
    NSLog(@"filePath = %@",filePath);
    
    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath   atomically:YES];
        if (result == YES) {
            NSLog(@"save success");
        }else{
            NSLog(@"save failed");
    }
    
}

+ (UIImage *)getImage: (NSString*)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:fileName];
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    NSLog(@"=== %@", img);
    return img;
    
}


+ (UIImage *)getScreenShot:(UIImage *)screenShot withDesc:(NSString*)desc url:(NSString*)url lan:(NSString*)lan{

    UIImage* bottomBg = [UIImage imageNamed:@"ZenThrive.bundle/share_bg.png"];
    UIImage* iconImage = [UIImage imageNamed:@"ZenThrive.bundle/share_icon.png"];
    UIImage* qrImage = NULL;
    if([lan isEqualToString:@"cn"]){
        qrImage = [UIImage imageNamed:@"ZenThrive.bundle/qr_cn.jpeg"];
    }
    else if([lan isEqualToString:@"tw"]){
        qrImage = [UIImage imageNamed:@"ZenThrive.bundle/qr_tw.jpeg"];
    }
    else{
        qrImage = [UIImage imageNamed:@"ZenThrive.bundle/qr_en.jpeg"];
    }

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString* topic = desc;
    NSString* httpUrl = url;

    CGSize canvasSize = CGSizeMake(screenShot.size.width, screenShot.size.height + bottomBg.size.height);
    UIGraphicsBeginImageContextWithOptions(canvasSize, NO, 0);

    [screenShot drawInRect:CGRectMake(0, 0, screenShot.size.width, screenShot.size.height)];

    [bottomBg drawInRect:CGRectMake(0, screenShot.size.height, screenShot.size.width, bottomBg.size.height)];

    [iconImage drawInRect:CGRectMake(15, screenShot.size.height - 30, iconImage.size.width, iconImage.size.height)];

    [qrImage drawInRect:CGRectMake(screenShot.size.width - 15 - qrImage.size.width, screenShot.size.height + 12, qrImage.size.width, qrImage.size.height)];
    NSMutableParagraphStyle *appNameParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    appNameParagraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    appNameParagraphStyle.alignment = NSTextAlignmentLeft;
    
    NSMutableParagraphStyle *topicsParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    topicsParagraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    topicsParagraphStyle.alignment = NSTextAlignmentLeft;
    
    NSMutableParagraphStyle *urlParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    urlParagraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    urlParagraphStyle.alignment = NSTextAlignmentLeft;
    
    UIFont  *appNameFont = [UIFont boldSystemFontOfSize:28];
    
    CGSize appNameSizeText = [appName boundingRectWithSize:canvasSize
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{
                                                  NSFontAttributeName:appNameFont,
                                                  NSKernAttributeName:@10,
                                                  }
                                        context:nil].size;
    
    CGRect appNameRect = CGRectMake(150, screenShot.size.height+20, appNameSizeText.width, appNameSizeText.height);

    UIFont  *topicFont = [UIFont boldSystemFontOfSize:20];
    
    CGSize topicsSizeText = [topic boundingRectWithSize:canvasSize
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{
                                                  NSFontAttributeName:topicFont,
                                                  NSKernAttributeName:@10,
                                                  }
                                        context:nil].size;
    
    CGRect topicsRect = CGRectMake(150, screenShot.size.height+63, topicsSizeText.width, topicsSizeText.height);
    
    UIFont  *urlFont = [UIFont boldSystemFontOfSize:20];
    
    CGSize urlSizeText = [httpUrl boundingRectWithSize:canvasSize
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{
                                                  NSFontAttributeName:urlFont,
                                                  NSKernAttributeName:@10,
                                                  }
                                        context:nil].size;

    CGRect urlRect = CGRectMake(screenShot.size.width/2+84, screenShot.size.height+63, urlSizeText.width, urlSizeText.height);
    
    UIColor *appNameColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    UIColor *topicsColor = [UIColor colorWithRed:0.64 green:0.83 blue:1 alpha:1.0];
    UIColor *urlColor = [UIColor colorWithRed:0.56 green:0.68 blue:0.85 alpha:1.0];

    [appName drawInRect:appNameRect withAttributes:@{ NSFontAttributeName :[ UIFont fontWithName : @"Arial-BoldMT" size : 28 ], NSForegroundColorAttributeName :appNameColor,NSParagraphStyleAttributeName:appNameParagraphStyle} ];

    [topic drawInRect:topicsRect withAttributes:@{ NSFontAttributeName :[ UIFont fontWithName : @"Arial" size : 20 ], NSForegroundColorAttributeName :topicsColor,NSParagraphStyleAttributeName:topicsParagraphStyle} ];
    
    [httpUrl drawInRect:urlRect withAttributes:@{ NSFontAttributeName :[ UIFont fontWithName : @"Arial" size : 20 ], NSForegroundColorAttributeName :urlColor,NSParagraphStyleAttributeName:urlParagraphStyle} ];
    
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return newImage;
    
}

+ (UIImage *)createImageWithQRString:(NSString*)qrString{
    
    NSString *qrCodeString = qrString;

    CIFilter *qrCodeFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];

    NSData *qrCodeData = [qrCodeString dataUsingEncoding:NSUTF8StringEncoding];
    [qrCodeFilter setValue:qrCodeData forKey:@"inputMessage"];

    CIImage *qrCodeImage = qrCodeFilter.outputImage;

    UIImage *uiImage = [UIImage imageWithCIImage:qrCodeImage];
    
    return uiImage;
    
}


+ (UIImage *)getShareImage:(NSNumber*)reward qrString:(NSString*)qrString countryID:(NSString*)countryID{
    
    UIImage* bottomBg = [UIImage imageNamed:@"ZenThrive.bundle/share_bg.jpg"];
    UIImage* qrImage = [ZTUtils createImageWithQRString:qrString];
    int rewardValue = [reward intValue];
    int country = [countryID intValue];
    
    CGSize canvasSize = CGSizeMake(bottomBg.size.width, bottomBg.size.height);
    UIGraphicsBeginImageContextWithOptions(canvasSize, NO, 0);

    [bottomBg drawInRect:CGRectMake(0, 0, bottomBg.size.width, bottomBg.size.height)];
    [qrImage drawInRect:CGRectMake(bottomBg.size.width/2-210,1060, 420, 420)];
    
    NSArray *currencys = @[@"th.png", @"php.png", @"id.png", @"my.png", @"id.png", @"vt.png", @"br.png"];
    
    NSArray *numbers = @[@"0.png", @"1.png", @"2.png", @"3.png", @"4.png", @"5.png",@"6.png",@"7.png",@"8.png",@"9.png"];
    
    
    if(country <= 7 && country >= 1){
        NSString *cuimage = [NSString stringWithFormat:@"ZenThrive.bundle/%@",currencys[country-1]];
        UIImage* imageCurrency = [UIImage imageNamed:cuimage];
        [imageCurrency drawInRect:CGRectMake(530, 916, imageCurrency.size.width, imageCurrency.size.height)];
    }
    
    if (rewardValue < 10) {
        NSString *reimage = [NSString stringWithFormat:@"ZenThrive.bundle/%@",numbers[rewardValue]];
        UIImage* imageReward = [UIImage imageNamed:reimage];
        [imageReward drawInRect:CGRectMake(620, 906, imageReward.size.width, imageReward.size.height)];
    }
    else{
        int firstNum = rewardValue / 10;
        int secondNum = rewardValue % 10;
        NSString *fnimage = [NSString stringWithFormat:@"ZenThrive.bundle/%@",numbers[firstNum]];
        NSString *snimage = [NSString stringWithFormat:@"ZenThrive.bundle/%@",numbers[secondNum]];
        UIImage* imageRewardFirst = [UIImage imageNamed:fnimage];
        UIImage* imageRewardSecond = [UIImage imageNamed:snimage];
        [imageRewardFirst drawInRect:CGRectMake(590, 906, imageRewardFirst.size.width, imageRewardFirst.size.height)];
        [imageRewardSecond drawInRect:CGRectMake(650, 906, imageRewardSecond.size.width, imageRewardSecond.size.height)];
    }
   
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

+ (void)saveImageToPhotoGraph:(UIImage *)image{
    
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    
    if (authorizationStatus == PHAuthorizationStatusAuthorized) {
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            PHAssetCollectionChangeRequest *collectionRequest;
            
            PHAssetCollection *assetCollection = [self getCurrentPhotoCollectionWithTitle:@"Golden Tiger"];
            
            if (assetCollection) {
                collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            } else {
                collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"Golden Tiger"];
            }
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            
            PHObjectPlaceholder *placeholder = [req placeholderForCreatedAsset];
            
            [collectionRequest addAssets:@[placeholder]];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"success = %d, error = %@", success, error);
            if (success == 1)
            {
               NSLog(@"save_image_success");
                [ZTInterface alert:@"saveSuccess"];
            }
            else
            {
                NSLog(@"save_image_fail");
                [ZTInterface alert:@"saveFailed"];
            }
        }];
        
    } else if (authorizationStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    PHAssetCollectionChangeRequest *collectionRequest;
                    
                    PHAssetCollection *assetCollection = [self getCurrentPhotoCollectionWithTitle:@"Galaxy"];
                    
                    if (assetCollection) {
                        collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                    } else {
                        collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"Galaxy"];
                    }
                    PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                    
                    PHObjectPlaceholder *placeholder = [req placeholderForCreatedAsset];
                    
                    [collectionRequest addAssets:@[placeholder]];
                    
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    NSLog(@"success = %d, error = %@", success, error);
                    if (success == 1)
                    {
                        NSLog(@"save_image_success");
                        [ZTInterface alert:@"saveSuccess"];
                    }
                    else
                    {
                        NSLog(@"save_image_fail");
                        [ZTInterface alert:@"saveFailed"];
                    }
                }];
            }
        }];
        
    } else {
        
        NSLog(@"permission deny !!!!!!!!");
    }
    
}


+ (PHAssetCollection *)getCurrentPhotoCollectionWithTitle:(NSString *)collectionName {
    
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *assetCollection in result) {
        
        if ([assetCollection.localizedTitle containsString:collectionName]) {
            return assetCollection;
        }
    }
    
    return nil;
}

+ (int) isInstallApp:(NSString*)scheme{

    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]){
        return 1;
    }
    else{
        return 0;
    }
    
    
}

+(UIImage *)HoldemClickkwalaPhotoPlyerResige:(UIImage *)image toSize:(CGSize)size
{

    UIGraphicsBeginImageContext(size);

    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


+(void) httpPost:(NSURL*)url params:(NSString*) params{

    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSData *postData = [params dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%ld",[postData length]];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error != nil){
            NSLog(@"post error : %@",[error description]);
        }else{
            NSDictionary *jasonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers
                                                                     error:nil];
            
                NSLog(@"json success：%@",jasonResponse);
                NSString* errorCode = [jasonResponse valueForKey:@"error_code"];
                NSLog(@"errorCode：%@",errorCode);
                if([errorCode intValue] == 0){
                    NSLog(@"po st success");
                }
                else{
                    NSLog(@"po st failed");
                }
            
    
        }
    }];

    [task resume];

}


+(void) requestSKAdNetwork
{
    if (@available(iOS 14, *)) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                    NSLog(@"%@",idfa);
                } else {
                }
            }];
        } else {
            if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
                NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                NSLog(@"%@",idfa);
            } else {
            }
        }
}


+(int) getSKAdNetworkEnable
{
    if (@available(iOS 14.0, *)) {
        ATTrackingManagerAuthorizationStatus status = [ATTrackingManager trackingAuthorizationStatus];
        if (status == ATTrackingManagerAuthorizationStatusAuthorized){
            return 1;
        }
        else{
            return 0;
        }
    } else {
        return 1;
    }
}

+(void) registerPushNotification
{
}


@end
