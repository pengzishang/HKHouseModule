/*******************************************************************************
 # File        : HKHouseDetailNavagitionView.m
 # Project     : ErpApp
 # Author      : rztime
 # Created     : 2017/12/15
 # Corporation : 成都好房通科技股份有限公司
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "HKHouseDetailNavagitionView.h"
#import "HKHouseCommon.h"
#import <HFTNavigation/HFTControllerManager.h>

@interface HKHouseDetailNavagitionView ()

@end

@implementation HKHouseDetailNavagitionView

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
    UIImageView *bacImg = [UIImageView new];
    bacImg.image = rzImage(@"详情页顶部蒙版@2x");
    [self addSubview:bacImg];
    [bacImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _titleLabel = [[UILabel alloc]init];
    [self addSubview:_titleLabel];
    _titleLabel.font = kFontSize6(17);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _backButton = [HFTControllerManager leftBarButtonItemWithTarget:self action:@selector(backPro)].customView;
    [self addSubview:_backButton];
    [_backButton setImage:rzImage(@"BackWhite") forState:UIControlStateNormal];
    _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_scanButton];
    [_scanButton setImage:rzImage(@"HouseDetailScan") forState:UIControlStateNormal];
    _scanButton.hidden = YES;
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_shareButton];
    [_shareButton setImage:rzImage(@"HouseDetailShare") forState:UIControlStateNormal];
    
    _storeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_storeButton];
    [_storeButton setImage:rzImage(@"HouseDetailStore") forState:UIControlStateNormal];
    [_storeButton setImage:rzImage(@"HouseDetailStored") forState:UIControlStateSelected];
    _storeButton.hidden = YES;
}

- (void)backPro {
    [[HFTControllerManager getCurrentAvailableNavController] popViewControllerAnimated:YES];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self.mas_bottom).offset(-22);
        make.width.equalTo(@44);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backButton);
        make.centerX.equalTo(self);
//        make.right.lessThanOrEqualTo(_storeButton.mas_left);
        make.right.lessThanOrEqualTo(_scanButton.mas_left);
    }];

    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(_backButton);
        make.width.height.equalTo(@30);
    }];
    
    [_storeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_shareButton.mas_left).offset(-10);
//        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(_backButton);
        make.width.height.equalTo(@30);
    }];
    
    [_scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_storeButton.mas_left).offset(-10);
//        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(_backButton);
        make.width.height.equalTo(@30);
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------


@end
