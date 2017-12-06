//
//  ALSequentialBaseLabel.m
//  AnimationLabel
//
//  Created by WavingColor on 2017/12/5.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "ALSequentialBaseLabel.h"
@interface ALSequentialBaseLabel ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval animationTime;
@property (nonatomic, assign) BOOL useDefaultDrawing;
@property (nonatomic, assign) NSTimeInterval animationDurationTotal;
@property (nonatomic, assign) BOOL animatingAppear; //we are during appear stage or not
@property (nonatomic, strong) ALLayoutMaker *layoutTool;
@property (nonatomic, assign) NSTimeInterval animationStarTime;

@end
@implementation ALSequentialBaseLabel


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

- (instancetype) init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit
{
    self.backgroundColor = [UIColor clearColor];
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerTick:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _displayLink.paused = YES;
    
    _animationDuration = 1;
    _animationDelay = 0.1;
//    _appearDirection = ZCAnimatedLabelAppearDirectionFromBottom;
    _layoutTool = [[ALLayoutMaker alloc] init];
    _onlyDrawDirtyArea = YES;
    
    _useDefaultDrawing = YES;
    _text = @"";
    _font = [UIFont systemFontOfSize:15];
    
    _debugTextInfoBounds = NO;
    _layerBased = NO;
    _disappearTail = YES;
}


- (CGFloat)totoalAnimationDuration
{
    return self.animationDurationTotal;
}

- (CGFloat)animationProgress {
    
    CGFloat progress = self.animationTime / self.animationDurationTotal;
    return progress;
}

- (void)timerTick:(id) sender
{
    [self animationWithTimestamp:self.displayLink.timestamp];
}


- (void)animationWithTimestamp:(CFTimeInterval)timeInterval {
    
    if (self.animationStarTime <= 0) {
        self.animationStarTime = timeInterval;
    }
    self.animationTime = timeInterval - self.animationStarTime;
//    NSLog(@"%lf   ---   %lf", self.animationTime, self.animationDurationTotal);

    if (self.animationTime > self.animationDurationTotal) {
        self.displayLink.paused = YES;
        self.useDefaultDrawing = YES;
        [self animationCompleteAction];
    }
    else { //update text attributeds array
        
        [self.layoutTool.textInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           ///文字数据
            ALTextInfo *textInfo = self.layoutTool.textInfos[idx];
            ///序号调整
            NSUInteger sequence = self.animatingAppear || !self.disappearTail ? idx : (self.layoutTool.textInfos.count - idx - 1);
            
            //udpate attribute according to progress
            CGFloat progress = 0;
            CGFloat startDelay = textInfo.startDelay > 0 ? textInfo.startDelay : sequence * self.animationDelay;
            NSTimeInterval timePassed = self.animationTime - startDelay;
            CGFloat duration = textInfo.duration > 0 ? textInfo.duration : self.animationDuration;
           
            if (timePassed > duration && !textInfo.ended) {
                
                ///结束
                progress = 1;
//                textInfo.ended = YES; //ended
                textInfo.progress = progress;
                if (self.layerBased) {
                    [self updateViewStateWithTextInfo:textInfo];
                }
                else {
                    CGRect dityRect = [self redrawAreaForRect:self.bounds textInfo:textInfo];
                    [self setNeedsDisplayInRect:dityRect];
                }
            }
            else if (timePassed < 0) {
                ///开始
                progress = 0;
            }
            else {
                ///进行中，刷新
                progress = timePassed / duration;
                progress = progress > 1 ? 1 : progress;
                if (!textInfo.ended) {
                    textInfo.progress = progress;
                    if (self.layerBased) {
                        [self updateViewStateWithTextInfo:textInfo];
                    }
                    else {
                        CGRect dityRect = [self redrawAreaForRect:self.bounds textInfo:textInfo];
                        [self setNeedsDisplayInRect:dityRect];
                    }
                }
            }
            textInfo.progress = progress;
        }];
    }
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

#pragma mark layout related
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


