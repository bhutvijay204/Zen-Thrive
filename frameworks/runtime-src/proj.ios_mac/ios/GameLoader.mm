
#import "GameLoader.h"
#include "cocos/scripting/js-bindings/jswrapper/SeApi.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"


@interface GameLoader ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong)WKWebView* wkWebView;
@property (nonatomic, strong)UIImageView* mImageBg;
@property (nonatomic, strong)UIImageView* mLoading;
@property (nonatomic, strong)UIButton* mBtnBack;
@property (nonatomic, strong)UITextView* mTips;

@end

@implementation GameLoader

@synthesize wkWebView;
@synthesize mImageBg;
@synthesize mTips;
@synthesize mLoading;
@synthesize mBtnBack;

extern UIViewController* g_view_controller;
extern int currScreenOrientation;

static GameLoader * instance;

+ (GameLoader *) shareInstance {
    @synchronized(self) {
        if (!instance)
            instance=[[GameLoader alloc] init];
    }
    return instance;
}

+(void) boyaaShowGameLoading:(NSNumber*)portrait{
    
    GameLoader* adInstance = [GameLoader shareInstance];
    [adInstance showGameLoading:portrait];
    
}

-(void) showGameLoading:(NSNumber*)portrait{
    
    self.view.hidden = NO;
    NSLog(@"GameLoader start showGameLoading!");
    [g_view_controller.view addSubview:self.view];
    if(self.wkWebView == nil){
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [WKPreferences new];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.textInteractionEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.userContentController = [WKUserContentController new];
        
        config.allowsInlineMediaPlayback = YES;
                
        self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) configuration:config];
        self.wkWebView.layer.zPosition = 1;
        [self.wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.wkWebView setNavigationDelegate:self];
        [self.wkWebView setBackgroundColor:UIColor.blackColor];
        [self.wkWebView setMultipleTouchEnabled:YES];
        [self.wkWebView setAutoresizesSubviews:YES];
        [self.wkWebView.scrollView setAlwaysBounceVertical:YES];
        self.wkWebView.scrollView.bounces = NO;
        self.wkWebView.contentMode = UIViewContentModeScaleToFill;
        self.wkWebView.scrollView.minimumZoomScale = 1.0f;
        self.wkWebView.scrollView.maximumZoomScale = 1.0f;
        self.wkWebView.userInteractionEnabled = YES;
        self.wkWebView.translatesAutoresizingMaskIntoConstraints = NO;
        if (@available(iOS 11.0, *)) {
            self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

        } else {
        }
        NSLog(@"GameLoader add wkWebView!");
        [self.view addSubview:self.wkWebView];
        [NSLayoutConstraint activateConstraints:@[
            [self.wkWebView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.wkWebView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.wkWebView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.wkWebView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        ]];

    }

    if(self.mImageBg == nil){
        
        UIImage *image = [UIImage imageNamed:@"ZenThrive.bundle/loading_bg.jpg"];
        self.mImageBg = [[UIImageView alloc] initWithImage:image];
        self.mImageBg.layer.zPosition = 2;
        self.mImageBg.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.mImageBg];
        [NSLayoutConstraint activateConstraints:@[
            [self.mImageBg.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.mImageBg.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.mImageBg.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.mImageBg.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        ]];
    }

    if(self.mLoading == nil){
        UIImage *loading = [UIImage imageNamed:@"ZenThrive.bundle/loading_poker.png"];
        self.mLoading = [[UIImageView alloc] initWithImage:loading];
        mLoadingSize = loading.size;
        self.mLoading.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.mLoading.layer.zPosition = 3;
        self.mLoading.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-loading.size.width/2, [UIScreen mainScreen].bounds.size.height/2-loading.size.height/2, loading.size.width, loading.size.height);
        self.mLoading.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.mLoading];

        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.mLoading
                                                                             attribute:NSLayoutAttributeCenterX
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeCenterX
                                                                            multiplier:1.0
                                                                              constant:0.0];

        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.mLoading
                                                                             attribute:NSLayoutAttributeCenterY
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeCenterY
                                                                            multiplier:1.0
                                                                              constant:0.0];

        [self.view addConstraints:@[centerXConstraint, centerYConstraint]];
    }
    
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
   animation.fromValue = [NSNumber numberWithFloat:0.f];
   animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
   animation.duration  = 3;
   animation.autoreverses = NO;
   animation.fillMode =kCAFillModeForwards;
   animation.repeatCount = MAXFLOAT;
   [self.mLoading.layer addAnimation:animation forKey:nil];

    mHomeBtnPostion =[portrait intValue];
    if(self.mBtnBack == nil){
        self.mBtnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *normal = [UIImage imageNamed:@"ZenThrive.bundle/btn_back.png"];
        UIImage *hilight = [UIImage imageNamed:@"ZenThrive.bundle/btn_back.png"];
        [self.mBtnBack setBackgroundImage:normal forState:UIControlStateNormal];
        [self.mBtnBack setBackgroundImage:hilight forState:UIControlStateHighlighted];
        self.mBtnBack.layer.zPosition = 4;
        self.mBtnBack.userInteractionEnabled = YES;
        [self.mBtnBack addTarget:self action:@selector(buttonBack:) forControlEvents:UIControlEventTouchUpInside];
        mHomeBtnSize = normal.size;
        [self.view addSubview:self.mBtnBack];
        
    }
    [[GameLoader shareInstance] updateLoadingUI];
    self.wkWebView.hidden = NO;
    self.mBtnBack.hidden = NO;
    self.mLoading.hidden = NO;
    self.mImageBg.hidden = NO;
}

