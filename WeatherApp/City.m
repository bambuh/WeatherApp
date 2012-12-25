//
//  City.m
//  WeatherApp
//
//  Created by Alexey Buhantsov on 12/17/12.
//  Copyright (c) 2012 Alexey Buhantsov. All rights reserved.
//

#import "City.h"
#import "AppDelegate.h"
#import "ForecastDay.h"


@implementation City

@dynamic city;
@dynamic location;
@dynamic forecastDate;
@dynamic forecastDay;


+ (void)addCity:(NSString *)city withLocation:(NSString *)location{
    NSManagedObjectContext * context = RKManagedObjectStore.defaultStore.persistentStoreManagedObjectContext;
    City *newCity = (City*)[NSEntityDescription
                            insertNewObjectForEntityForName:@"City"
                            inManagedObjectContext:context];
    
    NSError *error = nil;
    newCity.city = city;
    newCity.location = location;
    if (![context save:&error]) {
    }
    [newCity getForecast];
    
}
- (void)getForecast{
    NSString *resourcePath = [NSString stringWithFormat:@"api/ada2b3fdf05e0a10/forecast%@.json", self.location];
    [UIAppDelegate.objectManager
         getObjectsAtPath:resourcePath parameters:nil
         success:^(RKObjectRequestOperation *operation, RKMappingResult *result)
         {
             NSManagedObjectContext * context = [result.firstObject managedObjectContext];
             City *cityInCurrentContext = [[City findByAttribute:@"city" withValue:self.city inContext:context] objectAtIndex:0];
             [cityInCurrentContext addForecastDay:result.set];
             NSError *error = nil;
             if (![context save:&error]) {
                 NSLog(@"ERROR: %@", error);
             }
             [[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext] save:&error];
             [[[RKManagedObjectStore defaultStore] persistentStoreManagedObjectContext] save:&error];
         }
         failure:^(RKObjectRequestOperation *operation, NSError *error)
         {
             // Error handler.
             NSLog(@"ERROR %@", error);
         }];
}
+(NSArray *)findByAttribute:(NSString *)attr withValue:(NSString *)value inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"City" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city == %@", value];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Problem! %@",error);
    }
    return fetchedObjects;
}

@end
