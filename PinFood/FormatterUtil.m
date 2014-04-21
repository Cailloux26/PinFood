//
//  FormatterUtil.m
//  PinFood
//
//  Created by Tanaka Koichi on 2014/04/09.
//  Copyright (c) 2014年 Tanaka Koichi. All rights reserved.
//

#import "FormatterUtil.h"

@implementation FormatterUtil

+ (NSDateFormatter *)exifDateFormatter
{
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy:MM:dd HH:mm:ss";
    }
    
    return dateFormatter;
}

+ (NSDateFormatter *)GPSDateFormatter
{
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy:MM:dd";
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    }
    
    return dateFormatter;
}

+ (NSDateFormatter *)GPSTimeFormatter
{
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm:ss.SSSSSS";
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    }
    
    return dateFormatter;
}

+ (NSDateFormatter *)fileNameDateFormatter
{
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    }
    
    return dateFormatter;
}

@end