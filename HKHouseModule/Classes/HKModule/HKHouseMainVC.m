//
//  HKHouseMainVC.m
//  ErpApp
//
//  Created by midland on 2022/7/14.
//

#import "HKHouseMainVC.h"
#import "HKHouseCommon.h"
#import "HKNewHouseVC.h"
#import "HKCommunityListVC.h"
#import "HKHouseUtil.h"

@interface HKHouseMainVC ()

@property (nonatomic, strong) CommonSegmentControl *segmentControl;

/// 容器
@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) NSArray *titles;
/// 新房
@property (nonatomic, strong) HKNewHouseVC *newHouseVC;
/// 小区
@property (nonatomic, strong) HKCommunityListVC *communityListVC;


@end

@implementation HKHouseMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titles = @[@"香港新房", @"香港小区"];
    
    [self setupUI];
    [[HKHouseUtil shareManager] getRateCompletion:^(NSNumber * _Nonnull rate) {
            
    }];
    self.segmentControl.selectedIndex = 0;
}

- (void)setupUI {
    self.navigationItem.titleView = self.segmentControl;
    [self.view addSubview:self.contentView];

    [self addChildViewController:self.newHouseVC];
    [self.contentView addSubview:self.newHouseVC.view];
    self.newHouseVC.view.frame = CGRectMake(0, 0, self.view.width, kScreenHeight-kNavHeight);
//
    [self addChildViewController:self.communityListVC];
    [self.contentView addSubview:self.communityListVC.view];
    self.communityListVC.view.frame = CGRectMake(self.view.width, 0, self.view.width, kScreenHeight-kNavHeight);
}

- (CommonSegmentControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[CommonSegmentControl alloc]initWithFrame:CGRectMake(0, 0, kSegmentNaviWidth_2_4, 40) items:self.titles toSuperView:nil swipView:nil];
        self.navigationItem.titleView = _segmentControl;
        _segmentControl.segmentBackgroundColor = [UIColor clearColor];
        _segmentControl.selectColor = kColorTheme;
        _segmentControl.titleFont = kFontSize6(16);
        _segmentControl.lineColor = kColorTheme;
        _segmentControl.lineWidth = 70;
        [_segmentControl addTarget:self action:@selector(segmentControlChanged:)];
    }
    return _segmentControl;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
//        _contentView.delegate = self;
        _contentView.scrollEnabled = NO;
        [_contentView setShowsHorizontalScrollIndicator:NO];
        [_contentView setShowsVerticalScrollIndicator:NO];
        _contentView.pagingEnabled = YES;
        _contentView.frame = CGRectMake(0, 0, self.view.width, kScreenHeight-kNavHeight);
        _contentView.bounces = NO;
        [_contentView setContentSize:CGSizeMake(kScreenWidth*self.titles.count, kScreenHeight-kNavHeight)];
    }
    return _contentView;
}

- (HKNewHouseVC *)newHouseVC {
    if (!_newHouseVC) {
        _newHouseVC = [[HKNewHouseVC alloc] init];
    }
    return _newHouseVC;
}

- (HKCommunityListVC *)communityListVC {
    if (!_communityListVC) {
        _communityListVC = [[HKCommunityListVC alloc] init];
    }
    return _communityListVC;
}


#pragma mark - 切换
- (void)segmentControlChanged:(CommonSegmentControl *)sender {

    [self.contentView setContentOffset:CGPointMake(self.view.width*sender.selectedIndex, 0) animated:YES];
}

@end
