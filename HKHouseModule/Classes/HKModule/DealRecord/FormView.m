//
//  FormView.m
//  ErpApp
//
//  Created by midland on 2022/8/15.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "FormView.h"
#import "HKHouseCommon.h"
#import "DealRecordCollectionCell.h"
#import "HorizontalFlowLayout.h"

#define kRowHeight kViewSize6(60)
#define kRowWidth kViewSize6(80)

#define kTitleTableViewWidth kViewSize6(60)

@interface FormView ()<UITableViewDelegate, UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/// 底部容器
@property (nonatomic, strong)UIScrollView *containerView;
/// 左边标题
@property (nonatomic, strong)UITableView *titleTableView;
/// 右边内容
@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray *titles;

@property (nonatomic, strong)NSMutableArray<NSArray<BuildingData *> *> *conllectionDataSource;
/// 横向/每一层 最大个数
@property (nonatomic, assign)NSInteger maxNumber;

@end

@implementation FormView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createDefaultData];
        
        [self createUI];
    }
    return self;
}


- (void)createDefaultData {
    self.titles = @[].mutableCopy;
    self.conllectionDataSource = @[].mutableCopy;
}

/// 刷新页面
- (void)reloadData {
    self.containerView.contentSize = CGSizeMake(self.width, kRowHeight*self.titles.count);
    
    self.titleTableView.height = kRowHeight*self.titles.count;
    self.collectionView.height = kRowHeight*self.titles.count;
    
    [self.titleTableView reloadData];
    [self.collectionView reloadData];
}


- (void)createUI {
    [self addSubview:self.containerView];
    
    [self.containerView addSubview:self.titleTableView];
}

- (void)setDealRecordModels:(NSArray<DealRecordModel *> *)dealRecordModels {
    _dealRecordModels = dealRecordModels;
    
    self.titles = [_dealRecordModels bk_map:^id(DealRecordModel *obj) {
        return obj.floor;
    }].mutableCopy;
    
    __block NSInteger max = 0;
    self.conllectionDataSource = [_dealRecordModels bk_map:^id(DealRecordModel *obj) {
        if (obj.buildingDatas.count > max) {
            max = obj.buildingDatas.count;
        }
        return obj.buildingDatas;
    }].mutableCopy;
    
    self.maxNumber = max;
    
    [self.containerView addSubview:self.collectionView];
    
    [self reloadData];
}

#pragma mark --UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}


#pragma mark - collectionview
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.conllectionDataSource.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.conllectionDataSource[section].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DealRecordCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DealRecordCollectionCell class]) forIndexPath:indexPath];
    
    cell.buildingData = self.conllectionDataSource[indexPath.section][indexPath.row];
    
    return cell;
}

#pragma mark -- 懒加载
- (UIScrollView *)containerView {
    if (!_containerView) {
        _containerView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _containerView.bounces = NO;
        _containerView.showsVerticalScrollIndicator = NO;
    }
    return _containerView;
}

- (UITableView *)titleTableView {
    if (!_titleTableView) {
        _titleTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kTitleTableViewWidth, self.height) style:UITableViewStylePlain];
        _titleTableView.delegate = self;
        _titleTableView.dataSource = self;
        _titleTableView.scrollEnabled = NO;
        _titleTableView.showsVerticalScrollIndicator = NO;
        _titleTableView.tableFooterView = [UIView new];
        _titleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_titleTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _titleTableView.rowHeight = kRowHeight;
    }
    return _titleTableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        HorizontalFlowLayout *flowLayout = [[HorizontalFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        /// 减去间隙
        flowLayout.itemSize = CGSizeMake(kRowWidth-flowLayout.minimumLineSpacing, kRowHeight-flowLayout.minimumInteritemSpacing);
        if (@available(iOS 9.0, *)) {
            flowLayout.sectionHeadersPinToVisibleBounds = YES;
        } else {

        }
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kTitleTableViewWidth, 0, self.width-kTitleTableViewWidth, self.height) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[DealRecordCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([DealRecordCollectionCell class])];
        
    }
    return _collectionView;
}

@end
