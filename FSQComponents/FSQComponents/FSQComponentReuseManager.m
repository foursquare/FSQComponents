//
//  FSQComponentsReuseManager.m
//  FSQComponents
//
//  Created by Cameron Mulhern on 3/20/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import "FSQComponentReuseManager.h"

#import "FSQComposable.h"

static const CGFloat kReusePoolViewTypeLimit = 10;
static const CGFloat kReusePoolCountPerViewLimit = 10;

@interface FSQComponentReuseManager ()

@property (nonatomic) NSCache *classToReusePoolMap;

@end

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
        self.classToReusePoolMap = [[NSCache alloc] init];
        self.classToReusePoolMap.countLimit = kReusePoolViewTypeLimit;
    }
    return self;
}

- (void)didReceiveMemoryWarning:(NSNotification *)notification {
    [self.classToReusePoolMap removeAllObjects];
}

- (void)addViewToReusePool:(UIView<FSQComposable> *)view {
    dispatch_async(dispatch_get_main_queue(), ^() {
        NSString *identifier = NSStringFromClass([view class]);
        NSMutableSet *reusePool = [self.classToReusePoolMap objectForKey:identifier];
        if (!reusePool) {
            reusePool = [[NSMutableSet alloc] initWithCapacity:kReusePoolCountPerViewLimit];
            [self.classToReusePoolMap setObject:reusePool forKey:identifier];
        }
        
        if (reusePool.count < kReusePoolCountPerViewLimit) {
            [reusePool addObject:view];
        }
    });
}

- (UIView<FSQComposable> *)dequeueViewForClass:(Class)viewClass {
    NSString *identifier = NSStringFromClass(viewClass);
    NSMutableSet *reusePool = [self.classToReusePoolMap objectForKey:identifier];
    
    UIView<FSQComposable> *view;
    if (reusePool.count > 0) {
        view = [reusePool anyObject];
        [reusePool removeObject:view];
        [view prepareForReuse];
    }
    else {
        view = [[viewClass alloc] initWithFrame:CGRectZero];
    }
    
    return view;
}

@end
