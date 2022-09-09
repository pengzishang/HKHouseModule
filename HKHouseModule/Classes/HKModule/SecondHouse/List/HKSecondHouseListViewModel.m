//
//  HKSecondHouseListViewModel.m
//  ErpApp
//
//  Created by midland on 2022/8/2.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "HKSecondHouseListViewModel.h"
#import "HKHouseCommon.h"

@interface HKSecondHouseListViewModel ()

/**
 每页条数
 */
@property (nonatomic, assign) NSUInteger pageSize;
/// 总页数
@property (nonatomic, assign) NSUInteger totalPage;

@end

@implementation HKSecondHouseListViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDefaultData];
    }
    return self;
}

- (void)createDefaultData {
    self.pageNum = 1;
    self.pageSize = 20;
    self.dataSource = [NSMutableArray array];
}

- (void)requestDataWithResult:(void(^)(NSError *error, BOOL hasMore))block {
    NSString *url = HOUSE_SERVICE(@"SZHKHouse/searchHouseList");
    
    NSMutableDictionary *params = @{
                                    @"pageOffset":@(self.pageNum),
                                    @"pageRows":@(self.pageSize),
                                    @"hasSaleHouse":@"1",
                                    @"estateId":self.estateId,
                                    }.mutableCopy;
    // :还需要添加默认配置的筛选条件
    NSDictionary *fitCondtions = ({
        NSDictionary *dic = nil;
        if (self.SearchListCondition) {
            dic = self.SearchListCondition();
        }
        dic;
    });
    
    [params addEntriesFromDictionary:fitCondtions];

    RZShowLoadingView
    [[HFTHttpManager managerForAESEncryp] postForJson:url params:params complete:^(id data, HFTError *error) {
        RZHideLoadingView
        if (error) {
            if (block) {
                block([NSError errorWithDomain:error.errMsg code:error.errCode userInfo:nil], NO);
            }
        } else {
            if (self.pageNum == 1) {
                self.dataSource = [HKSecondHouseModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
            }else {
                [self.dataSource addObjectsFromArray:[HKSecondHouseModel mj_objectArrayWithKeyValuesArray:data[@"list"]]];
            }
            self.pageNum = [data[@"meta"][@"pageNum"] integerValue];
            self.pageSize = [data[@"meta"][@"pageSize"] integerValue];
            self.totalPage = [data[@"meta"][@"totalPage"] integerValue];
            
            block(nil, self.pageNum <= self.totalPage);
        }
    }];
}

@end
