//
//  ViewController.m
//  LiveLocation
//
//  Created by Dorian Holmes on 7/17/18.
//  Copyright © 2018 Dorian Holmes. All rights reserved.
//

#import "ViewController.h"
#import "UserLocations.h"
@interface ViewController ()
@property NSMutableDictionary *pins;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    //Firebase data reference
    self.ref = [[FIRDatabase database] reference];
    
    //Set delegate
    self.locationManager.delegate = self;
    self.map.delegate = self;
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [self.locationManager requestAlwaysAuthorization];
    if( [CLLocationManager locationServicesEnabled]){
        [self.locationManager startUpdatingLocation];
    }
    //get data from firebase and update users locations
    [[self.ref child:@"users"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray<UserLocations *> *userLocations = [UserLocations locationConverter:snapshot];
        [self layoutPinsForUserLocations:userLocations];
    }];
     
    //zoom to user coordinates
    [self.map setMapType:MKMapTypeStandard];
    [self.map setZoomEnabled:YES];
    self.map.centerCoordinate = self.currentLocation.coordinate;

}
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"Update Locations");
    self.currentLocation = [locations lastObject];
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.currentLocation.coordinate.latitude;
    region.center.longitude = self.currentLocation.coordinate.longitude;
    region.span.latitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [self.map setRegion:region animated:YES];
    self.map.showsUserLocation = YES;
    
    //Update users location
    
}
//pins locations
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass: [MKUserLocation class]])
        return nil;
    
    MKMarkerAnnotationView *pinAnnotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier: @"pinAnnotation"];
    [pinAnnotationView setAnnotation: annotation];
    if (!pinAnnotationView)
    {
        pinAnnotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation: annotation
                                                            reuseIdentifier: @"pinAnnotation"];
    }
    
    return pinAnnotationView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutPinsForUserLocations:(NSArray <UserLocations *>*)userLocations
{
    [self.map addAnnotations: userLocations];
    
}


@end
