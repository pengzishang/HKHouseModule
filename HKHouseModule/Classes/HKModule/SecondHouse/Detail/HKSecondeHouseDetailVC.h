//
//  HKSecondeHouseDetailVC.h
//  ErpApp
//
//  Created by midland on 2022/8/10.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKSecondeHouseDetailVC : UIViewController

@property (nonatomic, strong)NSString *serialNo;

- (instancetype)initWithSerialNo:(NSString *)serialNo;


@end

NS_ASSUME_NONNULL_END
