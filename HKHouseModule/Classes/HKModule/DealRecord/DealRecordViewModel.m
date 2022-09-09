//
//  DealRecordViewModel.m
//  ErpApp
//
//  Created by midland on 2022/8/12.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "DealRecordViewModel.h"
#import "HKHouseCommon.h"

@implementation DealRecordViewModel

- (void)requestTradRecordWithEstateId:(NSString *)estateId buildingId:(NSString *)buildingId phaseId:(NSString *)phaseId result:(void(^)(NSError *error))block {
    NSString *url = HOUSE_SERVICE(@"SZHKHouse/searchTradRecordByEid");
    if (![estateId isExist] || ![buildingId isExist] || ![phaseId isExist]) {
        return;
    }
    NSMutableDictionary *params = @{ @"estateId": estateId,
                                     @"buildingId": buildingId,
                                     @"phaseId": phaseId,
                                     }.mutableCopy;
 
    [[HFTHttpManager managerForAESEncryp] get:url params:params complete:^(id data, HFTError *error) {
        if (error) {
            if (block) {
                block([NSError errorWithDomain:error.errMsg code:error.errCode userInfo:nil]);
            }
        } else {
            self.dealRecord = [DealRecord mj_objectWithKeyValues:data];
            self.dealRecordModels = [DealRecordModel mj_objectArrayWithKeyValuesArray:data[@"buildingDataVos"]];
            block(nil);
        }
    }];
}

- (void)searchTradRecordConditionWithEstateId:(NSString *)estateId  result:(void(^)(NSError *error))block {
    NSString *url = HOUSE_SERVICE(@"SZHKHouse/searchTradRecordCondition");
    if (![estateId isExist] ) {
        return;
    }
    NSMutableDictionary *params = @{ @"estateId": estateId }.mutableCopy;
    [[HFTHttpManager managerForAESEncryp] get:url params:params complete:^(id data, HFTError *error) {
        if (error) {
            if (block) {
                block([NSError errorWithDomain:error.errMsg code:error.errCode userInfo:nil]);
            }
        } else {
            self.communityBuilds = [CommunityBuildModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
            block(nil);
        }
    }];
}



@end
