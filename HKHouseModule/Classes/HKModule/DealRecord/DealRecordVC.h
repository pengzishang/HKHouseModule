//
//  DealRecordVC.h
//  ErpApp
//
//  Created by midland on 2022/8/12.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DealRecordVC : UIViewController

- (instancetype)initWithEstateId:(NSString *)estateId;

@property (nonatomic, strong)NSString *estateId;

@end

NS_ASSUME_NONNULL_END
