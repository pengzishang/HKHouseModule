//
//  SegementPhotoView.h
//  ErpApp
//
//  Created by midland on 2022/8/9.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SegementPhotoView : UIView

@property (nonatomic, strong)NSArray *dataSource;
/// 选中的下标：默认：0
@property (nonatomic, assign)NSInteger selectIndex;

@property (nonatomic, copy) void(^selectBlock)(NSInteger selectedIndex);

@end

NS_ASSUME_NONNULL_END
