//
//  DataModels.m
//  ZaccoBooth
//
//  Created by Kristoffer Anger on 2018-10-14.
//  Copyright © 2018 Kristoffer Anger. All rights reserved.
//

#import "DataModels.h"


@implementation DataModels

+ (nonnull NSArray *)arrayOfModelObjects:(nullable NSArray *)arrayOfJSONData parsedByClass:(Class)dataModelClass {

    NSMutableArray *parsedObjects = [NSMutableArray new];
    
    // loop through downloaded JSON objects (presumably dictionaries)
    for (NSDictionary *dictionary in arrayOfJSONData) {
        
        // check if an instance of the class responds to the initializer "initWithDictionary:"
        if ([dataModelClass instancesRespondToSelector:@selector(initWithDictionary:)]) {
            
            // init object accordingly and add it to array
            id object = [[dataModelClass alloc]initWithDictionary:dictionary];
            
            if (object) {
                [parsedObjects addObject:object];
            }
        }
    }
    // return an array of model objects
    return parsedObjects;
}

@end
