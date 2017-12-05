//
//  QDRotateFlyView.m
//  AnimationLabel
//
//  Created by QD on 2017/12/1.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "QDRotateFlyView.h"
#import "CBJStrokeLabel.h"


@interface QDRotateFlyView()

@property (nonatomic, copy) NSAttributedString *attributedString;

@property (nonatomic, strong) CBJStrokeLabel *outlineLabel1;
@property (nonatomic, strong) CBJStrokeLabel *outlineLabel2;

@property (nonatomic, strong) CAAnimation *animation1;
@property (nonatomic, strong) CAAnimation *animation2;

@end


#define LabelSpacing  30
static NSString  * const animationKey1 = @"animationKey1";
static NSString  * const animationKey2 = @"animationKey2";

@implementation QDRotateFlyView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.outlineLabel1 = [CBJStrokeLabel new];
        [self addSubview:self.outlineLabel1];
        self.outlineLabel2 = [CBJStrokeLabel new];
        [self addSubview:self.outlineLabel2];
//        self.clipsToBounds = YES;
//        self.layer.opacity
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(-self.bounds.size.width*0.3/2.0, 0, self.bounds.size.width*1.3, self.bounds.size.height);
        gradientLayer.colors = @[
                                 (__bridge id)[UIColor colorWithWhite:0 alpha:0.f].CGColor,
                                 (__bridge id)[UIColor colorWithWhite:0 alpha:1.0f].CGColor,
                                 (__bridge id)[UIColor colorWithWhite:0 alpha:1.0f].CGColor,
                                 (__bridge id)[UIColor colorWithWhite:0 alpha:0.f].CGColor
                                 ];
        gradientLayer.locations = @[@0.0,@0.3,@0.7,@1.0];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
        
//        [self.layer addSublayer:gradientLayer];
        self.layer.mask = gradientLayer;
//        self.outlineLabel1.backgroundColor = [UIColor greenColor];
//        self.outlineLabel1.backgroundColor = [UIColor yellowColor];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

+ (CGSize)getSizeWithAttibutedString:(NSAttributedString *)attibutedString
{
    return CGSizeMake(attibutedString.size.width, attibutedString.size.height+LabelSpacing*2);
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    _attributedString = [attributedText copy];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    
    
    CGSize textSize = att.size ;
    CGFloat textWidth = textSize.width;
    CGFloat textHeight = textSize.height;
    CGFloat y = self.bounds.size.height/2.0-textSize.height/2.0;
    
    self.outlineLabel1.frame = CGRectMake(0, y, textWidth, textSize.height);
    self.outlineLabel1.outlineColor = [UIColor whiteColor];
    self.outlineLabel1.outlineScale = 0.13;
    self.outlineLabel1.glowSize = 20;
    self.outlineLabel1.glowColor = [UIColor whiteColor];
    self.outlineLabel1.attributedText = [self.outlineLabel1 composeAttributeString:att withColorArray:@[[UIColor blueColor]]];
    
    CGFloat y2 = CGRectGetMaxY(self.outlineLabel1.frame)+LabelSpacing;
    self.outlineLabel2.frame = CGRectMake(0, y2, textWidth, textSize.height);
    self.outlineLabel2.outlineColor = [UIColor whiteColor];
    self.outlineLabel2.outlineScale = 0.13;
    self.outlineLabel2.glowSize = 20;
    self.outlineLabel2.glowColor = [UIColor whiteColor];
    self.outlineLabel2.attributedText = [self.outlineLabel2 composeAttributeString:att withColorArray:@[[UIColor blueColor]]];
    
    //animation1
    //move
    CAKeyframeAnimation *animationmoveUp1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSArray *values1 = @[
                         [NSValue valueWithCGPoint:CGPointMake(textWidth/2.0, y+textHeight/2.0)],
                         [NSValue valueWithCGPoint:CGPointMake(textWidth/2.0, y+textHeight/2.0)],
                         [NSValue valueWithCGPoint:CGPointMake(textWidth/2.0, -y-textHeight/2.0)],
                         [NSValue valueWithCGPoint:CGPointMake(textWidth/2.0, y2+textHeight/2.0)],
                         [NSValue valueWithCGPoint:CGPointMake(textWidth/2.0, y2+textHeight/2.0)],
                         [NSValue valueWithCGPoint:CGPointMake(textWidth/2.0, y+textHeight/2.0)],
                         ];
    animationmoveUp1.values = values1;
    animationmoveUp1.keyTimes = @[@0.0f,@0.3f,@0.425,@0.425,@0.725,@1.f];
    //transform
    CAKeyframeAnimation *animationTransform1 = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D rotation1 = CATransform3DMakeRotation(-(M_PI/12), 0, 0, 1);
    CATransform3D scale1 = CATransform3DMakeScale(1.3, 1.3, 1);
    CATransform3D concat1 = CATransform3DConcat(rotation1, scale1);
    NSArray *transform1 = @[
                            [NSValue valueWithCATransform3D:CATransform3DIdentity],
                            [NSValue valueWithCATransform3D:concat1],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity],
                            ];
    animationTransform1.values = transform1;
    animationTransform1.keyTimes = @[@0.0f,@0.15f,@0.3f,@1.f];
    CAAnimationGroup *animationGroup1 = [CAAnimationGroup animation];
    animationGroup1.duration = 3;
    animationGroup1.repeatCount = MAXFLOAT;
    animationGroup1.animations = @[animationmoveUp1,animationTransform1];
