//
//  HouseDetailSurroundingFacilityViewController.m
//  ErpApp
//
//  Created by Mi on 2017/12/25.
//  Copyright © 2017年 haofangtongerp. All rights reserved.
//

#import "DetailSurroundingFacilityViewController.h"
#import "CustomButtonView.h"
#import "HKHouseCommon.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "MapSupportFacilitiesBottomView.h"
#import "MapPointBMKPointAnnotation.h"
#import "NSArray+Utils.h"

@interface DetailSurroundingFacilityViewController ()<BMKMapViewDelegate, CommunityCustomButtonViewDelegate, BMKPoiSearchDelegate>

/**地图*/
@property (nonatomic, strong) BMKMapView *mapView;
/**百度地图poi搜索*/
@property (nonatomic, strong) BMKPoiSearch *searchPoi;
/**<#type#>*/
@property (nonatomic, copy) NSString *imageNameString;
/**底部view*/
@property (nonatomic, strong) MapSupportFacilitiesBottomView *faciletiesBottomView;

@end

@implementation DetailSurroundingFacilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.translucent = YES;
    [self createUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
    _searchPoi.delegate = nil;
}

- (void)dealloc {
    NSLog(@"%@被释放掉了",[self class]);
}

#pragma mark - 加载界面
- (void)createUI {
    // 导航栏标题
    self.title = @"位置及周边";
    // 地图view
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight)];// - (_isSelectedNemu ?  kMarkViewSize6(510) : kMarkViewSize6(140))
    _mapView.delegate = self;
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.zoomLevel = 17;
    [_mapView setCenterCoordinate:_houseLocation animated:YES];
    
    MapPointBMKPointAnnotation *poiInfo = [MapPointBMKPointAnnotation new];
    poiInfo.coordinate = _houseLocation;
    [_mapView addAnnotation:poiInfo];
    
    [self.view addSubview:_mapView];
    
    // 底部选择按钮
    [self.view addSubview:self.faciletiesBottomView];
    LazyWeakSelf;
    [self.faciletiesBottomView customButtonTapedActionBlock:^(CustomButtonView *btn, BOOL isSelected, NSString *imageNameStr, NSString *KeyWordStr) {
        if (weakSelf.faciletiesBottomView.height == kMarkViewSize6(140)) {
            weakSelf.faciletiesBottomView.mainTableView.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.faciletiesBottomView.frame = CGRectMake(0, kScreenHeight - kMarkViewSize6(510) - kNavHeight, kScreenWidth, kMarkViewSize6(510));
            } completion:^(BOOL finished) {
                [weakSelf removeAnnotation];
                [weakSelf addCurrentPointAnnotation];
                [weakSelf setMapLocationCenter];
                [weakSelf initBKMPoiSearchWithKeyWord:KeyWordStr];
                weakSelf.imageNameString = imageNameStr;
            }];
        } else {
            [weakSelf removeAnnotation];
            [weakSelf addCurrentPointAnnotation];
            [weakSelf setMapLocationCenter];
            [weakSelf initBKMPoiSearchWithKeyWord:KeyWordStr];
            weakSelf.imageNameString = imageNameStr;
        }
    }];
    // 点击cell
    [self.faciletiesBottomView customCellTapedActionBlock:^(CLLocationCoordinate2D pt) {
        [weakSelf.mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            BMKPointAnnotation *item = (BMKPointAnnotation *)obj;
            if (item.coordinate.latitude == pt.latitude && item.coordinate.longitude == pt.longitude) {
                [weakSelf.mapView selectAnnotation:obj animated:YES];
                *stop = YES;
                BMKAnnotationView *view = [weakSelf.mapView viewForAnnotation:item];
                [weakSelf.mapView setCenterCoordinate:[weakSelf.mapView convertPoint:view.center toCoordinateFromView:weakSelf.mapView] animated:YES];
            }
        }];
    }];
    // 设置选中下标
    if (self.currentIndex != -1) {
        
        self.faciletiesBottomView.currentIndex = self.currentIndex;
        // 设置菜单类型
        if (self.currentIndex == 0 || self.currentIndex == 1) {
            self.faciletiesBottomView.menuType = MapSupportingFacilitiesTypeForOrdinary;
        } else {
            self.faciletiesBottomView.menuType = MapSupportingFacilitiesTypeForOther;
        }
        // 设置房源坐标
        self.faciletiesBottomView.houseLocation = self.houseLocation;
    }
}

