//
//  CmgeShareManager.h
//  CmgeShareKit
//
//  Created by ly on 2023/10/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 分享平台枚举类型
typedef NS_ENUM(NSUInteger, CmgeSharePlatform) {
    CmgeSharePlatformFacebook,
    CmgeSharePlatformLine
};

@interface CmgeShareManager : NSObject

/// 获取单例对象
+ (instancetype)shared;

/// 分享图片
/// - Parameters:
///   - image: 图片内容
///   - platform: 分享平台
///   - completion: 结果回调
- (void)shareImage:(UIImage *)image platform:(CmgeSharePlatform)platform completion:(void (^)(BOOL isSuccess, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
