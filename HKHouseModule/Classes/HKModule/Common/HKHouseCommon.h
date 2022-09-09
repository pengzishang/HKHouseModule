//
//  HKHouseCommon.h
//  ErpApp
//
//  Created by midland on 2022/7/14.
//

#ifndef HKHouseCommon_h
#define HKHouseCommon_h

#import <HFTCommonDefinition/HFTCommonDefinition.h>
#import <HFTUIKit/CommonSegmentControl.h>
#import <HFTUIKit/HFTActionSheet.h>
#import <HFTUIKit/CLLPickerDate.h>
#import <HFTUIKit/HFTAlertView.h>
#import <ErpNetwork/ErpNetworkHeader.h>
#import <ErpCommon/ErpCommonDefinition.h>
#import <UIImageView+WebCache.h>
#import <HFTCategroy/UIView+Frame.h>
#import <HFTCategroy/NSString+Utils.h>
#import <HFTCategroy/NSDate+Format.h>
#import <Masonry.h>
#import <HFTNavigation/HFTControllerManager.h>
#import <RZColorful.h>
#import <ErpRubbish/RZHudHelper.h>
#import <HFTCommonDefinition/HFTCommonDefinition.h>
#import <BlocksKit+UIKit.h>
#import <HFTCategroy/UITableView+Method.h>
#import "MJRefresh.h"
#import <HFTCategroy/UIView+Border.h>
#import <HFTCategroy/UILabel+Tool.h>
#import <HFTCategroy/UILabel+Community.h>
#import <HFTCategroy/NSArray+Safe.h>
#import <ErpRubbish/HFTNoNetOrDataWarmingView.h>
#import <HFTCategroy/NSArray+Safe.h>
#import <HFTCategroy/UIImageView+Tool.h>
#import <ErpCommon/ErpCommonDefinition.h>
#import <HFTMapKit/HFTBMapKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <GlobalDataCacher/GDC.h>
#import <GlobalDataCacher/GDC+SystemParam.h>
#import <GlobalDataCacher/GDC+Archive.h>
#import <GlobalDataCacher/GDC+User.h>
#import <GlobalDataCacher/GDC+Company.h>
#import <GlobalDataCacher/GDC+CompanyDept.h>
#import <GlobalDataCacher/GDC+City.h>
#import <RZColorful/RZColorful.h>
#import <HFTTracker/HFTTrackHeader.h>

// 获取图片的方法
#define rzImage(x) [UIImage imageNamed:[NSString stringWithFormat:@"HKHouse.bundle/%@", x]]
#define rzImageStr(x) [NSString stringWithFormat:@"HKHouse.bundle/%@", x]

/**
 全局的分割线颜色
 */
#define rzGlobleSqlitLineColor RGB(236,236,236)

#define RZNSStringFromNumber(number) [NSString stringWithFormat:@"%@", number]

// 二选一的字符串选择
#define rzChooseOneString(AString, BString)  (AString != nil? AString : (BString == nil?@"":BString))
#define rzFitString(string) (rzFitStringEx(string, @""))
#define rzFitStringEx(string, replaceString) (string == nil? replaceString: string)
#define rzFitStringExDefault(a, b) [NSString stringWithFormat:@"%@%@",[a isExist] ? a : @"--",b]

#define RZWindow       [UIApplication sharedApplication].keyWindow

#define RZControllerView ([self isKindOfClass:[UIViewController class]]? ([(UIViewController *)self view]) : RZWindow)

// 显示菊花转圈图
#define RZShowLoadingView {\
    __weak typeof(self) weakSelf = self;\
    if (weakSelf) {\
        [HFTHud showLoadingTo:RZControllerView animated:NO];\
    }\
}

// 隐藏菊花转圈图
#define RZHideLoadingView {\
    __weak typeof(self) weakSelf = self;\
    if (weakSelf) {\
        [HFTHud hideHUDForView:RZControllerView animated:NO];\
    }\
}


#endif /* HKHouseCommon_h */