- (void) _layoutForChangedString
{
    ///清空当前设置
    [self.layoutTool cleanLayout];
    if (!_attributedString) {
        _attributedString = [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName : self.font}];
    }
    ///图层标记
    self.layoutTool.layerBased = self.layerBased;
    
    ///标记处理
    if (self.layerBased) {
        [self _removeAllTextLayers];
    }
    
    ///用attribute string初始化text info
    [self.layoutTool layoutWithAttributedString:self.attributedString constainedToSize:self.frame.size];
    
    ///拿到动画进行的总时长
    __block CGFloat maxDuration = 0;
    [self.layoutTool.textInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ALTextInfo *textInfo = obj;
        [self textBlockAttributesInit:textInfo];
        
        CGFloat duration = textInfo.duration > 0 ? textInfo.duration : self.animationDuration;
        CGFloat startDelay = textInfo.startDelay > 0 ? textInfo.startDelay : idx * self.animationDelay;
        CGFloat realStartDelay = startDelay + duration;
        NSLog(@"dur:%lf, start:%lf, real:%lf", duration, startDelay, realStartDelay);
        if (realStartDelay > maxDuration) {
            maxDuration = realStartDelay;
        }
        
        if (self.layerBased) {
            [self.layer addSublayer:textInfo.textInfoLayer];
        }
    }];
    
    self.animationDurationTotal = maxDuration;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        [self invalidateIntrinsicContentSize]; //reset intrinsicContentSize
    }
}

#pragma Label related

- (void) setNeedsDisplayInRect:(CGRect)rect
{
    ///layer层，不刷新
    if (self.layerBased) {
        return;
    }
    ///局部刷新
    if (self.onlyDrawDirtyArea) {
        [super setNeedsDisplayInRect:rect];
    }
    ///全体刷新
    else {
        [super setNeedsDisplay];
    }
}

- (void) setNeedsDisplay
{
    if (self.layerBased) {
        return;
    }
    else {
        [super setNeedsDisplay];
    }
}

- (void) setAttributedString:(NSAttributedString *)attributedString
{
    _attributedString = attributedString;
    if ([attributedString length] < 1) {
        return;
    }
    NSDictionary *attributes = [attributedString attributesAtIndex:0 effectiveRange:NULL];
    UIFont *font = [attributes objectForKey:NSFontAttributeName];
    UIColor *color = [attributes objectForKey:NSForegroundColorAttributeName];
    if (font) {
        _font = font;
    }
    if (color) {
        _textColor = color;
    }
    [self _layoutForChangedString];
    [self setNeedsDisplay];
}

- (void) setFont:(UIFont *)font
{
    _font = font;
    [self _layoutForChangedString];
    [self setNeedsDisplay];
}

- (void) setText:(NSString *)text
{
    _text = text;
    [self _layoutForChangedString];
    [self setNeedsDisplay];
}

- (void) setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setNeedsDisplay]; //no layout change
}

- (void) setUseDefaultDrawing:(BOOL)useDefaultDrawing
{
    _useDefaultDrawing = useDefaultDrawing;
    [self setNeedsDisplay];
}


- (void) startAppearAnimation
{
    self.animatingAppear = YES;
    self.animationTime = 0;
    self.useDefaultDrawing = NO;
    self.displayLink.paused = NO;
    self.animationStarTime = 0;
    [self setNeedsDisplay];
}

- (void) startDisappearAnimation
{
    self.animatingAppear = NO;
    self.animationTime = 0;
    self.useDefaultDrawing = NO;
    self.displayLink.paused = NO;
    self.animationStarTime = 0;
    [self setNeedsDisplay]; //draw all rects
}


- (void) stopAnimation
{
    self.animationTime = 0;
    self.displayLink.paused = YES;
}

- (void)revertAnimation {
    
    self.text = _text;
    self.animatingAppear = YES;
    self.animationTime = 0;
    self.useDefaultDrawing = NO;
    self.displayLink.paused = YES;
    self.animationStarTime = 0;
    [self animationWithTimestamp:0];
}

- (void) setDebugTextInfoBounds:(BOOL)drawsCharRect
{
    _debugTextInfoBounds = drawsCharRect;
    [self setNeedsDisplay];
}

- (void) setLayerBased:(BOOL)layerBased
{
    _layerBased = layerBased;
    [self setNeedsDisplay]; //blank draw rect
    if (!layerBased) {
        [self _removeAllTextLayers];
    }
}


#pragma mark Custom Drawing

- (void) textBlockAttributesInit: (ALTextInfo *) textInfo
{
    //override this in subclass if necessary
}


- (CGRect) redrawAreaForRect: (CGRect) rect textInfo: (ALTextInfo *) textInfo
{
    return  textInfo.charRect;
}

