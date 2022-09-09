//
//  DealRecordViewModel.h
//  ErpApp
//
//  Created by midland on 2022/8/12.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DealRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DealRecordViewModel : NSObject

@property (nonatomic, strong)DealRecord *dealRecord;

@property (nonatomic, strong)NSArray <DealRecordModel *> *dealRecordModels;

@property (nonatomic, strong)NSArray<CommunityBuildModel *> *communityBuilds;

- (void)requestTradRecordWithEstateId:(NSString *)estateId buildingId:(NSString *)buildingId phaseId:(NSString *)phaseId result:(void(^)(NSError *error))block;

- (void)searchTradRecordConditionWithEstateId:(NSString *)estateId  result:(void(^)(NSError *error))block;

@end

NS_ASSUME_NONNULL_END
