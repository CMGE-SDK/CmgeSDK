//
//  JtlyAnalyticsConfig.h
//  JtlyAnalyticsKit
//
//  Created by ly on 2021/8/27.
//

#import <Foundation/Foundation.h>
#import <JtlyAnalyticsKit/JtlyAnalyticsSdkInfo.h>

NS_ASSUME_NONNULL_BEGIN


@interface JtlyAnalyticsConfig : NSObject

/// 单例
+ (instancetype)shared;

/// 调试模式
@property (nonatomic, assign) BOOL debugMode;

/// 上报服务器地址
@property (nonatomic, copy) NSString *serverUrl;


#pragma mark - 游戏CP无需设置以下参数

/// 主SDK相关数据（一般情况下游戏无需设置）
@property (nonatomic, strong) JtlyAnalyticsSdkInfo *sdkInfo;


@end

NS_ASSUME_NONNULL_END
