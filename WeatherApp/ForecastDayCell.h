//
//  ForecastDayCell.h
//  WeatherApp
//
//  Created by Alexey Buhantsov on 12/19/12.
//  Copyright (c) 2012 Alexey Buhantsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastDayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *weatherText;

@end
