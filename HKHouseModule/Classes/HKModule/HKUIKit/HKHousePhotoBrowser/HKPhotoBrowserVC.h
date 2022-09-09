/*******************************************************************************
 # File        : PhotoBrowserViewController.h
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

#import <HFTPhotoPreviewKit/BigPhotoPerviewHeader.h>
#import "HKPhotoBrowserItemModel.h"
@interface HKPhotoBrowserVC : BigPhotoPreviewBaseController

@property (nonatomic, strong) NSArray<HKPhotoBrowserItemModel *> *photos;

/**
 默认为YES
 */
@property (nonatomic, assign) BOOL showNavRightButton;

@property (nonatomic, copy) void(^didClickedNavBarRightButton)(void);
@end
