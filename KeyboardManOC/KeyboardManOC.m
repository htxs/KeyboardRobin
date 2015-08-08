//
//  KeyboardManOC.m
//  gzucm_tianjie
//
//  Created by jtian on 8/7/15.
//  Copyright (c) 2015 gzucm_tianjie. All rights reserved.
//

#import "KeyboardManOC.h"

@interface KeyboardInfo ()

@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) NSUInteger animationCurve;
@property (nonatomic, assign) CGRect frameBegin;
@property (nonatomic, assign) CGRect frameEnd;
@property (nonatomic, assign) CGFloat heightIncrement;
@property (nonatomic, assign) KeyboardAction action;
@property (nonatomic, assign) BOOL isSameAction;

@end

@implementation KeyboardInfo

- (instancetype)initWithAnimationDuration:(NSTimeInterval)duration
                           animationCurve:(NSUInteger)curve
                               frameBegin:(CGRect)beginFrame
                                 frameEnd:(CGRect)endFrame
                          heightIncrement:(CGFloat)dtHeight
                                   action:(KeyboardAction)action
                             isSameAction:(BOOL)isSameAtion {
    if (self = [super init]) {
        _animationDuration = duration;
        _animationCurve = curve;
        _frameBegin = beginFrame;
        _frameEnd = endFrame;
        _heightIncrement = dtHeight;
        _action = action;
        _isSameAction = isSameAtion;
    }
    return self;
}

- (instancetype)init {
    return [self initWithAnimationDuration:0.0f
                            animationCurve:0
                                frameBegin:CGRectZero
                                  frameEnd:CGRectZero
                           heightIncrement:0
                                    action:KeyboardActionHide
                              isSameAction:YES];
}

#pragma mark - Getter
- (CGFloat)height {
    return self.frameEnd.size.height;
}

@end

@interface KeyboardManOC ()

@property (nonatomic, strong) NSNotificationCenter *keyboardObserver;
@property (nonatomic, strong) KeyboardInfo *keyboardInfo;

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

- (void)setKeyboardInfo:(KeyboardInfo *)info {
    _keyboardInfo = info;
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        return;
    }
    if ((!info.isSameAction || info.heightIncrement != 0)) {
        NSTimeInterval duration = info.animationDuration;
        NSUInteger curve = info.animationCurve;
        UIViewAnimationOptions options = curve << 16 | UIViewAnimationOptionBeginFromCurrentState;
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            switch (info.action) {
                case KeyboardActionShow:
                    if (self.animateWhenKeyboardAppear) {
                        self.animateWhenKeyboardAppear(self.appearPostIndex, info.height, info.heightIncrement);
                    }
                    self.appearPostIndex++;
                    break;
                case KeyboardActionHide:
                    if (self.animateWhenKeyboardDisappear) {
                        self.animateWhenKeyboardDisappear(info.height);
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
    if (self.keyboardInfo) {
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
    self.keyboardInfo = nil;
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
        CGFloat previousHeight = self.keyboardInfo.height ?: 0;
        CGFloat heightIncrement = currentHeight - previousHeight;
        
        BOOL isSameAction;
        if (self.keyboardInfo) {
            isSameAction = action == self.keyboardInfo.action;
        }
        else {
            isSameAction = NO;
        }
        self.keyboardInfo = [[KeyboardInfo alloc] initWithAnimationDuration:animationDuration
                                                             animationCurve:animationCurve
                                                                 frameBegin:frameBegin
                                                                   frameEnd:frameEnd
                                                            heightIncrement:heightIncrement
                                                                     action:action
                                                               isSameAction:isSameAction];
    }
}

@end
