//
//  CmgeURNManager.h
//  CmgeKit
//
//  Created by WakeyWoo on 2020/3/31.
//  Copyright © 2020 William. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CmgeNotifUserRealNameObject;

NS_ASSUME_NONNULL_BEGIN

//notificaiton
FOUNDATION_EXPORT NSString *const kCmgeURNUserInfoChangeNotification;
//data


typedef NS_ENUM(NSUInteger, CmgeUserRealNameStatus) {
    CmgeUserRealNameStatusAlreadyAuth, //已实名
    CmgeUserRealNameStatusNotAuth  //未实名
};

typedef void (^CmgeUserRealNameAuthHandler) (NSError * _Nullable error, CmgeUserRealNameStatus realNameStatus, CmgeNotifUserRealNameObject  * _Nullable realNameObj);

@interface CmgeNotifUserRealNameObject : NSObject
@property (nonatomic, copy) NSString *realNameId;
@property (nonatomic, copy) NSString *realNameStatus;
@property (nonatomic, assign) NSInteger age;
@end


@interface CmgeURNManager : NSObject


/// 去认证接口(可选接入)
/// @param callback 返回认证结果，error：错误  realNameStatus：实名状态 realNameObj：实名对象
+(void) gotoRealNameWithComplete:(CmgeUserRealNameAuthHandler _Nullable) callback;


/// 查询用户实名信息（可选接入）
/// @param callback  返回认证结果，error：错误  realNameStatus：实名状态 realNameObj：实名对象
+(void) checkUserRealNameStatusWithCallback:(CmgeUserRealNameAuthHandler _Nullable) callback;

///返回SDK是否开启防沉迷功能 （可选接入）。
/// @return 返回SDK是否开启防沉迷功能
+(BOOL) fetchIsAddiction;

#pragma mark - zf
//zf成功通知，谨慎接入！！！！ 请请咨询SDK人员方可介入！！！！
FOUNDATION_EXPORT NSString * const kCmgeZFResultSuccessNotification;
//zf失败通知，谨慎接入！！！！ 请请咨询SDK人员方可介入！！！！
FOUNDATION_EXPORT NSString * const kCmgeZFResultFailNotification;
/// 开始zhifu 谨慎接入！！！！ 请请咨询SDK人员方可介入！！！！
/// @param roleName 角色名
/// @param roleId 角色id
/// @param server 区服名称
/// @param serverId 区服id
/// @param fpId 计费点id
/// @param gName 商品名称
/// @param gDesc 商品描述
/// @param callBackInfo 厂商自定义回调参数
+ (void)zfRealNameAuthWithRoleName:(NSString *)roleName
                            roleId:(NSString *)roleId
                            server:(NSString *)server
                          serverId:(NSString *)serverId
                            cpOdId:(NSString *)cpOdId
                              fpId:(NSString *)fpId
                             gName:(NSString *)gName
                             gDesc:(NSString *)gDesc
                      callBackInfo:(NSString *)callBackInfo;




NS_ASSUME_NONNULL_END
@end

