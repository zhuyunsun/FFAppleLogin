//
//  AppDelegate.m
//  FFAppleLogin
//
//  Created by 朱运 on 2021/2/25.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ViewController *vc = [[ViewController alloc]init];
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = naVC;
    return YES;
}
@end
