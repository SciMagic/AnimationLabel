//
//  ALCubeTransitionLabel.m
//  AnimationLabel
//
//  Created by QD-ZC on 2017/12/2.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "ALCubeTransitionLabel.h"

@interface ALCubeTransitionLabel()

@property (weak, nonatomic) UILabel *firstLabel;
@property (weak, nonatomic) UILabel *secondLabel;

@property (strong, nonatomic) CAAnimationGroup *groupAnimation_1;
@property (strong, nonatomic) CAAnimationGroup *groupAnimation_2;

@end


@implementation ALCubeTransitionLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self configAnimateLabel];
        
    }
    
    return self;

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{

    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self configAnimateLabel];
        
    }
    
    return self;
}

- (void)configAnimateLabel
{
  
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.firstLabel = firstLabel;
    self.firstLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.secondLabel = secondLabel;
    self.secondLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:secondLabel];
    
    CATransform3D fromValue_2 = CATransform3DMakeTranslation(0, self.bounds.size.height, 0);
    self.secondLabel.layer.transform = fromValue_2;
    self.secondLabel.layer.opacity = 0;
    
    
    [self composeAnimation];
    
}

- (void)setStartColor:(UIColor *)startColor
{
    self.firstLabel.textColor = startColor;
}

- (void)setEndColor:(UIColor *)endColor
{
    self.secondLabel.textColor = endColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    self.firstLabel.textAlignment = textAlignment;
    self.secondLabel.textAlignment = textAlignment;
}

- (void)setFont:(UIFont *)font
{
    self.firstLabel.font = font;
    self.secondLabel.font = font;
}

- (void)setText:(NSString *)text
{
    self.firstLabel.text = text;
    self.secondLabel.text = text;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    self.firstLabel.attributedText = attributedText;
    self.secondLabel.attributedText = attributedText;
}

- (void)startALAnimation
{
    self.groupAnimation_1.speed = 1;
    self.groupAnimation_2.speed = 1;
    [self.firstLabel.layer removeAnimationForKey:@"ALAnimation"];
    [self.firstLabel.layer addAnimation:self.groupAnimation_1 forKey:@"ALAnimation"];
    
    [self.secondLabel.layer removeAnimationForKey:@"ALAnimation_2"];
    [self.secondLabel.layer addAnimation:self.groupAnimation_2 forKey:@"ALAnimation_2"];
    
    
}

- (void)stopALAnimation
{
    [self.firstLabel.layer removeAnimationForKey:@"ALAnimation"];
    [self.secondLabel.layer removeAnimationForKey:@"ALAnimation_2"];
}

- (void)setALTimeOffset:(CGFloat)timeOffset
{
    [self.firstLabel.layer addAnimation:self.groupAnimation_1 forKey:@"ALAnimation"];
    [self.secondLabel.layer addAnimation:self.groupAnimation_2 forKey:@"ALAnimation_2"];

    self.groupAnimation_1.speed = 0;
    self.groupAnimation_2.speed = 0;
    self.groupAnimation_1.timeOffset = timeOffset;
    self.groupAnimation_2.timeOffset = timeOffset;

    
}

