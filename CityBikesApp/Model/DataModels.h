//
//  DataModels.h
//
//  Created by Kristoffer Anger on 2018-10-13
//  Copyright (c) 2018 Zacco - 360° Intellectual Property. All rights reserved.
//

#import <Foundation/Foundation.h>

// data model classes
#import "Stations.h"
#import "Extra.h"

/*
 data models
 -------------------------------
 copy this line below to import all above:
 #import "DataModels.h"
 */

/*
 convenience methods for handling data models
 --------------------------------------------
*/

NS_ASSUME_NONNULL_BEGIN

@interface DataModels : NSObject

+ (nonnull NSArray *)arrayOfModelObjects:(nullable NSArray *)arrayOfJSONData parsedByClass:(Class)dataModelClass;

@end

NS_ASSUME_NONNULL_END
