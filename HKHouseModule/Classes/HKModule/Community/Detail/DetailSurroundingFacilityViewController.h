//
//  HouseDetailSurroundingFacilityViewController.h
//  ErpApp
//
//  Created by Mi on 2017/12/25.
//  Copyright © 2017年 haofangtongerp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKHouseCommon.h"

@interface DetailSurroundingFacilityViewController : UIViewController
/**地图坐标*/
@property (nonatomic, assign) CLLocationCoordinate2D houseLocation;
/**选中下标*/
@property (nonatomic, assign) NSInteger currentIndex;
/**是否选择*/
@property (nonatomic, assign) BOOL isSelectedNemu;

@end
