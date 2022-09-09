//
//  HKSecondeHouseDetailViewModel.h
//  ErpApp
//
//  Created by midland on 2022/8/10.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKSecondeHouseDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKSecondeHouseDetailViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *dataSource;

@property (nonatomic, strong) HKSecondeHouseDetailModel *detailModel;

- (void)requestDataWithSerialNo:(NSString *)serialNo result:(void(^)(NSError *error))block;


@end

NS_ASSUME_NONNULL_END
