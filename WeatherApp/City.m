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
#import "FoundCity.h"


@implementation City

@dynamic city;
@dynamic location;
@dynamic forecastDate;
@dynamic forecastDay;


+ (void)findCityByStr:(NSString *)str delegate:(id)delegate
{
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[FoundCity class]];
//    objectMapping.primaryKeyAttribute = @"city";
    [objectMapping mapKeyPath:@"name" toAttribute:@"city"];
    [objectMapping mapKeyPath:@"l" toAttribute:@"location"];
    NSString *resourcePath = [NSString stringWithFormat:@"/aq?query=%@", str];
    [UIAppDelegate.autocompleteObjectManager.mappingProvider setObjectMapping:objectMapping forKeyPath:@"RESULTS"];
    [UIAppDelegate.autocompleteObjectManager loadObjectsAtResourcePath:resourcePath delegate:delegate];

}
+ (void)addCity:(NSString *)city withLocation:(NSString *)location{
    City *newCity = (City*)[NSEntityDescription
                            insertNewObjectForEntityForName:@"City"
                            inManagedObjectContext:UIAppDelegate.objectStore.primaryManagedObjectContext];
    
    NSError *error = nil;
    newCity.city = city;
    newCity.location = location;
    if (![UIAppDelegate.objectStore.primaryManagedObjectContext save:&error]) {
    }
    [newCity getForecast];
    
}
- (void)getForecast{
    NSString *resourcePath = [NSString stringWithFormat:@"/api/ada2b3fdf05e0a10/forecast%@.json", self.location];
    [UIAppDelegate.objectManager.mappingProvider setObjectMapping:[ForecastDay objectMapping] forKeyPath:@"forecast.txt_forecast.forecastday"];
    [UIAppDelegate.objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"RESPONSE BODY:   %@", response.bodyAsString);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    NSManagedObjectContext * context = [objects[0] managedObjectContext];
    City *cityInCurrentContext = [City findFirstByAttribute:@"city" withValue:self.city inContext:context];
    NSSet *set = [NSSet setWithArray:objects];
    [cityInCurrentContext addForecastDay:set];
    
    NSError *error = nil;
    if (![context save:&error]) {
    }
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
}



@end
