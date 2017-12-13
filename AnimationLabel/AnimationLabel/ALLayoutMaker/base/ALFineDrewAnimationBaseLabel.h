//
//  ALFineDrewAnimationBaseLabel.h
//  AnimationLabel
//
//  Created by WavingColor on 2017/12/8.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALLayoutMaker.h"
#import "ALAnimationProtocol.h"

@interface ALFineDrewAnimationBaseLabel : UILabel<ALAnimationProtocol>

/**
 * If YES, eash text info will be CALayer instead of redraw
 * default to YES
 */
@property (nonatomic, assign) BOOL layerBased;


/**
 * time for one text attribute to do completion animation
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 * start time offset for each group
 */
@property (nonatomic, assign) CGFloat animationDelay;


/**
 * If NO, disappear animation will start with the head of string
 * default NO
 */
@property (nonatomic, assign) BOOL appearTail;


/**
 * duration for the label to finish animation on screen
 */
@property (nonatomic, readonly) CGFloat totoalAnimationDuration;

/**
 * animatingAppear = NO means it's in animate disappear mode
 */
@property (nonatomic, readonly) BOOL animatingAppear;

@property (nonatomic, readonly) ALLayoutMaker *layoutTool;




/**
 * Custom animation to the layer of each TextBlock
 * Only used when layerBased is set to YES
 */
- (void) appearStateLayerAnimationForTextInfo: (ALTextInfo *) textInfo;




@end
