//
//  DealRecordModel.h
//  ErpApp
//
//  Created by midland on 2022/8/12.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuildingData : NSObject

@property (nonatomic, strong)NSString *area;
@property (nonatomic, strong)NSString *bldgType;
@property (nonatomic, strong)NSString *buildingId;
@property (nonatomic, strong)NSString *buildingName;
@property (nonatomic, strong)NSString *estateId;
@property (nonatomic, strong)NSString *estateName;
@property (nonatomic, strong)NSString *flat;
@property (nonatomic, strong)NSString *flatName;
@property (nonatomic, strong)NSString *floor;
@property (nonatomic, strong)NSString *floorSeq;
@property (nonatomic, strong)NSString *netArea;
@property (nonatomic, strong)NSString *phaseId;
@property (nonatomic, strong)NSString *phaseName;
@property (nonatomic, strong)NSString *price;
@property (nonatomic, strong)NSString *unitId;
@property (nonatomic, strong)NSString *unitType;

@end

@interface DealRecordModel : NSObject

@property (nonatomic, strong)NSArray<BuildingData *> *buildingDatas;
@property (nonatomic, strong)NSString *floor;

@end

@interface DealRecord : NSObject

@property (nonatomic, strong)NSString *flatMax;
@property (nonatomic, strong)NSString *flatMin;
@property (nonatomic, strong)NSArray<DealRecordModel *> *buildingDataVos;

@end

@interface BuildModel : NSObject

@property (nonatomic, strong)NSString *buildingId;
@property (nonatomic, strong)NSString *buildingName;

@end

/// 小区楼栋
@interface CommunityBuildModel : NSObject

@property (nonatomic, strong)NSString *phaseId;
@property (nonatomic, strong)NSString *phaseName;
@property (nonatomic, strong)NSArray<BuildModel *> *buildVos;

@end

NS_ASSUME_NONNULL_END
