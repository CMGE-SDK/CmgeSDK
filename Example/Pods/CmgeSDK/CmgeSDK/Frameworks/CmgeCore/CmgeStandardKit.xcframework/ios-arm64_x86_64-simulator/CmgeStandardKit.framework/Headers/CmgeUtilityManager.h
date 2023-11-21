//
//  CmgeUtilityManager.h
//  CmgeKit
//
//  Created by ly on 2022/4/12.
//  Copyright © 2022 WakeyWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM (NSInteger, CmgeBindPageType){
    CmgeBindPageTypeBindIndex, //绑定首页
    CmgeBindPageTypeBindEmail  //绑定邮箱页面
};

/// 公共功能类
@interface CmgeUtilityManager : NSObject

/// 获取单例对象
+ (instancetype)shared;


#pragma mark - 用户服务
/// 打开用户中心
- (void)showUserCenter;

/// 打开游戏客服
- (void)showGameService;

/// 展示忘记密码页面
-(void) showForgetPasswordView;

/// 绑定手机
/// @param callback isSuccess 是否成功绑定
- (void)bindPhoneWithCallback:(nullable void(^)(BOOL isSuccess))callback;


#pragma mark - PC扫码登录支付
/// 扫描二维码
- (void)scanQRCode;


#pragma mark - WebView
/// 显示WebView
/// @param url 网页链接
/// @param closeCallback 关闭页面的回调
- (void)showWebViewWithUrl:(NSString *)url closeCallback:(void (^)(void))closeCallback;


#pragma mark - AppStore评分
/// 显示评分页面（苹果限制每年最多向用户展示3次，仅支持iOS10.3+）
- (void)showReviewView;

#pragma mark - 直播
/// 打开直播页面
/// - Parameter completion: 完成的回调（isSuccess：是否成功，error：错误信息）
- (void)openLivePage:(void (^)(BOOL isSuccess, NSError * _Nullable error))completion;

#pragma mark - 绑定邮箱、第三方相关
/// 检查绑定结果
/// @param resultCallback  结果回调， 相关绑定结果回调， error 为nil情况下result才有值。 返回Set，可能存在的值会有：EMAIL, APPLE, FACEBOOK, MOBILE
-(void) checkBindedResult:(void (^)(NSError * _Nullable error, NSSet * _Nullable bindedSet)) resultCallback;

/// 去相关页面绑定
/// @param bindPageType 绑定页面类型
/// @param resultCallback  结果回调， 相关绑定结果回调， error 为nil情况下result才有值
-(void) gotoBindPage:(CmgeBindPageType) bindPageType checkBindedResult:(void (^)(NSError * _Nullable error, NSSet *_Nullable bindedSet)) resultCallback;



#pragma mark - 隐私协议相关
/// 显示用户协议页面
- (void)showUserAgreementView;

/// 显示隐私政策页面
- (void)showPrivacyPolicyView;

#pragma mark - Firebase 推送（海外必接入）
/// 需要用SDK集成的Firebase 推送才调用此接口，用于注册推送通知， 监听各回调（注意iOS 10以上才能使用此功能）
/// - Parameters:
///   - afterGrandRegisterRemoteHandler: 点击同意或不同意返回的回调，一般用于处理多个权限申请的弹出顺序
///   - afterRegisterTokenHandler: 返回的设备token。一般不需要处理， 调试期间获取可调试使用
///   - receiveMessagePresentedHandler: 推送消息展示时回调。时机，一般只有前台消息弹出后。一般没特殊要求不处理。
///   - receiveMessageTouchedHandler: 点击推送消息时回调。时机，一般是点击时（不管前台后台）。一般没特殊要求不处理。
-(void) registerRemoteNotifictionWithGrantHandler:(void (^)(BOOL, NSError * _Nullable)) afterGrandRegisterRemoteHandler receiveTokenHandler:(void (^)(NSString * _Nonnull)) afterRegisterTokenHandler receiveMessagePresentedHandler: (void (^)(NSDictionary * _Nonnull)) receiveMessagePresentedHandler receiveMessageTouchedHandler: (void (^)(NSDictionary * _Nonnull)) receiveMessageTouchedHandler NS_AVAILABLE_IOS(10.0);
@end

NS_ASSUME_NONNULL_END
