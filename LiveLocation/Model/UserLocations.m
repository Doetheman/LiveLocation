//
//  UserLocations.m
//  LiveLocation
//
//  Created by Dorian Holmes on 7/18/18.
//  Copyright © 2018 Dorian Holmes. All rights reserved.
//
#import "CoreLocation/CoreLocation.h"
#import "MapKit/MapKit.h"
#import "UserLocations.h"
@implementation UserLocations

-(CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

-(NSString *)title{
    return self.name;
}
//Get the users' longitude and latitude from Firebase and convert them into coordinates for to pin on LiveLocation mapview
+(NSArray<UserLocations *> *) locationConverter: (FIRDataSnapshot *) snapshot{
    NSMutableArray *uLocations = [NSMutableArray new];
    NSDictionary *users = snapshot.value;
    NSArray<NSString *>* allUsers = users.allKeys;
    for (NSString *userID in allUsers) {
        NSDictionary <NSString *, NSNumber *> *location = users[userID];
        //Changed path originally had location category
        //NSDictionary <NSString *, NSNumber *> *location = users[users][@"location"];
        UserLocations *userLocations = [UserLocations new];

        userLocations.latitude = location[@"lat"].doubleValue;
        userLocations.longitude = location[@"long"].doubleValue;
        userLocations.name = userID;
        
        //Adds new coordinates to array of userlocations
        [uLocations addObject:(userLocations)];
    }
    
   
   return uLocations;
}


@end
