//
//  ViewControllerSignal3.m
//  Examples
//
//  Created by Kyle LeNeau on 5/16/15.
//  Copyright (c) 2015 Kyle LeNeau. All rights reserved.
//

#import "ViewControllerSignal3.h"

@interface ViewControllerSignal3 ()
@property (nonatomic, strong) NSMutableArray *allTweets;
@end

@implementation ViewControllerSignal3

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loginWithUser:@"Kyle"
               password:@"foo"
                success:^(NSArray *tweet) {
                    
        [self loadCachedTweets:^(NSArray *cachedTweets) {
            [self.allTweets addObjectsFromArray:cachedTweets];
            
            [self fetchTweetsAfterTweet:cachedTweets.lastObject
                                success:^(NSArray *newTweets) {
                [self.allTweets addObjectsFromArray:newTweets];
            } error:^(NSError *fetchError) {
                // ...
            }];
        } error:^(NSError *cacheError) {
            // ...
        }];
    } error:^(NSError *loginError) {
        // ...
    }];
}

@end
