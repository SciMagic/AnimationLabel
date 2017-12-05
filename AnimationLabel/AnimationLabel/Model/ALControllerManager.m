//
//  ALControllerManager.m
//  AnimationLabel
//
//  Created by QD-ZC on 2017/12/1.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "ALControllerManager.h"
#import "ALCubeTransitionViewController.h"

@implementation ALControllerManager

+ (instancetype)sharedInstance
{
    static ALControllerManager *sharedInstance;
    static dispatch_once_t once_token;
    
    dispatch_once(&once_token, ^{
        
        sharedInstance = [[ALControllerManager alloc] init];
        
    });
    
    return sharedInstance;
}

- (void)controller:(UIViewController *)controller pushto:(NSString *)title
{
    UIViewController *viewController = nil;
    
    if ([title isEqualToString:@"效果1"]) {
        
        viewController = [[ALCubeTransitionViewController alloc] init];
        
    }
    
    
    if (viewController) {
        
        [controller.navigationController pushViewController:viewController animated:YES];
        
    }
    
}

@end
