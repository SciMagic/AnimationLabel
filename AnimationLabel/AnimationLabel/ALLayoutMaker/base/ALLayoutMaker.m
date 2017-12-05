//
//  ALLayoutMaker.m
//  AnimationLabel
//
//  Created by WavingColor on 2017/12/2.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "ALLayoutMaker.h"
@import CoreText;

@implementation ALTextInfoLayer
- (instancetype) init
{
    if (self = [super init]) {
        self.contentsScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (void) drawInContext:(CGContextRef)ctx
{
    UIGraphicsPushContext(ctx);
    [self.attributedString drawInRect:self.bounds];
    UIGraphicsPopContext();
}
@end


@interface ALTextInfo ()

@property (nonatomic, readwrite) NSAttributedString *derivedAttributedString;

@end
@implementation ALTextInfo


- (NSString *) description
{
    return [NSString stringWithFormat:@"[%@ %@, %@, %f]", [self class], self.text, NSStringFromCGRect(self.charRect), self.progress];
}

- (void) updateBaseAttributedString: (NSAttributedString *) attributedString
{
    _derivedAttributedString = attributedString;
}

- (NSAttributedString *) derivedAttributedString
{
    if (!self.font && !self.textColor) {
        return _derivedAttributedString; //nothing changed
    }
    NSMutableAttributedString *mutableCopy = [_derivedAttributedString mutableCopy];
    NSRange fullRange = NSMakeRange(0, _derivedAttributedString.string.length);
    if(self.font) [mutableCopy addAttribute:NSFontAttributeName value:self.font range:fullRange];
    if(self.textColor) [mutableCopy addAttribute:NSForegroundColorAttributeName value:self.textColor range:fullRange];
    
    return mutableCopy;
}

- (UIColor *) derivedTextColor
{
    return [_derivedAttributedString attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:NULL];
}

- (UIFont *) derivedFont
{
    return [_derivedAttributedString attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
}

@end

@interface ALLayoutMaker()

@property (nonatomic, assign) CGSize estimatedSize;

@end

@implementation ALLayoutMaker

- (instancetype) init
{
    if (self = [super init]) {
        self.groupType = ALLayoutGroupChar;
    }
    return self;
}

- (void) cleanLayout
{
    self.textInfos = nil;
}

- (void) layoutWithAttributedString: (NSAttributedString *) attributedString constainedToSize: (CGSize) size {
    
    NSString *text = [attributedString string];
    if ([text length] < 1) {
        return;
    }
    
    ///构造frame setter
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CTFrameRef ctFrame;
    CGRect frameRect;
    CFRange rangeAll = CFRangeMake(0, text.length);
    
    
    // Measure how mush specec will be needed for this attributed string
    // So we can find minimun frame needed
    CFRange fitRange;
    CGSize s = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, rangeAll, NULL, CGSizeMake(size.width, MAXFLOAT), &fitRange);
    
    self.estimatedSize = s;
    
    ///绘制区域
    frameRect = CGRectMake(0, 0, s.width, s.height);
    CGPathRef framePath = CGPathCreateWithRect(frameRect, NULL);
    ctFrame = CTFramesetterCreateFrame(framesetter, rangeAll, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the lines in our frame
    NSArray* lines = (NSArray*)CTFrameGetLines(ctFrame); //根据frame获取需要绘制的线的数组
    NSUInteger lineCount = [lines count];//获取线的数量
    
    ///建立起点的数组（cgpoint类型为结构体，故用C语言的数组）
    CGPoint *lineOrigins = malloc(sizeof(CGPoint) * lineCount);
    ///简历frame的数组
    CGRect *lineFrames = malloc(sizeof(CGRect) * lineCount);
    
    // Get the origin point of each of the lines
    ///获取起点
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    // Solution borrowew from (but simplified):
    // https://github.com/twitter/twui/blob/master/lib/Support/CoreText%2BAdditions.m
    
    //layout done add into textAttributes
    NSMutableArray *textAttributes = [NSMutableArray arrayWithCapacity:3];
    
    ///偏移
    CGFloat startOffsetY = 0;
    
    // Loop throught the lines
    for(CFIndex i = 0; i < lineCount; ++i) {
        
        CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
        
        CFRange lineRange = CTLineGetStringRange(line);
        
        CGPoint lineOrigin = lineOrigins[i];
        ///上距离，下距离，左距离
        CGFloat ascent, descent, leading;
        CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        // If we have more than 1 line, we want to find the real height of the line by measuring the distance between the current line and previous line. If it's only 1 line, then we'll guess the line's height.
        ///
        BOOL useRealHeight = i < lineCount - 1;
        ///
        CGFloat neighborLineY = i > 0 ? lineOrigins[i - 1].y : (lineCount - 1 > i ? lineOrigins[i + 1].y : 0.0f);
        CGFloat lineHeight = ceil(useRealHeight ? fabs(neighborLineY - lineOrigin.y) : ascent + descent + leading);
        
        lineFrames[i].origin = lineOrigin;
        lineFrames[i].size = CGSizeMake(lineWidth, lineHeight);
        
        NSString *lineString = [text substringWithRange:NSMakeRange(lineRange.location, lineRange.length)];
        
        NSStringEnumerationOptions options = 0;
        switch (self.groupType) {
            case ALLayoutGroupChar:
                options = NSStringEnumerationByComposedCharacterSequences;
                break;
            case ALLayoutGroupWord:
                options = NSStringEnumerationByWords;
                break;
            case ALLayoutGroupLine:
                options = NSStringEnumerationBySentences;
                break;
            default:
                break;
        }
        
        //first pass
        __block CGFloat maxDescender = 0;
        __block CGFloat maxCharHeight = 0;
        [lineString enumerateSubstringsInRange:NSMakeRange(0, lineRange.length) options:options usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            NSMutableAttributedString *subLineString = [[attributedString attributedSubstringFromRange:NSMakeRange(enclosingRange.location + lineRange.location, enclosingRange.length)] mutableCopy];
            UIFont *font = [subLineString attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
            maxDescender = MAX(maxDescender, font.descender > 0 ? font.descender : -font.descender);
            maxCharHeight = MAX(maxCharHeight, font.xHeight + font.ascender + font.descender);
        }];
        
        [lineString enumerateSubstringsInRange:NSMakeRange(0, lineRange.length) options:options usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            ALTextInfo *textInfo = [[ALTextInfo alloc] init];
            textInfo.text = [lineString substringWithRange:enclosingRange];
            textInfo.textRange = enclosingRange;
            NSMutableAttributedString *subLineString = [[attributedString attributedSubstringFromRange:NSMakeRange(enclosingRange.location + lineRange.location, enclosingRange.length)] mutableCopy];
            [subLineString removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, subLineString.length)];
            UIFont *font = [subLineString attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
            [textInfo updateBaseAttributedString:subLineString];
            
            CGFloat startOffset = CTLineGetOffsetForStringIndex(line, enclosingRange.location + lineRange.location, NULL);
            CGFloat endOffset = CTLineGetOffsetForStringIndex(line, enclosingRange.location + enclosingRange.length + lineRange.location, NULL);
            
            CGFloat realHeight = font.xHeight + font.ascender + font.descender;
            CGFloat absAscender = font.descender > 0 ? font.descender : -font.descender;
            CGFloat originDiff = (maxCharHeight - realHeight) - (maxDescender - absAscender);
            
            if (self.groupType == ALLayoutGroupLine) {
                realHeight = lineHeight;
                originDiff = 0;
            }
            ///单个字符, 词组，行 的rect
            textInfo.charRect = CGRectMake(startOffset + lineOrigins[i].x, startOffsetY + originDiff, endOffset - startOffset, realHeight);
            [textAttributes addObject:textInfo];
            
            if (self.layerBased) {
                ALTextInfoLayer *textInfoLayer = [[ALTextInfoLayer alloc] init];
                textInfoLayer.frame = textInfo.charRect;
                textInfoLayer.attributedString = subLineString;
                textInfoLayer.backgroundColor = [UIColor clearColor].CGColor;
                textInfo.textBlockLayer = textInfoLayer;
            }
        }];
        
        startOffsetY += lineHeight;
        
    }
    
    self.textInfos = textAttributes;
    
    //free stuff
    free(lineOrigins);
    free(lineFrames);
}



- (CGFloat) estimatedHeight
{
    return self.estimatedSize.height;
}



@end
