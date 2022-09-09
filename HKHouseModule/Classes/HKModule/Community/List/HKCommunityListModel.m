//
//  HKCommunityListModel.m
//  ErpApp
//
//  Created by midland on 2022/8/2.
//  Copyright © 2022 haofangtongerp. All rights reserved.
//

#import "HKCommunityListModel.h"
#import <MJExtension/MJExtension.h>

@implementation HKCommunityListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"communityId": @"id"};
}

@end
