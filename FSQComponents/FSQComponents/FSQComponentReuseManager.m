//
//  FSQComponentsReuseManager.m
//  FSQComponents
//
//  Created by Cameron Mulhern on 3/20/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import "FSQComponentReuseManager.h"

static const CGFloat kReusePoolLimit = 10;

@implementation FSQComponentReuseManager

+ (instancetype)shared {
    static dispatch_once_t predicate;
    static FSQComponentReuseManager *instance;
    dispatch_once(&predicate, ^() {
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if ((self = [super init])) {
        self.classToReusePoolMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addViewToReusePool:(UIView<FSQComposable> *)view {
    NSString *identifier = NSStringFromClass([view class]);
    NSMutableSet *reusePool = self.classToReusePoolMap[identifier];
    if (!reusePool) {
        reusePool = [[NSMutableSet alloc] initWithCapacity:kReusePoolLimit];
        self.classToReusePoolMap[identifier] = reusePool;
    }
    
    if (reusePool.count < kReusePoolLimit) {
        [reusePool addObject:view];
    }
}

- (UIView<FSQComposable> *)dequeueViewForClass:(Class)viewClass {
    NSMutableSet *reusePool = self.classToReusePoolMap[NSStringFromClass(viewClass)];
    
    UIView<FSQComposable> *view;
    if (reusePool.count > 0) {
        view = [reusePool anyObject];
        [reusePool removeObject:view];
    }
    else {
        view = [[viewClass alloc] initWithFrame:CGRectZero];
    }
    
    return view;
}

@end
