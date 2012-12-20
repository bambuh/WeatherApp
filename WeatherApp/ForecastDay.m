//
//  ForecastDay.m
//  WeatherApp
//
//  Created by Alexey Buhantsov on 12/17/12.
//  Copyright (c) 2012 Alexey Buhantsov. All rights reserved.
//

#import "ForecastDay.h"
#import "City.h"


@implementation ForecastDay

@dynamic iconUrl;
@dynamic text;
@dynamic day;
@dynamic city;

+(RKManagedObjectMapping *)objectMapping
{
    RKManagedObjectMapping *objectMapping = [RKManagedObjectMapping mappingForClass:[ForecastDay class] inManagedObjectStore:UIAppDelegate.objectStore];
    objectMapping.primaryKeyAttribute = @"city";
    [objectMapping mapKeyPath:@"period" toAttribute:@"day"];
    [objectMapping mapKeyPath:@"icon_url" toAttribute:@"iconUrl"];
    [objectMapping mapKeyPath:@"fcttext_metric" toAttribute:@"text"];
//    [objectMapping connectRelationship:@"city" withObjectForPrimaryKeyAttribute:@"city"];
    NSLog(@"Rel:   %@",[objectMapping relationshipsAndPrimaryKeyAttributes]);
    return objectMapping;
}


@end
