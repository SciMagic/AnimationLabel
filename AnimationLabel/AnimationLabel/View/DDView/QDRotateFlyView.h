//
//  QDRotateFlyView.h
//  AnimationLabel
//
//  Created by QD on 2017/12/1.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QDRotateFlyView : UIView

@property (nonatomic, strong) NSAttributedString *attibutedString;
+ (CGSize)getSizeWithAttibutedString:(NSAttributedString *)attibutedString;

@end
