//
//  ALBasicViewController.m
//  AnimationLabel
//
//  Created by QD-ZC on 2017/12/1.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "ALBasicViewController.h"
@interface ALBasicViewController () <UIGestureRecognizerDelegate>
@end

@implementation ALBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate= self;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(30, 400, self.view.bounds.size.width - 60, 100)];
    slider.maximumValue = 10.f;
    slider.minimumValue = 0;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [startButton setTitle:@"startAnimation" forState:UIControlStateNormal];
    [startButton setFrame:CGRectMake(10, 300, 150, 20)];
    [startButton addTarget:self action:@selector(startALAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [stopButton setTitle:@"stopAnimation" forState:UIControlStateNormal];
    [stopButton setFrame:CGRectMake(self.view.bounds.size.width - 10 - 150, 300, 150, 20)];
    [stopButton addTarget:self action:@selector(stopALAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    
    return NO;
}

- (void)startALAnimation
{
    
    
}

- (void)stopALAnimation
{
    
}

- (void)sliderValueChanged:(UISlider *)slider
{
    NSLog(@"the slider value is %f", slider.value);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
