//
//  ViewController.m
//  CityBikesApp
//
//  Created by Kristoffer Anger on 2019-03-06.
//  Copyright © 2019 kriang. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "ViewController.h"
#import "APIHelpers.h"
#import "ErrorHelpers.h"
#import "DataModels.h"
#import "StationsTableViewCell.h"

#define SPINNER_SIZE 100.0f

@interface ViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) NSArray *tableViewData;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *userLocation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init CLLocationManager object
    _locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    // add locate user button on map
    MKUserTrackingButton *buttonItem = [MKUserTrackingButton userTrackingButtonWithMapView:self.mapView];
    buttonItem.frame = CGRectMake(10, 20, 40, 40);
    [self.mapView addSubview:buttonItem];
    
    // add refresh controll
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(loadStationsAndShowActivityIndicator:) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;

    // load station data
    [self loadStationsAndShowActivityIndicator:YES];
}

#pragma mark - API methods

- (void)loadStationsAndShowActivityIndicator:(BOOL)showIndicator {
    
    // update user location
    [self.locationManager startUpdatingLocation];
    
    // show spinner
    if (showIndicator) {
        [self showIndicator];
    }
    
    // call api.citybik.es
    [APIHelpers makeRequestWithEndpoint:@"/malmobybike" queryParameters:@{@"fields": @"stations"} completion:^(NSDictionary * response) {
        
        [self hideIndicator];
        
        NSError *error = [response objectForKey:@"error"];
        if (error == nil) {
            NSArray *result = [response objectForKey:@"result"];
            NSArray *tableViewData = [DataModels arrayOfModelObjects:[result valueForKeyPath:@"network.stations"] parsedByClass:[Stations class]];
            self.tableViewData = tableViewData;
            [self updateMapWithTableViewData:tableViewData];
        }
        else {
            [ErrorHelpers showError:error onView:self.view];
        }
    }];
}

#pragma mark - Getters/setters

- (void)setTableViewData:(NSArray *)tableViewData  {
    
    if (_tableViewData != tableViewData) {
        _tableViewData = tableViewData;
        [self.tableView.refreshControl endRefreshing];
        [self.tableView reloadData];
    }
}


- (void)setUserLocation:(CLLocation *)userLocation  {
    
    if (_userLocation != userLocation) {
        _userLocation = userLocation;
        [self.tableView reloadData];
    }
}

- (UIActivityIndicatorView *)indicator {
    if (_indicator == nil) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.backgroundColor = [UIColor lightGrayColor];
        indicatorView.layer.cornerRadius = 6;
        indicatorView.frame = CGRectMake(0, 0, SPINNER_SIZE, SPINNER_SIZE);
        [indicatorView startAnimating];
        _indicator = indicatorView;
    }
    return _indicator;
}


#pragma mark - Activity indicator methods

- (void)showIndicator {
    [self.view addSubview:self.indicator];
    self.indicator.center = self.view.center;
}

- (void)hideIndicator {
    [self.indicator removeFromSuperview];
}


#pragma mark - UITableViewDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewData.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *header = @"Malmö";
    
    NSNumber *numberOfStations = @(self.tableViewData.count);
    NSNumber *numberOfFreeBikes = [self.tableViewData valueForKeyPath:@"@sum.freeBikes"];
    if (self.tableViewData.count > 0) {
        header = [NSString stringWithFormat:@"%@ - %@ stationer, %@ cyklar", header, numberOfStations, numberOfFreeBikes];
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *stationCellIdentifier = @"default_station_cell";
    
    StationsTableViewCell *cell = (StationsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:stationCellIdentifier];
    if (cell == nil) {
        cell = [[StationsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:stationCellIdentifier];
    }
    Stations *station = [self.tableViewData objectAtIndex:indexPath.row];
    cell.textLabel.text = station.name;
    cell.distanceLabel.text = [self userDistanceInKilometersToCoordinate:[[CLLocation alloc] initWithLatitude:station.latitude longitude:station.longitude]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ lediga cyklar, %@ tomma platser", @(station.freeBikes), @(station.emptySlots)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - Heelper methods

- (NSString *)userDistanceInKilometersToCoordinate:(CLLocation *)location {
    
    NSTimeInterval secondsFromNow = [[NSDate date] timeIntervalSinceDate:self.userLocation.timestamp];
    BOOL userLocationFresh = secondsFromNow < 300; // 5 min
    CGFloat distance = [self.userLocation distanceFromLocation:location];
    return userLocationFresh ? [NSString stringWithFormat:@"%0.1f km", distance/1000] : @"";
}

- (void)zoomToAnnotation:(MKPointAnnotation*)annotation {
    
    CGFloat fractionLatLon = self.mapView.region.span.latitudeDelta / self.mapView.region.span.longitudeDelta;
    CGFloat newLatDelta = 0.002f;
    CGFloat newLonDelta = newLatDelta * fractionLatLon;
    MKCoordinateRegion region = MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(newLatDelta, newLonDelta));
    [self.mapView setRegion:region animated:YES];
}

- (void)zoomToFitAllAnnotations:(NSArray *)annotations {
    
    MKMapRect zoomRect = MKMapRectNull;
    for (MKPointAnnotation *annotation in annotations) {
        
        if (![annotation isKindOfClass:[MKUserLocation class]]) {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
}

#pragma mark - Action methods

- (void)navigateToStationWithInfo:(NSDictionary *)stationInfo {
    
}

#pragma mark - MKMapView methods

- (void)updateMapWithTableViewData:(NSArray *)tableViewData {
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (Stations *station in tableViewData) {
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake(station.latitude, station.longitude);
        annotation.title = station.name;
        annotation.subtitle = [NSString stringWithFormat:@"Lediga cyklar: %@", @(station.freeBikes)];
        [self.mapView addAnnotation:annotation];
    }
    [self zoomToFitAllAnnotations:self.mapView.annotations];
}
         
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [self zoomToAnnotation:view.annotation];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [self zoomToFitAllAnnotations:self.mapView.annotations];
}

- (MKAnnotationView *)viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *reuseIdentifier = @"identifier";
    MKAnnotationView *view = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    view.canShowCallout = YES;
    return view;
}

#pragma mark - CLLocationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.userLocation = locations.lastObject;
    [manager stopUpdatingLocation]; // save battery
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"failed to recived user location");
}
         
@end
