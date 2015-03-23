//
//  ComponentsCell.h
//  iOS Example
//
//  Created by Cameron Mulhern on 1/14/15.
//  Copyright (c) 2015 Cameron Mulhern. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSQComponentsViewModel;

@interface ComponentsCell : UITableViewCell

+ (UIEdgeInsets)paddingInsets;

- (void)configureWithModel:(FSQComponentsViewModel *)model;

+ (CGFloat)heightForModel:(FSQComponentsViewModel *)model width:(CGFloat)width;
+ (CGFloat)estimatedHeightForModel:(FSQComponentsViewModel *)model width:(CGFloat)width;

@end
