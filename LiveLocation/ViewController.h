//
//  ViewController.h
//  LiveLocation
//
//  Created by Dorian Holmes on 7/17/18.
//  Copyright © 2018 Dorian Holmes. All rights reserved.
//
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"
#import <UIKit/UIKit.h>
@import Firebase;

@interface ViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property(nonatomic, strong) CLLocation *currentLocation;
@property (strong, nonatomic) FIRDatabaseReference *ref;


@end

