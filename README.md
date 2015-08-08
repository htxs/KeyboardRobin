#鸣谢

该项目是改写了 @nixzhu 作者的 [KeybaordMan](https://github.com/nixzhu/KeyboardMan) Swift 版本，特此感谢作者 @nixzhu。因为工作需要在 Objective-c 中实现，所以用 Objective-c 重写了一遍，大家各取所需。

# KeyboardManOC

We may need keyboard infomation from keyboard notification to do animation, but the approach is complicated and easy to make mistakes. 

But KeyboardManOC will make it simple & easy.

## Example

```objective-c
#import "KeyboardManOC.h"
```

Do animation with keyboard appear/disappear:

```objective-c
self.keyboardMan = [[KeyboardManOC alloc] init];
__weak typeof (self) weak_self = self;
self.keyboardMan.animateWhenKeyboardAppear = ^(NSInteger appearPostIndex, CGFloat keyboardHeight, CGFloat keyboardHeightIncrement) {
    NSLog(@"Keyboard appear: appearPostIndex:%@, keyboardHeight:%@, keyboardHeightIncrement:%@", @(appearPostIndex), @(keyboardHeight), @(keyboardHeightIncrement));
    CGPoint tempContentOffset = weak_self.tableView.contentOffset;
    tempContentOffset.y += keyboardHeightIncrement;
    weak_self.tableView.contentOffset = tempContentOffset;
    
    UIEdgeInsets tempInset = weak_self.tableView.contentInset;
    tempInset.bottom = keyboardHeight + CGRectGetHeight(weak_self.toolBar.frame);
    weak_self.tableView.contentInset = tempInset;
    
    weak_self.toolBarBottomConstraint.constant = keyboardHeight;
    
    [weak_self.view layoutIfNeeded];
};
self.keyboardMan.animateWhenKeyboardDisappear = ^(CGFloat keyboardHeight) {
    NSLog(@"Keyboard disappear: keyboardHeight:%@", @(keyboardHeight));
    CGPoint tempContentOffset = weak_self.tableView.contentOffset;
    tempContentOffset.y -= keyboardHeight;
    weak_self.tableView.contentOffset = tempContentOffset;
    
    UIEdgeInsets tempInset = weak_self.tableView.contentInset;
    tempInset.bottom = CGRectGetHeight(weak_self.toolBar.frame);
    weak_self.tableView.contentInset = tempInset;
    
    weak_self.toolBarBottomConstraint.constant = 0;
    
    [weak_self.view layoutIfNeeded];
};
```

For more specific information, you can use keyboardInfo that KeyboardManOC post:

```objective-c
self.keyboardMan.postKeyboardInfo = ^(KeyboardManOC *keyboardMan, KeyboardInfo keyboardInfo) {
    // TODO
}
```

Check the demo for more information.

原作者的[中文介绍](https://github.com/nixzhu/dev-blog/blob/master/2015-07-27-keyboard-man.md)。
