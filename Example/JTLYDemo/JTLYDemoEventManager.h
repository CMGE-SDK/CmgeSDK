//
//  JTLYDemoEventManager.h
//  JTLYDemo
//
//  Created by ly on 2022/4/1.
//  Copyright © 2022 WakeyWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JTLYDemoEvent;

/// 埋点事件管理器
@interface JTLYDemoEventManager : NSObject

/// 单例
+ (instancetype)shared;

@property (nonatomic, strong, readonly) NSMutableArray<JTLYDemoEvent *> *eventList;

@end


/// 事件类
@interface JTLYDemoEvent : NSObject

- (instancetype)initWithDisplayName:(NSString *)displayName eventName:(NSString *)eventName parameters:(NSDictionary *)parameters;
/// 显示名称
@property (nonatomic, copy, readonly) NSString *displayName;
/// 事件名称
@property (nonatomic, copy, readonly) NSString *eventName;
/// 事件参数
@property (nonatomic, strong, readonly) NSDictionary *parameters;

@end
