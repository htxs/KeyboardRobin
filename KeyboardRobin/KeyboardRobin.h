//
//  KeyboardRobin.h
//  htxs.me
//
//  Created by jtian on 8/7/15.
//  Copyright (c) 2015 htxs.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KeyboardAction) {
    KeyboardActionShow,
    KeyboardActionHide
};

@interface KeyboardInfo : NSObject

@property (nonatomic, assign, readonly) NSTimeInterval animationDuration;
@property (nonatomic, assign, readonly) NSUInteger animationCurve;
@property (nonatomic, assign, readonly) CGRect frameBegin;
@property (nonatomic, assign, readonly) CGRect frameEnd;
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, assign, readonly) CGFloat heightIncrement;
@property (nonatomic, assign, readonly) KeyboardAction action;
@property (nonatomic, assign, readonly) BOOL isSameAction;

- (instancetype)initWithAnimationDuration:(NSTimeInterval)duration
                           animationCurve:(NSUInteger)curve
                               frameBegin:(CGRect)beginFrame
                                 frameEnd:(CGRect)endFrame
                          heightIncrement:(CGFloat)dtHeight
                                   action:(KeyboardAction)action
                             isSameAction:(BOOL)isSameAtion;

@end

@class KeyboardRobin;

typedef void (^animateWhenKeyboardAppear)(NSInteger appearPostIndex, CGFloat keyboardHeight, CGFloat keyboardHeightIncrement);
typedef void (^animateWhenKeyboardDisappear)(CGFloat keyboardHeight);
typedef void (^postKeyboardInfo)(KeyboardRobin *keyboardRobin, KeyboardInfo *keyboardInfo);

@interface KeyboardRobin : NSObject

@property (nonatomic, assign) BOOL keyboardObserveEnabled;
@property (nonatomic, assign) NSInteger appearPostIndex;
@property (nonatomic, copy) animateWhenKeyboardAppear animateWhenKeyboardAppear;
@property (nonatomic, copy) animateWhenKeyboardDisappear animateWhenKeyboardDisappear;
@property (nonatomic, copy) postKeyboardInfo postKeyboardInfo;

@end
