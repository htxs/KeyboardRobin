<p>
    <a href="http://cocoadocs.org/docsets/KeyboardRobin"><img src="https://img.shields.io/cocoapods/v/KeyboardRobin.svg?style=flat"></a> 
</p>

#鸣谢

该项目是改写了 @nixzhu 作者的 [KeybaordMan](https://github.com/nixzhu/KeyboardMan) Swift 版本，特此感谢作者 @nixzhu。因为工作需要在 Objective-C 中实现，所以用 Objective-C 重写了一遍，大家各取所需。

# KeyboardRobin

We may need keyboard infomation from keyboard notification to do animation, but the approach is complicated and easy to make mistakes. 

But KeyboardRobin will make it simple & easy.

## Example

```objective-c
#import "KeyboardRobin.h"
```

Do animation with keyboard appear/disappear:

```objective-c
self.keyboardRobin = [[KeyboardRobin alloc] init];
__weak typeof (self) weak_self = self;

self.keyboardRobin.animateWhenKeyboardAppear = ^(NSInteger appearPostIndex, CGFloat keyboardHeight, CGFloat keyboardHeightIncrement) {
    NSLog(@"Keyboard appear: appearPostIndex:%@, keyboardHeight:%@, keyboardHeightIncrement:%@", @(appearPostIndex), @(keyboardHeight), @(keyboardHeightIncrement));
    
    //update tableView's contentOffset
    CGPoint tempContentOffset = weak_self.tableView.contentOffset;
    tempContentOffset.y += keyboardHeightIncrement;
    weak_self.tableView.contentOffset = tempContentOffset;
    
    //update tableView's contentInset
    UIEdgeInsets tempInset = weak_self.tableView.contentInset;
    tempInset.bottom = keyboardHeight + CGRectGetHeight(weak_self.toolBar.frame);
    weak_self.tableView.contentInset = tempInset;
    
    //update toolBar's bottom constraint relative to superview
    weak_self.toolBarBottomConstraint.constant = keyboardHeight;
    
    [weak_self.view layoutIfNeeded];
};

self.keyboardRobin.animateWhenKeyboardDisappear = ^(CGFloat keyboardHeight) {
    NSLog(@"Keyboard disappear: keyboardHeight:%@", @(keyboardHeight));
    
    //update tableView's contentOffset
    CGPoint tempContentOffset = weak_self.tableView.contentOffset;
    tempContentOffset.y -= keyboardHeight;
    weak_self.tableView.contentOffset = tempContentOffset;
    
    //update tableView's contentInset
    UIEdgeInsets tempInset = weak_self.tableView.contentInset;
    tempInset.bottom = CGRectGetHeight(weak_self.toolBar.frame);
    weak_self.tableView.contentInset = tempInset;
    
    //update toolBar's bottom constraint relative to superview
    weak_self.toolBarBottomConstraint.constant = 0;
    
    [weak_self.view layoutIfNeeded];
};
```

For more specific information, you can use keyboardInfo that KeyboardRobin post:

```objective-c
self.keyboardRobin.postKeyboardInfo = ^(KeyboardRobin *keyboardRobin, KeyboardInfo keyboardInfo) {
    // TODO
}
```

Check the demo for more information.

原作者的[中文介绍](https://github.com/nixzhu/dev-blog/blob/master/2015-07-27-keyboard-man.md)。

## Installation

Feel free to drag `KeyboardRobin.h` and `KeyboardRobin.m` to your iOS Project. But it's recommended to use CocoaPods.

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ [sudo] gem install cocoapods
```

To integrate KeyboardRobin into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'

pod 'KeyboardRobin', '~> 0.0.3'
```

Then, run the following command:

```bash
$ pod install
```

You should open the `{Project}.xcworkspace` instead of the `{Project}.xcodeproj` after you installed anything from CocoaPods.

For more information about how to use CocoaPods, I suggest [this tutorial](http://www.raywenderlich.com/64546/introduction-to-cocoapods-2).

## License

KeyboardRobin is available under the MIT license. See the LICENSE file for more info.