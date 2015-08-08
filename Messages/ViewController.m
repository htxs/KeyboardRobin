//
//  ViewController.m
//  Messages
//
//  Created by jtian on 8/7/15.
//  Copyright (c) 2015 gzucm_tianjie. All rights reserved.
//

#import "ViewController.h"
#import "KeyboardManOC.h"
#import "UIViewController+Private.h"

static NSString *cellID = @"cell";

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *toolBar;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *toolBarBottomConstraint;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) KeyboardManOC *keyboardMan;
@end

@implementation ViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messages = [NSMutableArray arrayWithObject:@"How do you do?"];
    
    self.tableView.rowHeight = 60;
    UIEdgeInsets tempInset = self.tableView.contentInset;
    tempInset.bottom = CGRectGetHeight(self.toolBar.frame);
    self.tableView.contentInset = tempInset;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.keyboardMan = [[KeyboardManOC alloc] init];
    __weak typeof (self) weak_self = self;
    
    self.keyboardMan.animateWhenKeyboardAppear = ^(NSInteger appearPostIndex, CGFloat keyboardHeight, CGFloat keyboardHeightIncrement) {
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
    
    self.keyboardMan.animateWhenKeyboardDisappear = ^(CGFloat keyboardHeight) {
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
    
//    self.keyboardMan.postKeyboardInfo = ^(KeyboardManOC *keyboardMan, KeyboardInfo *keyboardInfo) {
//        switch (keyboardInfo.action) {
//            case KeyboardActionShow:
//                NSLog(@"Show appearPostIndex:%@, keyboardInfoHeight:%@, keyboardHeightIncrement:%@", @(keyboardMan.appearPostIndex), @(keyboardInfo.height), @(keyboardInfo.heightIncrement));
//                break;
//            case KeyboardActionHide:
//                NSLog(@"Hide keyboardInfoHeight:%@", @(keyboardInfo.height));
//                break;
//            default:
//                break;
//        }
//    };
}

- (void)sendMessage:(UITextField *)textField {
    NSString *text = textField.text;
    if (text.length == 0) {
        return;
    }
    
    //update data source
    [self.messages addObject:text];
    
    // insert new row
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    // scroll up a little bit if need
    CGFloat newMessageHeight = self.tableView.rowHeight;
    CGFloat blockedHeight = [self pv_statusBarHeight] + [self pv_navigationBarHeight] + CGRectGetHeight(self.toolBar.frame) + self.toolBarBottomConstraint.constant;
    CGFloat visibleHeight = CGRectGetHeight(self.tableView.frame) - blockedHeight;
    CGFloat hiddenHeight = self.tableView.contentSize.height - visibleHeight;
    if (hiddenHeight + newMessageHeight > 0) {
        CGFloat contentOffsetYIncrement = hiddenHeight > 0 ? newMessageHeight : hiddenHeight + newMessageHeight;
        NSLog(@"contentOffsetYIncrement: %@", @(contentOffsetYIncrement));
        [UIView animateWithDuration:0.2 animations:^{
            CGPoint tempContentOffset = self.tableView.contentOffset;
            tempContentOffset.y += contentOffsetYIncrement;
            self.tableView.contentOffset = tempContentOffset;
        }];
    }
    
    //clear text
    textField.text = @"";
}

@end

@interface ViewController (TextField) <UITextFieldDelegate>

@end

@implementation ViewController (TextField)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendMessage:textField];
    return YES;
}

@end

@interface ViewController (TabelView) <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController (TabelView)

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (indexPath.row >= 0  && indexPath.row < self.messages.count) {
        NSString *message = self.messages[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", @(indexPath.row + 1), message];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.textField resignFirstResponder];
}

@end
