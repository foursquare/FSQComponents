//
//  ContentModel.m
//  iOS Example
//
//  Created by Cameron Mulhern on 3/4/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import "ContentModel.h"

@implementation ContentModel

- (instancetype)initWithName:(NSString *)name message:(NSString *)message image:(UIImage *)image {
    if ((self = [super init])) {
        _name = [name copy];
        _message = [message copy];
        _image = image;
    }
    return self;
}

@end
