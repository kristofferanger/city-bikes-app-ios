//
//  NSString+Concatenate.m
//  ZaccoBooth
//
//  Created by Kristoffer Anger on 2018-10-24.
//  Copyright © 2018 Kristoffer Anger. All rights reserved.
//

#import "NSString+Concatenate.h"

#define DELIMITER @"~^~"


@implementation NSString (Concatenate)

// joins strings with self as delimiter
- (NSString *)join:(nullable NSString *)firstString, ... NS_REQUIRES_NIL_TERMINATION {
    
    NSMutableArray *strings = [NSMutableArray new];
    NSCharacterSet *delimiterCharacterSet = [NSCharacterSet characterSetWithCharactersInString:self];
    
    va_list args;
    va_start(args, firstString);
    for (NSString *s = firstString; s != nil; s = va_arg(args, NSString *)) {
        [strings addObject:[s stringByTrimmingCharactersInSet:delimiterCharacterSet]];
    }
    va_end(args);
    return [strings componentsJoinedByString:self];
}

@end
