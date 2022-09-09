//
//  HKSecondHouseListVC.m
//  ErpApp
//
//  Created by midland on 2022/7/21.
//

#import "HKSecondHouseListVC.h"
#import "HKHouseCommon.h"
#import "HKSearchView.h"
#import "HKSecondHouseListCell.h"
#import <ErpConditionBar/HFTConditionHKCommunity.h>
#import <ErpConditionBar/HFTConditionHKSecondHouse.h>
#import "HKSecondHouseListViewModel.h"
#import "HKSecondeHouseDetailVC.h"
#import "HKHouseUtil.h"

/// 香港小区列表
@interface HKSecondHouseListVC ()<UITableViewDelegate, UITableViewDataSource>

/// 筛选栏
@property (nonatomic, strong) HFTConditionHKSecondHouse *conditionBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HKSecondHouseListViewModel *viewModel;

@property (nonatomic, copy) NSString *estateId;

@end

@implementation HKSecondHouseListVC

- (instancetype)initWithTitle:(NSString *)title estateId:(NSString *)estateId
{
    self = [super init];
    if (self) {
        self.estateId = estateId;
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDefaultData];
    [self createUI];
    [self.tableView.mj_header beginRefreshing];
}

- (void)createDefaultData {
    self.viewModel = [[HKSecondHouseListViewModel alloc] init];
    self.viewModel.estateId = self.estateId;
}

- (void)createUI {
    
    [self.view addSubview:self.conditionBar];
    [self.view addSubview:self.tableView];
}

#pragma mark ----------------------------- 代理方法 ------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKSecondHouseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKSecondHouseListCell class]) forIndexPath:indexPath];
    [cell updateModel: self.viewModel.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKSecondeHouseDetailVC *secondeHouseDetailVC = [[HKSecondeHouseDetailVC alloc] initWithSerialNo:self.viewModel.dataSource[indexPath.row].serialNo];
    [self.navigationController pushViewController:secondeHouseDetailVC animated:YES];
}

#pragma mark ----------------------------- 延迟加载 ------------------------------

- (HFTConditionHKSecondHouse *)conditionBar {
    if (!_conditionBar) {
        _conditionBar = [[HFTConditionHKSecondHouse alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
        LazyWeakSelf;
        [_conditionBar setSearchBlock:^(NSDictionary *conditions) {
            NSLog(@"\n%@", conditions);
            [weakSelf refreshDataWithTip:NO reload:YES];
        }];
        __weak typeof(_conditionBar) weakConditionBar = _conditionBar;
        self.viewModel.SearchListCondition = ^NSDictionary *{
            NSDictionary *dict1 = [weakConditionBar getAllConditions].copy;
            return dict1;
        };

    }
    return _conditionBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kConditionBarHeight, kScreenWidth, kScreenHeight - kNavHeight - kSafeBottomMargin) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HKSecondHouseListCell class] forCellReuseIdentifier:NSStringFromClass([HKSecondHouseListCell class])];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _tableView.rowHeight = kViewSize6(140);
        LazyWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self refreshDataWithTip:NO reload:YES];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf refreshDataWithTip:NO reload:NO];
        }];
        _tableView.mj_footer.hidden = YES;
    }
    return _tableView;
}

- (void)refreshDataWithTip:(BOOL)tip reload:(BOOL)isReload {
    if (tip) {
        RZShowLoadingView;
    }
    if (isReload) {
        self.viewModel.pageNum = 1;
    } else {
        self.viewModel.pageNum += 1;
    }
    [self.viewModel requestDataWithResult:^(NSError * _Nonnull error, BOOL hasMore) {
        RZHideLoadingView;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = !hasMore;
        [self.tableView reloadData];
        [HFTNoNetOrDataWarmingView dismissFromView:self.tableView];
        if (error) {
            [HFTHud showWarnMessage:error.domain];
            if (self.viewModel.dataSource.count == 0) {
                [HFTNoNetOrDataWarmingView showWithMessage:error.domain toView:self.tableView tag:ViewWithTypeNoNet handle:^{
                    [self refreshDataWithTip:tip reload:YES];
                    
                }];
            }
            return;
        }else if (self.viewModel.dataSource.count == 0) {
            [HFTNoNetOrDataWarmingView showWithMessage:@"暂无数据" toView:self.tableView tag:ViewWithTypeNoData handle:^{
                [self refreshDataWithTip:tip reload:YES];
            }];
        }
    }];
}


@end
