//
//  HKSecondeHouseDetailVC.m
//  ErpApp
//
//  Created by midland on 2022/8/10.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "HKSecondeHouseDetailVC.h"
#import "HKHouseCommon.h"
#import "HKHouseDetailNavagitionView.h"
#import "HKSecondeHouseDetailViewModel.h"
#import "AgentCardView.h"
#import "HKPhotosView.h"
#import "HKSecondeHouseDetailCell.h"
#import "HouseSaleinformationCell.h"
#import "HouseCommonInformationCell.h"
#import "HKMapCell.h"
#import "HKHouseUtil.h"


#define kBrokerInfoBarHeight (66+kSafeBottomMargin)

/// 香港二手房详情
@interface HKSecondeHouseDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) HKHouseDetailNavagitionView *navBar;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HKPhotosView *photosView;
@property (nonatomic, assign) NSUInteger photosViewHeight; // 顶部相册轮播的高度
/**
 缓存cell的高度
 */
@property (nonatomic, strong) NSMutableDictionary *cellHightDict;

@property (nonatomic, strong) HKSecondeHouseDetailViewModel *viewModel;

@property (nonatomic, strong) AgentCardView *agentCardView;

@end

@implementation HKSecondeHouseDetailVC

- (instancetype)initWithSerialNo:(NSString *)serialNo {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.serialNo = serialNo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createDefaultData];
    
    [self createUI];
    
    [self creatNav];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self handleFloatingOfBrokerInfoBarWithState:NO animation:NO];
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
//    [self setupViewModel];
    self.viewModel = [[HKSecondeHouseDetailViewModel alloc] init];
    LazyWeakSelf
//    self.viewModel.refreshFirstBlock = ^{
//        [weakSelf refreshWithIndex:0];
//    };
//    self.viewModel.editVerificateNumber = ^{
//        [weakSelf intoBaseInfoEditVC:YES];
//    };
    _photosViewHeight = kScreenWidth * 3/ 4;
    [[NSNotificationCenter defaultCenter]addObserverForName:@"SwitchCurrencyCallBack" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        BOOL isCNY = [note.object boolValue];
        [HKHouseUtil shareManager].isCNY = isCNY;
        [weakSelf.tableView reloadData];
    }];
}

- (void)setSerialNo:(NSString *)serialNo {
    _serialNo = serialNo;
}

- (void)creatNav {
    _navBar = [[HKHouseDetailNavagitionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    [self.view addSubview:_navBar];
    _navBar.backgroundColor = RGBA(56, 140, 255, 0);
    _navBar.titleLabel.textColor = [UIColor whiteColor];
    LazyWeakSelf;
    [_navBar.shareButton bk_addEventHandler:^(id sender) {
        NSLog(@"点击了分享");
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)createUI {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, kBrokerInfoBarHeight, 0);
    _tableView.estimatedRowHeight = 100;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundView.backgroundColor = RGBGRAY(246);
    _tableView.backgroundColor = RGBGRAY(246);
    [_tableView registerClass:[HKSecondeHouseDetailCell class] forCellReuseIdentifier:NSStringFromClass([HKSecondeHouseDetailCell class])];
    [_tableView registerClass:[HouseSaleinformationCell class] forCellReuseIdentifier:NSStringFromClass([HouseSaleinformationCell class])];
    [_tableView registerClass:[HouseCommonInformationCell class] forCellReuseIdentifier:NSStringFromClass([HouseCommonInformationCell class])];
    [_tableView registerClass:[HKMapCell class] forCellReuseIdentifier:NSStringFromClass([HKMapCell class])];
    
    @weakify(self);
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestData];
        
    }];
    _tableView.tableFooterView = [UIView new];
    
    self.photosView = [[HKPhotosView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.photosViewHeight)];
    _tableView.tableHeaderView = self.photosView;
    
    [self.view addSubview:self.agentCardView];
    

}

