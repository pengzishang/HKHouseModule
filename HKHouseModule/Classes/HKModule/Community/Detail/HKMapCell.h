//
//  HKMapCell.h
//  ErpApp
//
//  Created by midland on 2022/7/22.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "HKCommunityDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKMapCell : UITableViewCell

@property (nonatomic, strong) HKCommunityDetailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
