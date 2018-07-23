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
@property FIRDataSnapshot *updatedLocations;
@property NSArray *lat;
@property NSArray *lon;
@property (strong, nonatomic) NSString *key;
@property NSArray<UserLocations*> *locArray;

@end

@implementation ViewController

- (void)viewDidLoad {
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
        //stores snapshot
        self.updatedLocations = snapshot;
        //Calls method in UserLocation file
        NSArray<UserLocations *> *userLocations = [UserLocations locationConverter:snapshot];
        
        //pins locations
        [self layoutPinsForUserLocations:userLocations];

    }];
    [self.map setMapType:MKMapTypeStandard];
    [self.map setZoomEnabled:YES];
    self.map.centerCoordinate = self.currentLocation.coordinate;
    //Timer to update location
    [self allowDeferredLocationUpdatesUntilTraveled: 1 timeout:5];

 }

//update users lat and long data in Firebase
- (void)updateFireBase: (FIRDatabaseReference*)ref latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude{
    [[ref child:@"lat"] setValue: latitude.stringValue];
    [[ref child:@"long"] setValue: longitude.stringValue];
}

//Updates location
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"Update Locations");
    self.currentLocation = [locations lastObject]; 
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    //Storing data in variables to be used in updateFireBase function
    NSNumber *lat = [NSNumber numberWithDouble: self.currentLocation.coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble: self.currentLocation.coordinate.longitude];
    FIRDatabaseReference *userRef =[[self.ref child:@"users"] child:@"1"];
    // Calling function to update Firebase data
    [self updateFireBase:userRef latitude:lat longitude:lon];
    //Region to be zoomed in
    region.center.latitude = self.currentLocation.coordinate.latitude;
    region.center.longitude = self.currentLocation.coordinate.longitude;
    region.span.latitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [self.map setRegion:region animated:YES];
    //shows current user
    [self.map setShowsUserLocation:YES];
    //Update users location
}

//Acts as a timer to update locations
- (void)allowDeferredLocationUpdatesUntilTraveled:(CLLocationDistance)distance
                                          timeout:(NSTimeInterval)timeout{
    [self.locationManager startUpdatingLocation];

}
//pin 
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

//Remove all pins on map then add new ones
- (void)layoutPinsForUserLocations:(NSArray <UserLocations *>*)userLocations{
    
    [self.map removeAnnotations:self.map.annotations];
    [self.map addAnnotations: userLocations];
    
}


@end
