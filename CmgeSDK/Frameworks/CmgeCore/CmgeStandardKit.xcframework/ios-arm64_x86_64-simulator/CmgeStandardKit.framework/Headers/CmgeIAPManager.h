//
//  CmgeIAPManager.h
//  CmgeKit
//
//  Created by WakeyWoo on 2020/7/13.
//  Copyright © 2020 WakeyWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Notify
FOUNDATION_EXPORT NSString * const kCmgeIAPResultSuccessNotification;
FOUNDATION_EXPORT NSString * const kCmgeIAPResultFailNotification;
FOUNDATION_EXPORT NSString * const kCmgeIAPRestoreSuccessNotification;
FOUNDATION_EXPORT NSString * const kCmgeShouldBuyPromotedProductNotification ;

#pragma mark - Data key
//iap


#pragma mark - Class

#pragma mark - 支付游戏数据
@interface CmgeIAPGameData : NSObject
@property (nonatomic, strong, nonnull) NSString * roleID; //角色id
@property (nonatomic, strong, nonnull) NSString * roleName; //角色名称
@property (nonatomic, strong, nonnull) NSString * serverID; //服务器id
@property (nonatomic, strong, nonnull) NSString * serverName; //服务器名
@property (nonatomic, strong, nullable) NSString * goodName;    //产品名称
@property (nonatomic, strong, nullable) NSString * goodDesc;    //产品描述
@end


#pragma mark - 中台游戏数据
/// 中台下单的游戏数据（特别注意：仅供中手游自研游戏使用）
@interface CmgeMPGameData : NSObject
@property (nonatomic, strong, nonnull) NSString * gameUID; //游戏ID
@property (nonatomic, strong, nonnull) NSString * itemID; //道具ID
@property (nonatomic, strong, nonnull) NSString * itemName; //道具名称
@property (nonatomic, strong, nonnull) NSString * roleID; //角色ID
@property (nonatomic, strong, nonnull) NSString * roleName; //角色名称
@property (nonatomic, strong, nonnull) NSString * serverID; //游戏服ID
@property (nonatomic, strong, nonnull) NSString * serverName; //服务器名称
@property (nonatomic, strong, nonnull) NSString * region; //地区（可选，有玩家选择地区功能时可传），按照国际标准组织ISO 3166中规范2位字母，香港 HK 澳门 MO  台湾 TW 新加坡 SG 马来西亚 MY  其他 ZZ 港澳做特殊处理用HKMO
@end


#pragma mark - 支付结果通知对象
@interface CmgeNotifIAPObject : NSObject
@property (nonatomic, strong) NSString *gameOrderId;
@property (nonatomic, strong) NSString *feePoint;
@property (nonatomic, strong) CmgeIAPGameData *gameData;
@end


#pragma mark - 产品信息
/// 产品信息model
@interface CmgeProductInfo : NSObject
/// 计费点id
@property (nonatomic, copy) NSString *feePointId;
/// 苹果产品id
@property (nonatomic, copy) NSString *productId;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 描述
@property (nonatomic, copy) NSString *desc;
/// 价格（单位分）
@property (nonatomic, assign) NSInteger money;
/// 币种（ISO 4217）
@property (nonatomic, copy) NSString *currency;
@end


#pragma mark - 支付接口类
@interface CmgeIAPManager : NSObject

/// 获取单例
+ (instancetype)sharedInstance;

///  开始支付
/// @param feePoint 计费点（向SDK运营人员索取）
/// @param gameOrderID   游戏订单号
/// @param gameData  游戏相关数据
/// @param callbackText  透传回传拓展参数
/// @param notifyServerUrl  支付回调地址，若未传已SDK后台配置为准， 若有传以传值为准
- (void)startIAPWithFeePoint:(NSString * _Nonnull) feePoint
                 gameOrderID:(NSString * _Nonnull) gameOrderID
                    gameData:(CmgeIAPGameData * _Nonnull) gameData
                callbackText:(NSString * _Nullable) callbackText
             notifyServerUrl:(NSString * _Nullable) notifyServerUrl;


/// 中台下单并支付（特别注意：仅供中手游自研游戏使用）
/// @param feePoint 计费点id
/// @param gameData 游戏相关数据
/// @param callbackText 回调文本
- (void)startOrderAndIAPWithFeePoint:(NSString * _Nonnull)feePoint
                            gameData:(CmgeMPGameData * _Nonnull)gameData
                        callbackText:(NSString * _Nullable)callbackText;


/// 回复购买
/// @param gameData 数据相关数据
- (void)restoreIAPWithGameData:(CmgeIAPGameData * _Nonnull) gameData;


/// 获取内购产品信息
/// @param feePointIdList 计费点id数组
/// @param completion 完成的回调
- (void)fetchProductInfo:(NSArray<NSString *> *)feePointIdList
              completion:(void (^)(NSError *error, NSArray<CmgeProductInfo *> *productInfoList))completion;


/// 检查兑换码交易
/// @param handler 兑换码交易处理，需要游戏按照正常支付流程，游戏下单、拉SDK支付。
- (void)checkPromoCodeTransaction:(void (^)(NSString *feePointId, NSString *productId))handler;

@end

NS_ASSUME_NONNULL_END
