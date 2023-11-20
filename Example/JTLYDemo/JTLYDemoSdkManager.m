//
//  JTLYDemoSdkManager.m
//  JTLYDemo
//
//  Created by ly on 2023/2/17.
//  Copyright © 2023 WakeyWoo. All rights reserved.
//

#import "JTLYDemoSdkManager.h"
#import "JTLYDemoEventManager.h"
//#import "JTLYDemoAdHandler.h"
#import <WebKit/WebKit.h>
#import <CmgeIdentifierKit/CmgeIdentifierKit.h>
#import <JtlyAnalyticsKit/JtlyAnalyticsKit.h>
#import <CmgeShareKit/CmgeShareKit.h>
//#import <AppsFlyerLib/AppsFlyerLib.h>

//#define LITE

//function name define
#define kFunctionSdkInit @"SDK初始化"

//UI mode
#define kFunctionUILogin @"开始登录"
#define kFunctionUIPay @"IAP支付"
#define kFunctionUIMPPay @"中台支付"
#define kFunctionUIRestorePay @"恢复购买"
#define kFunctionUIGameDataTrack @"游戏数据上报"
#define kFunctionUIShowBindPhone @"显示绑定手机"
#define kFunctionUILogout @"登出账号"
#define kFunctionUIGotoAuth @"去实名"
#define kFunctionOpenUserCenter @"用户中心"
#define kFunctionGameCustomer @"游戏客服"
#define kFunctionShare @"分享"
#define kFunctionClearWebCache @"清除Web缓存"
#define kFunctionScanLogin @"扫码"
#define kFunctionShowAd @"显示广告"
#define kFunctionIndirectGuideIDFA @"二次引导idfa"
#define kFunctionShowWebView @"显示WebView"
#define kFunctionShowReviewView @"显示评分"
#define kFunctionDebugPanel @"调试面板"
#define kFunctionOpenLive @"打开直播"
#define kFunctionCheckBindedList @"查询绑定接口"
#define kFunctionGotoBindPage @"跳转绑定页面"
#define kFunctionFetchProductInfo @"内购产品信息"
#define kFunctionGrayEnv @"灰度环境"
#define kFunctionCheckPromoCode @"检查兑换码"
#define kFunctionTestRefund @"退款测试"
#define kFunctionShareFacebook @"Facebook分享"
#define kFunctionShareLine @"Line分享"

//Api mode
#define kFunctionAPILastLoginType @"上次登录类型"
#define kFunctionAPIAutoLogin @"自动登录"
#define kFunctionAPIGuestLogin @"游客登录"
#define kFunctionAPIFacebookLogin @"Facebook登录"
#define kFunctionAPIAppleLogin @"苹果登录"
#define kFunctionAPILineLogin @"Line登录"
#define kFunctionAPITwitterLogin @"Twitter登录"
#define kFunctionAPIGoogleWebLogin @"Google登录"
#define kFunctionAPIAccountLogin @"账密登录"
#define kFunctionAPIAccountRegister @"账密注册"
#define kFunctionAPIForgetPassword @"忘记密码"
#define kFunctionAPIUserAgreement @"用户协议"
#define kFunctionAPIPrivacyPolicy @"隐私政策"
#define kFunctionAPIUserCenter @"用户中心"
#define kFunctionAPILogout @"账号登出"
#define kFunctionAPIPay @"IAP支付"
#define kFunctionAPIDebugPanel @"调试面板"
#define kFunctionAPIBeforeSDKLoginAnnouncement  @"SDK登陆前公告"

