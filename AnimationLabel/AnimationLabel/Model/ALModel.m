//
//  ALModel.m
//  AnimationLabel
//
//  Created by QD-ZC on 2017/12/1.
//  Copyright © 2017年 Hacky. All rights reserved.
//

#import "ALModel.h"

@interface ALModel ()

@property (strong, nonatomic) NSArray *data;

@end


@implementation ALModel

+ (instancetype)sharedInstance
{
    static ALModel *sharedInstance;
    static dispatch_once_t once_token;
    
    dispatch_once(&once_token, ^{
        
        sharedInstance = [[ALModel alloc] init];
        
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self commonInit];
        
    }
    
    return self;
    
}

- (void)commonInit
{
    _data = @[@"效果1",@"效果2",@"效果3",@"效果11_DD",@"效果1_DD"];
}

- (NSArray *)fetchData
{
    return _data;
}

@end
