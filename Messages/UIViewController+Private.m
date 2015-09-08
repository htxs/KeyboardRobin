//
//  UIViewController+Private.m
//  Messages
//
//  Created by jtian on 8/8/15.
//  Copyright (c) 2015 htxs.me. All rights reserved.
//

#import "UIViewController+Private.h"

@implementation UIViewController (Private)

- (CGFloat)pv_statusBarHeight {
    if (self.view.window) {
        CGRect statusBarFrame = [self.view.window convertRect:[UIApplication sharedApplication].statusBarFrame toView:self.view];
        return statusBarFrame.size.height;
    }
    else {
        return 0.0f;
    }
}

- (CGFloat)pv_navigationBarHeight {
    if (self.navigationController) {
        return self.navigationController.navigationBar.frame.size.height;
    }
    else {
        return 0.0f;
    }
}
@end