//打印log
#define JTLYDemoLog(format,...)                                           \
({                                                                    \
    [self printLog:[NSString stringWithFormat:(format), ##__VA_ARGS__]];               \
})

@interface JTLYDemoSdkManager ()

/// 是否初始化成功
@property (nonatomic, assign) BOOL isInitSuccess;

/// 当前是否是中台支付
@property (nonatomic, assign) BOOL isMPPay;

@end

@implementation JTLYDemoSdkManager

+ (instancetype)shared {
    static JTLYDemoSdkManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[JTLYDemoSdkManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //监听通知
        [self setupUIModeObserver];
        [self setupAPIModeObserver];
    }
    return self;
}

#pragma mark - 功能列表获取
- (NSArray *)getUIModeFunctionList {
    return @[kFunctionSdkInit,
             kFunctionUILogin,
             kFunctionUIPay,
             kFunctionUIMPPay,
             kFunctionUIRestorePay,
             kFunctionUIGameDataTrack,
             kFunctionUIShowBindPhone,
             kFunctionUILogout,
             kFunctionUIGotoAuth,
             kFunctionOpenUserCenter,
             kFunctionGameCustomer,
             kFunctionShare,
             kFunctionClearWebCache,
             kFunctionScanLogin,
             kFunctionShowAd,
             kFunctionIndirectGuideIDFA,
             kFunctionShowWebView,
             kFunctionShowReviewView,
             kFunctionDebugPanel,
             kFunctionOpenLive,
             kFunctionCheckBindedList,
             kFunctionGotoBindPage,
             kFunctionFetchProductInfo,
             kFunctionGrayEnv,
             kFunctionCheckPromoCode,
             kFunctionTestRefund,
             kFunctionShareFacebook,
             kFunctionShareLine];
}

- (NSArray *)getApiModeFunctionList {
    return @[kFunctionSdkInit,
             kFunctionAPILastLoginType,
             kFunctionAPIAutoLogin,
             kFunctionAPIGuestLogin,
             kFunctionAPIFacebookLogin,
             kFunctionAPIAppleLogin,
             kFunctionAPILineLogin,
             kFunctionAPITwitterLogin,
             kFunctionAPIGoogleWebLogin,
             kFunctionAPIAccountLogin,
             kFunctionAPIAccountRegister,
             kFunctionAPIForgetPassword,
             kFunctionAPIUserAgreement,
             kFunctionAPIPrivacyPolicy,
             kFunctionAPIUserCenter,
             kFunctionAPILogout,
             kFunctionAPIPay,
             kFunctionAPIDebugPanel,
             kFunctionAPIBeforeSDKLoginAnnouncement];
}

- (NSArray *)getEventNameList {
    NSMutableArray *eventName = [NSMutableArray array];
    for (JTLYDemoEvent *event in JTLYDemoEventManager.shared.eventList) {
        [eventName addObject:event.displayName];
    }
    return eventName;
}

#pragma mark - SDK初始化
/// SDK初始化
- (void)sdkInit {
    //登陆
    CmgeConfigure *config = [CmgeConfigure new];
    #if DEBUG
        config.debugMode = YES;
    #else
        config.debugMode = NO;
    #endif
    
    //设置屏幕方向 横屏：CmgeScreenOreintationsLandscape 竖屏：CmgeScreenOreintationsPortrait
    config.orientation = self.sdkOreintation;
    //设置SDK地区版本：CmgeRegionChina国内版、CmgeRegionOversea海外版
    config.regionVersion = self.sdkRegion;
    //是否显示海外隐私协议弹窗。默认NO不显示。日本发行游戏必须设置为YES显示。
    config.isShowOverseaPrivacyAlert = YES;
    [CmgeConfigureManager startInitConfig:config completion:^(void) {
        self.isInitSuccess = YES;
        [self showToast:@"SDK初始化成功"];
        
        [[CmgeIDFAManager shareInstance] directRequestIDFAWithCompletionHandler:^(NSString *idfa, CmgeIDFAStatus status) {
            JTLYDemoLog(@"一启动就获取idfa:%@ status:%@", idfa, @(status));
            
            //接入海外Firebase推送才需要
            if (@available(iOS 10.0, *)) {
                [CmgeUtilityManager.shared registerRemoteNotifictionWithGrantHandler:^(BOOL granted, NSError * _Nullable error) {
                    if(granted) {
                        JTLYDemoLog(@"同意推送后做的事情");
                    } else {
                        JTLYDemoLog(@"注册推送错误:%@", error);
                    }
                } receiveTokenHandler:^(NSString * _Nonnull token) {
                    JTLYDemoLog(@"拿到token可以用于firebase特定设备测试推送:%@", token);
                } receiveMessagePresentedHandler:^(NSDictionary * _Nonnull userInfo) {
                    JTLYDemoLog(@"消息展示时机回调:%@", userInfo);
                } receiveMessageTouchedHandler:^(NSDictionary * _Nonnull userInfo) {
                    JTLYDemoLog(@"消息点击时机回调:%@", userInfo);
                }];
            }
            
            
        }];
    }];
    
    //查询sdk版本号
    JTLYDemoLog(@"SDK Version Info:%@", [CmgeConfigureManager sdkVersion]);
    
    //查询sdk是否开启防沉迷
    JTLYDemoLog(@"SDK isAddiction:%@", @([CmgeURNManager fetchIsAddiction]));
    
    //查询cachedUUID
    JTLYDemoLog(@"cachedUUID:%@",  [JtlyAnalytics.shared cachedUUID]);
    
    //查询渠道id
    JTLYDemoLog(@"SDK channelId:%@",  [JtlyAnalytics.shared channelId]);

    //查询渠道分类id
    JTLYDemoLog(@"SDK channelSortId:%@",  [JtlyAnalytics.shared channelSortId]);
    
    //查询渠道分类id
    JTLYDemoLog(@"SDK sessionId:%@",  [JtlyAnalytics.shared sessionId]);

    //提前设置则可打印所有调试信息
      #if DEBUG
        JtlyAnalytics.shared.config.debugMode = YES;
        //AppsFlyerLib.shared.isDebug = YES;
      #else
        //AppsFlyerLib.shared.isDebug = NO;
      #endif
}

#pragma mark - 执行SDK功能
- (void)selectFunction:(NSString *)functionName {
    //---------前面这些功能无需初始化---------
    if ([functionName isEqualToString:kFunctionSdkInit]) {
        //SDK初始化
        [self sdkInit];
    } else if ([functionName isEqualToString:kFunctionUIGameDataTrack]) {
        //上报事件
        NSArray<JTLYDemoEvent *> *eventList = JTLYDemoEventManager.shared.eventList;
        JTLYDemoEvent *event = eventList[self.selectedEventIndex];
        JTLYDemoLog(@"logEvent:%@, values:%@", event.eventName, event.parameters);
        if ([event.eventName isEqualToString:@"custom_event"]) {
            [JtlyAnalytics.shared logThirdPartyCustomEvent:event.eventName values:event.parameters];
        } else if ([event.eventName isEqualToString:@"test_user_set"]) {
            [JtlyAnalytics.shared taSetUserProperties:@{@"lastChargeMoney":@(12.2)} byType:JtlyAnalyticsPropertyTypeUserSet];
            [JtlyAnalytics.shared taSetUserProperties:@{@"lastChargeMoney":@(14.4)} byType:JtlyAnalyticsPropertyTypeUserSet];
        } else if ([event.eventName isEqualToString:@"test_user_once"]) {
            [JtlyAnalytics.shared taSetUserProperties:@{@"firstTimeChargeMoney":@(12.2)} byType:JtlyAnalyticsPropertyTypeUserSetOnce];
            [JtlyAnalytics.shared taSetUserProperties:@{@"firstTimeChargeMoney":@(14.4)} byType:JtlyAnalyticsPropertyTypeUserSetOnce];
        } else if ([event.eventName isEqualToString:@"test_user_add"]) {
            [JtlyAnalytics.shared taSetUserProperties:@{@"totalChargeMoney":@(12.2)} byType:JtlyAnalyticsPropertyTypeUserAdd];
        } else if ([event.eventName isEqualToString:@"test_public_property"]) {
            JTLYDemoLog(@"public_property is:%@", [JtlyAnalytics.shared taPublicProperties]);
        } else {
            //1.2以下使用。谨慎打开。
            //            [JtlyAnalytics.shared logEvent:event.eventName values:event.parameters];
            
            //            //TODO: 记得打开
            //1.2以上使用。
            [JtlyAnalytics.shared taLogEvent:event.eventName values:event.parameters];
        }
        
        
        //弹窗提示
        [self showAlert:event.displayName message:[NSString stringWithFormat:@"%@\n%@", event.eventName, event.parameters?:@""]];
        
    } else if ([functionName isEqualToString:kFunctionClearWebCache]) {
        NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                                   NSUserDomainMask, YES)[0];
        NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleIdentifier"];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        NSString *webKitFolderInCaches = [NSString
                                          stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
        NSString *webKitFolderInCachesfs = [NSString
                                            stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
        
        
        /* iOS9.0 WebView Cache的存放路径 */
        //// Optional data
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_0) {
            NSSet *websiteDataTypes
            = [NSSet setWithArray:@[
                WKWebsiteDataTypeDiskCache,
                //WKWebsiteDataTypeOfflineWebApplicationCache,
                WKWebsiteDataTypeMemoryCache,
                //WKWebsiteDataTypeLocalStorage,
                //WKWebsiteDataTypeCookies,
                //WKWebsiteDataTypeSessionStorage,
                //WKWebsiteDataTypeIndexedDBDatabases,
                //WKWebsiteDataTypeWebSQLDatabases,
                //WKWebsiteDataTypeFetchCache, //(iOS 11.3, *)
                //WKWebsiteDataTypeServiceWorkerRegistrations, //(iOS 11.3, *)
            ]];
            //// All kinds of data
            //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
            //// Date from
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            //// Execute
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
                // Done
            }];
        } else if(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_0) {
            NSError *error;
            /* iOS8.0 WebView Cache的存放路径 */
            [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
            [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
        } else {
            NSError *error;
            /* iOS7.0 WebView Cache的存放路径 */
            [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
        }
        
        [self showAlert:@"提示" message:@"清理成功"];
    } else if ([functionName isEqualToString:kFunctionShowWebView]) {
        if(self.webViewUrl.length > 0) {
            [CmgeUtilityManager.shared showWebViewWithUrl:self.webViewUrl closeCallback:^{
                JTLYDemoLog(@"网页已关闭");
            }];
        } else {
            [self showAlert:@"提示" message:@"请在URL填入有效的链接地址"];
        }
    } else if ([functionName isEqualToString:kFunctionIndirectGuideIDFA]) {
        JTLYDemoLog(@"二次引导前idfa:%@ status:%@", CmgeIDFAManager.shareInstance.idfa, @(CmgeIDFAManager.shareInstance.status));
        [CmgeIDFAManager.shareInstance indirectGuideUserTurnOnIDFA];
    } else if ([functionName isEqualToString:kFunctionShowReviewView]) {
        [CmgeUtilityManager.shared showReviewView];
    } else if ([functionName isEqualToString:kFunctionGrayEnv]) {
        BOOL isGrayEnv = [[NSUserDefaults standardUserDefaults] boolForKey:@"CmgeGrayEnv"];
        isGrayEnv = !isGrayEnv;
        [[NSUserDefaults standardUserDefaults] setBool:isGrayEnv forKey:@"CmgeGrayEnv"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self showToast:[NSString stringWithFormat:@"灰度环境：%@", isGrayEnv ? @"开" : @"关"]];
    } else if ([functionName isEqualToString:kFunctionCheckPromoCode]) {
        //角色登录后处理兑换码交易
        [self handlePromoCodeTransaction];
        [self showToast:@"开始监听兑换码交易，无需重复调用"];
    }
    else if ([functionName isEqualToString:kFunctionTestRefund]) {
        //退款测试，仅供SDK测试，游戏请勿调用！
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"退款测试"
                                                                                  message: @"请输入TransactionId"
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"TransactionId";
            textField.textColor = [UIColor blueColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleRoundedRect;
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *textField = alertController.textFields[0];
            Class aClass = NSClassFromString(@"CmgeStoreKitCoreManager");
            SEL method = NSSelectorFromString(@"beginRefundRequest:");
            [aClass performSelector:method withObject:textField.text afterDelay:1];
        }]];
        [self sdkPresentViewController:alertController];
    }
    //facebook分享
    else if ([functionName isEqualToString:kFunctionShareFacebook]) {
        UIImage *image = [UIImage imageNamed:@"jtly_ov_background_landscape.png"];
        if (@available(iOS 13.0, *)) {
            image = [UIImage systemImageNamed:@"moon"];
        }
        [CmgeShareManager.shared shareImage:image platform:CmgeSharePlatformFacebook completion:^(BOOL isSuccess, NSError * _Nonnull error) {
            JTLYDemoLog(@"fb分享%@ error: %@", isSuccess?@"成功":@"失败", error);
        }];
    }
    //line分享
    else if ([functionName isEqualToString:kFunctionShareLine]) {
        UIImage *image = [UIImage imageNamed:@"jtly_ov_background_landscape.png"];
        if (@available(iOS 13.0, *)) {
            image = [UIImage systemImageNamed:@"moon"];
        }
        [CmgeShareManager.shared shareImage:image platform:CmgeSharePlatformLine completion:^(BOOL isSuccess, NSError * _Nonnull error) {
            JTLYDemoLog(@"line分享%@ error: %@", isSuccess?@"成功":@"失败", error);
        }];
    }
    
    //---------后面这些功能必须先初始化---------
    else if (self.isInitSuccess == NO) {
        //未初始化提示
        [self showToast:@"请先进行SDK初始化"];
        return;
    }
    else if ([functionName isEqualToString:kFunctionUILogin]) {
        //登录界面
        [[CmgeLoginManager shared] startLogin];
    } else if ([functionName isEqualToString:kFunctionUIPay] || [functionName isEqualToString:kFunctionAPIPay]) {
        //IAP支付
        NSString *feePoint = self.feePointId; //(self.sdkRegion == CmgeRegionChina)?@"10003101":@"23";//国内版3、海外版23
        if (feePoint.length == 0) {
            [self showAlert:@"提示" message:@"请在计费点填入有效的值"];
            return;
        }
#ifdef LITE
        [CmgeURNManager zfRealNameAuthWithRoleName:@"role name"
                                            roleId:@"role id"
                                            server:@"server name"
                                          serverId:@"server id"
                                            cpOdId:@"r789e798r"
                                              fpId:feePoint
                                             gName:@"good name"
                                             gDesc:@"good desc"
                                      callBackInfo:@"callback text"];
        
#else
        
        // 非自研发游戏请用以下下单接口
        CmgeIAPGameData *gameData = [CmgeIAPGameData new];
        gameData.roleID = @"role id"; //角色id,必填
        gameData.roleName = @"role name"; //角色名字，必填
        gameData.serverID = @"server id";   //服务器id，必填
        gameData.serverName = @"server name";   //服务器名字，必填
        gameData.goodName = @"good name";   //商品名称，必填
        gameData.goodDesc = @"good desc";   //商品描述，可选
        [[CmgeIAPManager sharedInstance] startIAPWithFeePoint:feePoint gameOrderID:@"347893247981" gameData:gameData callbackText:@"callback text" notifyServerUrl:nil];
        
        //feePoint：是计费点ID，是纯数字的，咨询sdk人员
        //gameOrderID：游戏订单号
        //gameData：游戏数据
        //callbackText：回调字符串，用于游戏拓展验证
        //notifyServerUrl：支付回调地址，若未传已SDK后台配置为准， 若有传以传值为准
        
        //不是中台支付
        self.isMPPay = NO;
#endif
        
    } else if ([functionName isEqualToString:kFunctionUIMPPay]) {
#ifdef LITE
#else
        //中台支付
        NSString *feePoint = self.feePointId; //(self.sdkRegion == CmgeRegionChina) ? @"2502564" : @"23"
        if (feePoint.length == 0) {
            [self showAlert:@"提示" message:@"请在计费点填入有效的值"];
            return;
        }
        
        //以下支付接口仅供中手游自研游戏使用，有疑问请咨询运营。 sdk12345 sdk12345
        CmgeMPGameData *gameData = [CmgeMPGameData new];
        gameData.gameUID = (self.sdkRegion == CmgeRegionChina) ? @"22222152" : @"cggmtest"; //游戏id,必填
        gameData.itemID = @"11"; //道具id,必填 proID
        gameData.itemName = @"测试"; //道具名称,必填 proName
        gameData.roleID = @"test"; //角色id,必填
        gameData.roleName = @"role_name"; //角色名字，必填
        gameData.serverID = (self.sdkRegion == CmgeRegionChina) ? @"1005" : @"101"; //服务器id，必填
        gameData.serverName = (self.sdkRegion == CmgeRegionChina) ? @"格斗之夜" : @"内测1"; //服务器名字，必填
        gameData.region = @"HK";//地区（可选，有玩家选择地区功能时可传），按照国际标准组织ISO 3166中规范2位字母，香港 HK 澳门 MO  台湾 TW 新加坡 SG 马来西亚 MY  其他 ZZ 港澳做特殊处理用HKMO
        
        [[CmgeIAPManager sharedInstance] startOrderAndIAPWithFeePoint:feePoint
                                                             gameData:gameData
                                                         callbackText:@"cpExtendParam"];
        
        //feePoint：是计费点ID，是纯数字的，咨询sdk人员
        //gameData：游戏数据
        //callbackText：回调字符串，用于游戏拓展验证
        
        //中台支付
        self.isMPPay = YES;
#endif
        
    } else if ([functionName isEqualToString:kFunctionUIRestorePay]) {
        
    } else if ([functionName isEqualToString:kFunctionUIShowBindPhone]) {
        //绑定手机
        [CmgeUtilityManager.shared bindPhoneWithCallback:^(BOOL isSuccess) {
            JTLYDemoLog(@"是否成功绑定:%@", @(isSuccess));
        }];
    } else if ([functionName isEqualToString:kFunctionUILogout]) {
        //登出账号
        [CmgeLoginManager.shared logoutAccount];
        //登出账号提示
        //[self showAlert:@"提示" message:@"账号已登出"];
    } else if ([functionName isEqualToString:kFunctionUIGotoAuth]) {
        //去实名
        [CmgeURNManager gotoRealNameWithComplete:^(NSError *error, CmgeUserRealNameStatus realNameStatus, CmgeNotifUserRealNameObject *realNameObj) {
            if (error) {
                JTLYDemoLog(@"去实名错误:%@", error.debugDescription);
            } else {
                JTLYDemoLog(@"去实名结果为:%@ 对象为:%@", @(realNameStatus), realNameObj);
            }
        }];
        
    } else if ([functionName isEqualToString:kFunctionOpenUserCenter]) {
        //打开用户中心页面
        [CmgeUtilityManager.shared showUserCenter];
    } else if ([functionName isEqualToString:kFunctionGameCustomer]) {
        //打开客服页面
        [CmgeUtilityManager.shared showGameService];
    } else if ([functionName isEqualToString:kFunctionShare]) {
        
    } else if ([functionName isEqualToString:kFunctionScanLogin]) {
        [CmgeUtilityManager.shared scanQRCode];
    } else if ([functionName isEqualToString:kFunctionShowAd]) {
        //显示广告
        //[JTLYDemoAdHandler.shared showRewardVideoAd:self];
    } else if ([functionName isEqualToString:kFunctionDebugPanel]) {
        [self showDebugPanel];
    } else if ([functionName isEqualToString:kFunctionOpenLive]) {
        [[CmgeUtilityManager shared] openLivePage:^(BOOL isSuccess, NSError * _Nonnull error) {
            JTLYDemoLog(@"打开直播:%@ error:%@", @(isSuccess), error);
        }];
    } else if ([functionName isEqualToString:kFunctionCheckBindedList]) {
        [CmgeUtilityManager.shared checkBindedResult:^(NSError * _Nullable error, NSSet * _Nullable bindedSet) {
            NSString *checkString = [NSString stringWithFormat:@"检查绑定列表:%@ error:%@", bindedSet, error];
            JTLYDemoLog(@"%@", checkString);
            [self showAlert:@"Tips" message:checkString];
        }];
    } else if ([functionName isEqualToString:kFunctionGotoBindPage]) {
        [CmgeUtilityManager.shared gotoBindPage:CmgeBindPageTypeBindIndex checkBindedResult:^(NSError * _Nullable error, NSSet * _Nullable bindedSet) {
            NSString *checkString = [NSString stringWithFormat:@"检查绑定列表:%@ error:%@", bindedSet, error];
            JTLYDemoLog(@"%@", checkString);
            [self showAlert:@"Tips" message:checkString];
            
            //EMAIL, APPLE, FACEBOOK, MOBILE
            if([bindedSet containsObject:@"EMAIL"]) {
                JTLYDemoLog(@"绑定邮箱：%@", @"是的");
            }
        }];
    } else if ([functionName isEqualToString:kFunctionFetchProductInfo]) {
#ifdef LITE
#else
        // 获取内购产品信息（传入要查询的计费点id数组） 国内正式服：10003101、10003103、10003104  测试服：2501469、2501468、2501438  海外正式服：23、10002109、10002110
        NSArray *points = (self.sdkRegion == CmgeRegionChina) ? @[@"10003101", @"10003103", @"10003104"] : @[@"23", @"10002109", @"10002110"];
        [[CmgeIAPManager sharedInstance] fetchProductInfo:points completion:^(NSError * _Nonnull error, NSArray<CmgeProductInfo *> * _Nonnull productInfoList) {
            if (error == nil) {
                JTLYDemoLog(@"获取内购产品信息成功");
                for (CmgeProductInfo *productInfo in productInfoList) {
                    JTLYDemoLog(@"内购产品信息: %@", productInfo);
                }
            } else {
                JTLYDemoLog(@"获取内购产品信息失败, error: %@", error);
            }
        }];
#endif
    }
    //API登录（在调登录前，请确保已调SDK初始化接口！）
    else if ([functionName isEqualToString:kFunctionAPILastLoginType]) {
        CmgeApiLoginType loginType = [[CmgeApiLoginManager shared] getLastLoginType];
        NSString *loginTypeStr = @"未知";
        switch (loginType) {
            case CmgeApiLoginTypeInitial:
                loginTypeStr = @"初始的";
                break;
            case CmgeApiLoginTypeLogout:
                loginTypeStr = @"已登出";
                break;
            case CmgeApiLoginTypeGuest:
                loginTypeStr = @"游客";
                break;
            case CmgeApiLoginTypeFacebook:
                loginTypeStr = @"Facebook";
                break;
            case CmgeApiLoginTypeApple:
                loginTypeStr = @"Apple";
                break;
            case CmgeApiLoginTypeLine:
                loginTypeStr = @"Line";
                break;
            case CmgeApiLoginTypeTwitter:
                loginTypeStr = @"Twitter";
                break;
            case CmgeApiLoginTypeGoogleWeb:
                loginTypeStr = @"GoogleWeb";
                break;
            case CmgeApiLoginTypeAccount:
                loginTypeStr = @"Account";
                break;
            default:
                break;
        }
        JTLYDemoLog(@"API登录 上次登录类型: %@", loginTypeStr);
    } else if ([functionName isEqualToString:kFunctionAPIAutoLogin]) {
        [[CmgeApiLoginManager shared] autoLogin];
    } else if ([functionName isEqualToString:kFunctionAPIGuestLogin]) {
        [[CmgeApiLoginManager shared] loginWithType:CmgeApiLoginTypeGuest];
    } else if ([functionName isEqualToString:kFunctionAPIFacebookLogin]) {
        [[CmgeApiLoginManager shared] loginWithType:CmgeApiLoginTypeFacebook];
    } else if ([functionName isEqualToString:kFunctionAPIAppleLogin]) {
        [[CmgeApiLoginManager shared] loginWithType:CmgeApiLoginTypeApple];
    } else if ([functionName isEqualToString:kFunctionAPILineLogin]) {
        [[CmgeApiLoginManager shared] loginWithType:CmgeApiLoginTypeLine];
    } else if ([functionName isEqualToString:kFunctionAPITwitterLogin]) {
        [[CmgeApiLoginManager shared] loginWithType:CmgeApiLoginTypeTwitter];
    } else if ([functionName isEqualToString:kFunctionAPIGoogleWebLogin]) {
        [[CmgeApiLoginManager shared] loginWithType:CmgeApiLoginTypeGoogleWeb];
    } else if ([functionName isEqualToString:kFunctionAPIAccountLogin]) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Login"
                                                                                          message: @"Input account and password"
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"account";
                textField.textColor = [UIColor blueColor];
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.borderStyle = UITextBorderStyleRoundedRect;
            }];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"password";
                textField.textColor = [UIColor blueColor];
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.borderStyle = UITextBorderStyleRoundedRect;
                textField.secureTextEntry = YES;
            }];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSArray * textfields = alertController.textFields;
                UITextField * namefield = textfields[0];
                UITextField * passwordfiled = textfields[1];
                //NSLog(@"%@:%@",namefield.text,passwordfiled.text);
                [CmgeApiLoginManager.shared accountLoginWithAccount:namefield.text password:passwordfiled.text];
               
            }]];
        
        [self sdkPresentViewController:alertController];

    } else if ([functionName isEqualToString:kFunctionAPIAccountRegister]) {
        __weak typeof(self) weakSelf = self;
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Register"
                                                                                          message: @"Input account and password"
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"account";
                textField.textColor = [UIColor blueColor];
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.borderStyle = UITextBorderStyleRoundedRect;
            }];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"password";
                textField.textColor = [UIColor blueColor];
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.borderStyle = UITextBorderStyleRoundedRect;
                textField.secureTextEntry = YES;
            }];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSArray * textfields = alertController.textFields;
                UITextField * namefield = textfields[0];
                UITextField * passwordfiled = textfields[1];
                [CmgeApiLoginManager.shared accountRegisterWithAccount:namefield.text password:passwordfiled.text complete:^(NSError * _Nonnull error) {
                    if(error) {
                        NSString *tips = [NSString stringWithFormat:@"RegisterFail, error:%@", error.localizedDescription];
                        [weakSelf showAlert:@"注册失败" message:tips];
                        [weakSelf printLog:tips];
                    } else {
                        NSString *tips = [NSString stringWithFormat:@"RegisterSuccess, account:%@ password:%@", namefield.text, passwordfiled.text];
                        [weakSelf showAlert:@"注册成功" message:tips];
                        [weakSelf printLog:[NSString stringWithFormat:@"RegisterSuccess, account:%@ password:%@", namefield.text, passwordfiled.text]];
                    }
                }];
               
            }]];
            [self sdkPresentViewController:alertController];
    } else if ([functionName isEqualToString:kFunctionAPIForgetPassword]) {
        [CmgeUtilityManager.shared showForgetPasswordView];
    } else if ([functionName isEqualToString:kFunctionAPIUserAgreement]) {
        [CmgeUtilityManager.shared showUserAgreementView];
    } else if ([functionName isEqualToString:kFunctionAPIPrivacyPolicy]) {
        [CmgeUtilityManager.shared showPrivacyPolicyView];
    } else if ([functionName isEqualToString:kFunctionAPIUserCenter]) {
        [[CmgeUtilityManager shared] showUserCenter];
    } else if ([functionName isEqualToString:kFunctionAPILogout]) {
        [[CmgeApiLoginManager shared] logoutAccount];
    } else if ([functionName isEqualToString:kFunctionAPIDebugPanel]) {
        [self showDebugPanel];
    } else if ([functionName isEqualToString:kFunctionAPIBeforeSDKLoginAnnouncement]) {
        __weak typeof(self) weakSelf = self;
        [[CmgeApiLoginManager shared] showAlertBeforeLogin:^{
            [weakSelf showAlert:@"公告结束提示" message:@"不管成功后是否， 继续往下走SDK登陆流程"];
            [weakSelf printLog:@"不管成功后是否， 继续往下走SDK登陆流程"];
        }];
    }
}

