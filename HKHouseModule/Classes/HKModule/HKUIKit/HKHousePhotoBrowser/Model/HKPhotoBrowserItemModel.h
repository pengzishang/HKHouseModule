/*******************************************************************************
 # File        : PhotoBrowserItemModel.h
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

#import <HFTPhotoPreviewKit/PhotoPreviewModel.h>

@interface HKPhotoBrowserItemModel : NSObject

@property (nonatomic, strong) NSString                              *title;
@property (nonatomic, strong) NSMutableArray <PhotoPreviewModel *>  *photos;

@end
