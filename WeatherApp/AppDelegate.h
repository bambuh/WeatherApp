//
//  AppDelegate.h
//  WeatherApp
//
//  Created by Alexey Buhantsov on 12/17/12.
//  Copyright (c) 2012 Alexey Buhantsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/RKMIMETypeSerialization.h>
#import "FoundCity.h"
#import "ForecastDay.h"

#define UIAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) RKManagedObjectStore *objectStore;
@property (readonly, strong, nonatomic) RKObjectManager *objectManager;
@property (readonly, strong, nonatomic) RKObjectManager *autocompleteObjectManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
