//
//  ForecastDay.h
//  WeatherApp
//
//  Created by Alexey Buhantsov on 12/17/12.
//  Copyright (c) 2012 Alexey Buhantsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

@class City;

@interface ForecastDay : NSManagedObject

@property (nonatomic, retain) NSString * iconUrl;
@property (nonatomic, retain) NSString * text;
@property (nonatomic) int16_t day;
@property (nonatomic, retain) City *city;

+(RKResponseDescriptor *)responseDescriptor;
+(NSArray *)findByAttribute:(NSString *)attr withValue:(id)value;
@end
