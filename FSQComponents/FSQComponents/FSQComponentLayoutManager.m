//
//  FSQComponentLayoutManager.m
//  FSQComponents
//
//  Created by Cameron Mulhern on 3/20/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import "FSQComponentLayoutManager.h"

#import "FSQComponentsView.h"

static const CGFloat kStandardPadding = 10.0;

@implementation FSQComponentLayoutManager

+ (UIEdgeInsets)smartAdjustedInsetsForViewModel:(FSQComponentsViewModel *)model insets:(UIEdgeInsets)insets isTopEdge:(BOOL)isTopEdge isLeftEdge:(BOOL)isLeftEdge isBottomEdge:(BOOL)isBottomEdge isRightEdge:(BOOL)isRightEdge {
    CGFloat top = [self smartAdjustedTopInsetForViewModel:model insets:insets isEdgeElement:isTopEdge];
    CGFloat left = [self smartAdjustedLeftInsetForViewModel:model insets:insets isEdgeElement:isLeftEdge];
    CGFloat bottom = [self smartAdjustedBottomInsetForViewModel:model insets:insets isEdgeElement:isBottomEdge];
    CGFloat right = [self smartAdjustedRightInsetForViewModel:model insets:insets isEdgeElement:isRightEdge];
    return UIEdgeInsetsMake(top, left, bottom, right);
}

+ (CGFloat)smartAdjustedTopInsetForViewModel:(FSQComponentsViewModel *)model insets:(UIEdgeInsets)insets isEdgeElement:(BOOL)isEdgeElement {
    CGFloat inset = insets.top;
    if (inset == kFSQComponentSmartInsets.top) {
        CGFloat edgePadding = (model.smartInsetsAppliesToEdges) ? kStandardPadding : 0.0;
        inset = (isEdgeElement) ? edgePadding : kStandardPadding / 2.0;
    }
    return inset;
}

+ (CGFloat)smartAdjustedLeftInsetForViewModel:(FSQComponentsViewModel *)model insets:(UIEdgeInsets)insets isEdgeElement:(BOOL)isEdgeElement {
    CGFloat inset = insets.left;
    if (inset == kFSQComponentSmartInsets.left) {
        CGFloat edgePadding = (model.smartInsetsAppliesToEdges) ? kStandardPadding : 0.0;
        inset = (isEdgeElement) ? edgePadding : kStandardPadding / 2.0;
    }
    return inset;
}

+ (CGFloat)smartAdjustedBottomInsetForViewModel:(FSQComponentsViewModel *)model insets:(UIEdgeInsets)insets isEdgeElement:(BOOL)isEdgeElement {
    CGFloat inset = insets.bottom;
    if (inset == kFSQComponentSmartInsets.bottom) {
        CGFloat edgePadding = (model.smartInsetsAppliesToEdges) ? kStandardPadding : 0.0;
        inset = (isEdgeElement) ? edgePadding : kStandardPadding / 2.0;
    }
    return inset;
}

+ (CGFloat)smartAdjustedRightInsetForViewModel:(FSQComponentsViewModel *)model insets:(UIEdgeInsets)insets isEdgeElement:(BOOL)isEdgeElement {
    CGFloat inset = insets.right;
    if (inset == kFSQComponentSmartInsets.right) {
        CGFloat edgePadding = (model.smartInsetsAppliesToEdges) ? kStandardPadding : 0.0;
        inset = (isEdgeElement) ? edgePadding : kStandardPadding / 2.0;
    }
    return inset;
}

+ (CGFloat)layoutWidthForSpecification:(FSQComponentSpecification *)specification width:(CGFloat)width {
    CGFloat requiredSpace = 0.0;
    switch (specification.layoutType) {
        case FSQComponentLayoutTypeFull:
            requiredSpace = width;
            break;
        case FSQComponentLayoutTypeFlexible:
            requiredSpace = ceil(specification.minimumWidthPercent * width);
            break;
        case FSQComponentLayoutTypeFixed:
            requiredSpace = (specification.fixedWidth > 0.0) ? specification.fixedWidth : ceilf(specification.fixedWidthPercent * width);
            break;
    }
    return MIN(requiredSpace, width);
}

