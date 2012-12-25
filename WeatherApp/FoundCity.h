//
//  FoundCity.h
//  WeatherApp
//
//  Created by Alexey Buhantsov on 12/19/12.
//  Copyright (c) 2012 Alexey Buhantsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface FoundCity : NSObject

@property (strong, nonatomic) NSString * city;
@property (strong, nonatomic) NSString * location;

+(RKResponseDescriptor *)responseDescriptor;

@end