#pragma mark - ---------- 代理方法 ----------
#pragma mark - 百度地图delegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MapPointBMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"houseMaplocation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = NO;
        newAnnotationView.annotation = annotation;
        UIImage *image = rzImage(@"housedetail_location_icon");
        newAnnotationView.image = image;
        newAnnotationView.size = image.size;
        return newAnnotationView;
    } else {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = NO;
        newAnnotationView.annotation = annotation;
        UIImage *image = rzImage(_imageNameString);
        newAnnotationView.image = image;
        newAnnotationView.size = image.size;
        return newAnnotationView;
    }
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    BMKPointAnnotation *annatation = (BMKPointAnnotation*)view.annotation;
    NSLog(@"%@",annatation);
    self.faciletiesBottomView.mainTableView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.faciletiesBottomView.frame = CGRectMake(0, kScreenHeight - kMarkViewSize6(510) - kNavHeight, kScreenWidth, kMarkViewSize6(510));
    } completion:^(BOOL finished) {
        [mapView setCenterCoordinate:[mapView convertPoint:view.center toCoordinateFromView:mapView] animated:YES];
        [self.faciletiesBottomView settingTableViewCellSelected:annatation.coordinate];
    }];
}

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPOISearchResult*)poiResultList errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        [self poiSuccessActionWith:poiResultList];
    } else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
        [HFTHud showWarnMessage:@"起始点有歧义"];
    } else {
        self.faciletiesBottomView.dataSource = nil;
        [self addCurrentPointAnnotation];
    }
}

#pragma mark - 添加当前定位点的pointannotation
- (void)addCurrentPointAnnotation {
    MapPointBMKPointAnnotation* annotation = [[MapPointBMKPointAnnotation alloc] init];
    annotation.coordinate = _houseLocation;
    annotation.title = nil;
    annotation.subtitle = nil;
    [_mapView addAnnotation:annotation];
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    [UIView animateWithDuration:0.25 animations:^{
        self.faciletiesBottomView.frame = CGRectMake(0, kScreenHeight - kMarkViewSize6(140) - kNavHeight, kScreenWidth, kMarkViewSize6(140));
        self.faciletiesBottomView.mainTableView.hidden = YES;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 周边检索成功的处理
- (void)poiSuccessActionWith:(BMKPOISearchResult *)poiResultList {
    [self removeAnnotation];
    [self setMapLocationCenter];
    if (poiResultList.poiInfoList.count == 0) {
        self.faciletiesBottomView.dataSource = nil;
        return;
    }
    NSMutableArray *dataResultArr = [NSMutableArray array];
    for (NSInteger i = 0; i < poiResultList.poiInfoList.count; i ++) {
        BMKPoiInfo *model = poiResultList.poiInfoList[i];
        BMKMapPoint point1 = BMKMapPointForCoordinate(_houseLocation);
        BMKMapPoint point2 = BMKMapPointForCoordinate(model.pt);
        CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
        model.distance = distance;
        [self addPointAnnotationWith:model];
        [dataResultArr addObject:model];
    }
    self.faciletiesBottomView.dataSource = [NSArray handleSortActionWithObjcetArr:dataResultArr WithKeywordStr:@"distance"].mutableCopy;
    [self addCurrentPointAnnotation];
}

#pragma mark - 添加pointAnnotation
- (void)addPointAnnotationWith:(BMKPoiInfo *)poiInfo {
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = poiInfo.pt;
    annotation.title = poiInfo.name;
    annotation.subtitle = poiInfo.address;
    [_mapView addAnnotation:annotation];
}

#pragma mark - 排序
- (NSArray *)handleSortActionWithObjcetArr:(NSMutableArray *)array {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
    return [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

#pragma mark - ---------- setter&&getter ----------
- (void)setHouseLocation:(CLLocationCoordinate2D)houseLocation {
    _houseLocation = houseLocation;
}

- (MapSupportFacilitiesBottomView *)faciletiesBottomView {
    if (!_faciletiesBottomView) {
        _faciletiesBottomView = [[MapSupportFacilitiesBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight - (_isSelectedNemu ?  kMarkViewSize6(510) : kMarkViewSize6(140)) - kNavHeight, kScreenWidth, _isSelectedNemu ?  kMarkViewSize6(510) : kMarkViewSize6(140)) WithIsStartAnimating:(self.currentIndex != -1) ? YES : NO];
    }
    return _faciletiesBottomView;
}

#pragma mark - 初始化周边检索
- (void)initBKMPoiSearchWithKeyWord:(NSString *)keyWord {
    if (!_searchPoi) {
        _searchPoi = [[BMKPoiSearch alloc] init];
        _searchPoi.delegate = self;
    }
    
    BMKPOINearbySearchOption *option = [[BMKPOINearbySearchOption alloc] init];
    option.pageSize = 15;
    option.radius = 3000;
    option.location = _houseLocation;
    option.keywords = @[keyWord];
    BOOL flag = [_searchPoi poiSearchNearBy:option];
    
    if(flag) {
        NSLog(@"周边检索发送成功");
    } else {
        NSLog(@"周边检索发送失败");
    }
}

#pragma mark - 设置地图定位中心
- (void)setMapLocationCenter {
    [_mapView setCenterCoordinate:_houseLocation animated:YES];
    _mapView.zoomLevel = 17;
}

#pragma mark - 移除pointAnnotation
- (void)removeAnnotation {
    for (BMKPointAnnotation *annotation in _mapView.annotations) {
//        if (![annotation isKindOfClass:[MapPointBMKPointAnnotation class]]) {
            [_mapView removeAnnotation:annotation];
//        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
