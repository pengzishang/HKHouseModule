//
//  HKSearchView.h
//  ErpApp
//
//  Created by midland on 2022/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKSearchView : UIView

@property (nonatomic, copy) NSString *keyword;
/**placeholder*/
@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, copy) void(^searchBlock)(NSString *searchText);

@end

NS_ASSUME_NONNULL_END
