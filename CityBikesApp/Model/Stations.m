//
//  Stations.m
//
//  Created by Kristoffer Anger on 2019-03-06
//  Copyright (c) 2019 Zacco - 360° Intellectual Property. All rights reserved.
//

#import "Stations.h"
#import "Extra.h"

NSString *const kStationsLongitude = @"longitude";
NSString *const kStationsId = @"id";
NSString *const kStationsExtra = @"extra";
NSString *const kStationsLatitude = @"latitude";
NSString *const kStationsFreeBikes = @"free_bikes";
NSString *const kStationsEmptySlots = @"empty_slots";
NSString *const kStationsName = @"name";
NSString *const kStationsTimestamp = @"timestamp";


@interface Stations ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Stations

@synthesize longitude = _longitude;
@synthesize stationsIdentifier = _stationsIdentifier;
@synthesize extra = _extra;
@synthesize latitude = _latitude;
@synthesize freeBikes = _freeBikes;
@synthesize emptySlots = _emptySlots;
@synthesize name = _name;
@synthesize timestamp = _timestamp;


+ (Stations *)modelObjectWithDictionary:(NSDictionary *)dict
{
    Stations *instance = [[Stations alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.longitude = [[self objectOrNilForKey:kStationsLongitude fromDictionary:dict] doubleValue];
            self.stationsIdentifier = [self objectOrNilForKey:kStationsId fromDictionary:dict];
            self.extra = [Extra modelObjectWithDictionary:[dict objectForKey:kStationsExtra]];
            self.latitude = [[self objectOrNilForKey:kStationsLatitude fromDictionary:dict] doubleValue];
            self.freeBikes = [[self objectOrNilForKey:kStationsFreeBikes fromDictionary:dict] doubleValue];
            self.emptySlots = [[self objectOrNilForKey:kStationsEmptySlots fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kStationsName fromDictionary:dict];
            self.timestamp = [self objectOrNilForKey:kStationsTimestamp fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.longitude] forKey:kStationsLongitude];
    [mutableDict setValue:self.stationsIdentifier forKey:kStationsId];
    [mutableDict setValue:[self.extra dictionaryRepresentation] forKey:kStationsExtra];
    [mutableDict setValue:[NSNumber numberWithDouble:self.latitude] forKey:kStationsLatitude];
    [mutableDict setValue:[NSNumber numberWithDouble:self.freeBikes] forKey:kStationsFreeBikes];
    [mutableDict setValue:[NSNumber numberWithDouble:self.emptySlots] forKey:kStationsEmptySlots];
    [mutableDict setValue:self.name forKey:kStationsName];
    [mutableDict setValue:self.timestamp forKey:kStationsTimestamp];

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

    self.longitude = [aDecoder decodeDoubleForKey:kStationsLongitude];
    self.stationsIdentifier = [aDecoder decodeObjectForKey:kStationsId];
    self.extra = [aDecoder decodeObjectForKey:kStationsExtra];
    self.latitude = [aDecoder decodeDoubleForKey:kStationsLatitude];
    self.freeBikes = [aDecoder decodeDoubleForKey:kStationsFreeBikes];
    self.emptySlots = [aDecoder decodeDoubleForKey:kStationsEmptySlots];
    self.name = [aDecoder decodeObjectForKey:kStationsName];
    self.timestamp = [aDecoder decodeObjectForKey:kStationsTimestamp];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_longitude forKey:kStationsLongitude];
    [aCoder encodeObject:_stationsIdentifier forKey:kStationsId];
    [aCoder encodeObject:_extra forKey:kStationsExtra];
    [aCoder encodeDouble:_latitude forKey:kStationsLatitude];
    [aCoder encodeDouble:_freeBikes forKey:kStationsFreeBikes];
    [aCoder encodeDouble:_emptySlots forKey:kStationsEmptySlots];
    [aCoder encodeObject:_name forKey:kStationsName];
    [aCoder encodeObject:_timestamp forKey:kStationsTimestamp];
}

- (id)copyWithZone:(NSZone *)zone
{
    Stations *copy = [[Stations alloc] init];
    
    if (copy) {

        copy.longitude = self.longitude;
        copy.stationsIdentifier = [self.stationsIdentifier copyWithZone:zone];
        copy.extra = [self.extra copyWithZone:zone];
        copy.latitude = self.latitude;
        copy.freeBikes = self.freeBikes;
        copy.emptySlots = self.emptySlots;
        copy.name = [self.name copyWithZone:zone];
        copy.timestamp = [self.timestamp copyWithZone:zone];
    }
    
    return copy;
}


@end
