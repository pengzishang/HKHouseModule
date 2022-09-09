//
//  HKCommunityListViewModel.h
//  ErpApp
//
//  Created by midland on 2022/7/26.
//

#import <Foundation/Foundation.h>
#import "HKCommunityListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKCommunityListViewModel : NSObject
/// 页数
@property (nonatomic, assign) NSUInteger pageNum;
/// 数据源
@property (nonatomic, strong)NSMutableArray <HKCommunityListModel *> *dataSource;
/// 请求小区列表
- (void)requestDataWithResult:(void(^)(NSError *error, BOOL hasMore))block;
/// 搜索关键字
@property (nonatomic, copy) NSString *searchKeyword;

@property (nonatomic, copy,nullable) NSString * intDistrictIds;
// 获取所有的筛选条件的方法
@property (nonatomic, copy) NSDictionary *(^SearchListCondition)(void);

@end

NS_ASSUME_NONNULL_END
