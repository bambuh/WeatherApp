//
//  FoundCity.m
//  WeatherApp
//
//  Created by Alexey Buhantsov on 12/19/12.
//  Copyright (c) 2012 Alexey Buhantsov. All rights reserved.
//

#import "FoundCity.h"

@implementation FoundCity

+(RKResponseDescriptor *)responseDescriptor
{
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[FoundCity class]];
    [objectMapping addAttributeMappingsFromDictionary:@{ @"name": @"city", @"l": @"location"}];
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:objectMapping
                                            pathPattern:nil
                                                keyPath:@"RESULTS"
                                            statusCodes:nil];
    return responseDescriptor;
}

@end
