//
//  ALFineDrewAnimationBaseLabel.m
//  AnimationLabel
//
//  Created by WavingColor on 2017/12/8.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "ALFineDrewAnimationBaseLabel.h"

@interface ALFineDrewAnimationBaseLabel()

@property (nonatomic, strong) ALLayoutMaker *layoutTool;
@property (nonatomic, assign) NSTimeInterval animationDurationTotal;
@property (nonatomic, assign) BOOL animatingAppear; //we are during appear stage or not

@end

static NSString *const animationKey = @"animationKey";

@implementation ALFineDrewAnimationBaseLabel

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}


- (void) commonInit
{
    self.backgroundColor = [UIColor clearColor];
    
//    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerTick:)];
//    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//    _displayLink.paused = YES;
//
    _animationDuration = 1;
    _animationDelay = 0.1;
//    //    _appearDirection = ZCAnimatedLabelAppearDirectionFromBottom;
    _layoutTool = [[ALLayoutMaker alloc] init];
//    _onlyDrawDirtyArea = YES;
//
//    _useDefaultDrawing = YES;
//    _text = @"";
    self.font = [UIFont systemFontOfSize:15];
    
//
//    _debugTextInfoBounds = NO;
    _animatingAppear = YES;
    _layerBased = YES;
    _appearTail = NO;
}

- (void)startALAnimation {
    
    [self.layoutTool.textInfos enumerateObjectsUsingBlock:^(ALTextInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.contentAnimations setValue:@(1) forKey:@"speed"];
        [obj.contentAnimations setValue:@(0) forKey:@"timeOffset"];
        
        [obj.contentAnimations enumerateObjectsUsingBlock:^(CAAnimation * _Nonnull anim, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *animKey = [ALFineDrewAnimationBaseLabel keyWithOrigan:obj.animationKey num:idx];
            [obj.textInfoLayer removeAnimationForKey:animKey];
            [obj.textInfoLayer addAnimation:anim forKey:animKey];
        }];
    }];
}

- (void)stopALAnimation {
    
    [self.layoutTool.textInfos enumerateObjectsUsingBlock:^(ALTextInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj.contentAnimations enumerateObjectsUsingBlock:^(CAAnimation * _Nonnull anim, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *animKey = [ALFineDrewAnimationBaseLabel keyWithOrigan:obj.animationKey num:idx];
            [obj.textInfoLayer removeAnimationForKey:animKey];
        }];
        [obj.contentAnimations setValue:@(0) forKey:@"timeOffset"];
    }];
}

- (void)setALTimeOffset:(CGFloat)timeOffset {
    [self.layoutTool.textInfos enumerateObjectsUsingBlock:^(ALTextInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.contentAnimations setValue:@(0) forKey:@"speed"];
        [obj.contentAnimations setValue:@(timeOffset) forKey:@"timeOffset"];

        [obj.contentAnimations enumerateObjectsUsingBlock:^(CAAnimation * _Nonnull anim, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *animKey = [ALFineDrewAnimationBaseLabel keyWithOrigan:obj.animationKey num:idx];
            [obj.textInfoLayer removeAnimationForKey:animKey];
            [obj.textInfoLayer addAnimation:anim forKey:animKey];
        }];
    }];
}



#pragma mark layout related
- (void)setText:(NSString *)text {
    
    [super setText:text];
    [self _layoutForChangedString];
//    [self setNeedsDisplay];
}
/**    主要是高度fit    */
- (void) sizeToFit
{
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), self.layoutTool.estimatedHeight);
}

/**    宽度默认200，高度info设置    */
- (CGSize) intrinsicContentSize
{
    return CGSizeMake(self.preferredMaxLayoutWidth > 0 ? self.preferredMaxLayoutWidth : 200, self.layoutTool.estimatedHeight);
}

- (void)textBlockAttributesInit:(ALTextInfo *) textInfo
{
    //override this in subclass if necessary
    ALTextInfoLayer *layer = textInfo.textInfoLayer;
//    [CATransaction begin];
//    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.opacity = 0;
//    layer.frame = textInfo.charRect;
    [layer setNeedsDisplay];
//    layer.anchorPoint = CGPointMake(0, 0);
//    layer.position = CGPointMake(self.bounds.size.width, textInfo.textInfoLayer.position.y);
//    [CATransaction commit];
}


