//
//  MapSupportFacilitiesBottomView.m
//  ErpApp
//
//  Created by midland on 2022/7/22.
//

#import "MapSupportFacilitiesBottomView.h"
#import "MapSupportFacilitiesAddressCell.h"
#import "MapSupportFacilitiesLabelCell.h"
#import "MapSupportFacilitiesNoDataView.h"

#define Default_Button_Tag 100

@interface MapSupportFacilitiesBottomView()<CommunityCustomButtonViewDelegate, UITableViewDataSource, UITableViewDelegate>

/**scrollview*/
@property (nonatomic, strong) UIScrollView *mainScrollView;
/**图片名字*/
@property (nonatomic, copy) NSString *imageNameString;
/**图片源*/
@property (nonatomic, strong) NSArray *bzNamesArr;
/**标题*/
@property (nonatomic, strong) NSArray *titles;
/**菊花*/
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
/**没有数据*/
@property (nonatomic, strong) MapSupportFacilitiesNoDataView *noDataView;

@end

@implementation MapSupportFacilitiesBottomView

- (instancetype)initWithFrame:(CGRect)frame WithIsStartAnimating:(BOOL)startAnimating {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI:startAnimating];
    }
    return self;
}

- (void)createUI:(BOOL)startAnimating {
    // scrollview
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kMarkViewSize6(140))];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_mainScrollView];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _mainScrollView.bottom, kScreenWidth, 0.5)];
    lineView.backgroundColor = RGB(222, 222, 222);
    [self addSubview:lineView];
    
    _titles = @[@"公交",@"地铁",@"学校",@"医院",@"银行",@"休闲娱乐",@"购物",@"餐饮",@"运动健身"];
    
    NSArray *images = @[@"housemap_usgognjiao",@"housemap_usditie",@"housemap_usxuexiao",@"housemap_usyiyuan",@"housemap_usyinhang",@"housemap_usxiuxian",@"housemap_usgouwu",@"housemap_uscanyin",@"housemap_usjianshen"];
    NSArray *selectedImages = @[@"housemap_sgognjiao",@"housemap_sditie",@"housemap_sxuexiao",@"housemap_syiyuan",@"housemap_syinhang",@"housemap_sxiuxian",@"housemap_sgouwu",@"housemap_scanyin@2x",@"housemap_sjianshen"];
    
    _bzNamesArr = @[@"housedetail_gjaddre",@"housedetail_dtaddre",@"housedetail_xxaddre",@"housedetail_yyaddre",@"housedetail_yhaddre",@"housedetail_yladdre",@"housedetail_gwaddre",@"housedetail_cyaddre",@"housedetail_jsaddre"];
    _imageNameString = @"housedetail_gjaddre";
    
    for (NSInteger i = 0; i < _titles.count; i ++) {
        CustomButtonView *buttonView = [[CustomButtonView alloc] initWithFrame:CGRectMake(10+i*(8+50), 0, 50, 70)];
        buttonView.delegate = self;
        buttonView.tag = Default_Button_Tag+i;
        [buttonView setImageWith:images[i] SelectedImage:selectedImages[i] title:_titles[i]];
        [_mainScrollView addSubview:buttonView];
        _mainScrollView.contentSize = CGSizeMake(_titles.count*50+(_titles.count-1)*8+20, 70);
    }
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lineView.bottom, kScreenWidth, kMarkViewSize6(510) - lineView.bottom) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_mainTableView];

    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.5*(kScreenWidth - kMarkViewSize6(140)), 0.5*(kMarkViewSize6(510) - kMarkViewSize6(140)) + kMarkViewSize6(50), kMarkViewSize6(140), kMarkViewSize6(140))];
    _activityIndicatorView.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    if (startAnimating) {
        [_activityIndicatorView startAnimating];
    }
    [self addSubview:_activityIndicatorView];
}

#pragma mark - 设置默认选中状态
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
        [self.mainTableView reloadData];
    }
    if (_currentIndex >= 0) {
        CustomButtonView *buttonView;
        for (CustomButtonView *customView in _mainScrollView.subviews) {
            if ([customView isKindOfClass:[CustomButtonView class]]) {
                if ((customView.tag - Default_Button_Tag) == _currentIndex) {
                    buttonView = customView;
                    buttonView.isSelected = YES;
                    break;
                }
            }
        }
        if (self.customButtonBlock) {
            [self.activityIndicatorView startAnimating];
            self.customButtonBlock(buttonView, YES,_bzNamesArr[buttonView.tag - Default_Button_Tag],_titles[buttonView.tag - Default_Button_Tag]);
        }
        [self changeBottomScrollviewContentsizeWith:buttonView];
    }
}

