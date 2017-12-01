//
//  ViewController.m
//  AnimationLabel
//
//  Created by QD-ZC on 2017/12/1.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "ViewController.h"
#import "ALModel.h"
#import "ALControllerManager.h"
@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[ALModel sharedInstance] fetchData];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //asdasd
}

#pragma mark ---UITableViewDelegate---
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [[ALControllerManager sharedInstance] controller:self pushto:cell.textLabel.text];
    
    
}


#pragma mark ---UITableViewDataSource---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"altableviewcell" forIndexPath:indexPath];
    
    if (cell) {
        
        cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
        
    }
    
    return cell;
    
}


@end
