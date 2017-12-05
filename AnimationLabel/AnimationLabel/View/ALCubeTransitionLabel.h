//
//  ALCubeTransitionLabel.h
//  AnimationLabel
//
//  Created by QD-ZC on 2017/12/2.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALCubeTransitionLabel : UILabel

@property (strong, nonatomic) UIColor *startColor;
@property (strong, nonatomic) UIColor *endColor;

- (void)startALAnimation;

- (void)stopALAnimation;

- (void)setALTimeOffset:(CGFloat)timeOffset;

@end
