//
//  City.h
//  WeatherApp
//
//  Created by Alexey Buhantsov on 12/17/12.
//  Copyright (c) 2012 Alexey Buhantsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface City : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * location;
@property (nonatomic) NSTimeInterval forecastDate;
@property (nonatomic, retain) NSSet *forecastDay;


@end

@interface City (CoreDataGeneratedAccessors)

- (void)addForecastDayObject:(NSManagedObject *)value;
- (void)removeForecastDayObject:(NSManagedObject *)value;
- (void)addForecastDay:(NSSet *)values;
- (void)removeForecastDay:(NSSet *)values;

- (void)getForecast;
+ (void)addCity:(NSString *)city withLocation:(NSString *)location;
+ (NSArray *)findByAttribute:(NSString *)attr withValue:(NSString *)value inContext:(NSManagedObjectContext *)context;
@end
