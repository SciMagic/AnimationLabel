//
//  ALLineOneByOneLabel.m
//  AnimationLabel
//
//  Created by WavingColor on 2017/12/5.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "ALLineOneByOneLabel.h"

@implementation ALLineOneByOneLabel

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.onlyDrawDirtyArea = NO;
        self.layerBased = YES;
        self.disappearTail = NO;
    }
    return self;
}


- (void)startALAnimation {
    [self startAppearAnimation];
}

- (void)stopALAnimation {
    [self revertAnimation];
}

- (void)setALTimeOffset:(CGFloat)timeOffset {
    [self animationWithTimestamp:timeOffset];
}

- (void) textBlockAttributesInit:(ALTextInfo *)textInfo
{
    ALTextInfoLayer *layer = textInfo.textInfoLayer;
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    [layer setNeedsDisplay];
    layer.opacity = 0;
    layer.anchorPoint = CGPointMake(0, 0);
    layer.position = CGPointMake(self.bounds.size.width, textInfo.textInfoLayer.position.y);
    [CATransaction commit];
}

- (void)animationCompleteAction {
    
    if (self.animatingAppear) {
        [self startDisappearAnimation];
    } else {
        [self startAppearAnimation];
    }
}


- (void) appearStateLayerChangesForTextInfo:(ALTextInfo *)textInfo
{
    if (textInfo.progress <= 0) {
        return;
    }
    
    //0~0.5, run
    CGFloat realProgress = ([ZCEasingUtil easeOutWithStartValue:0 endValue:1 time:textInfo.progress < 0.5 ? textInfo.progress * 2 : 1]);
   
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    CGPoint shouldBePosition = CGPointMake(CGRectGetMinX(textInfo.charRect), CGRectGetMinY(textInfo.charRect));
    CALayer *textLayer = textInfo.textInfoLayer;
    ///根据进度，和本行剩余的距离，算出缓冲开始的水平坐标
    textLayer.position = CGPointMake(shouldBePosition.x + (1 - realProgress) * (self.bounds.size.width - shouldBePosition.x), shouldBePosition.y);
    textLayer.opacity = (textInfo.progress < 0.5) ? [ZCEasingUtil easeInWithStartValue:0 endValue:1 time:textInfo.progress * 2] : 1;

    [CATransaction commit];
    
    
}

- (void)disappearLayerStateChangesForTextInfo:(ALTextInfo *)textInfo {
    
    if (textInfo.progress <= 0) {
        return;
    }
    //0~0.5, run
    CGFloat realProgress = ([ZCEasingUtil easeInWithStartValue:0 endValue:1 time:textInfo.progress < 0.5 ? textInfo.progress * 2 : 1]);
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    CGPoint shouldBePosition = CGPointMake(CGRectGetMinX(textInfo.charRect), CGRectGetMinY(textInfo.charRect));
    CALayer *textLayer = textInfo.textInfoLayer;
//    NSLog(@"realProgress:  %lf", realProgress);
    textLayer.position = CGPointMake(shouldBePosition.x - realProgress * 100, shouldBePosition.y);
    textLayer.opacity = (textInfo.progress < 0.5) ? [ZCEasingUtil easeOutWithStartValue:1 endValue:0 time:textInfo.progress * 2] : 0;

    [CATransaction commit];
}

@end
