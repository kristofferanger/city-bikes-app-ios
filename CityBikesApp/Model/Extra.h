//
//  Extra.h
//
//  Created by Kristoffer Anger on 2019-03-06
//  Copyright (c) 2019 Zacco - 360° Intellectual Property. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Extra : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) double uid;

+ (Extra *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
