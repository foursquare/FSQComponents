//
//  ComponentPhotoView.h
//  iOS Example
//
//  Created by Cameron Mulhern on 3/4/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSQComposable.h"

@class ComponentPhotoView;

@interface ComponentPhotoViewModel : NSObject

@property (nonatomic, readonly) UIImage *image;

@property (nonatomic, copy) void (^photoSelectedBlock)(ComponentPhotoView *view);

- (instancetype)initWithImage:(UIImage *)image;

@end

@interface ComponentPhotoView : UIView <FSQComposable>

- (void)configureWithViewModel:(ComponentPhotoViewModel *)model;

+ (CGSize)sizeForViewModel:(ComponentPhotoViewModel *)model constrainedToSize:(CGSize)constrainedToSize;
+ (CGSize)estimatedSizeForViewModel:(ComponentPhotoViewModel *)model constrainedToSize:(CGSize)constrainedToSize;

@end
