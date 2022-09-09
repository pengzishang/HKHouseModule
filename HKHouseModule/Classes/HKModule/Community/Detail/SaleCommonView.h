//
//  SaleCommonView.h
//  ErpApp
//
//  Created by midland on 2022/8/8.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaleCommonModel : NSObject

@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *imgString;
@property (nonatomic, strong)NSString *des;
@property (nonatomic, strong)NSString *subDes;

@end

@interface SaleCommonView : UIView

- (instancetype)initWithModel:(SaleCommonModel *)model frame:(CGRect)frame;

@property (nonatomic, strong)SaleCommonModel *model;

@property (nonatomic, strong)NSString *value;

- (void)makePriceStyle:(NSString *)price;

- (void)makeAreaStyle:(NSString *)area;

@end

NS_ASSUME_NONNULL_END
