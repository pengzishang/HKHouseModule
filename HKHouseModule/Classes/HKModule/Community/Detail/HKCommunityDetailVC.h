//
//  HKCommunityDetailVC.h
//  ErpApp
//
//  Created by midland on 2022/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKCommunityDetailVC : UIViewController

@property (nonatomic, strong)NSString *estateId;

- (instancetype)initWithEstateId:(NSString *)estateId;

@end

NS_ASSUME_NONNULL_END
