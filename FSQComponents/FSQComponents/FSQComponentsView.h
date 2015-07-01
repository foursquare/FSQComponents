//
//  FSQComponentsView.h
//  FSQComponents
//
//  Created by Cameron Mulhern on 1/14/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSQComponentSpecification.h"
#import "FSQComposable.h"

/**
 *  The default edge insets for a component specification. These insets provide
 *  intelligent margin behavior between components based on whether they are on
 *  the edges of the container view.
 *
 *  @note It is possible to only use smart margins for certain insets by either
 *  opting-out by copying this struct and then overriding only the individual
 *  values for the edges you want to set, or by opting-in by setting the the
 *  value of your edge to the same value used in this struct.
 */
extern const UIEdgeInsets kFSQComponentSmartInsets;

/**
 *  FSQComponentsViewModel is the model object used to configure an instance of
 *  FSQComponentsVew.
 */
@interface FSQComponentsViewModel : NSObject

/**
 *  The collection of component specifications that will be used to contruct the
 *  content of the FSQComponentsView. The vertical ordering of the components is
 *  currently controlled by the ordering of this array.
 */
@property (nonatomic, copy, readonly) NSArray *componentSpecifications;

/**
 *  Background color of the container components view.
 */
@property (nonatomic) UIColor *backgroundColor;

/**
 *  Switch that controls if smart insets layout components with smart margins
 *  from the edges of the container components view. The default is YES.
 */
@property (nonatomic) BOOL smartInsetsAppliesToEdges;

/**
 *  Determines if user interaction is enabled for the components view. The 
 *  default is YES.
 */
@property (nonatomic) BOOL userInteractionEnabled;

/**
 *  This string can be used as the reuse identifier if the components view is
 *  being used in a reuse pool as an optimization to minimize modifications to
 *  the view hierarchy.
 *
 *  @note This will be most commonly useful as the reuse identifier for
 *  FSQComponentsCell and FSQComponentsCollectionCell
 */
@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

- (instancetype)initWithComponentSpecifications:(NSArray *)componentSpecifications;
- (instancetype)initWithComponentSpecifications:(NSArray *)componentSpecifications smartInsetsAppliesToEdges:(BOOL)smartInsetsAppliesToEdges NS_DESIGNATED_INITIALIZER;

@end

/**
 *  FSQComponentsView is a container view that composes a collection of content
 *  views and manages their layout.
 *
 *  The view is configured with an instance of FSQComponentsViewModel that
 *  specifies the ordering of the indiviudal components.
 */
@interface FSQComponentsView : UIView <FSQComposable>

/**
 *  This method is responsible for setting up the proper view hierarchy of
 *  components and piping the call through to the individual components with
 *  their paired model.
 *
 *  @param model The view model object used to set up the component.
 *
 *  @note The model object should be the same instance passed to
 *  [FSQComponentsView sizeForViewModel:constrainedToSize:].
 */
- (void)configureWithViewModel:(FSQComponentsViewModel *)model;

/**
 *  This call is propogated to each individual component.
 *
 *  @param highlighted YES to set the view as highlighted, NO to set it as
 *  unhighlighted. The default is NO.
 *
 *  @param animated YES to animate the transition between highlighted states,
 *  NO to make the transition immediate.
 */
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

/**
 *  This call is propogated to each individual component.
 *
 *  @param selected YES to set the view as selected, NO to set it as unselected.
 *  The default is NO.
 *
 *  @param animated YES to animate the transition between selected states, NO to
 *  make the transition immediate.
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

/**
 *  Prepares a the view for reuse if used inside a table view or collection
 *  view.
 */
- (void)prepareForReuse;

/**
 *  This method is responsible for providing the layout height for the view
 *  given the view model and the width constraint.
 *
 *  @param model The view model for the view.
 *  @param width The width of the frame that the view will be provisioned.
 *
 *  @return The height required to layout the view + model pair at the provided
 *  width.
 */
+ (CGSize)sizeForViewModel:(FSQComponentsViewModel *)model constrainedToSize:(CGSize)constrainedToSize;

/**
 *  This method is responsible for providing an estimate of the layout height
 *  for the view given the view model and the width constraint.
 *
 *  @param model The view model for the view.
 *  @param width The width of the frame that the view will be provisioned.
 *
 *  @return The estimated height required to layout the view + model pair at the
 *  provided width.
 */
+ (CGSize)estimatedSizeForViewModel:(FSQComponentsViewModel *)model constrainedToSize:(CGSize)constrainedToSize;

@end