-(void) setupUIModeObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:kCmgeLoginSuccessNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(exitLogin:)
                                                 name:kCmgeExitLoginNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutSuccess:)
                                                 name:kCmgeLogoutSuccessNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(realNameInfoChange:)
                                                 name:kCmgeURNUserInfoChangeNotification object:nil];
    
#ifdef LITE
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(iapSuccess:)
                                                 name:kCmgeZFResultSuccessNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(iapFailed:)
                                                 name:kCmgeZFResultFailNotification object:nil];
#else
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(iapSuccess:)
                                                 name:kCmgeIAPResultSuccessNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(iapFailed:)
                                                 name:kCmgeIAPResultFailNotification object:nil];
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(killApp:)
                                                 name:kCmgeKillAppNotification object:nil];
    
  

}

- (void)setupAPIModeObserver {
    //API登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apiLoginSuccess:)
                                                 name:kCmgeApiLoginSuccessNotification
                                               object:nil];
    //API登录失败的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apiLoginFail:)
                                                 name:kCmgeApiLoginFailNotification
                                               object:nil];
}

#pragma mark - Observer
//登陆成功
-(void)loginSuccess:(NSNotification *) notificaton
{
    JTLYDemoLog(@"===登陆成功回调信息===:\n");
    JTLYDemoLog(@"Login CallbackInfo:%@", notificaton.object);
    CmgeNotifLoginObject *loginObject = (CmgeNotifLoginObject *)notificaton.object;
    if (loginObject && [loginObject isKindOfClass:[CmgeNotifLoginObject class]] ) {
        JTLYDemoLog(@"成功的返回了登陆对象");
    }
}

