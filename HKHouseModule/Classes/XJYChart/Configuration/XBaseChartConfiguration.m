//
//  XBaseChartConfiguration.m
//  XJYChart
//
//  Created by JunyiXie on 2017/12/3.
//  Copyright © 2017年 JunyiXie. All rights reserved.
//

#import "XBaseChartConfiguration.h"
#import "XColor.h"
#import "HKHouseCommon.h"

@implementation XBaseChartConfiguration

- (instancetype)init {
    if (self = [super init]) {
        self.chartBackgroundColor = XJYWhite;
        self.ordinateDenominator = 4;
        self.isScrollable = YES;
        self.isEnableNumberAnimation = YES;
        self.isShowOrdinate = YES;
        self.isShowXAbscissa = YES;
        self.ordinateTextColor = HEX_RGB(0xD8BA84);
    }
    return self;
}
@end
