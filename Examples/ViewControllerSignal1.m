//
//  ViewControllerSignal1.m
//  Examples
//
//  Created by Kyle LeNeau on 5/16/15.
//  Copyright (c) 2015 Kyle LeNeau. All rights reserved.
//

#import "ViewControllerSignal1.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewControllerSignal1 ()
@property (nonatomic, strong) UITextField *tweetText;
@end

@implementation ViewControllerSignal1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tweetText.rac_textSignal subscribeNext:^(NSString *newTweetText) {
        NSLog(@"New Tweet: %@", newTweetText);
    }];

    [[self.tweetText.rac_textSignal map:^id(NSString *newTweetText) {
        return @(140 - newTweetText.length);
    }] subscribeNext:^(NSNumber *length) {
        NSLog(@"Characters Remaining: %@", length);
    }];

    self.tweetText.text = @"Hello Midwest Mobile Summit";
    // > New Tweet: Hello Midwest Mobile Summit
    // > Characters Remaining: 113
}

@end
