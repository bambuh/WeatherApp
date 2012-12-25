//
//  ForecastDay.m
//  WeatherApp
//
//  Created by Alexey Buhantsov on 12/17/12.
//  Copyright (c) 2012 Alexey Buhantsov. All rights reserved.
//

#import "ForecastDay.h"


@implementation ForecastDay

@dynamic iconUrl;
@dynamic text;
@dynamic day;
@dynamic city;

+(RKResponseDescriptor *)responseDescriptor
{
    RKEntityMapping *objectMapping =
        [RKEntityMapping mappingForEntityForName:@"ForecastDay"
                            inManagedObjectStore:RKManagedObjectStore.defaultStore];
    [objectMapping addAttributeMappingsFromDictionary:@{ @"period": @"day", @"icon_url": @"iconUrl", @"fcttext_metric": @"text" }];
    RKResponseDescriptor *responseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:objectMapping
                                                pathPattern:nil
                                                    keyPath:@"forecast.txt_forecast.forecastday"
                                                statusCodes:nil];
    
    return responseDescriptor;
}
+(NSArray *)findByAttribute:(NSString *)attr withValue:(id)value
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ForecastDay" inManagedObjectContext:RKManagedObjectStore.defaultStore.mainQueueManagedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city == %@", value];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [RKManagedObjectStore.defaultStore.mainQueueManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Problem! %@",error);
    }
    return fetchedObjects;
}


@end
