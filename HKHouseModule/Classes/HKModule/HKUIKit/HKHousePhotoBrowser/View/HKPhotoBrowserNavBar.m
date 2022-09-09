/*******************************************************************************
 # File        : PhotoBrowserNavBar.m
 # Project     : ErpApp
 # Author      : rztime
 # Created     : 2017/12/23
 # Corporation : 成都好房通科技股份有限公司
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "HKPhotoBrowserNavBar.h"
#import "HKHouseCommon.h"
#import <HFTNavigation/HFTControllerManager.h>
#import <RTRootNavigationController/RTRootNavigationController.h>
@interface HKPhotoBrowserNavBar ()

@end

@implementation HKPhotoBrowserNavBar

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化默认数据
        [self createDefaultData];
        // 初始化界面
        [self createUI];
        // 布局界面
        [self createConstraints];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createUI {
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    [self addSubview:_titleLabel];
    
    _titleLabel.font = kFontSize6(16);
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.center = ({
        CGPoint center = CGPointMake(kScreenWidth / 2, kNavHeight - 22);
        center;
    });
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_backButton];
    _backButton.frame = CGRectMake(0, 0, 50, 44);
    // 让按钮内部的所有内容左对齐
    _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //        [button sizeToFit];
    // 让按钮的内容往右边偏移3
    _backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    [_backButton setImage:rzImage(@"BackWhite") forState:UIControlStateNormal];
    _backButton.center = ({
        CGPoint center = CGPointMake(35, kNavHeight - 22);
        center;
    });

    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_rightButton];
    _rightButton.frame = CGRectMake(0, 0, 50, 44);
    [_rightButton setImage:rzImage(@"RZPhotoAll") forState:UIControlStateNormal];
    _rightButton.center = ({
        CGPoint center = CGPointMake(kScreenWidth - 35, kNavHeight - 22);
        center;
    });
}

#pragma mark - 布局界面
- (void)createConstraints {
        
}

#pragma mark ----------------------------- 公用方法 ------------------------------

@end
