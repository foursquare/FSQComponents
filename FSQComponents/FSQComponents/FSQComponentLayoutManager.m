//
//  FSQComponentLayoutManager.m
//  FSQComponents
//
//  Created by Cameron Mulhern on 3/20/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import "FSQComponentLayoutManager.h"

#import "FSQComponentsView.h"
#import "FSQComponentSizing.h"

static const CGFloat kStandardPadding = 10.0;

@implementation FSQComponentLayoutManager

+ (UIEdgeInsets)smartAdjustedInsetsForViewModel:(FSQComponentsViewModel *)model insets:(UIEdgeInsets)insets isTopEdge:(BOOL)isTopEdge isLeftEdge:(BOOL)isLeftEdge isBottomEdge:(BOOL)isBottomEdge isRightEdge:(BOOL)isRightEdge {
    CGFloat top = [self smartAdjustedTopInsetForViewModel:model insets:insets isEdgeElement:isTopEdge];
    CGFloat left = [self smartAdjustedLeftInsetForViewModel:model insets:insets isEdgeElement:isLeftEdge];
    CGFloat bottom = [self smartAdjustedBottomInsetForViewModel:model insets:insets isEdgeElement:isBottomEdge];
    CGFloat right = [self smartAdjustedRightInsetForViewModel:model insets:insets isEdgeElement:isRightEdge];
    return UIEdgeInsetsMake(top, left, bottom, right);
}

+ (CGFloat)smartAdjustedInsetForViewModel:(FSQComponentsViewModel *)model inset:(CGFloat)inset smartInset:(CGFloat)smartInset isEdgeElement:(BOOL)isEdgeElement {
    if (inset == smartInset) {
        CGFloat edgePadding = (model.smartInsetsAppliesToEdges) ? kStandardPadding : 0.0;
        inset = (isEdgeElement) ? edgePadding : kStandardPadding / 2.0;
    }
    return inset;
}

+ (CGFloat)smartAdjustedTopInsetForViewModel:(FSQComponentsViewModel *)model insets:(UIEdgeInsets)insets isEdgeElement:(BOOL)isEdgeElement {
    return [self smartAdjustedInsetForViewModel:model inset:insets.top smartInset:kFSQComponentSmartInsets.top isEdgeElement:isEdgeElement];
}

+ (CGFloat)smartAdjustedLeftInsetForViewModel:(FSQComponentsViewModel *)model insets:(UIEdgeInsets)insets isEdgeElement:(BOOL)isEdgeElement {
    return [self smartAdjustedInsetForViewModel:model inset:insets.left smartInset:kFSQComponentSmartInsets.left isEdgeElement:isEdgeElement];
}

+ (CGFloat)smartAdjustedBottomInsetForViewModel:(FSQComponentsViewModel *)model insets:(UIEdgeInsets)insets isEdgeElement:(BOOL)isEdgeElement {
    return [self smartAdjustedInsetForViewModel:model inset:insets.bottom smartInset:kFSQComponentSmartInsets.bottom isEdgeElement:isEdgeElement];
}

+ (CGFloat)smartAdjustedRightInsetForViewModel:(FSQComponentsViewModel *)model insets:(UIEdgeInsets)insets isEdgeElement:(BOOL)isEdgeElement {
    return [self smartAdjustedInsetForViewModel:model inset:insets.right smartInset:kFSQComponentSmartInsets.right isEdgeElement:isEdgeElement];
}

+ (CGFloat)layoutWidthForSpecification:(FSQComponentSpecification *)specification width:(CGFloat)width {
    CGFloat requiredSpace = 0.0;
    switch (specification.layoutType) {
        case FSQComponentLayoutTypeFull:
            requiredSpace = width;
            break;
        case FSQComponentLayoutTypeFlexible:
        case FSQComponentLayoutTypeFixed:
            requiredSpace = (specification.widthConstraint != 0.0) ? specification.widthConstraint : fsq_componentPixelRound(specification.widthPercentConstraint * width);
            break;
        case FSQComponentLayoutTypeDynamic:
            requiredSpace = [specification.viewClass sizeForViewModel:specification.viewModel constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)].width;
    }
    return MIN(requiredSpace, width);
}

+ (NSArray *)componentLayoutInfoForViewModel:(FSQComponentsViewModel *)model width:(CGFloat)width {
    return [self componentLayoutInfoForViewModel:model width:width layoutBlock:^CGSize (FSQComponentSpecification *specification, CGFloat layoutWidth) {
        return [specification.viewClass sizeForViewModel:specification.viewModel constrainedToSize:CGSizeMake(layoutWidth, CGFLOAT_MAX)];
    }];
}

