//
//  WPAnnotation.m
//  LiveLocation
//
//  Created by Dorian Holmes on 7/18/18.
//  Copyright © 2018 Dorian Holmes. All rights reserved.
//
#import "WPAnnotation.h"

@implementation WPAnnotation
@synthesize coordinate;

- (instancetype)initWithCoordinateString:(NSString *)coordinateString
{
    self = [super init];
    if (!self)
        return nil;
    
    NSArray *coordinateStringPieces = [coordinateString componentsSeparatedByString: @","];
    self.coordinate = CLLocationCoordinate2DMake([[coordinateStringPieces firstObject] doubleValue], [[coordinateStringPieces lastObject] doubleValue]);
    
    return self;
}
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    coordinate = newCoordinate;
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"WPAnnotation {%f, %f}", self.coordinate.latitude, self.coordinate.longitude];
}
@end
