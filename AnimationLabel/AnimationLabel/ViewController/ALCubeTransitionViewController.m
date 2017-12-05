//
//  ALCubeTransitionViewController.m
//  AnimationLabel
//
//  Created by QD-ZC on 2017/12/5.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "ALCubeTransitionViewController.h"
#import "ALCubeTransitionLabel.h"
@interface ALCubeTransitionViewController ()

@property(weak, nonatomic) ALCubeTransitionLabel *cubeLabel;

@end

@implementation ALCubeTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ALCubeTransitionLabel *label = [[ALCubeTransitionLabel alloc] initWithFrame:CGRectMake(0, 0, 300, 25)];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"这是一段特别的文字，哈哈哈哈";
    label.textColor = [UIColor blueColor];
    label.startColor = [UIColor blueColor];
    label.endColor = [UIColor redColor];
    [self.view addSubview:label];
    label.center = CGPointMake(self.view.center.x, 50);
    self.cubeLabel = label;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)startALAnimation
{
    [self.cubeLabel startALAnimation];
}

- (void)stopALAnimation
{
    [self.cubeLabel stopALAnimation];
}

- (void)sliderValueChanged:(UISlider *)slider
{
    [self.cubeLabel setALTimeOffset:slider.value];
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
