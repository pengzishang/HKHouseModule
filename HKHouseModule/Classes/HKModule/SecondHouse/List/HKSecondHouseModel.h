//
//  HKSecondHouseModel.h
//  ErpApp
//
//  Created by midland on 2022/8/2.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKSecondHouseModel : NSObject
/// AI装修的数量
@property (nonatomic, strong) NSString  *aiDecorateCount;
/// AI装修列表
@property (nonatomic, strong) NSArray  *aiDecorates;
/// 建筑面积
@property (nonatomic, strong) NSString  *area;
/// 房数
@property (nonatomic, strong) NSString  *bedroom;
/// 楼盘地址
@property (nonatomic, strong) NSString  *buildingAddress;
/// 房龄
@property (nonatomic, strong) NSString  *houseAge;
/// 房源名称
@property (nonatomic, strong) NSString  *houseName;
/// 主键
@property (nonatomic, strong) NSString  *houseId;
/// 片区名称
@property (nonatomic, strong) NSString  *intSmDistrictName;
/// 楼盘卖点
@property (nonatomic, strong) NSString  *miscSell;
/// 实用率
@property (nonatomic, strong) NSString  *netAreaOverArea;
/// 朝向
@property (nonatomic, strong) NSString  *orientationName;
/// 楼盘缩图
@property (nonatomic, strong) NSString  *outlookWanDocPath;
/// 售价
@property (nonatomic, strong) NSString  *price;
/// 楼盘号码
@property (nonatomic, strong) NSString  *serialNo;
/// 厅数
@property (nonatomic, strong) NSString  *sittingRoom;
/// 页面展示的标签
@property (nonatomic, strong) NSArray  *tagList;
/// 标签
@property (nonatomic, strong) NSString  *tags;
/// vr的数量
@property (nonatomic, strong) NSString  *vrCount;

@property (nonatomic, strong) NSArray  *vrs;

@end

NS_ASSUME_NONNULL_END