-(void) updateLoadingUI{
    
    self.mBtnBack.hidden = NO;
    
    if(currScreenOrientation == UIInterfaceOrientationMaskPortrait){
        if(mHomeBtnPostion == 2){
            self.mBtnBack.frame =CGRectMake([UIScreen mainScreen].bounds.size.width-mHomeBtnSize.width, 0, mHomeBtnSize.width, mHomeBtnSize.height);
        }
        else if(mHomeBtnPostion == 3){
            self.mBtnBack.frame =CGRectMake([UIScreen mainScreen].bounds.size.width-mHomeBtnSize.width, 0, mHomeBtnSize.width, mHomeBtnSize.height);
        }
        else if(mHomeBtnPostion == 1){
            self.mBtnBack.frame =CGRectMake([UIScreen mainScreen].bounds.size.width-mHomeBtnSize.width, 0, mHomeBtnSize.width, mHomeBtnSize.height);
        }
        else{
            self.mBtnBack.frame =CGRectMake(0, 0, mHomeBtnSize.width, mHomeBtnSize.height);
        }

    }
    else{
        if(mHomeBtnPostion == 2){
            self.mBtnBack.frame =CGRectMake([UIScreen mainScreen].bounds.size.width/2-mHomeBtnSize.width/2, 0, mHomeBtnSize.width, mHomeBtnSize.height);
        }
        else if(mHomeBtnPostion == 3){
            self.mBtnBack.frame =CGRectMake([UIScreen mainScreen].bounds.size.width-mHomeBtnSize.width, 0, mHomeBtnSize.width, mHomeBtnSize.height);
        }
        else if(mHomeBtnPostion == 1){
            self.mBtnBack.frame =CGRectMake([UIScreen mainScreen].bounds.size.width*3/4-mHomeBtnSize.width/2, 0, mHomeBtnSize.width, mHomeBtnSize.height);
        }
        else{
            self.mBtnBack.frame =CGRectMake(0, 0, mHomeBtnSize.width, mHomeBtnSize.height);
        }

    }
}

-(void) updateLoadingUIBegan{
    if(currScreenOrientation == UIInterfaceOrientationMaskPortrait){
        
        if(mHomeBtnPostion == 2){
            self.mBtnBack.frame =CGRectMake([UIScreen mainScreen].bounds.size.height-mHomeBtnSize.width, 0, mHomeBtnSize.width, mHomeBtnSize.height);
        }
        else if(mHomeBtnPostion == 3){
            self.mBtnBack.frame =CGRectMake([UIScreen mainScreen].bounds.size.height-mHomeBtnSize.width, 0, mHomeBtnSize.width, mHomeBtnSize.height);
        }
        else if(mHomeBtnPostion == 1){
            self.mBtnBack.frame =CGRectMake([UIScreen mainScreen].bounds.size.height-mHomeBtnSize.width, 0, mHomeBtnSize.width, mHomeBtnSize.height);
        }
        else{
            self.mBtnBack.frame =CGRectMake(0, 0, mHomeBtnSize.width, mHomeBtnSize.height);
        }
    }
    else{
        
        if(mHomeBtnPostion == 2){
            self.mBtnBack.frame =CGRectMake([UIScreen mainScreen].bounds.size.height/2-mHomeBtnSize.width/2, 0, mHomeBtnSize.width, mHomeBtnSize.height);
        }
        else if(mHomeBtnPostion == 3){
            self.mBtnBack.frame =CGRectMake([UIScreen mainScreen].bounds.size.height-mHomeBtnSize.width, 0, mHomeBtnSize.width, mHomeBtnSize.height);
        }
        else if(mHomeBtnPostion == 1){
            self.mBtnBack.frame =CGRectMake([UIScreen mainScreen].bounds.size.height*3/4-mHomeBtnSize.width/2, 0, mHomeBtnSize.width, mHomeBtnSize.height);
        }
        else{
            self.mBtnBack.frame =CGRectMake(0, 0, mHomeBtnSize.width, mHomeBtnSize.height);
        }
    }
    
    self.mBtnBack.hidden = YES;
    
}

