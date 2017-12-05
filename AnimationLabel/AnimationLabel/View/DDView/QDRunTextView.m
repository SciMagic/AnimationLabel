//
//  QDRunTextView.m
//  AnimationLabel
//
//  Created by QD on 2017/12/1.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "QDRunTextView.h"

@interface QDRunTextView()

@property (nonatomic, strong) CATextLayer *textLayer;
@property (nonatomic, copy) NSAttributedString *attributedString;
@property (nonatomic, strong) CAAnimation *animation;
@end

static NSString  * const animationKey = @"animationKey";
@implementation QDRunTextView

+(CGSize)getSizeWithAttibutedString:(NSAttributedString *)attibutedString
{
    return CGSizeMake(attibutedString.size.width*0.8, attibutedString.size.height);
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLayer = [CATextLayer layer];
        self.textLayer.anchorPoint = CGPointZero;
        self.textLayer.contentsScale = [UIScreen mainScreen].scale;

        [self.layer addSublayer:self.textLayer];
        self.clipsToBounds = YES;
    }
    return self;
}
-(void)setAttributedText:(NSAttributedString *)attributedText
{
    _attributedString = [attributedText copy];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    [att appendAttributedString:attributedText];
    self.textLayer.string = att;
    
    CGSize textSize = att.size ;
    CGFloat textWidth = textSize.width;
    CGFloat y = self.bounds.size.height/2.0-textSize.height/2.0;
    self.textLayer.frame = CGRectMake(0, y, textWidth, textSize.height);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSArray *values = @[
                        [NSValue valueWithCGPoint:CGPointMake(0, y)],
                        [NSValue valueWithCGPoint:CGPointMake(-textWidth/2.0, y)],
                        ];
    
    animation.values = values;
    animation.repeatCount = MAXFLOAT;
    animation.duration = 3;
    self.animation = animation;
}


-(NSAttributedString *)attributedText
{
    return [_attributedString copy];
}

-(void)startALAnimation
{
    [self.textLayer removeAnimationForKey:animationKey];
    self.animation.speed = 1;
    [self.textLayer addAnimation:self.animation forKey:animationKey];
    
}

-(void)stopALAnimation
{
    [self.textLayer removeAnimationForKey:animationKey];
}

-(void)setALTimeOffset:(CGFloat)timeOffset
{
    self.animation.speed = 0;
    self.animation.timeOffset = timeOffset;
    [self.textLayer addAnimation:self.animation forKey:animationKey];
 
    
}
@end


