//
//  JTLYDemoSdkManager.h
//  JTLYDemo
//
//  Created by ly on 2023/2/17.
//  Copyright © 2023 WakeyWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CmgeStandardKit/CmgeKit.h>
//#import <CmgeAdvanceKit/CmgeKit.h>
//#import <CmgeAdvanceLiteKit/CmgeKit.h>

/// SDK功能管理器
@interface JTLYDemoSdkManager : NSObject

/// 单例
+ (instancetype)shared;

/// SDK地区
@property (nonatomic, assign) CmgeRegionVersion sdkRegion;

/// SDK显示方向
@property (nonatomic, assign) CmgeScreenOrientation sdkOreintation;

/// 计费点id
@property (nonatomic, copy) NSString *feePointId;

/// 网页地址
@property (nonatomic, copy) NSString *webViewUrl;

/// 选中的事件序号
@property (nonatomic, assign) NSInteger selectedEventIndex;

/// 打印日志回调
@property (nonatomic, copy) void (^printLogHandler)(NSString *log);

/// 显示弹窗回调
@property (nonatomic, copy) void (^showAlertHandler)(NSString *title, NSString *message);

/// 显示toast回调
@property (nonatomic, copy) void (^showToastHandler)(NSString *text);

/// 显示ViewController
@property (nonatomic, copy) void (^presentViewControllerHandler)(UIViewController *);

/// 获取UI登录模式功能列表
- (NSArray *)getUIModeFunctionList;

/// 获取API登录模式功能列表
- (NSArray *)getApiModeFunctionList;

/// 获取埋点事件列表
- (NSArray *)getEventNameList;

/// 选中SDK功能
/// - Parameter functionName: 功能名称
- (void)selectFunction:(NSString *)functionName;

@end
