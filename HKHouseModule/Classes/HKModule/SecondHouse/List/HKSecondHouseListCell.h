//
//  HKSecondHouseListCell.h
//  ErpApp
//
//  Created by midland on 2022/7/21.
//

#import <UIKit/UIKit.h>
#import "HKSecondHouseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKSecondHouseListCell : UITableViewCell

- (void)updateModel:(HKSecondHouseModel *)model;

@end

NS_ASSUME_NONNULL_END