#pragma mark ----------------------------- 代理方法 ------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.viewModel.dataSource safeObjectAtIndex:indexPath.row];
    NSString *cellName = [dic objectForKey:@"cellName"];
    
    if ([NSStringFromClass([HKSecondeHouseDetailCell class]) isEqualToString:cellName]) {
        HKSecondeHouseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKSecondeHouseDetailCell class])];
        cell.detailModel = self.viewModel.detailModel;
        
        return cell;
    }
    if ([NSStringFromClass([HouseSaleinformationCell class]) isEqualToString:cellName]) {
        HouseSaleinformationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HouseSaleinformationCell class])];
        cell.model = self.viewModel.detailModel;
        return cell;
    }
    if ([NSStringFromClass([HouseCommonInformationCell class]) isEqualToString:cellName]) {
        HouseCommonInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HouseCommonInformationCell class])];
        cell.model = self.viewModel.detailModel;
        return cell;
    }
    
    if ([NSStringFromClass([HKMapCell class]) isEqualToString:cellName]) {
        HKMapCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKMapCell class])];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

- (NSMutableDictionary *)cellHightDict {
    if (!_cellHightDict) {
        _cellHightDict = [NSMutableDictionary new];
    }
    return _cellHightDict;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.viewModel.dataSource safeObjectAtIndex:indexPath.row];
    NSString *cellName = [dic objectForKey:@"cellName"];
    
    [self.cellHightDict setObject:@(cell.frame.size.height) forKey:[NSString stringWithFormat:@"%@%ld",cellName, (long)indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.viewModel.dataSource safeObjectAtIndex:indexPath.row];
    NSString *cellName = [dic objectForKey:@"cellName"];

    CGFloat height = [[self.cellHightDict objectForKey:[NSString stringWithFormat:@"%@%ld",cellName, (long)indexPath.row]] floatValue];
    if (height == 0) {
        return 100;
    }
    return height;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_tableView]) {
        // 导航栏处理
        CGFloat alpha = scrollView.contentOffset.y / (CGFloat)_photosViewHeight;
        if (alpha < 0) {
            alpha = 0;
        }
        if (alpha > 1) {
            alpha = 1;
        }
        self.navBar.titleLabel.alpha = alpha;
        self.navBar.backgroundColor = RGBA(56, 140, 255, alpha);
        
        //        if (scrollView.contentOffset.y > 0) {
        //            _canPlayVideoAtFirst = NO;
        //        }
        
//        // push进来的图片的处理
//        if (_pushImageView) {
//            _pushImageView.frame = ({
//                CGRect frame = _pushImageView.frame;
//                frame.origin.y = -scrollView.contentOffset.y - 20;
//                frame;
//            });
//        }
//
//        // 处理视频滑动的位置
//        if (_videoPlayerBackgroundView) {
//            _videoPlayerBackgroundView.frame = ({
//                CGRect frame = _videoPlayerBackgroundView.frame;
//                frame.origin.y = MAX(-scrollView.contentOffset.y - kStatusBarHeight, 0);
//                frame;
//            });
//        }
    }
}

float v_lastContentOffset;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    v_lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    CGFloat maximumOffset = size.height;
    if (currentOffset > maximumOffset) {
        if (self.agentCardView.bottom != _tableView.bottom) {
            self.agentCardView.bottom = _tableView.bottom;
            self.agentCardView.alpha = 1;
            self.agentCardView.hidden = NO;
        }
        return;
    }
    if (v_lastContentOffset < scrollView.contentOffset.y) {
        NSLog(@"向上滚动");
        [self handleFloatingOfBrokerInfoBarWithState:YES animation:YES];
    }else{
        NSLog(@"向下滚动");
        [self handleFloatingOfBrokerInfoBarWithState:NO animation:YES];
    }
}

