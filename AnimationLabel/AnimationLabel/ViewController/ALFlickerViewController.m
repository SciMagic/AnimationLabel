//
//  ALFlickerViewController.m
//  AnimationLabel
//
//  Created by QD-ZC on 2017/12/5.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "ALFlickerViewController.h"
#import "ALFlickerLabel.h"
@interface ALFlickerViewController ()
@property (weak, nonatomic) ALFlickerLabel *flickerLabel;
@end

@implementation ALFlickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    ALFlickerLabel *label = [[ALFlickerLabel alloc] initWithFrame:CGRectMake(0, 0, 300, 25)];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"这是一段特别的文字，哈哈哈哈";
    label.textColor = [UIColor blueColor];
    [self.view addSubview:label];
    label.center = CGPointMake(self.view.center.x, 50);
    self.flickerLabel = label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startALAnimation
{
    [self.flickerLabel startALAnimation];
}

- (void)stopALAnimation
{
    [self.flickerLabel stopALAnimation];
}

- (void)sliderValueChanged:(UISlider *)slider
{
    [self.flickerLabel setALTimeOffset:slider.value];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
