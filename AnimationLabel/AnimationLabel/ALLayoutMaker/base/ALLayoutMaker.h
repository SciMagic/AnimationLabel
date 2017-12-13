//
//  ALLayoutMaker.h
//  AnimationLabel
//
//  Created by WavingColor on 2017/12/2.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef NS_ENUM(NSInteger, ALLayoutGroupType)
{
    ALLayoutGroupChar,
    ALLayoutGroupWord,
    ALLayoutGroupLine,
};


@interface ALTextInfoLayer : CALayer

@property (nonatomic, strong) NSAttributedString *attributedString;

@end

@interface ALTextInfo : NSObject


@property (nonatomic, assign) CGRect charRect;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSRange textRange;

/**
 * if wanted to override default value from attributedString
 s*/
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

/**
 * attributes derived from current draw state, used to draw
 */
@property (nonatomic, readonly) UIColor *derivedTextColor;
@property (nonatomic, readonly) UIFont *derivedFont;
@property (nonatomic, readonly) NSAttributedString *derivedAttributedString;

@property (nonatomic, assign) BOOL ended; //flag, won't redraw if set to YES
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat startDelay;
@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, strong) ALTextInfoLayer *textInfoLayer;
@property (nonatomic, copy) NSArray< CAAnimation *>* contentAnimations;
@property (nonatomic, strong) NSString *animationKey;

/**
 * place holder for customValue
 */
@property (nonatomic, strong) id customValue;

- (void) updateBaseAttributedString: (NSAttributedString *) attributedString;

@end

@interface ALLayoutMaker : NSObject


- (void) cleanLayout;

/**
 layout maker function

 @param attributedString as title
 @param size as title
 */
- (void)layoutWithAttributedString:(NSAttributedString *)attributedString constainedToSize:(CGSize)size;

- (CGFloat)estimatedHeight;

@property (nonatomic, assign) BOOL layerBased;
@property (nonatomic, strong) NSArray <ALTextInfo *>*textInfos;
@property (nonatomic, assign) ALLayoutGroupType groupType;


@end
