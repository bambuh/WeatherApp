//
//  AddCityViewController.h
//  WeatherApp
//
//  Created by Alexey Buhantsov on 12/17/12.
//  Copyright (c) 2012 Alexey Buhantsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AddCityViewController : UIViewController <RKObjectLoaderDelegate, RKRequestDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cityInput;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *foundCities;

- (IBAction)findCity:(id)sender;

@end
