//
//  WPAnnotation.h
//  LiveLocation
//
//  Created by Dorian Holmes on 7/18/18.
//  Copyright © 2018 Dorian Holmes. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface WPAnnotation : NSObject <MKAnnotation>

- (instancetype)initWithCoordinateString:(NSString *)coordinateString;


@end
