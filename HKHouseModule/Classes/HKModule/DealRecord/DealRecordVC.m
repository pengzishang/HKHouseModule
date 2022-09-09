//
//  DealRecordVC.m
//  ErpApp
//
//  Created by midland on 2022/8/12.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "DealRecordVC.h"
#import "DealRecordViewModel.h"
#import "HKHouseCommon.h"
#import "FormView.h"
#import <HFTCategroy/UIButton+Layout.h>
#import "DealZuoshuActionSheet.h"

#define kTopContentHeight 75

/// 成交记录
@interface DealRecordVC ()

@property (nonatomic, strong)DealRecordViewModel *dealRecordViewModel;
@property (nonatomic, strong)FormView *formView;

@property (nonatomic, strong)UIButton *titleButton;
/// 顶部容器视图
@property (nonatomic, strong)UIView *topContainerView;
@property (nonatomic, strong)UILabel *zuoLabel;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UILabel *tipLable;
@property (nonatomic, strong)UILabel *floorLable;

@end

@implementation DealRecordVC

- (instancetype)initWithEstateId:(NSString *)estateId {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.estateId = estateId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createDefaultData];
    
    [self createUI];
    
    [self requestData];
}

- (void)createUI {
    
    self.navigationItem.titleView = self.titleButton;
    @weakify(self);
    [self.titleButton bk_whenTapped:^{
        @strongify(self);
        NSArray *array = @[@[@"选择期数:"],
                           self.dealRecordViewModel.communityBuilds,
                           @[@"选择座数:"],
                           @[@""]];
        [DealZuoshuActionSheet showDealZuoshuSheetWithTitle:@"" cancelTitle:@"取消" determinelTitle:@"确定" dataArray:array selectIndex:0 determineActionBlock:^(NSInteger row0, NSInteger row1, NSInteger row2, NSInteger row3) {
            
//            NSLog(@"选中的期数-%@,选中的座落-%@",self.dealRecordViewModel.communityBuilds[row1].phaseName, self.dealRecordViewModel.communityBuilds[row1].buildVos[row3].buildingName);
            
            NSString *phaseName = self.dealRecordViewModel.communityBuilds[row1].phaseName;
            NSString *buildingName =  self.dealRecordViewModel.communityBuilds[row1].buildVos[row3].buildingName;
            [self.titleButton setTitle:[NSString stringWithFormat:@"%@%@", phaseName, buildingName] forState:UIControlStateNormal];
            [self.titleButton setLayout:ButtonLayoutRight spacing:5];
            
            [self requestDealRecordWithBuildID:self.dealRecordViewModel.communityBuilds[row1].buildVos[row3].buildingId phaseID:self.dealRecordViewModel.communityBuilds[row1].phaseId];
        } cancleActionBlock:^{
        }];
    }];
    
    [self createTopView];
    
    [self.view addSubview:self.formView];
}

- (void)createTopView {
    self.topContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kTopContentHeight)];
    self.topContainerView.backgroundColor = HEX_RGB(0xF9f9f9);
    [self.view addSubview:self.topContainerView];
    
    [self.topContainerView addSubview:self.zuoLabel];
    [self.topContainerView addSubview:self.tipLable];
    [self.topContainerView addSubview:self.floorLable];
    
    [self.zuoLabel addSubview:self.lineView];
    
    
    [self.zuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(35);
    }];
    
    [self.tipLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.right.mas_equalTo(-15);
    }];
    
    [self.floorLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zuoLabel.mas_bottom);
        make.height.mas_equalTo(40);
        make.left.right.equalTo(self.topContainerView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(3);
        make.bottom.left.right.equalTo(self.zuoLabel);
    }];
    
}

- (void)createDefaultData {
    self.dealRecordViewModel = [[DealRecordViewModel alloc] init];
}

