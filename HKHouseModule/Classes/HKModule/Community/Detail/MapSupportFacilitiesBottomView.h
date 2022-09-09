//
//  MapSupportFacilitiesBottomView.h
//  ErpApp
//
//  Created by midland on 2022/7/22.
//

#import <UIKit/UIKit.h>
#import "CustomButtonView.h"
#import "HKHouseCommon.h"

typedef void(^CustomButtonTapedActionBlock)(CustomButtonView *btn, BOOL isSelected, NSString *imageNameStr, NSString *KeyWordStr);        // 选中一个菜单回调

typedef void(^CustomCellTapedActionBlock)(CLLocationCoordinate2D pt);        // 选择一个cell回调


typedef NS_ENUM(NSUInteger, MapSupportingFacilitiesMenuType) {
    MapSupportingFacilitiesTypeForOrdinary = 0, // 公交、地铁
    MapSupportingFacilitiesTypeForOther         // 学校以后的菜单
};

@interface MapSupportFacilitiesBottomView : UIView
/**tableview*/
@property (nonatomic, strong) UITableView *mainTableView;
/**菜单类型*/
@property (nonatomic, assign) MapSupportingFacilitiesMenuType menuType;
/**选中下标*/
@property (nonatomic, assign) NSInteger currentIndex;
/**数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;
/**回调*/
@property (nonatomic, copy) CustomButtonTapedActionBlock customButtonBlock;
/**回调*/
@property (nonatomic, copy) CustomCellTapedActionBlock customCellBlock;
/**地图坐标*/
@property (nonatomic, assign) CLLocationCoordinate2D houseLocation;
/**回调方法*/
- (void)customButtonTapedActionBlock:(CustomButtonTapedActionBlock)block;
/**回调方法*/
- (void)customCellTapedActionBlock:(CustomCellTapedActionBlock)block;

/*设置选中的cell*/
- (void)settingTableViewCellSelected:(CLLocationCoordinate2D)coor;

- (instancetype)initWithFrame:(CGRect)frame WithIsStartAnimating:(BOOL)startAnimating;

@end
