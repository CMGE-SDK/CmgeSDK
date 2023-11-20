//
//  CmgeIDFAManager.h
//  CmgeIdentifierKit
//
//  Created by WakeyWoo on 2021/3/16.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CmgeIDFAStatus) {
    CmgeIDFAStatusValid,
    CmgeIDFAStatusATTNotDetermined,
    CmgeIDFAStatusATTRestricted,
    CmgeIDFAStatusATTDenied,
    CmgeIDFAStatusTrackingDisable,
    CmgeIDFAStatusUnknownInvalid
};

@interface CmgeIDFAManager : NSObject
@property (nonatomic, assign, readonly) CmgeIDFAStatus status;
@property (nonatomic, strong, readonly) NSString *idfa;
+(instancetype)shareInstance;

-(void) directRequestIDFAWithCompletionHandler:(void (^)(NSString *idfa, CmgeIDFAStatus status)) complete;
-(void) indirectGuideUserTurnOnIDFA;

@end

