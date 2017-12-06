//
//  ALSequenceViewController.m
//  AnimationLabel
//
//  Created by WavingColor on 2017/12/6.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "ALSequenceViewController.h"
#import "ALLineOneByOneLabel.h"

@interface ALSequenceViewController ()

@property (nonatomic, strong) ALLineOneByOneLabel *oneLabel;

@end

@implementation ALSequenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [stopButton setTitle:@"backAnimation" forState:UIControlStateNormal];
    [stopButton setFrame:CGRectMake(self.view.bounds.size.width - 10 - 150-75, 300, 150, 20)];
    [stopButton addTarget:self action:@selector(backALAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
    
    
    _oneLabel = [[ALLineOneByOneLabel alloc] initWithFrame:CGRectMake(0, 0, 375, 300)];
    _oneLabel.text = @"When nd yet shall mourn with ever-returning spring.\n我哀悼着，并将随着一年一度的春光永远地哀悼着。";
  
    [self.view addSubview:_oneLabel];
    [_oneLabel sizeToFit];
    
    
    // Do any additional setup after loading the view.
}




- (void)startALAnimation
{
    [_oneLabel startAppearAnimation];
}

- (void)stopALAnimation
{
    [_oneLabel revertAnimation];
}

- (void)backALAnimation {
    
    [_oneLabel startDisappearAnimation];
}

- (void)sliderValueChanged:(UISlider *)slider
{
    [_oneLabel animationWithTimestamp:slider.value * 10];
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
