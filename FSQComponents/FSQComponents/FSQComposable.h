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
 *  [FSQComposable heightForViewModel:width:].
 */
- (void)configureWithViewModel:(id)model;

/**
 *  This method is responsible for providing the layout height for the component
 *  given the view model and the width constraint.
 *
 *  @param model The view model for the component.
 *  @param width The width of the frame that the view will be provisioned.
 *
 *  @return The height required to layout the view + model pair at the provided
 *  width.
 */
+ (CGFloat)heightForViewModel:(id)model width:(CGFloat)width;

/**
 *  This method is responsible for providing an estimate of the layout height
 *  for the component given the view model and the width constraint.
 *
 *  @param model The view model for the component.
 *  @param width The width of the frame that the view will be provisioned.
 *
 *  @return The estimated height required to layout the view + model at the
 *  provided width.
 *
 *  @note This method should avoid doing any expensive computation. It is used
 *  as an optimization to provide an estimation of the necessary layout height.
 */
+ (CGFloat)estimatedHeightForViewModel:(id)model width:(CGFloat)width;

/**
 *  If prepareForReuse is called on an instance of FSQComponentsView, the call
 *  is propogated to each individual component. Individual component views are
 *  placed in a reuse pool and this method should be used to prepare them for
 *  reuse.
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
