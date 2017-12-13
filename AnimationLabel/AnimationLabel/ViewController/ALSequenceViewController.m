//
//  ALSequenceViewController.m
//  AnimationLabel
//
//  Created by WavingColor on 2017/12/6.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "ALSequenceViewController.h"
#import "ALFineDrewAnimationBaseLabel.h"

@interface ALSequenceViewController ()

@property (nonatomic, strong) ALFineDrewAnimationBaseLabel *oneLabel;

@end

@implementation ALSequenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [stopButton setTitle:@"backAnimation" forState:UIControlStateNormal];
    [stopButton setFrame:CGRectMake(self.view.bounds.size.width - 10 - 150-75, 300, 150, 20)];
    [stopButton addTarget:self action:@selector(backALAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
    
    
    _oneLabel = [[ALFineDrewAnimationBaseLabel alloc] initWithFrame:CGRectMake(100, 0, 275, 300)];
    _oneLabel.text = @"一年一度的春光永远地哀悼着。";
  
    [self.view addSubview:_oneLabel];
    [_oneLabel sizeToFit];
    
    
    // Do any additional setup after loading the view.
}




- (void)startALAnimation
{
    [_oneLabel startALAnimation];
}

- (void)stopALAnimation
{
    [_oneLabel stopALAnimation];
}

- (void)backALAnimation {
    
}

- (void)sliderValueChanged:(UISlider *)slider
{
    [_oneLabel setALTimeOffset:slider.value * 0.5];
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
