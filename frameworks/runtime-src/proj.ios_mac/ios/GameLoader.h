
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

using namespace std;

@interface GameLoader : UIViewController
{
    int mHomeBtnPostion;
    CGSize mHomeBtnSize;
    CGSize mLoadingSize;
    
}

+ (GameLoader *)shareInstance;

+(void) boyaaShowGameLoading:(NSNumber*)portrait;
+(void) boyaaHideGameLoading:(NSString*)str;
+(void) boyaaShowGamePage:(NSString*)url uid:(NSNumber*)portrait;
+(void) boyaaHideGameHomeBtn:(NSString*)str;

-(void) updateLoadingUI;
-(void) updateLoadingUIBegan;

@end

NS_ASSUME_NONNULL_END