//退出登录界面
-(void) exitLogin:(NSNotification *) notificaton
{
    //不返回对象
    JTLYDemoLog(@"退出登录界面");
}

//账号登出
-(void) logoutSuccess:(NSNotification *) notificaton
{
    //不返回对象
    JTLYDemoLog(@"登出账号成功");
    [self showAlert:@"提示" message:@"账号已登出"];
}

-(void) realNameInfoChange:(NSNotification *) notificaton
{
    JTLYDemoLog(@"实名信息更新");
    CmgeNotifUserRealNameObject *realNameObj = (CmgeNotifUserRealNameObject *)notificaton.object;
    if (realNameObj) {
        JTLYDemoLog(@"realNameObj:%@", realNameObj);
    }
}



//注册成功后的操作
-(void)regSuccess
{
    JTLYDemoLog(@"注册成功");
}

//支付成功后的操作
-(void)iapSuccess:(NSNotification *)notification
{
    JTLYDemoLog(@"===支付成功===:\n");
    
#ifndef LITE
    JTLYDemoLog(@"Charge Info:%@", notification.object);
#endif
}

//支付过程失败后的操作
-(void)iapFailed:(NSNotification *)notification
{
    JTLYDemoLog(@"===支付失败===:\n");
#ifndef LITE
    JTLYDemoLog(@"Charge Info:%@", notification.object);
#endif
}

