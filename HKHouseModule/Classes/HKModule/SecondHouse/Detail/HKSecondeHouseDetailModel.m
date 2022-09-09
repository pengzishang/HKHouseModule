//
//  HKSecondeHouseDetailModel.m
//  ErpApp
//
//  Created by midland on 2022/8/10.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "HKSecondeHouseDetailModel.h"

@implementation VRModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"vrId": @"id"};
}

@end

@implementation AgentModel

@end

@implementation HKSecondeHouseDetailModel

//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{@"communityID": @"id"};
//}
//
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"top8HouseVos":[HKSecondHouseModel class],
             @"sitePlans":[SitePlans class],
             @"photos":[Photo class],
             @"district":[District class],
             @"floorPlans":[FloorPlan class],
             @"vrs": [VRModel class]
    };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"---------key:%@",key);
}
@end