+ (NSArray *)componentLayoutInfoForLineWithViewModel:(FSQComponentsViewModel *)model
                                      specifications:(NSArray *)specifications
                                               width:(CGFloat)width top:(CGFloat)top
                                           isTopLine:(BOOL)isTopLine
                                        isBottomLine:(BOOL)isBottomLine
                                         layoutBlock:(CGSize (^)(FSQComponentSpecification *specification, CGFloat width))layoutBlock {
    
    CGFloat requiredWidths[specifications.count];
    
    CGFloat remainingWidth = width;
    NSInteger numberOfFlexibleItems = 0;
    CGFloat totalGrowthFactor = 0.0;
    
    for (NSInteger i = 0; i < specifications.count; ++i) {
        FSQComponentSpecification *specification = specifications[i];
        
        CGFloat leftInset = [self smartAdjustedLeftInsetForViewModel:model insets:specification.insets isEdgeElement:(i == 0)];
        CGFloat rightInset = [self smartAdjustedRightInsetForViewModel:model insets:specification.insets isEdgeElement:(i == specifications.count - 1)];
        
        requiredWidths[i] = [self layoutWidthForSpecification:specification width:width] + leftInset + rightInset;
        remainingWidth -= requiredWidths[i];
        
        if (specification.layoutType == FSQComponentLayoutTypeFlexible) {
            numberOfFlexibleItems++;
            totalGrowthFactor += specification.growthFactor;
        }
    }
    
    CGFloat widthPerGrowthFactor = (numberOfFlexibleItems > 0) ? fsq_componentPixelFloor(remainingWidth / totalGrowthFactor) : 0.0;
    if (widthPerGrowthFactor > 0.0) {
        CGFloat allocatedWidth = 0.0;
        for (NSInteger i = 0; i < specifications.count; ++i) {
            FSQComponentSpecification *specification = specifications[i];
            if (specification.layoutType == FSQComponentLayoutTypeFlexible) {
                CGFloat growthWidth = fsq_componentPixelFloor(widthPerGrowthFactor * specification.growthFactor);
                requiredWidths[i] += (numberOfFlexibleItems == 1) ? remainingWidth - allocatedWidth : growthWidth;
                allocatedWidth += growthWidth;
                numberOfFlexibleItems--;
            }
        }
    }
    
    FSQComponentLayoutInfo infos[specifications.count];
    
    CGFloat xOrigin = 0.0;
    CGFloat lineHeight = 0.0;
    for (NSInteger i = 0; i < specifications.count; ++i) {
        FSQComponentSpecification *specification = specifications[i];
        UIEdgeInsets insets = [self smartAdjustedInsetsForViewModel:model insets:specification.insets isTopEdge:isTopLine isLeftEdge:(i == 0) isBottomEdge:isBottomLine isRightEdge:(i == specifications.count - 1)];
        
        CGFloat layoutWidth = requiredWidths[i] - insets.left - insets.right;
        CGFloat height = layoutBlock(specification, layoutWidth).height;
        CGRect frame = CGRectMake(xOrigin + insets.left, top + insets.top, layoutWidth, height);
        xOrigin = CGRectGetMaxX(frame) + insets.right;
        lineHeight = MAX(lineHeight, frame.size.height);
        
        infos[i] = FSQComponentLayoutInfoMake(frame, insets);
    }
    
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < specifications.count; ++i) {
        FSQComponentSpecification *specification = specifications[i];
        
        FSQComponentLayoutInfo *info = &infos[i];
        CGFloat heightDifference = (lineHeight - info->frame.size.height);
        switch (specification.verticalAlignment) {
            case FSQComponentVerticalAlignmentTop:
                // Default
                break;
            case FSQComponentVerticalAlignmentCenter:
                info->frame.origin = CGPointMake(info->frame.origin.x, fsq_componentPixelFloor(info->frame.origin.y + heightDifference / 2.0));
                break;
            case FSQComponentVerticalAlignmentBottom:
                info->frame.origin = CGPointMake(info->frame.origin.x, info->frame.origin.y + heightDifference);
                break;
        }
        
        [frames addObject:[NSValue valueWithBytes:info objCType:@encode(FSQComponentLayoutInfo)]];
    }
    
    return frames;
}

