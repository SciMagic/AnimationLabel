//
//  CBJStrokeLabel.h
//  Art font Demo
//
//  Created by 超八机 on 2017/9/2.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBJStrokeLabel : UILabel

@property (strong, nonatomic) UIColor *outlineColor;
@property (assign, nonatomic) CGFloat outlineWidth;
@property (assign, nonatomic) CGFloat outlineScale;

@property (strong, nonatomic) UIColor *glowColor;
@property (assign, nonatomic) CGFloat glowSize;

- (NSAttributedString *)composeAttributeString:(NSAttributedString *)attributeString withColorArray:(NSArray<UIColor *> *)colorArray;
@end
