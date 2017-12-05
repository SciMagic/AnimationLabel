//
//  ALFlickerLabel.m
//  AnimationLabel
//
//  Created by QD-ZC on 2017/12/5.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "ALFlickerLabel.h"
#import "CBJStrokeLabel.h"

@interface ALFlickerLabel ()

@property (weak, nonatomic) CBJStrokeLabel *strokeLabel;
@property (strong, nonatomic) CAAnimationGroup *groupAnimation;

@end

@implementation ALFlickerLabel

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

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    self.strokeLabel.textAlignment = textAlignment;
}

- (void)setFont:(UIFont *)font
{
    self.strokeLabel.font = font;
}

- (void)setText:(NSString *)text
{
    self.strokeLabel.text = text;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    self.strokeLabel.attributedText = attributedText;

}

- (void)configAnimateLabel
{
    
    CBJStrokeLabel *strokeLabel = [[CBJStrokeLabel alloc] initWithFrame:self.bounds];
    strokeLabel.outlineColor = [UIColor whiteColor];
    strokeLabel.textColor = [UIColor colorWithRed:240.f/255.f green:67.f/255.f blue:146.f/255.f alpha:1];
    strokeLabel.outlineScale = 0.2;
    self.strokeLabel = strokeLabel;
    [self addSubview:strokeLabel];
    
    [self composeAnimation];
    
}

- (void)composeAnimation
{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.25f;
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.f];
    opacityAnimation.autoreverses = YES;
    opacityAnimation.repeatCount = 4;

    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = 3;
    groupAnimation.animations = [NSArray arrayWithObject:opacityAnimation];
    groupAnimation.repeatCount = 2;
    
    self.groupAnimation = groupAnimation;
    
    
}

- (void)startALAnimation
{
 
    self.groupAnimation.speed = 1;

    [self.strokeLabel.layer removeAnimationForKey:@"ALAnimation"];
    [self.strokeLabel.layer addAnimation:self.groupAnimation forKey:@"ALAnimation"];
    
}

- (void)stopALAnimation
{
    [self.strokeLabel.layer removeAnimationForKey:@"ALAnimation"];
}

- (void)setALTimeOffset:(CGFloat)timeOffset
{
    [self.strokeLabel.layer addAnimation:self.groupAnimation forKey:@"ALAnimation"];
    
    self.groupAnimation.speed = 0;
    self.groupAnimation.timeOffset = timeOffset;
}

- (void)setALDuration:(CGFloat)duration
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
