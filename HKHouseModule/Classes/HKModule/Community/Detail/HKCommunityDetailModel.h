//
//  HKCommunityDetailModel.h
//  ErpApp
//
//  Created by midland on 2022/8/8.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKSecondHouseModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 楼价走势
@interface Monthlies : NSObject

@property (nonatomic, strong) NSString *avgFtPrice;
@property (nonatomic, strong) NSString *avgFtPriceChg;
@property (nonatomic, strong) NSString *avgFtRent;
@property (nonatomic, strong) NSString *avgFtRentChg;
@property (nonatomic, strong) NSString *avgNetFtPrice;
@property (nonatomic, strong) NSString *avgNetFtPriceChg;
@property (nonatomic, strong) NSString *avgNetFtRent;
@property (nonatomic, strong) NSString *avgNetFtRentChg;
@property (nonatomic, strong) NSString *circulateRate;
@property (nonatomic, strong) NSString *districtId;
@property (nonatomic, strong) NSString *districtName;

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *maxFtPrice;
@property (nonatomic, strong) NSString *maxFtRent;
@property (nonatomic, strong) NSString *maxNetFtPrice;
@property (nonatomic, strong) NSString *maxNetFtRent;
@property (nonatomic, strong) NSString *minFtPrice;
@property (nonatomic, strong) NSString *minFtRent;
@property (nonatomic, strong) NSString *minNetFtPrice;
@property (nonatomic, strong) NSString *minNetFtRent;

@property (nonatomic, strong) NSString *monthlyDate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *preAvgFtPrice;
@property (nonatomic, strong) NSString *preAvgFtRent;
@property (nonatomic, strong) NSString *preAvgNetFtPrice;
@property (nonatomic, strong) NSString *preAvgNetFtRent;
@property (nonatomic, strong) NSString *preCirculateRate;
@property (nonatomic, strong) NSString *preMaxFtPrice;
@property (nonatomic, strong) NSString *preMaxFtRent;
@property (nonatomic, strong) NSString *preMaxNetFtPrice;

@property (nonatomic, strong) NSString *preMaxNetFtRent;
@property (nonatomic, strong) NSString *preMinFtPrice;
@property (nonatomic, strong) NSString *preMinFtRent;
@property (nonatomic, strong) NSString *preMinNetFtPrice;
@property (nonatomic, strong) NSString *preMinNetFtRent;
@property (nonatomic, strong) NSString *preTotalNoOfUnit;
@property (nonatomic, strong) NSString *preTotalRentTxAmount;
@property (nonatomic, strong) NSString *preTotalRentTxCount;
@property (nonatomic, strong) NSString *preTotalTxAmount;
@property (nonatomic, strong) NSString *preTotalTxCount;

@property (nonatomic, strong) NSString *regionId;
@property (nonatomic, strong) NSString *regionName;
@property (nonatomic, strong) NSString *sourceId;
@property (nonatomic, strong) NSString *subregionId;
@property (nonatomic, strong) NSString *subregionName;
@property (nonatomic, strong) NSString *totalNoOfUnit;
@property (nonatomic, strong) NSString *totalRentTxAmount;
@property (nonatomic, strong) NSString *totalRentTxCount;
@property (nonatomic, strong) NSString *totalTxAmount;
@property (nonatomic, strong) NSString *totalTxCount;
@property (nonatomic, strong) NSString *type;

@end

/// 周边配套设施
@interface District : NSObject

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *intSmDistrictId;
@property (nonatomic, strong) NSString *locationLat;
@property (nonatomic, strong) NSString *locationLon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sourceId;
@property (nonatomic, strong) NSString *subCategory;
@property (nonatomic, strong) NSString *tags;
@property (nonatomic, strong) NSString *updateDate;
@end

@interface Photo : NSObject
/// 图片id
@property (nonatomic, strong) NSString *photoID;
/// 小区id
@property (nonatomic, strong) NSString *estateId;
/// 图片名称
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *licenceNo;

/// 图片地址
@property (nonatomic, strong) NSString *path;

@end

/// 小区平面图
@interface FloorPlan : NSObject

@property (nonatomic, strong) NSString *buildingId;
@property (nonatomic, strong) NSString *buildingName;
@property (nonatomic, strong) NSString *estateId;

@property (nonatomic, strong) NSString *floorDesc;
@property (nonatomic, strong) NSString *floorFrom;
@property (nonatomic, strong) NSString *floorTo;
@property (nonatomic, strong) NSString *floorplanId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phaseId;
@property (nonatomic, strong) NSString *phaseName;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *wanDocPath;

@end

/// 小区规划图
@interface SitePlans : NSObject

/// 图
@property (nonatomic, strong) NSString *siteplanPath;

@property (nonatomic, strong) NSString *estateId;
/// 图片id
@property (nonatomic, strong) NSString *photoID;

@end

