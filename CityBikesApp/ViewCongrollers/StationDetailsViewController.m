//
//  StationDetailsViewController.m
//  CityBikesApp
//
//  Created by Kristoffer Anger on 2019-03-06.
//  Copyright © 2019 kriang. All rights reserved.
//

#import "StationDetailsViewController.h"

@interface StationDetailsViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation StationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    self.infoLabel.text = self.infoString;
    [self updateMap];
}

- (void)updateMap {
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = self.coordinate;
    [self.mapView addAnnotation:annotation];

    MKCoordinateRegion region = MKCoordinateRegionMake(self.coordinate, MKCoordinateSpanMake(0.002, 0.002));
    [self.mapView setRegion:region animated:YES];
}

@end
