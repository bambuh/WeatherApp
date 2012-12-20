//
//  DetailViewController.m
//  WeatherApp
//
//  Created by Alexey Buhantsov on 12/17/12.
//  Copyright (c) 2012 Alexey Buhantsov. All rights reserved.
//

#import "DetailViewController.h"
#import "ForecastDayCell.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
    }
}

- (void)configureView
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"+++++++: %i",[[ForecastDay findByAttribute:@"city" withValue:self.detailItem] count]);
    return [[ForecastDay findByAttribute:@"city" withValue:self.detailItem] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ForecasDayCell";
    
    ForecastDayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        UIViewController *temporaryController = [[UIViewController alloc] initWithNibName:@"ForecastDayCell" bundle:nil];
        cell = (ForecastDayCell *)temporaryController.view;
    }
    cell.weatherText.text = [[[ForecastDay findByAttribute:@"city" withValue:self.detailItem] objectAtIndex:indexPath.row] text];
    NSArray *arr = [[NSArray alloc] initWithObjects:cell.icon, [[[ForecastDay findByAttribute:@"city" withValue:self.detailItem] objectAtIndex:indexPath.row] iconUrl], nil];
    [self performSelectorInBackground:@selector(loadIcon:) withObject:arr];
    NSLog(@"-----------: %@", cell.weatherText.text);
    return cell;
}

-(void)loadIcon:(NSArray *)arr
{
    NSURL * url = [NSURL URLWithString:[arr objectAtIndex:1]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    UIImage * image = [UIImage imageWithData:data];
    if (image)
    {
        [[arr objectAtIndex:0] setImage:image];
    }
    else
    {
        NSLog(@"Something went wrong");
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

@end
