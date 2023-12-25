//
//  JtlyAnalyticsSdkInfo.h
//  JtlyAnalyticsKit
//
//  Created by ly on 2022/3/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// SDK信息
@interface JtlyAnalyticsSdkInfo : NSObject

/// 服务器类型
@property (nonatomic, copy) NSString *sdkServerType;
/// 打包类型
@property (nonatomic, copy) NSString *sdkPackageType;
/// UI类型
@property (nonatomic, copy) NSString *sdkUiType;
/// 版本号
@property (nonatomic, copy) NSString *sdkVersion;
/// 构建号
@property (nonatomic, copy) NSString *sdkBuild;
/// 地区版本
@property (nonatomic, copy) NSString *sdkRegionVersion;
/// 屏幕方向
@property (nonatomic, copy) NSString *sdkViewOreintation;

@end

NS_ASSUME_NONNULL_END
