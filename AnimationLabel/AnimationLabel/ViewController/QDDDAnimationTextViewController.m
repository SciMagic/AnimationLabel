//
//  QDDDAnimationTextViewController.m
//  AnimationLabel
//
//  Created by QD on 2017/12/1.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "QDDDAnimationTextViewController.h"
#import "QDRunTextView.h"
#import "QDRotateFlyView.h"
#import "ALAnimationProtocol.h"
@interface QDDDAnimationTextViewController ()
@property (nonatomic, strong) QDRunTextView *runTextView;
@property (nonatomic, strong) QDRotateFlyView *rotateView;

@end

@implementation QDDDAnimationTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    // Do any additional setup after loading the view.
    if ([self.title isEqualToString:@"效果11_DD"]) {
        [self configureRunTextView];

    }else if ([self.title isEqualToString:@"效果1_DD"]){
        [self configureRotateFlyView];

    }
}
- (void)configureRotateFlyView
{
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:@"1234567890" attributes:[self attributes]];
    CGSize size = [QDRotateFlyView getSizeWithAttibutedString:att];
    QDRotateFlyView *flyView = [[QDRotateFlyView alloc] initWithFrame:CGRectMake(100, 100, size.width, size.height)];
    [self.view addSubview:flyView];
    flyView.attributedText = att;
    self.rotateView = flyView;
}

- (void)configureRunTextView
{
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:@"1234567890" attributes:[self attributes]];
    CGSize size = [QDRunTextView getSizeWithAttibutedString:att];
    QDRunTextView *textView = [[QDRunTextView alloc] initWithFrame:CGRectMake(100, 100, size.width, size.height)];
    [self.view addSubview:textView];
    textView.attributedText = [[NSAttributedString alloc] initWithString:@"1234567890" attributes:[self attributes]];
    self.runTextView = textView;
}
- (NSDictionary *)attributes
{
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor orangeColor];
        shadow.shadowBlurRadius = 5;
        shadow.shadowOffset = CGSizeMake(5, 5);
//        [att addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, attibutedString.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    NSMutableDictionary *attributesDict = [NSMutableDictionary  dictionary];
    [attributesDict setValuesForKeysWithDictionary:@{
                                                     NSParagraphStyleAttributeName:paragraphStyle,
                                                     NSFontAttributeName:[UIFont systemFontOfSize:30],
                                                     NSKernAttributeName:@(1),
                                                                            }];
    return attributesDict;
}

- (id<ALAnimationProtocol>)animationView
{
    if (self.runTextView) {
        return self.runTextView;
    }else if (self.rotateView)
    {
        return self.rotateView;
    }
    return nil;
}
- (void)startALAnimation
{
    
    [self.animationView startALAnimation];
}

- (void)stopALAnimation
{
    [self.animationView stopALAnimation];
}

- (void)sliderValueChanged:(UISlider *)slider
{
    [self.animationView setALTimeOffset:slider.value];
}
@end