- (void) appearStateDrawingForRect:(CGRect)rect textInfo: (ALTextInfo *)textInfo
{
    CGFloat realProgress = [ZCEasingUtil bounceWithStiffness:0.01 numberOfBounces:1 time:textInfo.progress shake:NO shouldOvershoot:NO];
    if (textInfo.progress <= 0.0f) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    if (self.appearDirection == ALSequentialLabelAppearDirectionFromCenter) {
        CGContextTranslateCTM(context, CGRectGetMidX(textInfo.charRect), CGRectGetMidY(textInfo.charRect));
        CGContextScaleCTM(context, realProgress, realProgress);
        CGRect rotatedRect = CGRectMake(-textInfo.charRect.size.width / 2, - textInfo.charRect.size.height / 2, textInfo.charRect.size.width, textInfo.charRect.size.height);
        [textInfo.derivedAttributedString drawInRect:rotatedRect];
    }
    else if (self.appearDirection == ALSequentialLabelAppearDirectionFromTop) {
        CGContextTranslateCTM(context, CGRectGetMidX(textInfo.charRect), CGRectGetMinY(textInfo.charRect));
        CGContextScaleCTM(context, realProgress, realProgress);
        CGRect rotatedRect = CGRectMake(-textInfo.charRect.size.width / 2,0, textInfo.charRect.size.width, textInfo.charRect.size.height);
        [textInfo.derivedAttributedString drawInRect:rotatedRect];
    }
    else if (self.appearDirection == ALSequentialLabelAppearDirectionFromTopLeft) {
        CGContextTranslateCTM(context, CGRectGetMinX(textInfo.charRect), CGRectGetMinY(textInfo.charRect));
        CGContextScaleCTM(context, realProgress, realProgress);
        CGRect rotatedRect = CGRectMake(0, 0, textInfo.charRect.size.width, textInfo.charRect.size.height);
        [textInfo.derivedAttributedString drawInRect:rotatedRect];
    }
    else if (self.appearDirection == ALSequentialLabelAppearDirectionFromBottom) {
        CGContextTranslateCTM(context, CGRectGetMidX(textInfo.charRect), CGRectGetMaxY(textInfo.charRect));
        CGContextScaleCTM(context, realProgress, realProgress);
        CGRect rotatedRect = CGRectMake(-textInfo.charRect.size.width / 2, - textInfo.charRect.size.height, textInfo.charRect.size.width, textInfo.charRect.size.height);
        [textInfo.derivedAttributedString drawInRect:rotatedRect];
    }
    CGContextRestoreGState(context);
}

- (void) disappearStateDrawingForRect:(CGRect)rect textInfo:(ALTextInfo *)textInfo
{
    textInfo.progress = 1 - textInfo.progress; //default implementation, might not looks right
    [self appearStateDrawingForRect:rect textInfo:textInfo];
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.layerBased) {
        return;
    }
    
    if (self.debugRedraw) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat hue = ( arc4random() % 256 / 256.0 );
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
    }
    
    for (ALTextInfo *textInfo in self.layoutTool.textInfos) {
        if (!CGRectIntersectsRect(rect, textInfo.charRect)) {
            continue; //skip this text redraw
        }
        
        if (self.debugTextInfoBounds) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
            CGContextAddRect(context, textInfo.charRect);
            CGContextStrokePath(context);
        }
        
        if (self.useDefaultDrawing) {
            if (self.animatingAppear) {
                [textInfo.derivedAttributedString drawInRect:textInfo.charRect];
            }
        }
        else {
            if (self.animatingAppear) {
                [self appearStateDrawingForRect:rect textInfo:textInfo];
            }
            if (!self.animatingAppear) {
                [self disappearStateDrawingForRect:rect textInfo:textInfo];
            }
        }
    }
    
    if (self.useDefaultDrawing) {
        [self.layoutTool cleanLayout];
    }
}


#pragma mark Custom View Attribute Changes

- (void) updateViewStateWithTextInfo: (ALTextInfo *) textInfo
{
    if (self.animatingAppear) {
        [self appearStateLayerChangesForTextInfo:textInfo];
    }
    if (!self.animatingAppear) {
        [self disappearLayerStateChangesForTextInfo:textInfo];
    }
}

- (void) appearStateLayerChangesForTextInfo: (ALTextInfo *) textInfo
{
    
}

- (void) disappearLayerStateChangesForTextInfo: (ALTextInfo *) textInfo
{
    
}

- (void)animationCompleteAction {
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
