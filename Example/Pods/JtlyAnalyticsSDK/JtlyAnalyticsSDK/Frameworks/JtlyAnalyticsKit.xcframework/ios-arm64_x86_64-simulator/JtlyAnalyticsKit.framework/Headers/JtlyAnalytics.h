//
//  JtlyAnalytics.h
//  JtlyAnalyticsKit
//
//  Created by WakeyWoo on 2021/8/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JtlyAnalyticsKit/JtlyAnalyticsConfig.h>
#import <JtlyAnalyticsKit/JtlyAnalyticsSdkInfo.h>


typedef NS_ENUM(NSInteger, JtlyAnalyticsPropertyType) {
    JtlyAnalyticsPropertyTypeUserSet,
    JtlyAnalyticsPropertyTypeUserSetOnce,
    JtlyAnalyticsPropertyTypeUserAdd,
};

/// 分析统计SDK
@interface JtlyAnalytics : NSObject
/// 单例
+(instancetype) shared;

#pragma mark - 初始化
/// 配置参数
@property (nonatomic, strong) JtlyAnalyticsConfig *config;

/// 刷新初始化参数
-(void) refreshConfiguration;


#pragma mark - 事件上报
/// 【新】上报事件（默认不是首次事件， 需要标记首次事件请用下面方法）。
/// @param eventName 事件名
/// @param values 参数值
-(void) taLogEvent:(NSString *)eventName
            values:(NSDictionary *)values;

/// 【新】上报事件
/// @param eventName 事件名
/// @param values 参数值
/// @param isFirstCheck  是否首次事件
/// @param firstCheckId  首次事件区别ID
-(void) taLogEvent:(NSString *)eventName
            values:(NSDictionary *)values
      isFirstCheck:(BOOL) isFirstCheck
      firstCheckId:(NSString *) firstCheckId;


/// 【新】设置用户属性
/// @param properties  属性值
/// @param type  属于哪种类型属性JtlyAnalyticsPropertyType
-(void) taSetUserProperties:(NSDictionary *) properties
                     byType:(JtlyAnalyticsPropertyType) type;


/// 【新】获取公共参数。用于游戏服务器使用相同的公共参数。
-(NSDictionary *) taPublicProperties;




/// 上报第三方自定义事件（支持AppsFlyer、Firebase、Facebook）
/// @param eventName 事件名
/// @param values 参数值
- (void)logThirdPartyCustomEvent:(NSString *)eventName values:(NSDictionary *)values;


#pragma mark - 其他可选功能
/// 设置自定义用户ID（注意：接入了主SDK， 不需要接入）
/// @param userID  自定义用户ID
-(void) setThirdPartyCustomUserID:(NSString *) userID;

/// 设置用户邮箱（注意：接入了主SDK， 不需要接入）
/// @param emailAddress 邮箱地址
- (void)setUserEmail:(NSString *)emailAddress;

/**
 返回版本号与构建号信息
 
 @return 版本信息
 */
-(NSString *) versionInfo;

/// 设备标识符
-(NSString *) cachedUUID;

//苹果系统idfa（广告ID）
-(NSString *) idfa;

//苹果系统idfv（广告商ID）
-(NSString *) idfv;

/// 渠道id
-(NSString *) channelId;

/// 经分系统渠道分类id
-(NSString *) channelSortId;


/// session id， 一个生命周期事件唯一id
-(NSString *) sessionId;

/// 设置广告拓展id（从剪贴板获取）
/// @param adExtendId 广告拓展id
- (void)setAdExtendId:(NSString *)adExtendId;

/// 获取服务器id
- (NSString *)serverId;

/// 获取角色id
- (NSString *)roleId;

/// 时长上报（SDK内部调用， 游戏如接入主SDK可忽略）
/// - Parameters:
///   - accountId: sdk 账号id
///   - realNameId: 实名id
///   - limitType: 限制类型
///   - intervalTs: 间隔秒数
///   - handler: 回调函数
-(void) onlineReportAccountId:(NSString *) accountId
            realNameId:(NSString *) realNameId
            limitType:(NSInteger) limitType
            intervalTs:(NSInteger) intervalTs
            handler:(void(^)(NSError *error, long long curDayDuration, long long totalDuration, long long currentTime)) handler;


/// ggbs接口（SDK内部调用， 游戏如接入主SDK可忽略）
/// - Parameters:
///   - params: 入参
///   - handler: 回调函数
-(void) ggbsParams:(NSDictionary *) params handler:(void(^)(NSError *error)) handler;



#pragma mark - 系统回调方法
///   启动完成回调
/// @param application UIApplication
/// @param launchOptions NSDictionary
-(BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/**
 外部App跳转回调（iOS9及以上系统）

 @param app 应用
 @param url url
 @param options 选项
 @return 是否处理成功
 */
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;

/**
 * 外部App跳转回调
 * @param application 应用
 * @param url url
 * @param sourceApplication 源应用
 * @param annotation 是
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;


/**
 * 外部App跳转回调
 * @param application 应用
 * @param url url
 */
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url;


/**
* 继续用户活动
* @param application 应用
* @param userActivity 用户活动
*/
- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *))restorationHandler;


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

-(void) application:(UIApplication *)application
handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)(void))completionHandler;
@end

