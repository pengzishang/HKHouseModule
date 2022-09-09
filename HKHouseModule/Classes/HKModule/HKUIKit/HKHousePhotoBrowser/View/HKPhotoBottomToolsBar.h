/*******************************************************************************
 # File        : PhotoBottomToolsBar.h
 # Project     : ErpApp
 # Author      : rztime
 # Created     : 2017/12/23
 # Corporation : 成都好房通科技股份有限公司
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>

@interface HKPhotoBottomToolsBar : UIView

@property (nonatomic, strong) NSArray <NSString *>*titles;

@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, copy) void(^DidClickedIndex)(NSUInteger currentIndex);

@end
