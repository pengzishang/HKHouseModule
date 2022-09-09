//
//  NSArray+Utils.m
//  UUHaoFang
//
//  Created by Mi on 2017/6/19.
//  Copyright © 2017年 haofangtong. All rights reserved.
//

#import "NSArray+Utils.h"

@implementation NSArray (Utils)

+ (NSArray *)handleSortActionWithObjcetArr:(NSMutableArray *)array WithKeywordStr:(NSString *)keywordStr {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:keywordStr ascending:YES];
    return [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

@end
