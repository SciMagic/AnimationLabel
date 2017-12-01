//
//  ALModel.h
//  AnimationLabel
//
//  Created by QD-ZC on 2017/12/1.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALModel : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)fetchData;

@end
