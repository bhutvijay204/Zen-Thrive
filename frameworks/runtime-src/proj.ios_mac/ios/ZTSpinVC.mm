//
//  ZTSpinVC.m
//  Zen Thrive
//
//  Created by Hitesh Mac on 18/05/24.
//

#import "ZTSpinVC.h"
#import "cocos2d.h"
#include "platform/CCApplication.h"
#include "platform/ios/CCEAGLView-ios.h"
#include "GameLoader.h"
#import "ZTAppDelegate.h"

@implementation ZTSpinVC

+(void)spinAction
{
    ZTSpinVC *spinVC = [(ZTAppDelegate *)UIApplication.sharedApplication.delegate spinVC];
    [spinVC spinGame];
}

- (void)spinGame
{
    UINavigationController *gameNav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    gameNav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:gameNav animated:YES completion:nil];
}

- (void)loadView {
    self.view = (__bridge CCEAGLView *)cocos2d::Application::getInstance()->getView();
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#ifdef __IPHONE_6_0
- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
#endif

- (BOOL) shouldAutorotate {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [[GameLoader shareInstance] updateLoadingUIBegan];
    
    NSLog(@"GameLoader viewWillTransitionToSize!");

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {

        NSLog(@"GameLoader viewIngTransitionToSize!");

     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
         NSLog(@"GameLoader viewCompleteTransitionToSize!");
         [[GameLoader shareInstance] updateLoadingUI];
     }];
}

@end
