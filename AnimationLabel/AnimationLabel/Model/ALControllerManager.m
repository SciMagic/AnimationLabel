//
//  ALControllerManager.m
//  AnimationLabel
//
//  Created by QD-ZC on 2017/12/1.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "ALControllerManager.h"
#import "ALCubeTransitionViewController.h"
#import "QDDDAnimationTextViewController.h"
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
        
    }else if ([title isEqualToString:@"效果11_DD"] || [title isEqualToString:@"效果1_DD"]){
        
        viewController = [[QDDDAnimationTextViewController alloc] init];
        viewController.title = title;
        
    }
    
    if (viewController) {
        
        [controller.navigationController pushViewController:viewController animated:YES];
        
    }
    
}

@end
