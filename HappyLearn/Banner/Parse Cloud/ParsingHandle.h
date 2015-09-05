//
//  ParsingHandle.h
//  socialCalendar
//
//  Created by Yifan Xiao on 5/29/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParsingHandle : NSObject

+(id)sharedParsing;


-(void)findChannelsOfCurrentUserToCompletion:(void(^)(NSArray *array))completion;

-(void)findChannelsOfUser:(PFUser *)user ToCompletion:(void(^)(NSArray *array))completion;

-(void)findObjectsofDate:(NSDate *)date ToCompletion:(void (^)(NSArray *array))completion;

-(NSArray *)findObjectsFromNativeCalendarOnDate:(NSDate *)date;

//-(void)insertNewObjectToDatabase:(eventObject *)newObj createdBy:(PFUser *)user ToCompletion:(void (^)())completion;
//
//-(void)insertNewObjectToDatabase:(eventObject *)newObj ToCompletion:(void (^)())completion;


-(Channels *)parseChannelToChannelObject:(PFObject *)object;

-(void)getAllUsersToCompletion:(void (^)(NSArray *array))completion;

-(void)getMyFriendsToCompletion:(void (^)(NSArray *array))completion;

-(void)getMyPendingReceivedRequestToCompletion:(void (^)(NSArray *array))completion;

-(void)getMyPendingSentRequestToCompletion:(void (^)(NSArray *array))completion;

-(void)sendUserFriendRequest:(PFUser *)user;

-(void)approvedFriendRequestFrom:(PFUser *)user;

- (void)removeDeniedFriendRequestFrom:(PFUser *)user;

-(void)getApprovedUsersToCompletion:(void (^)(NSArray *array))completion;

-(void)deleteEventFromCloudByID:(NSString *)objectId ToCompletion:(void (^)())completion;

-(void)updateUser:(PFUser*)user Email:(NSString*)email ToCompletion:( void (^)(BOOL finished) )completion;

@end
