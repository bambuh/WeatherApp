//
//  AddCityViewController.m
//  WeatherApp
//
//  Created by Alexey Buhantsov on 12/17/12.
//  Copyright (c) 2012 Alexey Buhantsov. All rights reserved.
//

#import "AddCityViewController.h"
#import "City.h"

@interface AddCityViewController ()

@end

@implementation AddCityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.foundCities count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSLog(@"index:  %i", indexPath.row);
    cell.textLabel.text = [[self.foundCities objectAtIndex:indexPath.row] city];
//    [self.tableView configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (IBAction)findCity:(id)sender {
    [City findCityByStr:self.cityInput.text delegate:self];
    [self.cityInput resignFirstResponder];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"RESPONSE BODY:   %@", response.bodyAsString);
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    self.foundCities = objects;
    [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
//    NSLog(@"Encountered an error: %@", error);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    City *chosen = [self.foundCities objectAtIndex:indexPath.row];
    [City addCity:chosen.city withLocation:chosen.location];
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldSouldReturn: (UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
