//
//  NSString+Concatenate.h
//  ZaccoBooth
//
//  Created by Kristoffer Anger on 2018-10-24.
//  Copyright © 2018 Kristoffer Anger. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Concatenate)

// python-like join method
- (NSString *)join:(nullable NSString *)firstString, ... NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END
