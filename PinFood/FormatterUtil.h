//
//  FormatterUtil.h
//  PinFood
//
//  Created by Tanaka Koichi on 2014/04/09.
//  Copyright (c) 2014年 Tanaka Koichi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormatterUtil : NSObject

+ (NSDateFormatter *)exifDateFormatter;
+ (NSDateFormatter *)GPSDateFormatter;
+ (NSDateFormatter *)GPSTimeFormatter;
+ (NSDateFormatter *)fileNameDateFormatter;

@end