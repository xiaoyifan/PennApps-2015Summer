//
//  LPNetworkingManager.m
//  LillyPulitzer
//
//  Created by Thomas on 4/30/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "LPBannerView.h"
#import "HLNetworkingManager.h"

#import <AFNetworking/AFNetworking.h>


@implementation HLNetworkingManager

+ (instancetype)sharedManager
{
    static HLNetworkingManager *networkingManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkingManager = [HLNetworkingManager new];
    });
    return networkingManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status) {
            self.didStartMonitoring = YES;
            //DLog( @"Reachability: %@", AFStringFromNetworkReachabilityStatus(status) );

            if (status == AFNetworkReachabilityStatusNotReachable) {
                [LPBannerView showMessage:@"No Network connection is available"];
            } else {
                [LPBannerView hideBanner];
            }
        }];

        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

- (BOOL)isReachable
{
    return ([AFNetworkReachabilityManager sharedManager] && self.didStartMonitoring) ?  [AFNetworkReachabilityManager sharedManager].reachable : YES;
}

@end