+ (NSArray *)componentLayoutInfoForViewModel:(FSQComponentsViewModel *)model width:(CGFloat)width {
    return [self componentLayoutInfoForViewModel:model width:width block:^CGFloat(FSQComponentSpecification *specification, CGFloat width) {
        return [specification.viewClass heightForViewModel:specification.viewModel width:width];
    }];
}

+ (NSArray *)componentLayoutInfoForLineWithViewModel:(FSQComponentsViewModel *)model
                                      specifications:(NSArray *)specifications
                                               width:(CGFloat)width top:(CGFloat)top
                                           isTopLine:(BOOL)isTopLine
                                        isBottomLine:(BOOL)isBottomLine
                                               block:(CGFloat (^)(FSQComponentSpecification *specification, CGFloat width))block {
    
    CGFloat requiredWidths[specifications.count];
    
    CGFloat remainingWidth = width;
    NSInteger numberOfFlexibleItems = 0;
    
    for (NSInteger i = 0; i < specifications.count; ++i) {
        FSQComponentSpecification *specification = specifications[i];
        
        CGFloat leftInset = [self smartAdjustedLeftInsetForViewModel:model insets:specification.insets isEdgeElement:(i == 0)];
        CGFloat rightInset = [self smartAdjustedRightInsetForViewModel:model insets:specification.insets isEdgeElement:(i == specifications.count - 1)];
        
        requiredWidths[i] = [self layoutWidthForSpecification:specification width:width] + leftInset + rightInset;
        remainingWidth -= requiredWidths[i];
        
        if (specification.layoutType == FSQComponentLayoutTypeFlexible) {
            numberOfFlexibleItems++;
        }
    }
    
    CGFloat additionalWidth = (numberOfFlexibleItems > 0) ? floor(remainingWidth / numberOfFlexibleItems) : 0.0;
    if (additionalWidth > 0.0) {
        CGFloat finalWidth = remainingWidth - additionalWidth * (numberOfFlexibleItems - 1);
        for (NSInteger i = 0; i < specifications.count; ++i) {
            FSQComponentSpecification *specification = specifications[i];
            if (specification.layoutType == FSQComponentLayoutTypeFlexible) {
                requiredWidths[i] += (numberOfFlexibleItems == 1) ? finalWidth : additionalWidth;
                numberOfFlexibleItems--;
            }
        }
    }
    
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    CGFloat xOrigin = 0.0;
    for (NSInteger i = 0; i < specifications.count; ++i) {
        FSQComponentSpecification *specification = specifications[i];
        UIEdgeInsets insets = [self smartAdjustedInsetsForViewModel:model insets:specification.insets isTopEdge:isTopLine isLeftEdge:(i == 0) isBottomEdge:isBottomLine isRightEdge:(i == specifications.count - 1)];
        
        CGFloat layoutWidth = requiredWidths[i] - insets.left - insets.right;
        CGFloat height = block(specification, layoutWidth);
        CGRect frame = CGRectMake(xOrigin + insets.left, top + insets.top, layoutWidth, height);
        xOrigin = CGRectGetMaxX(frame) + insets.right;
        
        FSQComponentLayoutInfo info = FSQComponentLayoutInfoMake(frame, insets);
        [frames addObject:[NSValue valueWithBytes:&info objCType:@encode(FSQComponentLayoutInfo)]];
    }
    
    return frames;
}