/// 经纪人数据
@interface Agency : NSObject

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *agentStatCount;
@property (nonatomic, strong) NSString *altName;
@property (nonatomic, strong) NSString *branchWanDocPath;
@property (nonatomic, strong) NSString *comdistIds;
@property (nonatomic, strong) NSString *deptCode;
@property (nonatomic, strong) NSString *deptHeadAgentChatLink;
@property (nonatomic, strong) NSString *deptHeadEmail;
@property (nonatomic, strong) NSString *deptHeadLicenceNo;
@property (nonatomic, strong) NSString *deptHeadNameChi;
@property (nonatomic, strong) NSString *deptHeadNameEng;
@property (nonatomic, strong) NSString *deptHeadPhotoPath;

@property (nonatomic, strong) NSString *deptHeadPhoneNo;
@property (nonatomic, strong) NSString *deptHeadTitle;
@property (nonatomic, strong) NSString *deptHeadUrlDesc;
@property (nonatomic, strong) NSString *deptHeadWechatId;
@property (nonatomic, strong) NSString *deptHeadWechatQrPath;
@property (nonatomic, strong) NSString *deptHeadWhatsappText;
@property (nonatomic, strong) NSString *distIds;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *faxNo;
@property (nonatomic, strong) NSString *agencyId;

@property (nonatomic, strong) NSString *intdistIds;
@property (nonatomic, strong) NSString *intsmdistIds;
@property (nonatomic, strong) NSString *isDeluxe;
@property (nonatomic, strong) NSString *locationLat;
@property (nonatomic, strong) NSString *locationLon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phoneNo;
@property (nonatomic, strong) NSString *propertyStatRentCount;
@property (nonatomic, strong) NSString *propertyStatSellCount;
@property (nonatomic, strong) NSString *regionIds;
@property (nonatomic, strong) NSString *sourceId;
@property (nonatomic, strong) NSString *subregionIds;
@property (nonatomic, strong) NSString *urlDesc;

@end

/// 小区详情
@interface HKCommunityDetailModel : NSObject
/// 平均放盘价，即单价
@property (nonatomic, strong) NSString *avgNetFtPrice;
/// 停车位
@property (nonatomic, strong) NSString *carpark;
/// 周边配套设施
@property (nonatomic, strong) NSArray <District *> *district;
/// 小区编号
@property (nonatomic, strong) NSString *estateId;
/// 物业设施
@property (nonatomic, strong) NSString *facilityGroup;
/// 建筑年代
@property (nonatomic, strong) NSString *firstOpDate;
/// 小区平面图
@property (nonatomic, strong) NSArray<FloorPlan *> *floorPlans;
/// 楼龄
@property (nonatomic, strong) NSString *houseAge;
/// 物业栋数
@property (nonatomic, strong) NSString *housePropertyNum;
/// 小区id
@property (nonatomic, strong) NSString *communityID;
/// 图片名称
@property (nonatomic, strong) NSString *imgName;
/// 图片路径
@property (nonatomic, strong) NSString *imgPath;
/// 片區號碼
@property (nonatomic, strong) NSString *intSmDistrictId;
/// 片区名称
@property (nonatomic, strong) NSString *intSmDistrictName;
/// 经纬度
@property (nonatomic, strong) NSString *locationLat;
@property (nonatomic, strong) NSString *locationLon;
/// 平均成交价（过去30日成交）
@property (nonatomic, strong) NSString *marketStatNetFtPrice;
/// 较上月波幅
@property (nonatomic, strong) NSString *marketStatNetFtPriceChg;
/// 近30日成交（单位套）
@property (nonatomic, strong) NSString *marketStatTxCount;
/// 最高
@property (nonatomic, strong) NSString *maxNetFtPrice;
/// 售价最高
@property (nonatomic, strong) NSString *maxPrice;
/// 小区概况
@property (nonatomic, strong) NSString *merits;
///最低
@property (nonatomic, strong) NSString *minNetFtPrice;
/// 售价最低
@property (nonatomic, strong) NSString *minPrice;
/// 楼价走势
@property (nonatomic, strong) NSArray<Monthlies *> *monthlies;
/// 小区中文名
@property (nonatomic, strong) NSString *nameChi;
/// 小区英文名
@property (nonatomic, strong) NSString *nameEn;
/// 产权年限
@property (nonatomic, strong) NSString *termOfYear;
/// 物业层数
@property (nonatomic, strong) NSString *noOfStoreys;
/// 物業期數
@property (nonatomic, strong) NSString *phaseId;
/// 小区图片
@property (nonatomic, strong) NSArray<Photo *> *photos;
/// 小学代号（物业校网使用）
@property (nonatomic, strong) NSString *schoolNetPrimaryId;
/// 中学名称（物业校网使用）
@property (nonatomic, strong) NSString *schoolNetSecondaryName;
/// 在售【在售房源数(单位套)】
@property (nonatomic, strong) NSString *sellCount;
/// 小区规划图
@property (nonatomic, strong) NSArray<SitePlans *> *sitePlans;
/// 小区房源
@property (nonatomic, strong) NSArray<HKSecondHouseModel *> *top8HouseVos;
/// 房屋总数
@property (nonatomic, strong) NSString *totalFlats;

@property (nonatomic, strong) Agency *agency;
/// 小区地址
@property (nonatomic, strong) NSString *address;
/// 最大面积
@property (nonatomic, strong) NSString *maxArea;
/// 最小面积
@property (nonatomic, strong) NSString *minArea;

@end

NS_ASSUME_NONNULL_END