#pragma mark - CustomButtonViewDelegate
- (void)customButtonTapedActionWith:(CustomButtonView *)view buttonSelected:(BOOL)isSelected {
    for (CustomButtonView *customView in _mainScrollView.subviews) {
        if ([customView isKindOfClass:[CustomButtonView class]]) {
            customView.isSelected = NO;
        }
    }
    view.isSelected = YES;

    if (!isSelected) {
        return;
    }
    
    _imageNameString = _bzNamesArr[view.tag - Default_Button_Tag];
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
        [self.mainTableView reloadData];
    }
    [self.noDataView removeFromSuperview];
    [self.activityIndicatorView startAnimating];
    
    if (view.tag == 100 || view.tag == 101) {// 公交或者地铁
        self.menuType = MapSupportingFacilitiesTypeForOrdinary;
    } else {
        self.menuType = MapSupportingFacilitiesTypeForOther;
    }
    
    if (self.customButtonBlock) {
        self.customButtonBlock(view, YES, _imageNameString, _titles[view.tag - Default_Button_Tag]);
    }
    [self changeBottomScrollviewContentsizeWith:view];
}

#pragma mark - 移动button所在的scrollview的contentsize
- (void)changeBottomScrollviewContentsizeWith:(CustomButtonView *)button {
    
    CGFloat screenLeftOffset = -1*_mainScrollView.contentOffset.x + button.frame.origin.x;
    CGFloat moveOffset = -1*screenLeftOffset + _mainScrollView.width/2 - button.width/2;
    CGFloat newContentOffset = _mainScrollView.contentOffset.x-moveOffset;
    if (moveOffset > 0 && newContentOffset < 0) {// 如果是向→移且会移出左边边界，则最多移至左边界处
        newContentOffset = 0;
    } else if (moveOffset < 0 && newContentOffset > _mainScrollView.contentSize.width-_mainScrollView.width) {// 如果是向←移且会移出右边边界，则最多移至右边界处
        newContentOffset = _mainScrollView.contentSize.width-_mainScrollView.width;
    }
    [_mainScrollView setContentOffset:CGPointMake(newContentOffset, 0) animated:YES];
}

#pragma mark - 设置列表数据源
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    if (_dataSource.count == 0) {
        [self.mainTableView addSubview:self.noDataView];
    } else {
        [self.noDataView removeFromSuperview];
    }
    [_activityIndicatorView stopAnimating];
    [self.mainTableView reloadData];
}

#pragma mark - UITableViewDatasource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource && self.dataSource.count > 0) {
        return self.dataSource.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.menuType == MapSupportingFacilitiesTypeForOrdinary) {
        if (_dataSource.count > 0) {
            MapSupportFacilitiesLabelCell *cell = [[MapSupportFacilitiesLabelCell alloc] init];
            [cell setDataModel:[_dataSource objectAtIndex:indexPath.row] WithHouseLocationPT:self.houseLocation];
            return cell.currentHeight;
        } else {
            return kMarkViewSize6(140);
        }
    } else {
        return kMarkViewSize6(140);
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.menuType == MapSupportingFacilitiesTypeForOrdinary) {
        static NSString *cellIdentifier = @"MapSupportFacilitiesLabelCell";
        MapSupportFacilitiesLabelCell *cell = (MapSupportFacilitiesLabelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[MapSupportFacilitiesLabelCell alloc] init];
        }
        if (self.dataSource.count > 0) {
            [cell setDataModel:self.dataSource[indexPath.row] WithHouseLocationPT:self.houseLocation];
        }
        return cell;
    } else {
        static NSString *cellIdentifier = @"MapSupportFacilitiesAddressCell";
        MapSupportFacilitiesAddressCell *cell = (MapSupportFacilitiesAddressCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[MapSupportFacilitiesAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        if (self.dataSource.count > 0) {
            BMKPoiInfo *dataModel = self.dataSource[indexPath.row];
            [cell setDataModel:dataModel WithHouseLocationPT:self.houseLocation];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BMKPoiInfo *dataModel = self.dataSource[indexPath.row];
    if (self.customCellBlock) {
        self.customCellBlock(dataModel.pt);
    }
}

- (void)customButtonTapedActionBlock:(CustomButtonTapedActionBlock)block {
    self.customButtonBlock = block;
}

- (void)customCellTapedActionBlock:(CustomCellTapedActionBlock)block {
    self.customCellBlock = block;
}

- (MapSupportFacilitiesNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[MapSupportFacilitiesNoDataView alloc] initWithFrame:self.mainTableView.bounds];
    }
    return _noDataView;
}

- (void)settingTableViewCellSelected:(CLLocationCoordinate2D)coor {
    if (self.dataSource.count > 0) {
        NSInteger currentIndex = 0;
        for (NSInteger i = 0; i < self.dataSource.count; i ++) {
            BMKPoiInfo *dataModel = self.dataSource[i];
            if (dataModel.pt.latitude == coor.latitude) {
                currentIndex = i;
                break;
            }
        }
        [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)dealloc {
    NSLog(@"shifang");
}

@end
