//
//  MapSupportFacilitiesAddressCell.h
//  ErpApp
//
//  Created by midland on 2022/7/22.
//

#import <UIKit/UIKit.h>
#import "HKHouseCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapSupportFacilitiesAddressCell : UITableViewCell

/**单个数据源model*/
- (void)setDataModel:(BMKPoiInfo *)dataModel WithHouseLocationPT:(CLLocationCoordinate2D)houseLocationPT;

@end

NS_ASSUME_NONNULL_END
