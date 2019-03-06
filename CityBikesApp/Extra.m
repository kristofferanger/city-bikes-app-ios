//
//  Extra.m
//
//  Created by Kristoffer Anger on 2019-03-06
//  Copyright (c) 2019 Zacco - 360° Intellectual Property. All rights reserved.
//

#import "Extra.h"


NSString *const kExtraAddress = @"address";
NSString *const kExtraStatus = @"status";
NSString *const kExtraUid = @"uid";

@interface Extra ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Extra

@synthesize address = _address;
@synthesize status = _status;
@synthesize uid = _uid;


+ (Extra *)modelObjectWithDictionary:(NSDictionary *)dict
{
    Extra *instance = [[Extra alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.address = [self objectOrNilForKey:kExtraAddress fromDictionary:dict];
            self.status = [self objectOrNilForKey:kExtraStatus fromDictionary:dict];
            self.uid = [[self objectOrNilForKey:kExtraUid fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.address forKey:kExtraAddress];
    [mutableDict setValue:self.status forKey:kExtraStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.uid] forKey:kExtraUid];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.address = [aDecoder decodeObjectForKey:kExtraAddress];
    self.status = [aDecoder decodeObjectForKey:kExtraStatus];
    self.uid = [aDecoder decodeDoubleForKey:kExtraUid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_address forKey:kExtraAddress];
    [aCoder encodeObject:_status forKey:kExtraStatus];
    [aCoder encodeDouble:_uid forKey:kExtraUid];
}

- (id)copyWithZone:(NSZone *)zone
{
    Extra *copy = [[Extra alloc] init];
    
    if (copy) {

        copy.address = [self.address copyWithZone:zone];
        copy.status = [self.status copyWithZone:zone];
        copy.uid = self.uid;
    }
    
    return copy;
}


@end
