//
//  FSQComponentSpecification.h
//  FSQComponents
//
//  Created by Cameron Mulhern on 3/20/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Used to control how a component is laid out.
 */
typedef NS_ENUM(NSUInteger, FSQComponentLayoutType) {
    /**
     *  Specifies that the component should be provided
     *  the full width of the containing view.
     */
    FSQComponentLayoutTypeFull = 0,
    /**
     *  Specifies that the component can share a line
     *  with other components. The minimumWidthPercent property are used to
     *  control the layout of the component.
     */
    FSQComponentLayoutTypeFlexible,
    /**
     *  Specifies that the component can share a line
     *  with other components. The fixedWidth or fixedWidthPercent properties are
     *  used to control the layout of the component.
     */
    FSQComponentLayoutTypeFixed
};

/**
 *  Used to control the vertical alignment of multiple components on a single line.
 */
typedef NS_ENUM(NSUInteger, FSQComponentVerticalAlignment) {
    FSQComponentVerticalAlignmentTop = 0,
    FSQComponentVerticalAlignmentCenter,
    FSQComponentVerticalAlignmentBottom
};

/**
 *  FSQComponentSpecification is the model object that specifies an individual
 *  component in the hierarchy of an FSQComponentsView.
 *
 *  Currently components are laid out vertically and each view is given the
 *  full horizontal width of the containing view. The only control over layout
 *  currently available is the ability to specify the layout margins around the
 *  component.
 */
@interface FSQComponentSpecification : NSObject

/**
 *  The view model for the component. This model object will be passed to the
 *  components metaclass and class instance for height calculation and view
 *  configuration.
 */
@property (nonatomic, readonly) id viewModel;

/**
 *  The view class of the component. Must implement FSQComposable.
 */
@property (nonatomic, readonly) Class viewClass;

/**
 *  The layout margins surrounding the component.
 */
@property (nonatomic) UIEdgeInsets insets;

/**
 *  The type of layout desired for the component.
 */
@property (nonatomic) FSQComponentLayoutType layoutType;

/**
 *  The vertical alignment desired for the component.
 */
@property (nonatomic) FSQComponentVerticalAlignment verticalAlignment;

/**
 *  The width in points that the component should be given, not including
 *  insets. If layoutType is FSQComponentLayoutTypeFlexible this is treated as a
 *  minimum width for the component. If layoutType is
 *  FSQComponentLayoutTypeFixed this is treated as the absolute width.
 */
@property (nonatomic) CGFloat widthConstraint;

/**
 *  The width the component should be given as a percent of the total width of
 *  the containing view, not including insets. If layoutType is
 *  FSQComponentLayoutTypeFlexible this is treated as a minimum width for the
 *  component, including insets. If layoutType is FSQComponentLayoutTypeFixed
 *  this is treated as the absolute width.
 *
 *  @note Only checked if widthConstraint is 0.0.
 */
@property (nonatomic) CGFloat widthPercentConstraint;

/**
 *  This defines the ability for a FSQComponentLayoutTypeFlexible layoutType
 *  item to grow. It accepts a unitless value that serves as a proportion. It
 *  dictates what amount of available line space inside the container the item
 *  should take up.
 *  
 *  If two flexible items live on the same line and have a growthFactor of 1,
 *  they will have equal size inside the container. If you were to give one of
 *  the components a growthFactor of 2, it would take up twice as much space as
 *  the other.
 */
@property (nonatomic) CGFloat growthFactor;

/**
 *  Forces the component to start a new line.
 */
@property (nonatomic) BOOL startsNewLine;

/**
 *  Forces the component to end the current line.
 */
@property (nonatomic) BOOL endsCurrentLine;

- (instancetype)initWithViewModel:(id)viewModel viewClass:(Class)viewClass;
- (instancetype)initWithViewModel:(id)viewModel viewClass:(Class)viewClass insets:(UIEdgeInsets)insets NS_DESIGNATED_INITIALIZER;

@end
