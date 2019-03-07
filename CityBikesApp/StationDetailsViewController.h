//
//  StationDetailsViewController.h
//  CityBikesApp
//
//  Created by Kristoffer Anger on 2019-03-06.
//  Copyright © 2019 kriang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StationDetailsViewController : UIViewController

@property (nonatomic, strong) NSString *infoString;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

NS_ASSUME_NONNULL_END
