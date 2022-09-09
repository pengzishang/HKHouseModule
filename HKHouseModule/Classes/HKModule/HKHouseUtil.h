//
//  HKHouseUtil.h
//  HKHouseModule
//
//  Created by DeshHome on 2022/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKHouseUtil : NSObject

@property (nonatomic,copy) NSNumber *rate;

@property (nonatomic,assign) BOOL isCNY;

+ (instancetype)shareManager;

- (void)getRateCompletion:(void(^)(NSNumber *rate))block;

+ (CGFloat)toSquare:(CGFloat)feet;

+ (CGFloat)toFeet:(CGFloat)square;

@end

NS_ASSUME_NONNULL_END
