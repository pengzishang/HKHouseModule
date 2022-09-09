//
//  DetailMapView.m
//  ErpApp
//
//  Created by midland on 2022/7/22.
//

#import "DetailMapView.h"
#import "CustomButtonView.h"
#import <HFTMapKit/HFTBMapKit.h>
#import "HKHouseCommon.h"
#import "DetailSurroundingFacilityViewController.h"
#import <HFTNavigation/HFTControllerManager.h>
#import <ErpTools/TQLocationConverter.h>

#define Default_Button_Tag 1030

#define kUpBottomSpacing 20                     // 顶底的间距
#define kLeftRightSpacing 15                    // 左右的间距
#define kBottomViewHeight 70                    // 底部视图的高
#define kBottomBtnWidth 50                      // 底部按钮的宽
#define kBottomBtnSpacing 10                    // 底部按钮间的间距

@interface DetailMapView ()<BMKMapViewDelegate, CommunityCustomButtonViewDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKGeoCodeSearch *geoSearch;
/**地图*/
@property (nonatomic, strong) BMKMapView *mapView;
/**scrollview*/
@property (nonatomic, strong) UIScrollView *mainScrollView;
/**标题*/
@property (nonatomic, strong) NSArray *titles;
/**图片*/
@property (nonatomic, strong) NSArray *images;
/**被选中图片*/
@property (nonatomic, strong) NSArray *selectedImages;
/**<#type#>*/
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIView *tempView;
/**地址view*/
@property (nonatomic, strong) UIView *addreView;

@property (nonatomic, assign) BOOL hideTitle;
/**地址view*/
@property (nonatomic, strong) UILabel *addressLabel;


@end

@implementation DetailMapView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame hideTitle:(BOOL)hideTitle {
    if (self = [super initWithFrame:frame]) {
        _hideTitle = hideTitle;
        [self initData];
        [self initUI];
    }
    return self;
}

- (void)dealloc {
    if (_geoSearch) {
        _geoSearch.delegate = nil;
    }
}
- (UILabel *)addressLabel {
    if(!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _addreView.width - 30, _addreView.height)];
        _addressLabel.textColor = RGBGRAY(53);
        _addressLabel.font = [UIFont systemFontOfSize:15];
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    }
    return _addressLabel;
}

#pragma mark - ---------- 私有方法 ----------
#pragma mark - 加载初始数据
- (void)initData {
    _titles = @[@"公交",@"地铁",@"学校",@"医院",@"银行",@"休闲娱乐",@"购物",@"餐饮",@"运动健身"];
    _images = @[@"housemap_usgognjiao",@"housemap_usditie",@"housemap_usxuexiao",@"housemap_usyiyuan",@"housemap_usyinhang",@"housemap_usxiuxian",@"housemap_usgouwu",@"housemap_uscanyin",@"housemap_usjianshen"];
    _selectedImages = @[@"housemap_sgognjiao",@"housemap_sditie",@"housemap_sxuexiao",@"housemap_syiyuan",@"housemap_syinhang",@"housemap_sxiuxian",@"housemap_sgouwu",@"housemap_scanyin@2x",@"housemap_sjianshen"];
}

#pragma mark - 加载界面
- (void)initUI {
    // 背景颜色
    self.backgroundColor = [UIColor whiteColor];
    if (!_hideTitle) {
        // 周边配套
        self.title = [[UILabel alloc] init];
        [self.title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.textColor = RGBGRAY(53);
        self.title.text = @"楼盘位置";
        self.title.userInteractionEnabled = NO;
        [self.title sizeToFit];
        self.title.height = 50;
        self.title.left = kLeftRightSpacing;
        [self addSubview:self.title];
    }
    
    // 地图view
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, self.title.bottom, self.width, 190)];
    _mapView.delegate = self;
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.zoomLevel = 18;
    [self addSubview:_mapView];
    
    _tempView = [[UIView alloc] initWithFrame:CGRectMake(0, self.title.bottom, self.width, 190)];
    _tempView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tempView];

    // 底部选择按钮
    [self initBottomButtom];
    
    // 手势view
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, _tempView.bottom)];
    [self addSubview:tapView];
    
    // 添加点击手势view
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapedActionToPushToDetail)];
    [tapView addGestureRecognizer:tapGesture];
    
    _addreView = [[UIView alloc] initWithFrame:CGRectMake(10, _mapView.bottom - 50, self.width-20, 35)];
    _addreView.backgroundColor = RGBA(255, 255, 255, 0.8);
    _addreView.layer.cornerRadius = 2;

    [_addreView addSubview:_addressLabel];
    
    [self addSubview:_addreView];
    
    self.height = _tempView.bottom+kBottomViewHeight;
}

