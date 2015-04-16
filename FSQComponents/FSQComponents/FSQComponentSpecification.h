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
 *  The width in points that the component should be given. If layoutType is
 *  FSQComponentLayoutTypeFlexible this is treated as a minimum width. If
 *  layoutType is FSQComponentLayoutTypeFixed this is treated as the absolute
 *  width.
 */
@property (nonatomic) CGFloat widthConstraint;

/**
 *  The width the component should be given as a percent of the total width of
 *  the containing view. If layoutType is FSQComponentLayoutTypeFlexible this is
 *  treated as a minimum width. If layoutType is FSQComponentLayoutTypeFixed
 *  this is treated as the absolute width.
 *
 *  @note Only checked if widthConstraint is 0.0.
 */
@property (nonatomic) CGFloat widthPercentConstraint;

- (instancetype)initWithViewModel:(id)viewModel viewClass:(Class)viewClass;
- (instancetype)initWithViewModel:(id)viewModel viewClass:(Class)viewClass insets:(UIEdgeInsets)insets NS_DESIGNATED_INITIALIZER;

@end
