//
//  HouseCell.h
//  ErpApp
//
//  Created by midland on 2022/8/8.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCommunityDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 房源
@interface HouseCell : UITableViewCell

@property (nonatomic, strong)HKCommunityDetailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
