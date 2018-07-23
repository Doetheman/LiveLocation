//
//  UserLocations.h
//  LiveLocation
//
//  Created by Dorian Holmes on 7/18/18.
//  Copyright © 2018 Dorian Holmes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"
#import "MapKit/MapKit.h"
@import Firebase;

@interface UserLocations : NSObject <MKAnnotation>

@property(nonatomic, readwrite) CLLocationDegrees latitude;
@property(nonatomic, readwrite) CLLocationDegrees longitude;
@property(nonatomic, copy, readwrite) NSString *name;
@property MKPointAnnotation *pinAnnotation;

+(NSArray<UserLocations *> *)locationConverter: (FIRDataSnapshot *) snapshot;

    
@end
