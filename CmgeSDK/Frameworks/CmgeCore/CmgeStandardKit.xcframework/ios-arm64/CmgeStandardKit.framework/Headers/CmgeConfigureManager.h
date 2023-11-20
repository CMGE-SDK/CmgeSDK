//
//  CmgeConfigureManager.h
//  CmgeKit
//
//  Created by WakeyWoo on 2020/5/28.
//  Copyright © 2020 WakeyWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const kCmgeKillAppNotification; //退出游戏通知。

typedef NS_ENUM (NSInteger, CmgeScreenOrientation){
    CmgeScreenOreintationsLandscape, //横屏
    CmgeScreenOreintationsPortrait  //竖屏
};

/// 枚举类型：SDK地区版本
typedef NS_ENUM(NSInteger, CmgeRegionVersion) {
    CmgeRegionNotDetermined = -1, //未决定
    CmgeRegionChina = 0,    //中国大陆版
    CmgeRegionOversea,      //海外版
};

@interface CmgeConfigure : NSObject

/// 是否打开调试模式
@property (nonatomic, assign) BOOL debugMode;

/// 设置游戏横竖屏
@property (nonatomic, assign) CmgeScreenOrientation orientation;

/// 设置SDK地区版本
@property (nonatomic, assign) CmgeRegionVersion regionVersion;

/// 是否显示海外隐私协议弹窗。默认NO不显示。日本发行游戏必须设置为YES显示。
@property (nonatomic, assign) BOOL isShowOverseaPrivacyAlert;

@end

@interface CmgeConfigureManager : NSObject

/// 版本号
+(NSString *) sdkVersion;

/// 初始化设置
/// @param config 初始化对象
/// @param completion 初始化完成回调
+(void) startInitConfig:(CmgeConfigure *) config completion:(nullable void(^)(void))completion;

+(BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+(BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;

+(BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

+(BOOL) application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler;

+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

+ (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler;

/// 默认是NO， SDK初始化后选择完版本区域
+ (BOOL) determinedRegion;

@end



NS_ASSUME_NONNULL_END