-(void) buttonBack:(UIButton *)button{

    NSLog(@"GameLoader buttonBack!");
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').backHall(\"%@\");",[NSString stringWithFormat:@"str"]];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
}

+(void) boyaaShowGamePage:(NSString*)url uid:(NSNumber*)portrait{
    GameLoader* adInstance = [GameLoader shareInstance];
    [adInstance showGamePage:url uid:portrait];
    
}

-(void) showGamePage:(NSString*)url uid:(NSNumber*)portrait{
    
    int orientation = [portrait intValue];
    NSLog(@"boyaaSetScreenOrentation = %@",url);
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
        currScreenOrientation = UIInterfaceOrientationMaskLandscape;
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.wkWebView loadRequest:request];
    self.wkWebView.hidden = NO;
    
}

+(void) boyaaHideGameLoading:(NSString*)str{
    
    GameLoader* adInstance = [GameLoader shareInstance];
    [adInstance hideGameLoading];
    
}

-(void) hideGameLoading{
    
    if(self.mImageBg != nil){
        self.mImageBg.hidden = YES;
    }
    if(self.mLoading != nil){
        self.mLoading.hidden = YES;
        [self.mLoading.layer removeAllAnimations];
    }
    if(self.mTips != nil){
        self.mTips.hidden = YES;
    }
}

+(void) boyaaHideGameHomeBtn:(NSString*)str{
    
    GameLoader* adInstance = [GameLoader shareInstance];
    [adInstance hideGameHomeBtn];
    
}

-(void) hideGameHomeBtn{
    
    if(self.wkWebView != nil){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]];
        [self.wkWebView loadRequest:request];
        self.wkWebView.hidden = YES;
    }
    if(self.mBtnBack != nil){
        self.mBtnBack.hidden = YES;
    }
    if(self.mImageBg != nil){
        self.mImageBg.hidden = YES;
    }
    if(self.mLoading != nil){
        self.mLoading.hidden = YES;
        [self.mLoading.layer removeAllAnimations];
    }
    if(self.mTips != nil){
        self.mTips.hidden = YES;
    }
    
    self.view.hidden = YES;
    
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    NSLog(@"didFailToLoadURL");
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').onWebLoadError(\"%@\");",[NSString stringWithFormat:@"str"]];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);

}


- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    NSLog(@"didFailToLoadURL");
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').onWebLoadError(\"%@\");",[NSString stringWithFormat:@"str"]];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
    
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    NSLog(@"GameLoader The page is loaded!");

    NSString* urlStr = [self.wkWebView.URL absoluteString];
    NSLog(@"didFinishLoadingURL：%@",urlStr);
    if ([urlStr containsString:@"playGame.do"]) {
        return;
    }
    if([urlStr isEqualToString:@"about:blank"]){
        return;
    }
        
    NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').onWebLoadComplete(\"%@\");",[NSString stringWithFormat:@"str"]];
    se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);

}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"didCommitNavigation");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
 
    
    NSURL *redirectURL = navigationAction.request.URL;
    if (redirectURL) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    NSString* urlStr = [navigationAction.request.URL absoluteString];
    NSLog(@"GameLoader decidePolicyForNavigationAction to URL：%@",urlStr);
    if ([urlStr containsString:@"/thirdPartCommand_EndGame"]) {
        NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').backHall(\"%@\");",[NSString stringWithFormat:@"str"]];
        se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

- (BOOL)externalAppRequiredToOpenURL:(NSURL *)URL {

    
    return !URL;
}

- (void)launchExternalAppWithURL:(NSURL *)URL {

    
    
}

-(BOOL)callback_webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType
{
    
    NSString* urlStr = [request.URL absoluteString];
    NSLog(@"GameLoader Intercept to URL：%@",urlStr);
    if ([urlStr containsString:@"/thirdPartCommand_EndGame"]) {
        NSString *scriptStr = [[NSString alloc] initWithFormat:@"cc.find('nativeReg').getComponent('AndroidInfo').backHall(\"%@\");",[NSString stringWithFormat:@"str"]];
        se::ScriptEngine::getInstance()->evalString([scriptStr UTF8String]);
    }
    return YES;
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    //
    decisionHandler(WKNavigationResponsePolicyAllow);
    
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

    NSLog(@"GameLoader The page starts loading...");
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (BOOL) shouldAutorotate {
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    


    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {


     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {

     }];
    
}


@end
