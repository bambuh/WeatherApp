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

## Registering parser

in 0.10
```  objective-c
[[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
```

in 0.20
```  objective-c
[RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];
```