//    [self.outlineLabel1.layer addAnimation:animationGroup1 forKey:nil];
    
    //animation2
    CAAnimationGroup *animationGroup2 = [CAAnimationGroup animation];
    animationGroup2.duration = 3;
    animationGroup2.repeatCount = MAXFLOAT;
    
    CAKeyframeAnimation *animationmoveUp2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSArray *values2 = @[
                         [NSValue valueWithCGPoint:CGPointMake(textWidth/2.0, y2+textHeight/2.0)],
                         [NSValue valueWithCGPoint:CGPointMake(textWidth/2.0, y2+textHeight/2.0)],
                         [NSValue valueWithCGPoint:CGPointMake(textWidth/2.0, y+textHeight/2.0)],
                         [NSValue valueWithCGPoint:CGPointMake(textWidth/2.0, y+textHeight/2.0)],
                         [NSValue valueWithCGPoint:CGPointMake(textWidth/2.0, -y-textHeight/2.0)],
                         ];
    animationmoveUp2.values = values2;
    animationmoveUp2.keyTimes = @[@0.0f,@0.3f,@0.425,@0.725,@1.f];
    
    CAKeyframeAnimation *animationTransform2 = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D rotation2 = CATransform3DMakeRotation((M_PI/12), 0, 0, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.3, 1.3, 1);
    CATransform3D concat2 = CATransform3DConcat(rotation2, scale2);
    NSArray *transform2 = @[
                            [NSValue valueWithCATransform3D:CATransform3DIdentity],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity],
                            [NSValue valueWithCATransform3D:concat2],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity],
                            ];
    animationTransform2.values = transform2;
    animationTransform2.keyTimes = @[@0.0f,@0.425f,@0.575f,@0.725,@1.f];
    
    animationGroup2.animations = @[animationmoveUp2,animationTransform2];
//    [self.outlineLabel2.layer addAnimation:animationGroup2 forKey:nil];
    self.animation1 = animationGroup1;
    self.animation2 = animationGroup2;
}

-(NSAttributedString *)attributedText
{
    return [_attributedString copy];
}

-(void)startALAnimation
{
    [self.outlineLabel1.layer removeAnimationForKey:animationKey1];
    [self.outlineLabel2.layer removeAnimationForKey:animationKey2];

    self.animation1.speed = 1;
    self.animation2.speed = 1;
    [self.outlineLabel1.layer addAnimation:self.animation1 forKey:animationKey1];
    [self.outlineLabel2.layer addAnimation:self.animation2 forKey:animationKey2];

}

-(void)stopALAnimation
{
    [self.outlineLabel1.layer removeAnimationForKey:animationKey1];
    [self.outlineLabel2.layer removeAnimationForKey:animationKey2];
    
}

-(void)setALTimeOffset:(CGFloat)timeOffset
{
    self.animation1.speed = 0;
    self.animation2.speed = 0;
    self.animation1.timeOffset = timeOffset;
    self.animation2.timeOffset = timeOffset;
    [self.outlineLabel1.layer addAnimation:self.animation1 forKey:animationKey1];
    [self.outlineLabel2.layer addAnimation:self.animation2 forKey:animationKey2];
    
}
@end
