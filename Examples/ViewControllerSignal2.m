//
//  ViewControllerSignal2.m
//  Examples
//
//  Created by Kyle LeNeau on 5/14/15.
//  Copyright (c) 2015 Kyle LeNeau. All rights reserved.
//

#import "ViewControllerSignal2.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewControllerSignal2 ()
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) UIButton *loginButton;
@end

@implementation ViewControllerSignal2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [RACObserve(self, userName) subscribeNext:^(NSString *newName) {
        NSLog(@"User name entered: %@", newName);
    }];
    
    [RACObserve(self, password) subscribeNext:^(NSString *newPassword) {
        NSLog(@"Password entered: %@", newPassword);
    }];

    NSArray *signals = @[RACObserve(self, userName), RACObserve(self, password)];
    RACSignal *validSignal = [RACSignal combineLatest:signals
        reduce:^(NSString *userName, NSString *password) {
        // return YES or NO for valid fields
        return @(userName != nil && userName.length > 0
            && password != nil && password.length > 0);
    }];
    
    [validSignal subscribeNext:^(NSNumber *isValid) {
        NSLog(@"Form is Valid: %@", isValid.boolValue ? @"true" : @"false");
    }];
    
    RAC(self.loginButton, enabled) = validSignal;
    
    
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(NSString *string) {
        NSLog(@"new string: %@", string);
    }];
    [subject sendNext:@"foo"];
    // prints: new string foo
}

@end

/*
 
// loginButton is Disabled
 
// Somewhere this happens
self.userName = @"Kyle";

// Prints this:
> User name entered: Kyle
> Form is Valid: false

// loginButton is Disabled

// Somewhere this happens
self.password = @"SmartThings";

// Prints this:
> Password entered: SmartThings
> Form is Valid: true
 
// loginButton is Enabled

 */