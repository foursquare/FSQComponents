//
//  FSQComponentsReuseManager.h
//  FSQComponents
//
//  Created by Cameron Mulhern on 3/20/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSQComposable;

@interface FSQComponentReuseManager : NSObject

@property (nonatomic) NSMutableDictionary *classToReusePoolMap;

+ (instancetype)shared;

- (void)addViewToReusePool:(UIView<FSQComposable> *)view;
- (UIView<FSQComposable> *)dequeueViewForClass:(Class)viewClass;

@end
