//
//  CmgeDemoViewController.m
//  CmgeDemo
//
//  Created by WakeyWoo on 2019/12/4.
//  Copyright © 2019 CMGE. All rights reserved.
//

#import "JTLYDemoViewController.h"
#import "JTLYDemoSdkManager.h"
//#import <AliyunLogProducer/AliyunLogProducer.h>
//#import <JtlyAnalyticsKit/JtlyAnalyticsKit.h>

//cell identifier
#define kFunctionCellID @"DemoFunctionCellID"

//userdefault
#define kUserDefaultsLoginMode @"kUserDefaultsLoginMode"
#define kUserDefaultsScreenDirection @"kUserDefaultsScreenDirection"
#define kUserDefaultsRegion @"kUserDefaultsRegion"

//打印log
#define JTLYDemoLog(format,...)                                           \
({                                                                    \
    printf("===DemoLog===:%s\n",[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String]); \
    [self printLog:[NSString stringWithFormat:(format), ##__VA_ARGS__]];               \
})              \


@interface JTLYDemoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *buttonsCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *projectConfigScrollView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *screenDirectionSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *regionSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sdkLoginModeSegControl;

@property (strong, nonatomic) IBOutlet UIView *configContainerView;
@property (weak, nonatomic) IBOutlet UITextView *logPrintTextView;
@property (weak, nonatomic) IBOutlet UITextField *feePointTF;
@property (weak, nonatomic) IBOutlet UITextField *webUrlTF;
@property (weak, nonatomic) IBOutlet UIPickerView *gameDataSelectPicker;

@property (nonatomic, assign) CmgeScreenOrientation gameOreintation;
@property (nonatomic, assign) CmgeRegionVersion gameRegion;

@property (nonatomic, assign) BOOL isApiLogin;

/// SDK功能列表
@property (nonatomic, strong) NSArray *functionList;
/// 埋点事件列表
@property (nonatomic, strong) NSArray *eventNameList;

@end

@implementation JTLYDemoViewController

#pragma mark - LifeCycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customLayoutUI];
    [self customConfigureUI];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger screenOrientationIndex = [userDefault integerForKey:kUserDefaultsScreenDirection];
    NSInteger regionIndex = [userDefault integerForKey:kUserDefaultsRegion];
    NSInteger sdkTypeIndex = [userDefault integerForKey:kUserDefaultsLoginMode];
    

    self.screenDirectionSegControl.selectedSegmentIndex = screenOrientationIndex;
    self.regionSegControl.selectedSegmentIndex = regionIndex;
    self.sdkLoginModeSegControl.selectedSegmentIndex = sdkTypeIndex;


    [self updateLayoutsOreintationLandscape:self.gameOreintation == CmgeScreenOreintationsLandscape ? YES : NO];
    
    //初始化数值
    self.feePointTF.text = (self.gameRegion == CmgeRegionChina)?@"10003101":@"23";//国内版10003101、海外版23
    self.webUrlTF.text = @"https://www.baidu.com";
    
    //设置功能列表
    if (self.isApiLogin) {
        self.functionList = [JTLYDemoSdkManager.shared getApiModeFunctionList];
    }
    else {
        self.functionList = [JTLYDemoSdkManager.shared getUIModeFunctionList];
    }
    
    //设置埋点事件列表
    self.eventNameList = [JTLYDemoSdkManager.shared getEventNameList];
    
    //设置SDK参数
    JTLYDemoSdkManager.shared.sdkOreintation = self.gameOreintation;
    JTLYDemoSdkManager.shared.sdkRegion = self.gameRegion;
    JTLYDemoSdkManager.shared.feePointId = self.feePointTF.text;
    JTLYDemoSdkManager.shared.webViewUrl = self.webUrlTF.text;
    JTLYDemoSdkManager.shared.selectedEventIndex = [self.gameDataSelectPicker selectedRowInComponent:0];
    JTLYDemoSdkManager.shared.printLogHandler = ^(NSString *log) {
        JTLYDemoLog(@"%@", log);
    };
    JTLYDemoSdkManager.shared.showAlertHandler = ^(NSString *title, NSString *message) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    };
    JTLYDemoSdkManager.shared.showToastHandler = ^(NSString *text) {
         UILabel *tipLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
        tipLB.text = text;
        tipLB.textColor = UIColor.whiteColor;
        tipLB.backgroundColor = UIColor.blackColor;
        tipLB.textAlignment = NSTextAlignmentCenter;
        tipLB.alpha = 0.7;
        tipLB.clipsToBounds = YES;
        CGFloat width = [tipLB sizeThatFits:CGSizeMake(MAXFLOAT, tipLB.frame.size.height)].width + 20;
        tipLB.frame = CGRectMake(0, 0, width, 50);
        tipLB.layer.cornerRadius = 5.0;
        tipLB.center = [UIApplication sharedApplication].keyWindow.center;
        [[UIApplication sharedApplication].keyWindow addSubview:tipLB];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tipLB removeFromSuperview];
        });
    };
    JTLYDemoSdkManager.shared.presentViewControllerHandler = ^(UIViewController *viewController) {
        [self presentViewController:viewController animated:YES completion:nil];
    };
    
    //KVO监听UI控件以更新SDK参数
    [self addObserver:self forKeyPath:@"feePointTF.text" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"webUrlTF.text" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"gameDataSelectPicker.text" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

-(UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    CmgeScreenOrientation orientation = [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsScreenDirection] == 0 ? CmgeScreenOreintationsLandscape : CmgeScreenOreintationsPortrait;
    if (orientation == CmgeScreenOreintationsLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

#pragma mark - Setter and Getter
-(CmgeRegionVersion) gameRegion
{
    return [self regionWithSegmentControlIndex:self.regionSegControl.selectedSegmentIndex];
}

-(CmgeScreenOrientation) gameOreintation
{
    return [self orientationWithSegmentControlIndex:self.screenDirectionSegControl.selectedSegmentIndex];
}

-(BOOL) isApiLogin
{
    return [self isApiLoginWithSegmentControlIndex:self.sdkLoginModeSegControl.selectedSegmentIndex];
}


#pragma mark - Public Fun

#pragma mark - Action and Selector
- (IBAction)saveProjConfigAction:(UIButton *)sender {
   
    //测试者模式
    //游戏中千万不要用此方法，可能会被拒审！！！
    [[NSUserDefaults standardUserDefaults] setInteger:self.screenDirectionSegControl.selectedSegmentIndex forKey:kUserDefaultsScreenDirection];
    [[NSUserDefaults standardUserDefaults] setInteger:self.regionSegControl.selectedSegmentIndex forKey:kUserDefaultsRegion];
    [[NSUserDefaults standardUserDefaults] setInteger:self.sdkLoginModeSegControl.selectedSegmentIndex forKey:kUserDefaultsLoginMode];

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功，已经重置！点击确定重启！" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        JTLYDemoLog(@"重新设置成功！！！！！");
        exit(0);
        
    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    

}

- (IBAction)screenDirectionChangeAction:(UISegmentedControl *)sender {
    //更新SDK参数
    JTLYDemoSdkManager.shared.sdkOreintation = self.gameOreintation;
}

- (IBAction)regioinChangeAction:(UISegmentedControl *)sender {
    //更新SDK参数
    JTLYDemoSdkManager.shared.sdkRegion = self.gameRegion;
}

- (IBAction)loginModeChangeAction:(UISegmentedControl *)sender {
    
}

- (IBAction)clearLog:(UIButton *)sender {
    self.logPrintTextView.text = nil;
}

- (void)functionDidSelected:(NSString *)functionName {
    JTLYDemoLog(@"Select function : %@", functionName);
    [JTLYDemoSdkManager.shared selectFunction:functionName];
}

#pragma mark - Private Helper
-(void) customConfigureUI
{
    self.buttonsCollectionView.delegate = self;
    self.buttonsCollectionView.dataSource = self;
    [self.buttonsCollectionView registerClass:[JTLYDemoCollectionViewCell class] forCellWithReuseIdentifier:kFunctionCellID];
    [self.projectConfigScrollView addSubview:self.configContainerView];
    self.feePointTF.delegate = self;
    self.webUrlTF.delegate = self;
    self.gameDataSelectPicker.delegate = self;
    self.gameDataSelectPicker.dataSource = self;
    
}

-(void) customLayoutUI
{
    
}

-(void) updateLayoutsOreintationLandscape:(BOOL) isLandscape
{
    [self removeAllContraintsWithView:self.buttonsCollectionView];
    [self removeAllContraintsWithView:self.projectConfigScrollView];
    
    if (isLandscape) {
        
        NSLayoutConstraint *buttonsTopConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *buttonsBottomConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        NSLayoutConstraint *buttonsLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsCollectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *buttonsWidthConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsCollectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0.0];
        
        self.buttonsCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:@[buttonsTopConstraint, buttonsBottomConstraint, buttonsLeadingConstraint, buttonsWidthConstraint]];
        
        NSLayoutConstraint *projectTopConstraint = [NSLayoutConstraint constraintWithItem:self.projectConfigScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *projectBottomConstraint = [NSLayoutConstraint constraintWithItem:self.projectConfigScrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        NSLayoutConstraint *projectTrainingConstraint = [NSLayoutConstraint constraintWithItem:self.projectConfigScrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *projectWidthConstraint = [NSLayoutConstraint constraintWithItem:self.projectConfigScrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.buttonsCollectionView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        
        self.projectConfigScrollView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:@[projectTopConstraint, projectBottomConstraint, projectTrainingConstraint, projectWidthConstraint]];
        
        self.configContainerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)/2.0, 734);
        self.projectConfigScrollView.contentSize = self.configContainerView.frame.size;
        
    } else {
        NSLayoutConstraint *buttonsTopConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
               NSLayoutConstraint *buttonsTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsCollectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
               NSLayoutConstraint *buttonsLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsCollectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
               
               NSLayoutConstraint *buttonsHeightConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0.0];
               
               self.buttonsCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
               [self.view addConstraints:@[buttonsTopConstraint, buttonsTrailingConstraint, buttonsLeadingConstraint, buttonsHeightConstraint]];
               
               NSLayoutConstraint *projectbottomConstraint = [NSLayoutConstraint constraintWithItem:self.projectConfigScrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
               NSLayoutConstraint *projectLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.projectConfigScrollView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
               NSLayoutConstraint *projectTrainingConstraint = [NSLayoutConstraint constraintWithItem:self.projectConfigScrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
               
               NSLayoutConstraint *projectHeightConstraint = [NSLayoutConstraint constraintWithItem:self.projectConfigScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.buttonsCollectionView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
               
               self.projectConfigScrollView.translatesAutoresizingMaskIntoConstraints = NO;
               [self.view addConstraints:@[projectbottomConstraint, projectLeadingConstraint, projectTrainingConstraint, projectHeightConstraint]];
               
               self.configContainerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)/2.0, 734);
        self.projectConfigScrollView.contentSize = self.configContainerView.frame.size;
    }
}

-(void) removeAllContraintsWithView:(UIView *) targetView
{
    UIView *superview = targetView.superview;
    while (superview != nil) {
       for (NSLayoutConstraint *c in superview.constraints) {
           if (c.firstItem == self || c.secondItem == self) {
               [superview removeConstraint:c];
           }
       }
       superview = superview.superview;
    }

   [targetView removeConstraints:targetView.constraints];
   targetView.translatesAutoresizingMaskIntoConstraints = YES;
}


-(CmgeScreenOrientation) orientationWithSegmentControlIndex:(NSInteger) index
{
    return index == 0 ? CmgeScreenOreintationsLandscape : CmgeScreenOreintationsPortrait;
}

-(CmgeRegionVersion) regionWithSegmentControlIndex:(NSInteger) index
{
    CmgeRegionVersion region = CmgeRegionChina;
    switch (index) {
        case 0:
            region = CmgeRegionChina;
            break;
        case 1:
            region = CmgeRegionOversea;
            break;
        default:
            break;
    }
    return region;
}

-(BOOL) isApiLoginWithSegmentControlIndex:(NSInteger) index
{
    if (index == 1) {
        return YES;
    }
    return NO;
}

-(CGSize) cellSizeWithText:(NSString *) text
{
    UIFont *font = [UIFont systemFontOfSize:19];
    NSDictionary *attributeDic = @{NSFontAttributeName:font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(100, 2000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributeDic context:NULL].size;
    return size;
}

-(void) printLog:(NSString *) textString
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.logPrintTextView.text = [weakSelf.logPrintTextView.text stringByAppendingFormat:@"%@\n", textString];
    });
}