- (void)composeAnimation
{
    CABasicAnimation *opacityAnimation_1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation_1.fromValue = [NSNumber numberWithFloat:1.f];
    opacityAnimation_1.toValue = [NSNumber numberWithFloat:0.f];
    opacityAnimation_1.duration = 1.f;
    opacityAnimation_1.autoreverses = YES;
    opacityAnimation_1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CATransform3D toValue_1 = CATransform3DMakeTranslation(0, -self.bounds.size.height, 0);
    CABasicAnimation *transformAnimation_1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation_1.toValue = [NSValue valueWithCATransform3D:toValue_1];
    transformAnimation_1.duration = 1.f;
    transformAnimation_1.autoreverses = YES;
    transformAnimation_1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *ropacityAnimation_1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    ropacityAnimation_1.fromValue = [NSNumber numberWithFloat:1.f];
    ropacityAnimation_1.toValue = [NSNumber numberWithFloat:0.f];
    ropacityAnimation_1.duration = 1.f;
    ropacityAnimation_1.beginTime = 2;
    ropacityAnimation_1.removedOnCompletion = NO;
    ropacityAnimation_1.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *rtransformAnimation_1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    rtransformAnimation_1.toValue = [NSValue valueWithCATransform3D:toValue_1];
    rtransformAnimation_1.duration = 1.f;
    rtransformAnimation_1.beginTime = 2;
    rtransformAnimation_1.removedOnCompletion = NO;
    rtransformAnimation_1.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *groupAnimation_1 = [CAAnimationGroup animation];
    groupAnimation_1.animations = [NSArray arrayWithObjects:opacityAnimation_1, transformAnimation_1, ropacityAnimation_1, rtransformAnimation_1, nil];
    groupAnimation_1.duration = 4.f;
    groupAnimation_1.fillMode = kCAFillModeForwards;
    groupAnimation_1.removedOnCompletion = NO;
    self.groupAnimation_1 = groupAnimation_1;
    
    
    CABasicAnimation *opacityAnimation_2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation_2.fromValue = [NSNumber numberWithFloat:0.f];
    opacityAnimation_2.toValue = [NSNumber numberWithFloat:1.f];
    opacityAnimation_2.duration = 1.f;
    opacityAnimation_2.autoreverses = YES;
    opacityAnimation_2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *transformAnimation_2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation_2.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    transformAnimation_2.duration = 1.f;
    transformAnimation_2.autoreverses = YES;
    transformAnimation_2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *ropacityAnimation_2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    ropacityAnimation_2.fromValue = [NSNumber numberWithFloat:0.f];
    ropacityAnimation_2.toValue = [NSNumber numberWithFloat:1.f];
    ropacityAnimation_2.duration = 1.f;
    ropacityAnimation_2.beginTime = 2;
    ropacityAnimation_2.removedOnCompletion = NO;
    ropacityAnimation_2.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *rtransformAnimation_2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    rtransformAnimation_2.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    rtransformAnimation_2.duration = 1.f;
    rtransformAnimation_2.beginTime = 2;
    rtransformAnimation_2.removedOnCompletion = NO;
    rtransformAnimation_2.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *groupAnimation_2 = [CAAnimationGroup animation];
    groupAnimation_2.animations = [NSArray arrayWithObjects:opacityAnimation_2, transformAnimation_2, ropacityAnimation_2, rtransformAnimation_2, nil];
    groupAnimation_2.duration = 4.f;
    groupAnimation_2.fillMode = kCAFillModeForwards;
    groupAnimation_2.removedOnCompletion = NO;
    
    self.groupAnimation_2 = groupAnimation_2;
    
    
}




- (void)cubeTransition
{
    
    UILabel *auxLabel = [[UILabel alloc] initWithFrame:self.frame];
    auxLabel.text = self.text;
    auxLabel.font = self.font;
    auxLabel.textAlignment = self.textAlignment;
    auxLabel.textColor = self.endColor;
    auxLabel.backgroundColor = self.backgroundColor;
    
    CGFloat auxLabelOffset = self.frame.size.height/5.0;
    
    
    auxLabel.transform = CGAffineTransformConcat(
                                                 CGAffineTransformMakeScale(1.0, 0.1),
                                                 CGAffineTransformMakeTranslation(0.0, auxLabelOffset));

    [self.superview addSubview:auxLabel];

    
    
    
    [UIView animateWithDuration:1 delay:1. options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{

        auxLabel.transform = CGAffineTransformIdentity;
        self.transform = CGAffineTransformConcat(
                                                  CGAffineTransformMakeScale(1.0, 0.1),
                                                  CGAffineTransformMakeTranslation(0.0, -auxLabelOffset));


    } completion:^(BOOL finished) {

        self.transform = CGAffineTransformIdentity;
        [auxLabel removeFromSuperview];

    }];
    

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
