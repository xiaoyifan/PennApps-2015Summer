//
//  Channels.h
//  HappyLearn
//
//  Created by Yifan Xiao on 9/5/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <Parse/Parse.h>

@interface Channels : PFObject

@property (nonatomic, strong) NSString *channelName;

@property (nonatomic, strong) UIImage *channelImage;

@end
