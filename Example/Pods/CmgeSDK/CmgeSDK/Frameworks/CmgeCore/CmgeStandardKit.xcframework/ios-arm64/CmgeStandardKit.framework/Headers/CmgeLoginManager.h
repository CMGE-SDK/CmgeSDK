//
//  CmgeLoginManager.h
//  CmgeKit
//
//  Created by WakeyWoo on 2020/5/27.
//  Copyright © 2020 WakeyWoo. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

#pragma mark - Notify
FOUNDATION_EXPORT NSString *const kCmgeLoginSuccessNotification;
FOUNDATION_EXPORT NSString *const kCmgeExitLoginNotification;
FOUNDATION_EXPORT NSString *const kCmgeLogoutSuccessNotification;
#pragma mark - Data key
//login



@interface CmgeNotifLoginObject : NSObject
@property (nonatomic, strong) NSString *signValue; //sign值，需要服务器校验使用
@property (nonatomic, assign) long long loginTime; //登陆时间戳（毫秒）
@property (nonatomic, strong) NSString *userId; //SDK 用户id
@property (nonatomic, assign) BOOL isNewUser;   //是否新用户，新用户代表注册成功且登陆返回
@property (nonatomic, copy) NSString *token;   //用户token
@end

#pragma mark - Class
@interface CmgeLoginManager : NSObject
+(instancetype) shared;

/// 开始登陆
-(void) startLogin;


/// 登出账号
-(void) logoutAccount;

@end

NS_ASSUME_NONNULL_END
