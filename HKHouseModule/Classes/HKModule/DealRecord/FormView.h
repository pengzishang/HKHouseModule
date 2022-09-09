//
//  FormView.h
//  ErpApp
//
//  Created by midland on 2022/8/15.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormView : UIView

@property (nonatomic, strong)NSArray<DealRecordModel *> *dealRecordModels;

@end

NS_ASSUME_NONNULL_END
