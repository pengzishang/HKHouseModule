//
//  DetailMapView.h
//  ErpApp
//
//  Created by midland on 2022/7/22.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "HKCommunityDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailMapView : UIView

- (instancetype)initWithFrame:(CGRect)frame hideTitle:(BOOL)hideTitle;
/**标题*/
@property (nonatomic, strong) UILabel *title;
/**房源坐标*/
@property (nonatomic, assign) CLLocationCoordinate2D houseLocation;

@property (nonatomic, strong) HKCommunityDetailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
