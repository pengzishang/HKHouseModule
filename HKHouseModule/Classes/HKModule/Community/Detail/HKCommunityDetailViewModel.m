//
//  HKCommunityDetailViewModel.m
//  ErpApp
//
//  Created by midland on 2022/7/25.
//

#import "HKCommunityDetailViewModel.h"
#import "HKHouseCommon.h"

@implementation HKCommunityDetailViewModel

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
        [self.dataSource addObject:@{@"cellName":@"HKCommunityDetailCell", @"type":@""}];
        [self.dataSource addObject:@{@"cellName":@"SaleinformationCell", @"type":@""}];
        [self.dataSource addObject:@{@"cellName":@"CommonInformationCell", @"type":@""}];
        [self.dataSource addObject:@{@"cellName":@"HouseCell", @"type":@""}];
        [self.dataSource addObject:@{@"cellName":@"HKMapCell", @"type":@""}];
        [self.dataSource addObject:@{@"cellName":@"PropertyPricesTrendCell", @"type":@""}];
    }
   
}

- (void)requestDataWithEstateId:(NSString *)estateId result:(void(^)(NSError *error))block {
    NSString *url = HOUSE_SERVICE(@"SZHKHouse/searchCommunityById");
    NSMutableDictionary *params = @{ @"estateId": estateId }.mutableCopy;
    [[HFTHttpManager managerForAESEncryp] get:url params:params complete:^(id data, HFTError *error) {
        if (error) {
            if (block) {
                block([NSError errorWithDomain:error.errMsg code:error.errCode userInfo:nil]);
            }
        } else {
            self.detailModel = [HKCommunityDetailModel mj_objectWithKeyValues:data];
//            楼价走势查询,searchType 0 半年 1 一年 2 二年 3 三年 4 全部,这里直接取2年的,然后切分
            [self searchPropertyPricesTrendWithEstateId:estateId searchType:@"2" result:^(NSError * _Nonnull error) {
                if (!error) {
                    block(nil);
                }
            }];
        }
    }];
}

- (void)searchPropertyPricesTrendWithEstateId:(NSString *)estateId searchType:(NSString *)searchType  result:(void(^)(NSError *error))block {
    NSString *url = HOUSE_SERVICE(@"SZHKHouse/searchPropertyPricesTrend");
    
    NSMutableDictionary *params = @{ @"estateId": estateId,
                                     @"searchType": searchType }.mutableCopy;
    
    [[HFTHttpManager managerForAESEncryp] postForJson:url params:params complete:^(id data, HFTError *error) {
        if (!error) {
            self.monthlies = [Monthlies mj_objectArrayWithKeyValuesArray:data[@"list"]];
            self.detailModel.monthlies = self.monthlies.copy;
            EXECUTE_BLOCK(block,nil);
        }
    }];
}




@end
