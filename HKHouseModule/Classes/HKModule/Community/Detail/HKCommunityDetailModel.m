//
//  HKCommunityDetailModel.m
//  ErpApp
//
//  Created by midland on 2022/8/8.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "HKCommunityDetailModel.h"

@implementation Monthlies


@end

@implementation District

@end

@implementation Photo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"photoID": @"id",
             @"path": @"wanDocPath" /// 二手房图片的地址转换
    };
}

@end

@implementation FloorPlan

//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{@"photoID": @"id"};
//}

@end



@implementation SitePlans

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"photoID": @"id"};
}

@end


@implementation Agency

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"agencyId": @"id"};
}

@end

@implementation HKCommunityDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"communityID": @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"top8HouseVos": [HKSecondHouseModel class],
             @"sitePlans": [SitePlans class],
             @"photos": [Photo class],
             @"district": [District class],
             @"floorPlans": [FloorPlan class],
             @"monthlies": [Monthlies class]
    };
}

@end
