//
//  HKHouseTargrtAction.m
//  ErpApp
//
//  Created by midland on 2022/8/6.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "HKHouseTargrtAction.h"
#import "HKHouseMainVC.h"

@implementation HKHouseTargrtAction

/// 获取香港房源入口
- (UIViewController *)house_getHKHouseController:(nullable NSDictionary *)params {
    return [[HKHouseMainVC alloc] init];
}

@end
