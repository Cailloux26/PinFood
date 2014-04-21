//
//  Annotation.m
//  PinFood
//
//  Created by Tanaka Koichi on 2014/04/09.
//  Copyright (c) 2014年 Tanaka Koichi. All rights reserved.
//
#import "Annotation.h"

@implementation Annotation

@synthesize latitude, longitude, title, subtitle;

- (CLLocationCoordinate2D)coordinate {
	
    CLLocationCoordinate2D aCoordinate;
    aCoordinate.latitude = [self.latitude doubleValue];
    aCoordinate.longitude = [self.longitude doubleValue];
    return aCoordinate;
}
@end
