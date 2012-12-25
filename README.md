# Switching to RestKit 0.20 (my experience)

in 0.10
```  objective-c
_objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"WeatherApp.sqlite"];
```

in 0.20
```  objective-c
    _objectStore = [[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:self.persistentStoreCoordinator];
    [_objectStore createManagedObjectContexts];
```
