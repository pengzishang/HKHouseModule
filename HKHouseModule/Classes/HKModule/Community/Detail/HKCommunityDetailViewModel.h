//
//  HKCommunityDetailViewModel.h
//  ErpApp
//
//  Created by midland on 2022/7/25.
//

#import <Foundation/Foundation.h>
#import "HKCommunityDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HKCommunityDetailViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *dataSource;

@property (nonatomic, strong) HKCommunityDetailModel *detailModel;
/// 楼价走势
@property (nonatomic, strong) NSArray<Monthlies *> *monthlies;

/// 获取小区详情
- (void)requestDataWithEstateId:(NSString *)estateId result:(void(^)(NSError *error))block;

/// 获取楼价走势
- (void)searchPropertyPricesTrendWithEstateId:(NSString *)estateId searchType:(NSString *)searchType  result:(void(^)(NSError *error))block;
@end

NS_ASSUME_NONNULL_END
