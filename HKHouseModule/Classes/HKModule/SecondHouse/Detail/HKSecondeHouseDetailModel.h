//
//  HKSecondeHouseDetailModel.h
//  ErpApp
//
//  Created by midland on 2022/8/10.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKCommunityDetailModel.h"

NS_ASSUME_NONNULL_BEGIN
@class Photo, FloorPlan, SitePlans;
@interface VRModel : NSObject

@property (nonatomic, strong) NSString *deluxe;
@property (nonatomic, strong) NSString *featureIcons;
@property (nonatomic, strong) NSString *licenceNo;
@property (nonatomic, strong) NSString *serialNo;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *vrLink;
@property (nonatomic, strong) NSString *vrThumbnail;
@property (nonatomic, strong) NSString *vrId;

@end

@interface AgentModel : NSObject

@property (nonatomic, strong) NSString *agentChatLink;
@property (nonatomic, strong) NSString *agentChatReady;
@property (nonatomic, strong) NSString *deptId;
@property (nonatomic, strong) NSString *email;
/// 头像
@property (nonatomic, strong) NSString *empPhoto;
/// 代理號碼
@property (nonatomic, strong) NSString *licenceNo;
/// 中文名
@property (nonatomic, strong) NSString *nameChi;
/// 英文名
@property (nonatomic, strong) NSString *nameEng;
/// 昵称
@property (nonatomic, strong) NSString *nickname;
/// 名
@property (nonatomic, strong) NSString *otherName;
/// 主盤人
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *serialNo;
/// 姓
@property (nonatomic, strong) NSString *surname;
/// 職位名稱
@property (nonatomic, strong) NSString *title;
/// 代理專頁link
@property (nonatomic, strong) NSString *urlDesc;
/// 電話
@property (nonatomic, strong) NSString *virtualPhoneNo;
/// WeChat號碼
@property (nonatomic, strong) NSString *wechatId;
/// WeChat QR圖
@property (nonatomic, strong) NSString *wechatQrPath;

@end

@interface HKSecondeHouseDetailModel : NSObject

/// 经纪人数据
@property (nonatomic, strong) AgentModel *agent;
/// AI装修的数量
@property (nonatomic, strong) NSString *aiDecorateCount;
///AI装修列表
@property (nonatomic, strong) NSString *aiDecorates;
/// 建筑面积（尺）
@property (nonatomic, strong) NSString *area;
/// 房数
@property (nonatomic, strong) NSString *bedroom;
/// 楼盘地址
@property (nonatomic, strong) NSString *buildingAddress;
/// 周边配套设施
@property (nonatomic, strong) NSString *district;
/// 小区编号
@property (nonatomic, strong) NSString *estateId;
/// 建筑日期
@property (nonatomic, strong) NSString *firstPubDate;
/// 平面图
@property (nonatomic, strong) NSArray<FloorPlan *> *floorPlans;
/// 房龄
@property (nonatomic, strong) NSString *houseAge;
/// 房源名称
@property (nonatomic, strong) NSString *houseName;
/// 片区号码
@property (nonatomic, strong) NSString *intSmDistrictId;
/// 片区名称
@property (nonatomic, strong) NSString *intSmDistrictName;
/// 楼盘卖点
@property (nonatomic, strong) NSString *miscSell;
/// 楼盘卖点
@property (nonatomic, strong) NSString *miscSells;
/// 实用率（%）
@property (nonatomic, strong) NSString *netAreaOverArea;
/// 朝向
@property (nonatomic, strong) NSString *orientationName;
/// 楼盘缩略图
@property (nonatomic, strong) NSString *outlookWanDocPath;
/// 图片
@property (nonatomic, strong) NSArray<Photo *> *photos;
/// 售價（总价）【单位港币】
@property (nonatomic, strong) NSString *price;
/// 樓盤號碼(即 物业编号)
@property (nonatomic, strong) NSString *serialNo;
/// 规划图
@property (nonatomic, strong) NSArray<SitePlans *> *sitePlans;
/// 廳數
@property (nonatomic, strong) NSString *sittingRoom;
/// 页面展示的标签
@property (nonatomic, strong) NSArray<NSString *> *tagList;
/// 标签
@property (nonatomic, strong) NSString *tags;
/// 产权年限
@property (nonatomic, strong) NSString *termOfYear;
/// 更新时间
@property (nonatomic, strong) NSString *updateDate;
/// VR的数量
@property (nonatomic, strong) NSString *vrCount;
@property (nonatomic, strong) NSArray<VRModel *> *vrs;

@property (nonatomic, strong) HKCommunityDetailModel *communityVO;



@end

NS_ASSUME_NONNULL_END
