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

@end

@implementation QDRunTextView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLayer = [CATextLayer layer];
        self.textLayer.backgroundColor = [UIColor greenColor].CGColor;
        self.textLayer.anchorPoint = CGPointZero;
        self.textLayer.contentsScale = [UIScreen mainScreen].scale;

        self.backgroundColor = [UIColor redColor];
        [self.layer addSublayer:self.textLayer];
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setAttibutedString:(NSAttributedString *)attibutedString
{
    _attibutedString = attibutedString;

    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:attibutedString];
    [att appendAttributedString:attibutedString];
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
    [self.textLayer addAnimation:animation forKey:nil];
}

@end