- (BMKGeoCodeSearch *)geoSearch {
    if (!_geoSearch) {
        _geoSearch = [[BMKGeoCodeSearch alloc]init];
        _geoSearch.delegate = self;
    }
    return _geoSearch;
}

- (void)setDetailModel:(HKCommunityDetailModel *)detailModel {
    _detailModel = detailModel;
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([detailModel.locationLat doubleValue], [detailModel.locationLon doubleValue]);
    _houseLocation = location;
    [self setMapLocationCenter];
    [self setHouseLocation:location];;
    self.addressLabel.text = detailModel.address;
}

- (void)setHouseLocation:(CLLocationCoordinate2D)houseLocation {
    [self setMapLocationCenter];
    
    BMKPoiInfo *poiInfo = [BMKPoiInfo new];
    poiInfo.pt = _houseLocation;
    poiInfo.address = _detailModel.address;
    [_mapView removeAnnotations:_mapView.annotations];
    [self addPointAnnotationWith:poiInfo];
    
    BMKReverseGeoCodeSearchOption *reverseGeoCodeOption = [[BMKReverseGeoCodeSearchOption alloc] init];
    reverseGeoCodeOption.location = _houseLocation;
    [self.geoSearch reverseGeoCode:reverseGeoCodeOption];
}

#pragma mark 根据坐标返回反地理编码搜索结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
//    NSString *addr = result.sematicDescription;
    NSString *addr =  result.address;
    if (result.poiList.count > 0) {
        BMKPoiInfo *info = result.poiList.firstObject;
        addr = info.address;
    }
    /// self.addressStr有值就用原来的值，没值就定反编码出来的值
//    if (addr.length > 0 && ![self.addressStr isExist]) {
//        _geoSearch.delegate = nil;
//    }
}
#pragma mark - 点击进入地图详情
- (void)viewTapedActionToPushToDetail {
    _currentIndex = -1;
    [self jumpMapDetail];
}

#pragma mark - 手势点击Action
- (void)viewTapedAction {
    [self jumpMapDetail];
    _currentIndex = 0;
}

#pragma mark - 跳转进入地图详情
- (void)jumpMapDetail {
    DetailSurroundingFacilityViewController *vc = [[DetailSurroundingFacilityViewController alloc] init];
    vc.isSelectedNemu = (_currentIndex != -1) ? YES : NO;
    vc.currentIndex = _currentIndex;
    vc.houseLocation = self.houseLocation;
    [[HFTControllerManager getCurrentAvailableNavController] pushViewController:vc animated:YES];
}

#pragma mark - 加载底部选择按钮
- (void)initBottomButtom {
    // scrollview
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _tempView.bottom, self.width, kBottomViewHeight)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_mainScrollView];
    
    CGFloat x = 0;
    for (NSInteger i = 0; i < _titles.count; i ++) {
        x = i == 0 ? kBottomBtnSpacing : x;
        CustomButtonView *view = [[CustomButtonView alloc] initWithFrame:CGRectMake(x, 0, kBottomBtnWidth, kBottomViewHeight)];
        view.delegate = self;
        view.isSelected = NO;
        view.tag = Default_Button_Tag + i;
        [view setImageWith:_images[i] SelectedImage:_selectedImages[i] title:_titles[i]];
        [_mainScrollView addSubview:view];
        x = view.right + kBottomBtnSpacing;
    }
    _mainScrollView.contentSize = CGSizeMake(x, kBottomViewHeight);
}

#pragma mark - 设置地图定位中心
- (void)setMapLocationCenter {
    [_mapView setCenterCoordinate:_houseLocation animated:YES];
    _mapView.zoomLevel = 17;
}

#pragma mark - 添加pointAnnotation
- (void)addPointAnnotationWith:(BMKPoiInfo *)poiInfo {
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = poiInfo.pt;
    annotation.title = poiInfo.name;
    annotation.subtitle = poiInfo.address;
    [_mapView addAnnotation:annotation];
}

#pragma mark - ---------- 代理方法 ----------
#pragma mark - 百度地图delegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
    newAnnotationView.animatesDrop = NO;
    newAnnotationView.annotation = annotation;
    UIImage *image = rzImage(@"housedetail_location_icon");
    newAnnotationView.image = image;
    newAnnotationView.size = image.size;
    return newAnnotationView;
}

#pragma mark - CustomButtonViewDelegate
- (void)customButtonTapedActionWith:(CustomButtonView *)view buttonSelected:(BOOL)isSelected {
    _currentIndex = view.tag - Default_Button_Tag;
    [self viewTapedAction];
}

@end
