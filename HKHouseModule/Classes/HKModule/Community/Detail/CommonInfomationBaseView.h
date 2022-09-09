//
//  CommonInfomationBaseView.h
//  ErpApp
//
//  Created by midland on 2022/8/8.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCommunityDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommonInfomationBaseViewModel : NSObject

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content;

@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *content;

@end

@interface CommonInfomationBaseView : UIView

@property (nonatomic, strong)CommonInfomationBaseViewModel *model;

@property (nonatomic, assign)NSInteger mLeft;

@end

NS_ASSUME_NONNULL_END