//需要购买推广商品
- (void)shouldBuyPromotedProduct:(NSNotification *)notification {

}

-(void) killApp:(NSNotification *) notification {
    JTLYDemoLog(@"杀掉进程通知");
}

//---------API登录相关通知回调方法--------//
- (void)apiLoginSuccess:(NSNotification *)notify {
    id obj = notify.object;
    if (![obj isKindOfClass:[CmgeApiLoginInfo class]]) {
        return;
    }
    CmgeApiLoginInfo *loginInfo = (CmgeApiLoginInfo *)obj;
    NSString *userId = loginInfo.userId;
    long long loginTime = loginInfo.loginTime;
    NSString *sign = loginInfo.signValue;
    BOOL isNewAccount = loginInfo.isNewUser;
    NSString *token = loginInfo.token;
    
    JTLYDemoLog(@"%@", [NSString stringWithFormat:@"API登录成功 \n signValue:%@ loginedTime:%@ userId:%@ isNewUser:%@ token:%@", sign, @(loginTime), userId, @(isNewAccount), token]);
    //[self showAlert:@"结果提示" message:[NSString stringWithFormat:@"API登录成功 \n %@", loginInfo]];
    [self showToast:@"API登录成功"];
}

- (void)apiLoginFail:(NSNotification *)notify {
    id obj = notify.object;
    if (![obj isKindOfClass:[NSError class]]) {
        return;
    }
    NSError *error = (NSError *)obj;
    JTLYDemoLog(@"%@", [NSString stringWithFormat:@"API登录失败 \n %@", error]);
    JTLYDemoLog(@"游戏打印错误本地化文本：%@", error.localizedDescription);
    //[self showAlert:@"结果提示" message:[NSString stringWithFormat:@"API登录失败 \n error is:%@", error]];
    [self showToast:@"API登录失败"];
}

