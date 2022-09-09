//
//  AgentCardView.h
//  ErpApp
//
//  Created by midland on 2022/8/9.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCommunityDetailModel.h"
#import "HKSecondeHouseDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AgentCardView : UIView

@property (nonatomic, strong)Agency *agencyModel;

@property (nonatomic, strong)AgentModel *agentModel;
@end

NS_ASSUME_NONNULL_END
