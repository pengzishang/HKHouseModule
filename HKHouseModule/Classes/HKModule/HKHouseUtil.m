//
//  HKHouseUtil.m
//  HKHouseModule
//
//  Created by DeshHome on 2022/9/8.
//

#import "HKHouseUtil.h"
#import <HFTCommonDefinition/HFTCommonDefinition.h>
#import <ErpNetwork/ErpNetworkHeader.h>
#import <ErpNetworkConfig/APPNetworkConfig.h>
@interface HKHouseUtil ()



@end

@implementation HKHouseUtil

static HKHouseUtil *manager = nil;

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)setRate:(NSNumber *)rate {
    [[NSUserDefaults standardUserDefaults]setObject:rate forKey:@"exchangeRate"];
}

- (NSNumber *)rate {
    NSNumber *cache = [[NSUserDefaults standardUserDefaults]objectForKey:@"exchangeRate"];
    if (cache) {
        return cache;
    } else {
        self.rate = @(1.1353);
        return self.rate;
    }
}

- (BOOL)isCNY {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"exchangeCurrent"]) {
        return [[[NSUserDefaults standardUserDefaults]objectForKey:@"exchangeCurrent"] boolValue];
    } else {
        self.isCNY = YES;
        return self.isCNY;
    }
}

- (void)setIsCNY:(BOOL)isCNY {
    [[NSUserDefaults standardUserDefaults]setBool:isCNY forKey:@"exchangeCurrent"];
}

+ (CGFloat)toSquare:(CGFloat)feet {
    return feet / 10.764;
}

+ (CGFloat)toFeet:(CGFloat)square {
    return square * 0.0929;
}

- (void)getRateCompletion:(void(^)(NSNumber *rate))block {
    if ([[HKHouseUtil shareManager] rate]) {
        block([[HKHouseUtil shareManager] rate]);
    }
    NSString *url = HOUSE_SERVICE(@"SZHKHouse/getRateFromCode");
    [[HFTHttpManager managerForAESEncryp] get:url params:nil complete:^(id data, HFTError *error) {
        if (!error) {
            [HKHouseUtil shareManager].rate = data[@"stupidKey"];
            EXECUTE_BLOCK(block, nil);
        }
    }];
}
@end