+ (NSArray *)componentLayoutInfoForViewModel:(FSQComponentsViewModel *)model width:(CGFloat)width layoutBlock:(CGSize (^)(FSQComponentSpecification *specification, CGFloat width))layoutBlock {
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    __block CGFloat yOrigin = 0.0;
    __block CGFloat currentWidthAllocated = 0.0;
    
    NSMutableArray *pendingSpecifications = [[NSMutableArray alloc] init];
    
    void (^flushLine)(void) = ^() {
        BOOL isTopLine = (frames.count == 0);
        BOOL isBottomLine = (frames.count + pendingSpecifications.count == model.componentSpecifications.count);
        NSArray *lineFrames = [self componentLayoutInfoForLineWithViewModel:model specifications:pendingSpecifications width:width top:yOrigin isTopLine:isTopLine isBottomLine:isBottomLine layoutBlock:layoutBlock];
        for (NSInteger i = 0; i < lineFrames.count; ++i) {
            FSQComponentLayoutInfo info;
            [lineFrames[i] getValue:&info];
            yOrigin = MAX(yOrigin, CGRectGetMaxY(info.frame) + info.insets.bottom);
        }
        
        [frames addObjectsFromArray:lineFrames];
        [pendingSpecifications removeAllObjects];
        
        currentWidthAllocated = 0.0;
    };
    
    for (NSInteger i = 0; i < model.componentSpecifications.count; ++i) {
        FSQComponentSpecification *specification = model.componentSpecifications[i];
        
        if (specification.startsNewLine && pendingSpecifications.count > 0) {
            flushLine();
        }
        
        switch (specification.layoutType) {
            case FSQComponentLayoutTypeFull: {
                if (pendingSpecifications.count > 0) {
                    flushLine();
                }
                
                BOOL isTopEdge = (i == 0);
                BOOL isBottomEdge = (i == model.componentSpecifications.count - 1);
                
                UIEdgeInsets insets = [self smartAdjustedInsetsForViewModel:model insets:specification.insets isTopEdge:isTopEdge isLeftEdge:YES isBottomEdge:isBottomEdge isRightEdge:YES];
                
                CGFloat widthConstraint = width - insets.left - insets.right;
                CGSize layoutSize = layoutBlock(specification, widthConstraint);
                
                CGFloat width = (specification.layoutType == FSQComponentLayoutTypeFull) ? widthConstraint : layoutSize.width;
                CGFloat height = layoutSize.height;
                
                CGRect frame = CGRectMake(insets.left, yOrigin + insets.top, width, height);
                yOrigin = CGRectGetMaxY(frame) + insets.bottom;
                
                FSQComponentLayoutInfo info = FSQComponentLayoutInfoMake(frame, insets);
                [frames addObject:[NSValue valueWithBytes:&info objCType:@encode(FSQComponentLayoutInfo)]];
                break;
            }
            case FSQComponentLayoutTypeFlexible:
            case FSQComponentLayoutTypeFixed:
            case FSQComponentLayoutTypeDynamic: {
                CGFloat leftInset = [self smartAdjustedLeftInsetForViewModel:model insets:specification.insets isEdgeElement:(pendingSpecifications.count == 0)];
                CGFloat leftEdgeInset = [self smartAdjustedLeftInsetForViewModel:model insets:specification.insets isEdgeElement:YES];
                
                CGFloat rightInset = [self smartAdjustedRightInsetForViewModel:model insets:specification.insets isEdgeElement:NO];
                CGFloat rightEdgeInset = [self smartAdjustedRightInsetForViewModel:model insets:specification.insets isEdgeElement:YES];
                
                CGFloat layoutWidth = [self layoutWidthForSpecification:specification width:width];
                
                if (currentWidthAllocated + layoutWidth + leftInset + rightEdgeInset > width) {
                    flushLine();
                    leftInset = leftEdgeInset;
                }
                
                currentWidthAllocated += layoutWidth + leftInset + rightInset;
                [pendingSpecifications addObject:specification];
                
                if (specification.endsCurrentLine) {
                    flushLine();
                }
                
                break;
            }
        }
    }
    
    if (pendingSpecifications.count > 0) {
        flushLine();
    }
    
    return frames;
}

+ (CGSize)sizeForViewModel:(FSQComponentsViewModel *)model constrainedToSize:(CGSize)constrainedToSize layoutBlock:(CGSize (^)(FSQComponentSpecification *specification, CGFloat width))layoutBlock {
    CGFloat height = 0.0;
    
    NSArray *componentFrames = [self componentLayoutInfoForViewModel:model width:constrainedToSize.width layoutBlock:layoutBlock];
    for (NSInteger i = 0; i < model.componentSpecifications.count; ++i) {
        FSQComponentLayoutInfo info;
        [componentFrames[i] getValue:&info];
        height = MAX(height, CGRectGetMaxY(info.frame) + info.insets.bottom);
    }
    
    return CGSizeMake(constrainedToSize.width, height);
}

+ (CGSize)sizeForViewModel:(FSQComponentsViewModel *)model constrainedToSize:(CGSize)constrainedToSize {
    return [self sizeForViewModel:model constrainedToSize:constrainedToSize layoutBlock:^CGSize (FSQComponentSpecification *specification, CGFloat layoutWidth) {
        return [specification.viewClass sizeForViewModel:specification.viewModel constrainedToSize:CGSizeMake(layoutWidth, CGFLOAT_MAX)];
    }];
}

+ (CGSize)estimatedSizeForViewModel:(FSQComponentsViewModel *)model constrainedToSize:(CGSize)constrainedToSize {
    return [self sizeForViewModel:model constrainedToSize:constrainedToSize layoutBlock:^CGSize (FSQComponentSpecification *specification, CGFloat layoutWidth) {
        return [specification.viewClass estimatedSizeForViewModel:specification.viewModel constrainedToSize:CGSizeMake(layoutWidth, CGFLOAT_MAX)];
    }];
}

@end
