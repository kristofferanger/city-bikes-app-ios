//
//  Stations.h
//
//  Created by Kristoffer Anger on 2019-03-06
//  Copyright (c) 2019 Zacco - 360° Intellectual Property. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Extra;

@interface Stations : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) NSInteger freeBikes;
@property (nonatomic, assign) NSInteger emptySlots;

@property (nonatomic, strong) Extra *extra;
@property (nonatomic, strong) NSString *stationsIdentifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *timestamp;

+ (Stations *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