- (void) _layoutForChangedString
{
    ///清空当前设置
    [self.layoutTool cleanLayout];
   
    ///图层标记
    self.layoutTool.layerBased = self.layerBased;
    
    ///标记处理，移除当前做过动画的所有图层
    if (self.layerBased) {
        [self _removeAllTextLayers];
    }
    
    ///用attribute string初始化text info
    [self.layoutTool layoutWithAttributedString:self.attributedText constainedToSize:self.frame.size];
    [self sizeToFit];
    ///拿到动画进行的总时长
    __block CGFloat maxDuration = 0;
    [self.layoutTool.textInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //        ALTextInfo *textInfo = obj;
        
        ///序号调整,头开始，还是尾开始
        NSUInteger sequence = self.appearTail ? (self.layoutTool.textInfos.count - idx - 1) : idx;
        ///拿到文字数据
        ALTextInfo *textInfo = self.layoutTool.textInfos[sequence];
        [self textBlockAttributesInit:textInfo];
        
        ///这个info做动画的时长
        CGFloat duration  =  self.animationDuration;
        ///这个info做动画的起始时间
        CGFloat startDelay = sequence * self.animationDelay;
        CGFloat realStartDelay = startDelay + duration;
        
        textInfo.duration = duration;
        textInfo.startDelay = realStartDelay;
        textInfo.animationKey = [NSString stringWithFormat:@"%@_%ld", animationKey, sequence];
        
        ///实际动画做到什么时候
        //        NSLog(@"dur:%lf, start:%lf, real:%lf", duration, startDelay, realStartDelay);
        if (realStartDelay > maxDuration) {
            ///刷新动画总时长
            maxDuration = realStartDelay;
        }
       
    }];
    
    ///为总动画时长赋值
    self.animationDurationTotal = maxDuration;
    
    [self.layoutTool.textInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        ///序号调整,头开始，还是尾开始
        NSUInteger sequence = self.appearTail ? (self.layoutTool.textInfos.count - idx - 1) : idx;
        ///拿到文字数据
        ALTextInfo *textInfo = self.layoutTool.textInfos[sequence];
        
        if (self.layerBased) {
            ///图层动画的处理
            [self.layer addSublayer:textInfo.textInfoLayer];
            [self appearStateLayerAnimationForTextInfo:textInfo];
        }
    }];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        [self invalidateIntrinsicContentSize]; //reset intrinsicContentSize
    }
}

- (void)setNeedsDisplay
{
    if (self.layerBased) {
        return;
    }
    else {
        [super setNeedsDisplay];
    }
}

- (void)drawTextInRect:(CGRect)rect {

}


/**    移除view所有子layer    */
- (void)_removeAllTextLayers
{
    NSMutableArray *toDelete = [NSMutableArray arrayWithCapacity:1];
    for (CALayer *layer in self.layer.sublayers) {
        [toDelete addObject:layer];
    }
    
    for (CALayer *layer in toDelete) {
        [layer removeFromSuperlayer];
    }
}



#pragma mark --layer Appear animation--
- (void)appearStateLayerAnimationForTextInfo:(ALTextInfo *)textInfo {
    
    
    ///in
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(0.0);
    opacityAnimation.toValue = @(1.0);
    opacityAnimation.duration = textInfo.duration;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeBoth;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    
    CATransform3D fromValue = CATransform3DMakeTranslation(100, 0, 0);
    CATransform3D toValue   = CATransform3DIdentity;

    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:toValue];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:fromValue];
    transformAnimation.duration = textInfo.duration;
    transformAnimation.removedOnCompletion = NO;
    transformAnimation.fillMode = kCAFillModeBoth;
    transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

    
    ///out
    CABasicAnimation *outopacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    outopacityAnimation.toValue = @(0.0);
    outopacityAnimation.duration = textInfo.duration;
    outopacityAnimation.beginTime = self.animationDurationTotal;
    outopacityAnimation.removedOnCompletion = NO;
    outopacityAnimation.fillMode = kCAFillModeForwards;
    outopacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CATransform3D outtoValue   = CATransform3DMakeTranslation(-100, 0, 0);

    CABasicAnimation *outtransformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    outtransformAnimation.toValue = [NSValue valueWithCATransform3D:outtoValue];
    outtransformAnimation.duration = textInfo.duration;
    outtransformAnimation.beginTime = self.animationDurationTotal;
    outtransformAnimation.removedOnCompletion = NO;
    outtransformAnimation.fillMode = kCAFillModeForwards;
    outtransformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[opacityAnimation, transformAnimation, outopacityAnimation, outtransformAnimation];
    group.duration = textInfo.duration * 4 ;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeBoth;
    group.beginTime = textInfo.startDelay + CACurrentMediaTime();// + self.animationDurationTotal;
    group.repeatCount = MAXFLOAT;
    
//    NSLog(@"%@", NSStringFromCGRect(textInfo.charRect));
    textInfo.contentAnimations = @[group];
}


+ (NSString *)keyWithOrigan:(NSString *)oriKey num:(NSInteger)num {
    return [NSString stringWithFormat:@"%@_%ld", oriKey, num];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
