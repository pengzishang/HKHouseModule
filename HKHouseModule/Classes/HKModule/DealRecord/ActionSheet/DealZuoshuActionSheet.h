//
//  DealZuoshuActionSheet.h
//  ErpApp
//
//  Created by midland on 2022/8/15.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

//@class CommunityBuildModel,BuildModel;

@interface DealZuoshuActionSheet : UIView

+ (DealZuoshuActionSheet *)showDealZuoshuSheetWithTitle:(nullable NSString *)title
                                     cancelTitle:(nullable NSString *)cancelTitle
                                 determinelTitle:(nullable NSString *)determinelTitle
                                       dataArray:(NSArray *)dataArray
                                     selectIndex:(NSInteger)selectIndex
                            determineActionBlock:(nullable void (^)(NSInteger row0, NSInteger row1, NSInteger row2, NSInteger row3))determineActionBlock
                                      cancleActionBlock:(nullable void(^)(void))cancleActionBlock;

- (instancetype)initWithDataArr:(NSArray<NSArray *> *)dataArr
                    selectIndex:(NSInteger)selectIndex
                          Title:(nullable NSString *)title
                    cancelTitle:(nullable NSString *)cancelTitle
                determinelTitle:(nullable NSString *)determinelTitle;

/**
 点击block回调
 */
@property (nonatomic, copy) void (^CancleAction)(void);

@property (nonatomic, copy) void (^didSelectPhone)(NSInteger row0, NSInteger row1, NSInteger row2, NSInteger row3);

- (void)show;

@end

NS_ASSUME_NONNULL_END
