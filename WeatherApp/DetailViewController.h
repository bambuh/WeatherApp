//
//  DetailViewController.h
//  WeatherApp
//
//  Created by Alexey Buhantsov on 12/17/12.
//  Copyright (c) 2012 Alexey Buhantsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"
#import "ForecastDay.h"

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) City * detailItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
