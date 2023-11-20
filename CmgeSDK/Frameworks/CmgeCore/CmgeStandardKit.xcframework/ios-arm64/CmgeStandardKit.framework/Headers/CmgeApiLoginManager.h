//
//  CmgeApiLoginManager.h
//  CmgeKit
//
//  Created by ly on 2021/10/12.
//  Copyright © 2021 WakeyWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// API登录成功通知
FOUNDATION_EXPORT NSString *const kCmgeApiLoginSuccessNotification;
/// API登录失败通知
FOUNDATION_EXPORT NSString *const kCmgeApiLoginFailNotification;
/// API登出成功通知
FOUNDATION_EXPORT NSString *const kCmgeApiLogoutSuccessNotification;

/// API 自动登陆失败类型
FOUNDATION_EXPORT NSString *const kCmgeAPILoginAutoLoginErrorDomain;

//API登录类型
typedef NS_ENUM(NSUInteger, CmgeApiLoginType) {
    CmgeApiLoginTypeInitial,//初始的（未进行过登录）
    CmgeApiLoginTypeLogout,//已登出
    CmgeApiLoginTypeGuest,//游客登录
    CmgeApiLoginTypeFacebook,//Facebook登录
    CmgeApiLoginTypeApple,//Apple登录
    CmgeApiLoginTypeLine,//Line登录
    CmgeApiLoginTypeTwitter,//Twitter登录
    CmgeApiLoginTypeGoogleWeb,//GoogleWeb登录
    CmgeApiLoginTypeAccount, //账密登陆
};

/// API登录信息
@interface CmgeApiLoginInfo : NSObject
@property (nonatomic, copy) NSString *signValue; //sign值，需要服务器校验使用
@property (nonatomic, assign) long long loginTime; //登陆时间戳（毫秒）
@property (nonatomic, copy) NSString *userId; //SDK 用户id
@property (nonatomic, assign) BOOL isNewUser;   //是否新用户，新用户代表注册成功且登陆返回
@property (nonatomic, copy) NSString *token;   //用户token
@end

/// API登录
@interface CmgeApiLoginManager : NSObject

+ (instancetype)shared;

/// 获得上次登录类型
- (CmgeApiLoginType)getLastLoginType;

/// 自动登录
- (void)autoLogin;

/// 根据类型登录
/// @param type 登录类型
- (void)loginWithType:(CmgeApiLoginType)type;

/// 登出账号
- (void)logoutAccount;


/// 账号密码登陆API接口， 回调都统一通过登陆成功与登陆失败
/// - Parameters:
///   - account: 账号
///   - password: 密码
-(void) accountLoginWithAccount:(NSString *) account password:(NSString *) password;


/// 账号密码注册API接口
/// - Parameters:
///   - account: 账号
///   - password: 密码
///   - completion: 是否成功回调
-(void) accountRegisterWithAccount:(NSString *) account password:(NSString *) password complete:(void(^)(NSError *error))completion;



/// SDK登录前显示拍脸图和公告（API登录专属）
/// - Parameter finishedHandler: 完成回调。不管是否成功，回调回来就必须往下走。
-(void) showAlertBeforeLogin:(void(^)(void))finishedHandler;

@end

NS_ASSUME_NONNULL_END
