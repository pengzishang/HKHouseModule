//
//  XLineChartItem.h
//  RecordLife
//
//  Created by 谢俊逸 on 17/03/2017.
//  Copyright © 2017 谢俊逸. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCommunityDetailModel.h"

@interface XLineChartItem : NSObject

@property(nonatomic, strong) UIColor* color;
/// 用于显示数据
@property(nonatomic, strong) NSArray<NSNumber*>* numberArray;
/// 数据源
@property(nonatomic, strong) NSArray<Monthlies*>* dataArray;
/**
 设置数据item

 @param numberArray (NSNumber *)dataNumber
 @param color (UIColor *)color
 @return instancetype
 */
- (instancetype)initWithDataNumberArray:(NSArray*)numberArray
                              dataArray:(NSArray *)dataArray
                                  color:(UIColor*)color;

@end
