//
//  HKCommunityListVC.m
//  ErpApp
//
//  Created by midland on 2022/7/14.
//

#import "HKCommunityListVC.h"
#import "HKHouseCommon.h"
#import "HKSearchView.h"
#import "HKCommunityListCell.h"
#import <ErpConditionBar/HFTConditionHKCommunity.h>
#import "HKCommunityDetailVC.h"
#import "HKCommunityListViewModel.h"
#import "HKHouseUtil.h"

/// 香港小区列表
@interface HKCommunityListVC ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong)HKCommunityListViewModel *viewModel;
/// 搜索框
@property (nonatomic, strong)HKSearchView *searchBar;
/// 筛选栏
@property (nonatomic, strong)HFTConditionHKCommunity *conditionBar;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HKCommunityListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createDefaultData];
    
    [self createUI];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)createDefaultData {
    self.viewModel = [[HKCommunityListViewModel alloc] init];
    LazyWeakSelf
    [[NSNotificationCenter defaultCenter]addObserverForName:@"SwitchCurrencyCallBack" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        BOOL isCNY = [note.object boolValue];
        [HKHouseUtil shareManager].isCNY = isCNY;
        [weakSelf.tableView reloadData];
    }];
}

- (void)createUI {
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.conditionBar];
    [self.view addSubview:self.tableView];
}

#pragma mark ----------------------------- 代理方法 ------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKCommunityListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKCommunityListCell class]) forIndexPath:indexPath];
    cell.model = self.viewModel.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKCommunityDetailVC *communityDetailVC = [[HKCommunityDetailVC alloc] initWithEstateId:self.viewModel.dataSource[indexPath.row].estateId];
    [self.navigationController pushViewController:communityDetailVC animated:YES];
}

#pragma mark ----------------------------- 延迟加载 ------------------------------
/// 搜索栏
- (HKSearchView *)searchBar {
    if (!_searchBar) {
        _searchBar = [[HKSearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 75)];
        LazyWeakSelf;
        self.searchBar.searchBlock = ^(NSString * _Nonnull searchText) {
            NSLog(@"搜索的关键字%@", searchText);
            weakSelf.viewModel.searchKeyword = searchText;
            /// 刷新数据
            [weakSelf refreshDataWithTip:YES reload:YES];
        };
    }
    return _searchBar;
}

- (HFTConditionHKCommunity *)conditionBar {
    if (!_conditionBar) {
        _conditionBar = [[HFTConditionHKCommunity alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, self.view.width, kConditionBarHeight)];
        LazyWeakSelf;
        [_conditionBar setSearchBlock:^(NSDictionary *conditions) {
            NSLog(@"\n%@", conditions);
            weakSelf.viewModel.intDistrictIds = conditions[@"intDistrictId"];
            [weakSelf refreshDataWithTip:NO reload:YES];
        }];
        __weak typeof(_conditionBar) weakConditionBar = _conditionBar;
        self.viewModel.SearchListCondition = ^NSDictionary *{
            NSDictionary *dict1 = [weakConditionBar getAllConditions].copy;
           
            return dict1.copy;
        };
    }
    return _conditionBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchBar.height+kConditionBarHeight, kScreenWidth, kScreenHeight - kNavHeight - kSafeBottomMargin - (self.searchBar.height)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HKCommunityListCell class] forCellReuseIdentifier:NSStringFromClass([HKCommunityListCell class])];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _tableView.rowHeight = 140;
        LazyWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refreshDataWithTip:NO reload:YES];
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
