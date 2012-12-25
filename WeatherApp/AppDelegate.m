//
//  AppDelegate.m
//  WeatherApp
//
//  Created by Alexey Buhantsov on 12/17/12.
//  Copyright (c) 2012 Alexey Buhantsov. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"

@implementation AppDelegate

//@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize objectStore = _objectStore;
@synthesize objectManager = _objectManager;
@synthesize autocompleteObjectManager = _autocompleteObjectManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [RKManagedObjectStore setDefaultStore:self.objectStore];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.objectStore.persistentStoreManagedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - RestKit

- (RKManagedObjectStore *)objectStore
{
    if (_objectStore != nil) {
        return _objectStore;
    }
    _objectStore = [[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:self.persistentStoreCoordinator];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];
    [_objectStore createManagedObjectContexts];
    return _objectStore;
}
- (RKObjectManager *)objectManager
{
    if (_objectManager != nil) {
        return _objectManager;
    }
    _objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://api.wunderground.com/"]];
    [_objectManager addResponseDescriptor:[ForecastDay responseDescriptor]];
    _objectManager.managedObjectStore = [RKManagedObjectStore defaultStore];
    [RKObjectManager setSharedManager:_objectManager];
    return _objectManager;
}
- (RKObjectManager *)autocompleteObjectManager
{
    if (_autocompleteObjectManager != nil) {
        return _autocompleteObjectManager;
    }
    _autocompleteObjectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://autocomplete.wunderground.com/"]];
    [_autocompleteObjectManager addResponseDescriptor:[FoundCity responseDescriptor]];
    return _autocompleteObjectManager;
}

#pragma mark - Core Data stack

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WeatherApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WeatherApp.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
