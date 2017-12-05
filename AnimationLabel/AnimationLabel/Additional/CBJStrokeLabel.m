//
//  CBJStrokeLabel.m
//  Art font Demo
//
//  Created by 超八机 on 2017/9/2.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "CBJStrokeLabel.h"

@implementation CBJStrokeLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self commonInit];
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self commonInit];
        
    }
    
    return self;
    
}

- (void)commonInit
{
    _outlineColor = [UIColor whiteColor];
    _outlineWidth = 0.f;
    _glowSize = 0.f;
    _glowColor = [UIColor blueColor];
}

- (void)setOutlineColor:(UIColor *)outlineColor
{
    _outlineColor = outlineColor;
    [self setNeedsDisplay];
}

- (void)setOutlineWidth:(CGFloat)outlineWidth
{
    _outlineWidth = outlineWidth;
    [self setNeedsDisplay];
}

- (void)setGlowSize:(CGFloat)glowSize
{
    _glowSize = glowSize;
    [self setNeedsDisplay];
}

- (void)setGlowColor:(UIColor *)glowColor
{
    _glowColor = glowColor;
    [self setNeedsDisplay];
}


- (void)drawTextInRect:(CGRect)rect
{
    
    
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (self.glowSize > 0.0) {
        
        CGContextSetShadowWithColor(context, CGSizeZero, self.glowSize, self.glowColor.CGColor);
        
    }
    
    [super drawTextInRect:rect];
    //[self.attributedText drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();//image context end here
    
    
    context = UIGraphicsGetCurrentContext();
    
    if (self.outlineScale < 1.f && self.outlineScale > 0) {
        
        self.outlineWidth = (int)(self.font.pointSize * self.outlineScale + 0.5f);
        
    }else if(self.outlineScale > 1.f){
        
        self.outlineWidth = self.outlineScale;
    }
    
    if (self.outlineWidth > 0.f) {
        
        CGContextSaveGState(context);
        
        CGContextSetLineWidth(context, self.outlineWidth);
        
        CGContextSetLineJoin(context, kCGLineJoinRound);
        
        CGContextSetTextDrawingMode(context, kCGTextStroke);
        
        self.textColor = self.outlineColor;
        
        //CGContextSetStrokeColorWithColor(context, [self.outlineColor CGColor]);
        
        [super drawTextInRect:rect];
        
        CGContextRestoreGState(context);
        
    }
    
    [image drawInRect:rect];
    
}

- (NSAttributedString *)composeAttributeString:(NSAttributedString *)attributeString withColorArray:(NSArray<UIColor *> *)colorArray
{
    NSMutableAttributedString *mAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:attributeString];
    
    if (colorArray && [colorArray count] > 0) {
        
        for (NSUInteger index = 0; index < mAttributeString.length; index ++) {
            
            NSUInteger colorIndex = index % [colorArray count];
            
            UIColor *color = [colorArray objectAtIndex:colorIndex];
            
            [mAttributeString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(index, 1)];
            
        }
        
    }
    
    if (self.glowSize > 0.f) {
        
        NSShadow *glow = [[NSShadow alloc] init];
        glow.shadowOffset = CGSizeZero;
        glow.shadowColor = self.glowColor;
        glow.shadowBlurRadius = self.glowSize > 10.f ? 10.f : self.glowSize;
        
        
        [mAttributeString addAttribute:NSShadowAttributeName value:glow range:NSMakeRange(0, [mAttributeString length])];
        
    }
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;//水平居中
    
    [mAttributeString addAttribute:NSParagraphStyleAttributeName value:textStyle range:NSMakeRange(0, [mAttributeString length])];
    
    return mAttributeString;
    
}


@end
