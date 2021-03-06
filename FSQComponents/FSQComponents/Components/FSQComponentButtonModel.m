//
//  FSQComponentButtonModel.m
//  iOS Example
//
//  Created by Cameron Mulhern on 4/14/15.
//  Copyright (c) 2015 Cameron Mulhern. All rights reserved.
//

#import "FSQComponentButtonModel.h"
#import <objc/runtime.h>

static NSArray* allControlStates() {
    static dispatch_once_t predicate;
    static NSArray *controlStates;
    dispatch_once(&predicate, ^() {
        controlStates = @[
            @(UIControlStateNormal),
            @(UIControlStateHighlighted),
            @(UIControlStateDisabled),
            @(UIControlStateSelected),
            @(UIControlStateApplication)
        ];
    });
    return controlStates;
}

static NSArray* allControlEvents() {
    static dispatch_once_t predicate;
    static NSArray *controlEvents;
    dispatch_once(&predicate, ^() {
        controlEvents = @[
            @(UIControlEventTouchDown),
            @(UIControlEventTouchDownRepeat),
            @(UIControlEventTouchDragInside),
            @(UIControlEventTouchDragOutside),
            @(UIControlEventTouchDragEnter),
            @(UIControlEventTouchDragExit),
            @(UIControlEventTouchUpInside),
            @(UIControlEventTouchUpOutside),
            @(UIControlEventTouchCancel),
            @(UIControlEventValueChanged),
            @(UIControlEventEditingDidBegin),
            @(UIControlEventEditingChanged),
            @(UIControlEventEditingDidEnd),
            @(UIControlEventEditingDidEndOnExit),
            @(UIControlEventApplicationReserved)
        ];
    });
    return controlEvents;
}


#pragma mark - FSQComponentButtonModel -

@interface FSQTargetSelectorPair : NSObject

@property (nonatomic, readonly, unsafe_unretained) id target;
@property (nonatomic, readonly) SEL selector;

@end

@implementation FSQTargetSelectorPair

- (instancetype)initWithTarget:(id)target selector:(SEL)selector {
    if ((self = [super init])) {
        _target = target;
        _selector = selector;
    }
    return self;
}

@end

@interface FSQComponentButtonModel ()

@property (nonatomic) NSMutableDictionary *imageDictionary;
@property (nonatomic) NSMutableDictionary *titleDictionary;
@property (nonatomic) NSMutableDictionary *titleColorDictionary;

@property (nonatomic) NSMutableDictionary *actionsDictionary;

@end

@implementation FSQComponentButtonModel

