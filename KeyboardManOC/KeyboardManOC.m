//
//  KeyboardManOC.m
//  gzucm_tianjie
//
//  Created by jtian on 8/7/15.
//  Copyright (c) 2015 gzucm_tianjie. All rights reserved.
//

#import "KeyboardManOC.h"

//判断KeyboardInfo是否有效；当action == KeyboardActionNotSupport时，无效
static BOOL KeyboardInfoIsValid (KeyboardInfo keyboardInfo) {
    if (keyboardInfo.action == KeyboardActionNotSupport) {
        return NO;
    }
    return YES;
}

@interface KeyboardManOC ()

@property (nonatomic, strong) NSNotificationCenter *keyboardObserver;
@property (nonatomic) KeyboardInfo keyboardInfo;

@end

@implementation KeyboardManOC

- (void)dealloc {
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setter
- (void)setKeyboardObserveEnabled:(BOOL)keyboardObserveEnabled {
    if (keyboardObserveEnabled != _keyboardObserveEnabled) {
        self.keyboardObserver = keyboardObserveEnabled ? [NSNotificationCenter defaultCenter] : nil;
    }
}

- (void)setAnimateWhenKeyboardAppear:(animateWhenKeyboardAppear)animateWhenKeyboardAppear {
    _animateWhenKeyboardAppear = [animateWhenKeyboardAppear copy];
    self.keyboardObserveEnabled = YES;
}

- (void)setAnimateWhenKeyboardDisappear:(animateWhenKeyboardDisappear)animateWhenKeyboardDisappear {
    _animateWhenKeyboardDisappear = [animateWhenKeyboardDisappear copy];
    self.keyboardObserveEnabled = YES;
}

- (void)setPostKeyboardInfo:(postKeyboardInfo)postKeyboardInfo {
    _postKeyboardInfo = [postKeyboardInfo copy];
    self.keyboardObserveEnabled = YES;
}

- (void)setKeyboardObserver:(NSNotificationCenter *)keyboardObserver {
    [_keyboardObserver removeObserver:self];
    _keyboardObserver = keyboardObserver;
    [_keyboardObserver addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [_keyboardObserver addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [_keyboardObserver addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [_keyboardObserver addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)setKeyboardInfo:(KeyboardInfo)info {
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        return;
    }
    if (KeyboardInfoIsValid(self.keyboardInfo) && (!info.isSameAction || info.heightIncrement != 0)) {
        NSTimeInterval duration = info.animationDuration;
        NSUInteger curve = info.animationCurve;
        UIViewAnimationOptions options = curve << 16 | UIViewAnimationOptionBeginFromCurrentState;
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            switch (info.action) {
                case KeyboardActionShow:
                    if (self.animateWhenKeyboardAppear) {
                        self.animateWhenKeyboardAppear(self.appearPostIndex, info.frameEnd.size.height, info.heightIncrement);
                    }
                    self.appearPostIndex++;
                    break;
                case KeyboardActionHide:
                    if (self.animateWhenKeyboardDisappear) {
                        self.animateWhenKeyboardDisappear(info.frameEnd.size.height);
                    }
                    self.appearPostIndex = 0;
                    break;
                default:
                    break;
            }
        } completion:nil];
        if (self.postKeyboardInfo) {
            self.postKeyboardInfo(self, info);
        }
    }
}

#pragma mark - NSNotification
- (void)keyboardWillShow:(NSNotification *)notification {
    [self handleKeyboard:notification action:KeyboardActionShow];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    if (KeyboardInfoIsValid(self.keyboardInfo)) {
        if (self.keyboardInfo.action == KeyboardActionShow) {
            [self handleKeyboard:notification action:KeyboardActionShow];
        }
    }
    else {
        [self handleKeyboard:notification action:KeyboardActionShow];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self handleKeyboard:notification action:KeyboardActionHide];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    NSTimeInterval animationDuration = 0;
    NSUInteger animationCurve = 0;
    CGRect frameBegin = CGRectZero;
    CGRect frameEnd = CGRectZero;
    CGFloat heightIncrement = 0;
    KeyboardAction action = KeyboardActionNotSupport;
    BOOL isSameAction = YES;
    //OC中的结构体的初始化，存在疑惑
    self.keyboardInfo = (KeyboardInfo) {
        animationDuration = animationDuration,
        animationCurve = animationCurve,
        frameBegin = frameBegin,
        frameEnd = frameEnd,
        heightIncrement = heightIncrement,
        action = action,
        isSameAction = isSameAction
    };
}

#pragma mark - Actions
- (void)handleKeyboard:(NSNotification *)notification action:(KeyboardAction)action {
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo) {
        NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        NSUInteger animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
        CGRect frameBegin = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect frameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        CGFloat currentHeight = frameEnd.size.height;
        CGFloat previousHeight = self.keyboardInfo.frameEnd.size.height ?: 0;
        CGFloat heightIncrement = currentHeight - previousHeight;
        
        BOOL isSameAction;
        if (self.keyboardInfo.action) {
            isSameAction = action == self.keyboardInfo.action;
        }
        else {
            isSameAction = NO;
        }
        //OC中的结构体的初始化，存在疑惑
        self.keyboardInfo = (KeyboardInfo) {
            animationDuration = animationDuration,
            animationCurve = animationCurve,
            frameBegin = frameBegin,
            frameEnd = frameEnd,
            heightIncrement = heightIncrement,
            action = action,
            isSameAction = isSameAction
        };
    }
}

@end
