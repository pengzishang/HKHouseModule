//
//  HKSecondeHouseDetailViewModel.m
//  ErpApp
//
//  Created by midland on 2022/8/10.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "HKSecondeHouseDetailViewModel.h"
#import "HKHouseCommon.h"

@implementation HKSecondeHouseDetailViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self resetDataSource];
    }
    return self;
}

- (NSMutableArray <NSDictionary *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
       
    }
    return _dataSource;
}

- (void)resetDataSource {
    [self.dataSource removeAllObjects];
    // 如果cell唯一，则不用设置type
    {
        // 房源标题栏
        [self.dataSource addObject:@{@"cellName":@"HKSecondeHouseDetailCell"}];
        [self.dataSource addObject:@{@"cellName":@"HouseSaleinformationCell"}];
        [self.dataSource addObject:@{@"cellName":@"HouseCommonInformationCell"}];
        [self.dataSource addObject:@{@"cellName":@"HKMapCell"}];
    }
   
}

- (void)requestDataWithSerialNo:(NSString *)serialNo result:(void(^)(NSError *error))block {
    NSString *url = HOUSE_SERVICE(@"SZHKHouse/searchHKHouseBySN");
    if (![serialNo isExist]) {
        return;
    }
    NSMutableDictionary *params = @{ @"serialNo": serialNo }.mutableCopy;
    [[HFTHttpManager managerForAESEncryp] get:url params:params complete:^(id data, HFTError *error) {
        if (error) {
            if (block) {
                block([NSError errorWithDomain:error.errMsg code:error.errCode userInfo:nil]);
            }
        } else {
            self.detailModel = [HKSecondeHouseDetailModel mj_objectWithKeyValues:data];
            block(nil);
        }
    }];
}


@end
