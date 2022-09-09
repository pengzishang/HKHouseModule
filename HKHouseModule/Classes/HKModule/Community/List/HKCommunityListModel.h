//
//  HKCommunityListModel.h
//  ErpApp
//
//  Created by midland on 2022/8/2.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKCommunityListModel : NSObject

@property (nonatomic, strong) NSString  *imgName;
/// 图片的地址
@property (nonatomic, strong) NSString  *imgPath;
/// 平均放盘价，即单价
@property (nonatomic, strong) NSString  *avgNetFtPrice;
/// 小区编号
@property (nonatomic, strong) NSString  *estateId;
/// 小区ID
@property (nonatomic, strong) NSString  *communityId;
/// 片區號碼
@property (nonatomic, strong) NSString  *intSmDistrictId;
/// 片区名称
@property (nonatomic, strong) NSString  *intSmDistrictName;
/// 近30日成交（单位套）
@property (nonatomic, strong) NSString  *marketStatTxCount;
/// 小区中文名
@property (nonatomic, strong) NSString  *nameChi;
/// 小区中英文名
@property (nonatomic, strong) NSString  *nameEn;
/// 在售【在售房源数(单位套)】
@property (nonatomic, strong) NSString  *sellCount;
/// 建筑年代
@property (nonatomic, strong) NSString  *firstOpDate;
/// 最大面积
@property (nonatomic, strong) NSString *maxArea;
/// 最大面积
@property (nonatomic, strong) NSString *minArea;




@end

NS_ASSUME_NONNULL_END
