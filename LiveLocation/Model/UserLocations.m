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

+(NSArray<UserLocations *> *) locationConverter: (FIRDataSnapshot *) snapshot{
    NSMutableArray *uLocations = [NSMutableArray new];
    NSDictionary *users = snapshot.value;
    NSArray<NSString *>* allUsers = users.allKeys;
    for (NSString *user in allUsers) {
        NSDictionary <NSString *, NSNumber *> *location = users[user][@"location"];
        UserLocations *userLocations = [UserLocations new];
        userLocations.latitude = location[@"lat"].doubleValue;
        userLocations.longitude = location[@"long"].doubleValue;
        userLocations.name = user;
        [uLocations addObject:(userLocations)];
    }
    
   
   return uLocations;
}


@end
