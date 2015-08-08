//
//  KeyboardManOC.h
//  gzucm_tianjie
//
//  Created by jtian on 8/7/15.
//  Copyright (c) 2015 gzucm_tianjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KeyboardAction) {
    KeyboardActionNotSupport = 99,
    KeyboardActionShow,
    KeyboardActionHide
};

struct KeyboardInfo {
    NSTimeInterval animationDuration;
    NSUInteger animationCurve;
    CGRect frameBegin;
    CGRect frameEnd;
    CGFloat heightIncrement;
    enum KeyboardAction action;
    BOOL isSameAction;
};
typedef struct KeyboardInfo KeyboardInfo;

@class KeyboardManOC;

typedef void (^animateWhenKeyboardAppear)(NSInteger appearPostIndex, CGFloat keyboardHeight, CGFloat keyboardHeightIncrement);
typedef void (^animateWhenKeyboardDisappear)(CGFloat keyboardHeight);
typedef void (^postKeyboardInfo)(KeyboardManOC *keyboardMan, KeyboardInfo keyboardInfo);

@interface KeyboardManOC : NSObject

@property (nonatomic, assign) BOOL keyboardObserveEnabled;
@property (nonatomic, assign) NSInteger appearPostIndex;
@property (nonatomic, copy) animateWhenKeyboardAppear animateWhenKeyboardAppear;
@property (nonatomic, copy) animateWhenKeyboardDisappear animateWhenKeyboardDisappear;
@property (nonatomic, copy) postKeyboardInfo postKeyboardInfo;

@end
