//
//  HKSecondHouseListViewModel.h
//  ErpApp
//
//  Created by midland on 2022/8/2.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKSecondHouseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKSecondHouseListViewModel : NSObject
/// 页数
@property (nonatomic, assign) NSUInteger pageNum;
/// 数据源
@property (nonatomic, strong)NSMutableArray <HKSecondHouseModel *> *dataSource;
/// 小区编号
@property (nonatomic, strong)NSString *estateId;

/// 请求二手房列表
- (void)requestDataWithResult:(void(^)(NSError *error, BOOL hasMore))block;
// 获取所有的筛选条件的方法
@property (nonatomic, copy) NSDictionary *(^SearchListCondition)(void);

@end

NS_ASSUME_NONNULL_END
