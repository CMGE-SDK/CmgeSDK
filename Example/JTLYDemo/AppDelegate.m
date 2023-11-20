//
//  AppDelegate.m
//  JTLYDemo
//
//  Created by WakeyWoo on 2020/4/8.
//  Copyright © 2020 WakeyWoo. All rights reserved.
//

#import "AppDelegate.h"
#import "JTLYDemoViewController.h"
#import "JTLYDemoSdkManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    JTLYDemoViewController *demoVC = [[JTLYDemoViewController alloc] init];
   
    self.window.rootViewController = demoVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //Facebook 9.0以上一定要加上
    [CmgeConfigureManager application:application didFinishLaunchingWithOptions:launchOptions];
    

//    NSLog(@"===whj===SDK Version Information=== %@", [[CmgeProject shareData] versionInfo]);
    
    return YES;
}

#pragma mark - 第三方登录回调
-(BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    //设置第三方登录回调
    return [CmgeConfigureManager application:app openURL:url options:options];
}

//-(BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    //设置第三方登录回调
//    return [CmgeConfigureManager application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
//}

//-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return  [CmgeConfigureManager application:application openURL:url options:nil];
//}


- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    //继续用户活动
    return [CmgeConfigureManager application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"如果receiveMessageTouchedHandler不在didFinished初始化，则点击消息后回调（杀进程情况）:%@", userInfo);
    [CmgeConfigureManager application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    [CmgeConfigureManager application:application handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void) applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
