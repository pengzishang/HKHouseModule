//
//  SaleinformationCell.h
//  ErpApp
//
//  Created by midland on 2022/8/8.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCommunityDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 销售信息cell
@interface SaleinformationCell : UITableViewCell

@property (nonatomic, strong)HKCommunityDetailModel *model;

@end

NS_ASSUME_NONNULL_END
