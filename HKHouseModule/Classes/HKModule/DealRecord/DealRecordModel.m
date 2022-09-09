//
//  DealRecordModel.m
//  ErpApp
//
//  Created by midland on 2022/8/12.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "DealRecordModel.h"

@implementation BuildingData

@end

@implementation DealRecordModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"buildingDatas":[BuildingData class]
    };
}

@end

@implementation DealRecord

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"buildingDataVos":[DealRecordModel class]
    };
}

@end

@implementation BuildModel

@end

@implementation CommunityBuildModel

//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{@"communityID": @"id"};
//}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"buildVos":[BuildModel class]
    };
}

@end