- (instancetype)init {
    return [self initWithImage:nil title:nil titleColor:nil];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor {
    if ((self = [super init])) {
        self.imageDictionary = [[NSMutableDictionary alloc] init];
        self.titleDictionary = [[NSMutableDictionary alloc] init];
        self.titleColorDictionary = [[NSMutableDictionary alloc] init];
        self.actionsDictionary = [[NSMutableDictionary alloc] init];
        
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
    }
    return self;
}

- (void)setObject:(id)object forDictionary:(NSMutableDictionary *)dictionary forState:(UIControlState)state {
    if (object) {
        if (state == 0) {
            dictionary[@(state)] = object;
        }
        else {
            for (NSNumber *controlState in allControlStates()) {
                if ((state & [controlState unsignedIntegerValue]) != 0) {
                    dictionary[controlState] = object;
                }
            }
        }
    }
    else {
        if (state == 0) {
            [dictionary removeObjectForKey:@(state)];
        }
        else {
            for (NSNumber *controlState in allControlStates()) {
                if ((state & [controlState unsignedIntegerValue]) != 0) {
                    [dictionary removeObjectForKey:controlState];
                }
            }
        }
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [self setObject:image forDictionary:self.imageDictionary forState:state];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [self setObject:[title copy] forDictionary:self.titleDictionary forState:state];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    [self setObject:color forDictionary:self.titleColorDictionary forState:state];
}

- (UIImage *)imageForState:(UIControlState)state {
    return self.imageDictionary[@(state)];
}

- (NSString *)titleForState:(UIControlState)state {
    return self.titleDictionary[@(state)];
}

- (UIColor *)titleColorForState:(UIControlState)state {
    return self.titleColorDictionary[@(state)];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    FSQTargetSelectorPair *targetSelector = [[FSQTargetSelectorPair alloc] initWithTarget:target selector:action];
    
    for (NSNumber *controlEvent in allControlEvents()) {
        if ((controlEvents & [controlEvent unsignedIntegerValue]) != 0) {
            NSMutableArray *actions = self.actionsDictionary[controlEvent];
            if (actions == nil) {
                actions = [[NSMutableArray alloc] init];
                self.actionsDictionary[controlEvent] = actions;
            }
            
            [actions addObject:targetSelector];
        }
    }
}

- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    for (NSNumber *controlEvent in allControlEvents()) {
        if ((controlEvents & [controlEvent unsignedIntegerValue]) != 0) {
            NSMutableArray *actions = self.actionsDictionary[@(controlEvents)];
            NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
            
            [actions enumerateObjectsUsingBlock:^(FSQTargetSelectorPair *targetSelector, NSUInteger index, BOOL *stop) {
                if (targetSelector.target == target && (action == NULL || targetSelector.selector == action)) {
                    [indexSet addIndex:index];
                }
            }];
            
            [actions removeObjectsAtIndexes:indexSet];
        }
    }
}

@end

#pragma mark - UIButton (FSQComponentButton) -

@interface UIButton (FSQComponentButtonPrivate)

@property (nonatomic) FSQComponentButtonModel *fsqComponentButtonModel;

@end

@implementation UIButton (FSQComponentButton)

- (void)configureWithViewModel:(FSQComponentButtonModel *)model {
    self.fsqComponentButtonModel = model;
    
    self.titleLabel.font = model.font;
    self.backgroundColor = model.backgroundColor;
    self.layer.cornerRadius = model.cornerRadius;
    self.contentHorizontalAlignment = model.contentHorizontalAlignment;
    self.contentVerticalAlignment = model.contentVerticalAlignment;
    
    [self resetState];
    [self configureStateWithModel:model];
}

- (void)prepareForReuse {
    self.fsqComponentButtonModel = nil;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

#pragma mark - Private

- (void)resetState {
    for (NSNumber *controlState in allControlStates()) {
        UIControlState state = [controlState unsignedIntegerValue];
        [self setImage:nil forState:state];
        [self setTitle:nil forState:state];
        [self setTitleColor:nil forState:state];
    }
    
    [self removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
}

- (void)configureStateWithModel:(FSQComponentButtonModel *)model {
    for (NSNumber *controlState in model.imageDictionary.allKeys) {
        UIControlState state = [controlState unsignedIntegerValue];
        [self setImage:[model imageForState:state] forState:state];
    }
    
    for (NSNumber *controlState in model.titleDictionary.allKeys) {
        UIControlState state = [controlState unsignedIntegerValue];
        [self setTitle:[model titleForState:state] forState:state];
    }
    
    for (NSNumber *controlState in model.titleColorDictionary.allKeys) {
        UIControlState state = [controlState unsignedIntegerValue];
        [self setTitleColor:[model titleColorForState:state] forState:state];
    }
    
    for (NSNumber *controlEvent in model.actionsDictionary.allKeys) {
        UIControlEvents events = [controlEvent unsignedIntegerValue];
        NSArray *actions = model.actionsDictionary[controlEvent];
        for (FSQTargetSelectorPair *targetSelector in actions) {
            [self addTarget:targetSelector.target action:targetSelector.selector forControlEvents:events];
        }
    }
}

- (void)setFsqComponentButtonModel:(FSQComponentButtonModel *)fsqComponentButtonModel {
    return objc_setAssociatedObject(self, @selector(fsqComponentButtonModel), fsqComponentButtonModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (FSQComponentButtonModel *)fsqComponentButtonModel {
    return objc_getAssociatedObject(self, @selector(fsqComponentButtonModel));
}

#pragma mark - Class methods

+ (CGSize)sizeForViewModel:(FSQComponentButtonModel *)model constrainedToSize:(CGSize)constrainedToSize {
    NSAssert([NSThread currentThread].isMainThread, @"expected to be on main thread");
    
    // NOTE: We're using a static cache to keep a copy of button objects instead of using a static button. FSQComponentButton
    // can be subclassed (e.g. BurritoButton). We don't want to run into the situation where buttonForSizing is a
    // static subclassed object and we later want to call configureWithViewModel with a different class (and
    // possibly resulting in a crash since BurritoButton will have different properties to set than FSQComponentButton).
    
    static dispatch_once_t predicate;
    static NSCache *cache;
    dispatch_once(&predicate, ^() {
        cache = [[NSCache alloc] init];
    });
    
    NSString *className = NSStringFromClass([self class]);
    UIButton *buttonForSizing = [cache objectForKey:className];
    if (!buttonForSizing) {
        buttonForSizing = [[self alloc] initWithFrame:CGRectZero];
        [cache setObject:buttonForSizing forKey:className];
    }
    
    [buttonForSizing configureWithViewModel:model];
    
    CGSize size = [buttonForSizing sizeThatFits:constrainedToSize];
    if (model.heightConstraint != 0.0) {
        size.height = model.heightConstraint;
    }
    
    size.width += 2.0 * model.horizontalPadding;
    size.height += 2.0 * model.verticalPadding;
    
    return CGSizeMake(MIN(size.width, constrainedToSize.width), MIN(size.height, constrainedToSize.height));
}

+ (CGSize)estimatedSizeForViewModel:(FSQComponentButtonModel *)model constrainedToSize:(CGSize)constrainedToSize {
    return [self sizeForViewModel:model constrainedToSize:constrainedToSize];
}

@end
