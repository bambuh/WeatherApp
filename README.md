# Switching to RestKit 0.20 (my experience)

>   One of the big changes is that the custom networking code has been dropped and replaced by the widely used AFNetworking library. This means RKClient and related classes are no longer part of RestKit.

And as I understand 0.10 has MagicalRecord included but 0.20 hasn't. So we need to include it ourselves or do its job manually.

## Object store initialization

in 0.10
```  objective-c
_objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"WeatherApp.sqlite"];
```

in 0.20
```  objective-c
_objectStore = [[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:self.persistentStoreCoordinator];
[_objectStore createManagedObjectContexts];
```

So now we need to init persistentStoreCoordinator explicitly. I think it's a good idea!
Also 0.10 has one primary context while 0.20 has two:

>   The managed object store provides the application developer with a pair of managed objects with which to work with Core Data. The store configures a primary managed object context with the NSPrivateQueueConcurrencyType that is associated with the persistent store coordinator for handling Core Data persistence. A second context is also created with the NSMainQueueConcurrencyType that is a child of the primary managed object context for doing work on the main queue. Additional child contexts can be created directly or via a convenience method interface provided by the store (see newChildManagedObjectContextWithConcurrencyType:).

>   The managed object context hierarchy is designed to isolate the main thread from disk I/O and avoid deadlocks. Because the primary context manages its own private queue, saving the main queue context will not result in the objects being saved to the persistent store. The primary context must be saved as well for objects to be persisted to disk.

## Registering parser

in 0.10
```  objective-c
[[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
```

in 0.20
```  objective-c
[RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];
```

## Working with object manager

in 0.10
```  objective-c
RKManagedObjectMapping *objectMapping = [RKManagedObjectMapping mappingForClass:[ForecastDay class] inManagedObjectStore:UIAppDelegate.objectStore];
objectMapping.primaryKeyAttribute = @"city";
[objectMapping mapKeyPath:@"period" toAttribute:@"day"];
[objectMapping mapKeyPath:@"icon_url" toAttribute:@"iconUrl"];
[objectMapping mapKeyPath:@"fcttext_metric" toAttribute:@"text"];
NSString *resourcePath = [NSString stringWithFormat:@"/api/ada2b3fdf05e0a10/forecast%@.json", self.location];
[RKObjectManager.sharedmanager.mappingProvider setObjectMapping:objectMapping forKeyPath:@"forecast.txt_forecast.forecastday"];
[RKObjectManager.sharedmanager loadObjectsAtResourcePath:resourcePath delegate:self];
```
```  objective-c
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
```

in 0.20
```  objective-c
RKEntityMapping *objectMapping =
    [RKEntityMapping mappingForEntityForName:@"ForecastDay"
                        inManagedObjectStore:RKManagedObjectStore.defaultStore];
[objectMapping addAttributeMappingsFromDictionary:@{ @"period": @"day", @"icon_url": @"iconUrl", @"fcttext_metric": @"text" }];
mapping.identificationAttributes = @[@"city"] ;
RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:objectMapping
                                            pathPattern:nil
                                                keyPath:@"forecast.txt_forecast.forecastday"
                                            statusCodes:nil];
[RKObjectManager.sharedmanager addResponseDescriptor:responseDescriptor];
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
```


