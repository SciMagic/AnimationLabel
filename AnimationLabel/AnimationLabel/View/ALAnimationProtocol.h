//
//  ALAnimationProtocol.h
//  AnimationLabel
//
//  Created by QD-ZC on 2017/12/5.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ALAnimationProtocol <NSObject>

@optional

- (void)startALAnimation;

- (void)stopALAnimation;

- (void)setALTimeOffset:(CGFloat)timeOffset;

- (void)setALRepeatCount:(NSUInteger)count;

- (void)setALDuration:(CGFloat)duration;

+ (CGSize)getSizeWithAttibutedString:(NSAttributedString *)attibutedString;

@end
