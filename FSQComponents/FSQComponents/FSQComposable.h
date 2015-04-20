//
//  FSQComposable.h
//  FSQComponents
//
//  Created by Cameron Mulhern on 3/20/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  FSQComposable is the protocol that an individual component view of
 *  FSQComponentsView must implement to be compatible.
 */
@protocol FSQComposable <NSObject>

/**
 *  This initializer will be used to create an instance of the component view
 *  if there is not one available from the reuse pool.
 *
 *  @param frame The initial frame of the view.
 *
 *  @return An instance of the component view.
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  This method is responsible for setting up the component view using the view
 *  model object paired with the view in the it's FSQComponentSpecification.
 *
 *  @param model The view model object used to set up the component.
 *
 *  @note The model object will be the same instance passed to
 *  [FSQComposable sizeForViewModel:width:].
 */
- (void)configureWithViewModel:(id)model;

/**
 *  This method is responsible for providing the layout size for the component
 *  given the view model and the size constraints. The components architechture
 *  will always provide a valid width constraint. CGFLOAT_MAX is provided if
 *  there is no constraint.
 *
 *  @param model The view model for the component.
 *  @param constrainedToSize The maximum size of the frame that the view can be
 *  allotted.
 *
 *  @return The size required to layout the view + model pair with the provided
 *  constraints.
 */
+ (CGSize)sizeForViewModel:(id)model constrainedToSize:(CGSize)constrainedToSize;

/**
 *  This method is responsible for providing an estimate of the layout size
 *  for the component given the view model and the size constraints. The
 *  components architechture will always provide a valid width constraint.
 *  CGFLOAT_MAX is provided if there is no constraint.
 *
 *  @param model The view model for the component.
 *  @param constrainedToSize The maximum size of the frame that the view can be
 *  allotted.
 *
 *  @return The estimated size required to layout the view + model with the
 *  provided constraints.
 *
 *  @note This method should avoid doing any expensive computation. It is used
 *  as an optimization to provide an estimation of the necessary layout height.
 */
+ (CGSize)estimatedSizeForViewModel:(id)model constrainedToSize:(CGSize)constrainedToSize;

/**
 *  Prepares a reusable component for reuse by FSQComponentsView.
 *
 *  @note For performance reasons, you should only reset attributes of the view
 *  that are not related to content, for example, alpha, editing, and selection
 *  state. The component's configureWithViewModel: should always reset all
 *  content.
 */
- (void)prepareForReuse;

/**
 *  If setHighlighted:animated: is called on an instance of FSQComponentsView,
 *  the call is propogated to each individual component.
 *
 *  @param highlighted YES to set the view as highlighted, NO to set it as
 *  unhighlighted. The default is NO.
 *
 *  @param animated YES to animate the transition between highlighted states,
 *  NO to make the transition immediate.
 */
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

/**
 *  If setSelected:animated: is called on an instance of FSQComponentsView, the
 *  call is propogated to each individual component.
 *
 *  @param selected YES to set the view as selected, NO to set it as unselected.
 *  The default is NO.
 *
 *  @param animated YES to animate the transition between selected states, NO to
 *  make the transition immediate.
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
