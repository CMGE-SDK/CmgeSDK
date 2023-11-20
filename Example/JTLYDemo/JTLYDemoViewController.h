//
//  CmgeDemoViewController.h
//  CmgeDemo
//
//  Created by WakeyWoo on 2019/12/4.
//  Copyright © 2019 CMGE. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JTLYDemoCollectionViewCell;

NS_ASSUME_NONNULL_BEGIN

@interface JTLYDemoViewController : UIViewController

@end

@interface JTLYDemoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *cellTag;
@end

NS_ASSUME_NONNULL_END