#pragma mark - 处理浮动经纪人信息栏
- (void)handleFloatingOfBrokerInfoBarWithState:(BOOL)isTop animation:(BOOL)animation {
    if (isTop) {

        if (self.agentCardView.bottom == self.view.bottom) {
            return;
        }
        if (!animation) {
            self.agentCardView.bottom = self.view.bottom;
            self.agentCardView.alpha = 1;
            self.agentCardView.hidden = NO;
            return;
        }
        self.agentCardView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.agentCardView.bottom = self.view.bottom;
            self.agentCardView.alpha = 1;
            self.agentCardView.hidden = NO;
        } completion:^(BOOL finished) {
            self.agentCardView.bottom = self.view.bottom;
            self.agentCardView.alpha = 1;
            self.agentCardView.hidden = NO;
        }];
    } else {

        if (self.agentCardView.top == self.view.bottom) {
            return;
        }
        if (!animation) {
            self.agentCardView.top = self.view.bottom;
            self.agentCardView.alpha = 0;
            self.agentCardView.hidden = YES;
            return;
        }
        self.agentCardView.alpha = 1;
        [UIView animateWithDuration:0.3 animations:^{
            self.agentCardView.top = self.view.bottom;
            self.agentCardView.alpha = 0;
        } completion:^(BOOL finished) {
            self.agentCardView.top = self.view.bottom;
            self.agentCardView.alpha = 0;
            self.agentCardView.hidden = YES;
        }];
    }
}

- (void)requestData {
    @weakify(self);
    [self.viewModel requestDataWithSerialNo:self.serialNo result:^(NSError * _Nonnull error) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        
        _navBar.titleLabel.text = self.viewModel.detailModel.houseName;
        
        [self.tableView reloadData];
        
        _agentCardView.agentModel = self.viewModel.detailModel.agent;
        
        [self bannerData];
    }];
}

- (void)bannerData {
    NSMutableArray<PhotosViewModel *> *result = [NSMutableArray array];
    /// vr
    if (self.viewModel.detailModel.vrs != nil && self.viewModel.detailModel.vrs.count > 0) {
        NSArray *imageStrings = [self.viewModel.detailModel.vrs bk_map:^id(VRModel *obj) {
            return obj.vrThumbnail;
        }];
        PhotosViewModel *photosViewModel = [[PhotosViewModel alloc] initWithTitle:@"VR" imageURLString:imageStrings];
        [result addObject: photosViewModel];
    }
    /// 图片
    if (self.viewModel.detailModel.photos != nil && self.viewModel.detailModel.photos.count > 0) {
        NSArray *imageStrings = [self.viewModel.detailModel.photos bk_map:^id(Photo *obj) {
            return obj.path;
        }];
        PhotosViewModel *photosViewModel = [[PhotosViewModel alloc] initWithTitle:@"图片" imageURLString:imageStrings];
        [result addObject: photosViewModel];
    }
    
    /// 平面图
    if (self.viewModel.detailModel.floorPlans != nil && self.viewModel.detailModel.floorPlans.count > 0) {
        NSArray *imageStrings = [self.viewModel.detailModel.floorPlans bk_map:^id(FloorPlan *obj) {
            return obj.wanDocPath;
        }];
        PhotosViewModel *photosViewModel = [[PhotosViewModel alloc] initWithTitle:@"平面图" imageURLString:imageStrings];
        [result addObject: photosViewModel];
    }
    
    /// 规划图
    if (self.viewModel.detailModel.sitePlans != nil && self.viewModel.detailModel.sitePlans.count > 0) {
        NSArray *imageStrings = [self.viewModel.detailModel.sitePlans bk_map:^id(SitePlans *obj) {
            return obj.siteplanPath;
        }];
        PhotosViewModel *photosViewModel = [[PhotosViewModel alloc] initWithTitle:@"规划图" imageURLString:imageStrings];
        [result addObject: photosViewModel];
    }
    self.photosView.dataSource = result;
}

- (AgentCardView *)agentCardView {
    if (!_agentCardView) {
        _agentCardView = [[AgentCardView alloc] initWithFrame:CGRectMake(0, self.view.height-(kBrokerInfoBarHeight), kScreenWidth, kBrokerInfoBarHeight)];
    }
    return _agentCardView;
}

@end
