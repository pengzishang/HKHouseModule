//
//  HKPhotosView.h
//  ErpApp
//
//  Created by midland on 2022/8/9.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCommunityDetailModel.h"


NS_ASSUME_NONNULL_BEGIN
@interface PhotosViewModel : NSObject

@property (nonatomic, strong)NSArray *imageURLStrings;

@property (nonatomic, strong)NSString *title;

- (instancetype)initWithTitle:(NSString *)title imageURLString:(NSArray *)imageURLStrings;

@end


@interface HKPhotosView : UIView

@property (nonatomic, strong)NSArray<PhotosViewModel *> *dataSource;

@end

NS_ASSUME_NONNULL_END
