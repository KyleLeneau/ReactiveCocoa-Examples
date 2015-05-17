//
//  ViewControllerSignal4.m
//  Examples
//
//  Created by Kyle LeNeau on 5/16/15.
//  Copyright (c) 2015 Kyle LeNeau. All rights reserved.
//

#import "ViewControllerSignal4.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewControllerSignal4 ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSMutableArray *allTweets;
@end

@implementation ViewControllerSignal4

- (void)loginWithUser:(NSString *)username
             password:(NSString *)password
              success:(void(^)(NSArray *))success
                error:(void(^)(NSError *))error {
    // ...
}

- (void)loadCachedTweets:(void(^)(NSArray *))success
                   error:(void(^)(NSError *))error {
    // ...
}

- (void)fetchTweetsAfterTweet:(NSObject *)tweet
                      success:(void(^)(NSArray *))success
                        error:(void(^)(NSError *))error {
    // ...
}

- (RACSignal *)loginWithUser:(NSString *)username
                    password:(NSString *)password {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self loginWithUser:username
                   password:password
                    success:^(NSArray *user) {
            [subscriber sendNext:user];
            [subscriber sendCompleted];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        // no way to cancel this so return nil
        return nil;
    }];
}

- (RACSignal *)loadCachedTweets {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self loadCachedTweets:^(NSArray *cachedTweets) {
            for (NSObject *tweet in cachedTweets) {
                [subscriber sendNext:tweet];
            }
            [subscriber sendCompleted];
        } error:^(NSError *error) {
            [subscriber sendNext:error];
        }];
        
        // no way to cancel this so return nil
        return nil;
    }];
}

- (RACSignal *)fetchTweetsAfterTweet:(NSObject *)tweet {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self fetchTweetsAfterTweet:tweet success:^(NSArray *newTweets) {
            for (NSObject *tweet in newTweets) {
                [subscriber sendNext:tweet];
            }
            [subscriber sendCompleted];
        } error:^(NSError *error) {
            [subscriber sendNext:error];
        }];
        
        // no way to cancel this so return nil
        return nil;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[[self loginWithUser:@"Kyle" password:@"pass"]
    deliverOn:[RACScheduler mainThreadScheduler]]
    subscribeNext:^(id x) {
        NSLog(@"logged in, yay!");
        self.label.text = @"Welcome!";
    } error:^(NSError *error) {
        //...
    }];
    
    RACSignal *tweetsSignal =
        [[[self loginWithUser:@"Kyle" password:@"pass"]
        flattenMap:^RACStream *(id value) {
            return [[self loadCachedTweets] collect];
        }]
        flattenMap:^RACStream *(NSArray *cachedTweets) {
            return [[self fetchTweetsAfterTweet:cachedTweets] collect];
        }];

    [tweetsSignal subscribeNext:^(NSArray *allTweets) {
        // all Tweets are loaded
    } error:^(NSError *error) {
        // something threw an error
        // hide activity indicator
    } completed:^{
        // everything is done
        // hide activity indicator
    }];

    RAC(self, allTweets) = tweetsSignal;
}

@end