#pragma mark - UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return NO;
}


#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.functionList[indexPath.row];
    static NSString *cellID = kFunctionCellID;
    JTLYDemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
     
    cell.backgroundView.backgroundColor = UIColor.greenColor;
    cell.titleLabel.text = title;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *functionName = self.functionList[indexPath.row];
    [self functionDidSelected:functionName];
    
}


#pragma mark - UICollectionViewDataSource
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.functionList.count;
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *function = self.functionList[indexPath.row];
//    [self cellSizeWithText:function];
    
    return CGSizeMake(150, 30);
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}


#pragma mark - UIPickerView
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.eventNameList.count;
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //事件显示名称
    NSString *eventDisplayName = self.eventNameList[row];
    return  [NSString stringWithFormat:@"%@ %@", @(row), eventDisplayName];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label){
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:18];
        label.adjustsFontSizeToFitWidth = YES;
    }
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //更新SDK参数
    JTLYDemoSdkManager.shared.selectedEventIndex = row;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //计费点id
    if ([keyPath isEqualToString:@"feePointTF.text"]) {
        //更新SDK参数
        JTLYDemoSdkManager.shared.feePointId = change[NSKeyValueChangeNewKey];
    }
    //网页地址
    else if ([keyPath isEqualToString:@"webUrlTF.text"]) {
        //更新SDK参数
        JTLYDemoSdkManager.shared.webViewUrl = change[NSKeyValueChangeNewKey];
    }
}

@end


#pragma mark - CollectionViewCell类
@interface JTLYDemoCollectionViewCell ()

@end

@implementation JTLYDemoCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [UILabel new];
        _titleLabel.frame = self.contentView.frame;
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _titleLabel.font = [UIFont systemFontOfSize:19.0];
        _titleLabel.backgroundColor = UIColor.greenColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)prepareForReuse
{
    [super prepareForReuse];
//    _titleLabel = [UILabel new];
//    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    _titleLabel.font = [UIFont systemFontOfSize:19.0];
//    _titleLabel.backgroundColor = UIColor.greenColor;
//    [self.contentView addSubview:_titleLabel];
    
}

@end
