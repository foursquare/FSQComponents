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

+ (CGFloat)heightForViewModel:(ComponentPhotoViewModel *)model width:(CGFloat)width;
+ (CGFloat)estimatedHeightForViewModel:(ComponentPhotoViewModel *)model width:(CGFloat)width;

@end