+ (NSArray *)componentLayoutInfoForViewModel:(FSQComponentsViewModel *)model width:(CGFloat)width block:(CGFloat (^)(FSQComponentSpecification *specification, CGFloat width))block {
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    __block CGFloat yOrigin = 0.0;
    __block CGFloat currentLineWidth = width;
    __block CGFloat lastRightInset = 0.0;
    
    NSMutableArray *pendingSpecifications = [[NSMutableArray alloc] init];
    
    void (^flushLine)(void) = ^() {
        BOOL isTopLine = (frames.count == 0);
        BOOL isBottomLine = (frames.count + pendingSpecifications.count == model.componentSpecifications.count);
        NSArray *lineFrames = [self componentLayoutInfoForLineWithViewModel:model specifications:pendingSpecifications width:width top:yOrigin isTopLine:isTopLine isBottomLine:isBottomLine block:block];
        for (NSInteger i = 0; i < lineFrames.count; ++i) {
            FSQComponentLayoutInfo info;
            [lineFrames[i] getValue:&info];
            yOrigin = MAX(yOrigin, CGRectGetMaxY(info.frame));
        }
        
        [frames addObjectsFromArray:lineFrames];
        [pendingSpecifications removeAllObjects];
        
        currentLineWidth = width;
        lastRightInset = 0.0;
    };
    
    for (NSInteger i = 0; i < model.componentSpecifications.count; ++i) {
        FSQComponentSpecification *specification = model.componentSpecifications[i];
        
        switch (specification.layoutType) {
            case FSQComponentLayoutTypeFull: {
                if (pendingSpecifications.count > 0) {
                    flushLine();
                }
                
                BOOL isTopEdge = (i == 0);
                BOOL isBottomEdge = (i == model.componentSpecifications.count - 1);
                
                UIEdgeInsets insets = [self smartAdjustedInsetsForViewModel:model insets:specification.insets isTopEdge:isTopEdge isLeftEdge:YES isBottomEdge:isBottomEdge isRightEdge:YES];
                
                CGFloat layoutWidth = width - insets.left - insets.right;
                CGFloat height = block(specification, layoutWidth);
                CGRect frame = CGRectMake(insets.left, yOrigin + insets.top, layoutWidth, height);
                yOrigin = CGRectGetMaxY(frame) + insets.bottom;
                
                FSQComponentLayoutInfo info = FSQComponentLayoutInfoMake(frame, insets);
                [frames addObject:[NSValue valueWithBytes:&info objCType:@encode(FSQComponentLayoutInfo)]];
                break;
            }
            case FSQComponentLayoutTypeFlexible:
            case FSQComponentLayoutTypeFixed: {
                CGFloat layoutWidth = [self layoutWidthForSpecification:specification width:width];
                
                CGFloat leftInset = [self smartAdjustedLeftInsetForViewModel:model insets:specification.insets isEdgeElement:(pendingSpecifications.count == 0)];
                CGFloat rightEdgeInset = [self smartAdjustedRightInsetForViewModel:model insets:specification.insets isEdgeElement:YES];
                
                if (layoutWidth + leftInset + rightEdgeInset > currentLineWidth) {
                    flushLine();
                }
                
                currentLineWidth -= lastRightInset + leftInset + layoutWidth;
                lastRightInset = [self smartAdjustedRightInsetForViewModel:model insets:specification.insets isEdgeElement:NO];
                [pendingSpecifications addObject:specification];
                break;
            }
        }
    }
    
    if (pendingSpecifications.count > 0) {
        flushLine();
    }
    
    return frames;
}

+ (CGFloat)heightForViewModel:(FSQComponentsViewModel *)model width:(CGFloat)width block:(CGFloat (^)(FSQComponentSpecification *specification, CGFloat width))block {
    CGFloat height = 0.0;
    
    NSArray *componentFrames = [self componentLayoutInfoForViewModel:model width:width block:block];
    for (NSInteger i = 0; i < model.componentSpecifications.count; ++i) {
        FSQComponentLayoutInfo info;
        [componentFrames[i] getValue:&info];
        height = MAX(height, CGRectGetMaxY(info.frame) + info.insets.bottom);
    }
    
    return height;
}

+ (CGFloat)heightForViewModel:(FSQComponentsViewModel *)model width:(CGFloat)width {
    return [self heightForViewModel:model width:width block:^CGFloat (FSQComponentSpecification *specification, CGFloat layoutWidth) {
        return [specification.viewClass heightForViewModel:specification.viewModel width:layoutWidth];
    }];
}

+ (CGFloat)estimatedHeightForViewModel:(FSQComponentsViewModel *)model width:(CGFloat)width {
    return [self heightForViewModel:model width:width block:^CGFloat (FSQComponentSpecification *specification, CGFloat layoutWidth) {
        return [specification.viewClass estimatedHeightForViewModel:specification.viewModel width:layoutWidth];
    }];
}

@end