#pragma mark - 兑换码
//处理兑换码交易（需要角色已登录）
- (void)handlePromoCodeTransaction {
#ifdef LITE
#else
    //检查兑换码订单（请游戏在角色登录后自动调用该方法）
    [[CmgeIAPManager sharedInstance] checkPromoCodeTransaction:^(NSString * _Nonnull feePointId, NSString * _Nonnull productId) {
        JTLYDemoLog(@"存在兑换码订单");
        //游戏内提示（游戏自行决定提示样式）
        [self showAlert:@"提示" message:@"正在兑换礼包，请注意查收"];
        
        //游戏下单
        //...
        
        //拉起SDK支付
        if (!self.isMPPay) {
            // 非自研发游戏请用以下下单接口
            CmgeIAPGameData *gameData = [CmgeIAPGameData new];
            gameData.roleID = @"role id"; //角色id,必填
            gameData.roleName = @"role name"; //角色名字，必填
            gameData.serverID = @"server id";   //服务器id，必填
            gameData.serverName = @"server name";   //服务器名字，必填
            gameData.goodName = @"good name";   //商品名称，必填
            gameData.goodDesc = @"good desc";   //商品描述，可选
            [[CmgeIAPManager sharedInstance] startIAPWithFeePoint:feePointId gameOrderID:@"1234567890" gameData:gameData callbackText:@"callback text" notifyServerUrl:nil];
            
            //feePoint：是计费点ID，是纯数字的，咨询sdk人员
            //gameOrderID：游戏订单号
            //gameData：游戏数据
            //callbackText：回调字符串，用于游戏拓展验证
            //notifyServerUrl：支付回调地址，若未传已SDK后台配置为准， 若有传以传值为准
        }
        else {
            //以下支付接口仅供中手游自研游戏使用，有疑问请咨询运营。 sdk12345 sdk12345
            CmgeMPGameData *gameData = [CmgeMPGameData new];
            gameData.gameUID = (self.sdkRegion == CmgeRegionChina) ? @"22222152" : @"cggmtest"; //游戏id,必填
            gameData.itemID = @"11"; //道具id,必填 proID
            gameData.itemName = @"测试"; //道具名称,必填 proName
            gameData.roleID = @"test"; //角色id,必填
            gameData.roleName = @"role_name"; //角色名字，必填
            gameData.serverID = (self.sdkRegion == CmgeRegionChina) ? @"1005" : @"101"; //服务器id，必填
            gameData.serverName = (self.sdkRegion == CmgeRegionChina) ? @"格斗之夜" : @"内测1"; //服务器名字，必填
            gameData.region = @"HK";//地区（可选，有玩家选择地区功能时可传），按照国际标准组织ISO 3166中规范2位字母，香港 HK 澳门 MO  台湾 TW 新加坡 SG 马来西亚 MY  其他 ZZ 港澳做特殊处理用HKMO

            [[CmgeIAPManager sharedInstance] startOrderAndIAPWithFeePoint:feePointId
                                                                 gameData:gameData
                                                             callbackText:@"cpExtendParam"];
            
            //feePoint：是计费点ID，是纯数字的，咨询sdk人员
            //gameData：游戏数据
            //callbackText：回调字符串，用于游戏拓展验证
        }
    }];
#endif
}

#pragma mark - tools
//打印日志
- (void)printLog:(NSString *)text {
    if (self.printLogHandler) {
        self.printLogHandler(text);
    }
}

//显示弹窗
- (void)showAlert:(NSString *)title message:(NSString *)message {
    if (self.showAlertHandler) {
        self.showAlertHandler(title, message);
    }
}

//显示toast
- (void)showToast:(NSString *)text {
    if (self.showToastHandler) {
        self.showToastHandler(text);
    }
}

-(void) sdkPresentViewController:(UIViewController *) viewController {
    if(self.presentViewControllerHandler) {
        self.presentViewControllerHandler(viewController);
    }
}

/// 显示调试面板（游戏无需调用，仅用于SDK调试）
- (void)showDebugPanel {
    Class aClass = NSClassFromString(@"CmgeTools");
    if (aClass && [aClass respondsToSelector:@selector(showDebugPanel)]) {
        [aClass performSelector:@selector(showDebugPanel)];
    }
}

@end