- (void)requestDealRecordWithBuildID:(NSString *)buildId phaseID:(NSString *)phaseID {
    [self.dealRecordViewModel requestTradRecordWithEstateId:self.estateId buildingId:buildId phaseId:phaseID result:^(NSError * _Nonnull error) {
        
        self.formView.dealRecordModels = self.dealRecordViewModel.dealRecordModels;
        self.zuoLabel.text = [NSString stringWithFormat:@"%@-%@",self.dealRecordViewModel.dealRecord.flatMin,self.dealRecordViewModel.dealRecord.flatMax];
        
        if (error) {
            [HFTHud showWarnMessage:error.domain];
            if (self.formView.dealRecordModels.count == 0) {
                [HFTNoNetOrDataWarmingView showWithMessage:error.domain toView:self.view tag:ViewWithTypeNoNet handle:^{
                    [self requestDealRecordWithBuildID:buildId phaseID:phaseID];
                }];
            }
            return;
        }else if (self.formView.dealRecordModels.count == 0) {
            [HFTNoNetOrDataWarmingView showWithMessage:@"暂无数据" toView:self.view tag:ViewWithTypeNoData handle:^{
                [self requestDealRecordWithBuildID:buildId phaseID:phaseID];
            }];
        }
    }];
}

- (void)requestData {
    RZShowLoadingView;
    [self.dealRecordViewModel searchTradRecordConditionWithEstateId:self.estateId result:^(NSError * _Nonnull error) {
        RZHideLoadingView;
        if (!error) {
            
            NSString *phaseName = self.dealRecordViewModel.communityBuilds.firstObject.phaseName;
            NSString *buildingName =  self.dealRecordViewModel.communityBuilds.firstObject.buildVos.firstObject.buildingName;
            [self.titleButton setTitle:[NSString stringWithFormat:@"%@%@", phaseName, buildingName] forState:UIControlStateNormal];
            [_titleButton setLayout:ButtonLayoutRight spacing:5];
//            [self setTitleButtonTitleWithBuildName:buildingName phaseName:phaseName];
            
            
            NSString *phaseId = self.dealRecordViewModel.communityBuilds.firstObject.phaseId;
            NSString *buildingId =  self.dealRecordViewModel.communityBuilds.firstObject.buildVos.firstObject.buildingId;
            
            [self requestDealRecordWithBuildID:buildingId phaseID:phaseId];
        }
    }];
}

- (void)setTitleButtonTitleWithBuildName:(NSString *)buildName phaseName:(NSString *)phaseName {
    
    
}

- (FormView *)formView {
    if (!_formView) {
        _formView = [[FormView alloc] initWithFrame:CGRectMake(0, kTopContentHeight, kScreenWidth, kScreenHeight-kNavHeight-kTopContentHeight)];
    }
    return _formView;
}

- (UIButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(0, 0, 200, 30);
        [_titleButton setTitle:@"天晋2期2A座" forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_titleButton setImage:rzImage(@"jiantou") forState:UIControlStateNormal];
        [_titleButton setLayout:ButtonLayoutRight spacing:5];
    }
    return _titleButton;
}

- (UILabel *)zuoLabel {
    if (!_zuoLabel) {
        _zuoLabel = [[UILabel alloc]init];
        _zuoLabel.text = @"A-D";
        _zuoLabel.font = kFontBoldSize6(13);
    }
    return _zuoLabel;
}

- (UILabel *)tipLable {
    if (!_tipLable) {
        _tipLable = [[UILabel alloc]init];
        _tipLable.textAlignment = NSTextAlignmentRight;
        _tipLable.text = @"*近一年成交记录";
        _tipLable.font = kFontSize6(10);
        _tipLable.textColor = HEX_RGB(0x333333);

    }
    return _tipLable;
}

- (UILabel *)floorLable {
    if (!_floorLable) {
        _floorLable = [[UILabel alloc]init];
        _floorLable.backgroundColor = [UIColor whiteColor];
        _floorLable.text = @"  楼层";
        _floorLable.font = kFontSize6(13);
        _floorLable.textColor = HEX_RGB(0x666666);
    }
    return _floorLable;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor blackColor];
    }
    return _lineView;
}


@end
