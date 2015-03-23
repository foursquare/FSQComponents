//
//  ContentModel.h
//  iOS Example
//
//  Created by Cameron Mulhern on 3/4/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentModel : NSObject

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *message;

@property (nonatomic, readonly) UIImage *image;

- (instancetype)initWithName:(NSString *)name message:(NSString *)message image:(UIImage *)image;

@end
