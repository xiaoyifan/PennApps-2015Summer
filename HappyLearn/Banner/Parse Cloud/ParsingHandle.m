//
//  ParsingHandle.m
//  socialCalendar
//
//  Created by Yifan Xiao on 5/29/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "ParsingHandle.h"

@implementation ParsingHandle

+ (id)sharedParsing
{
    static dispatch_once_t pred;
    static ParsingHandle *shared = nil;

    dispatch_once(&pred, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

- (void)findChannelsOfCurrentUserToCompletion:( void (^)(NSArray *) )completion
{
    [self findChannelsOfUser:[PFUser currentUser] ToCompletion:completion];
}

- (void)findChannelsOfUser:(PFUser *)user ToCompletion:( void (^)(NSArray *array) )completion
{
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Channel"];
    [eventQuery whereKey:@"users" equalTo:user];


    [eventQuery findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu events.", (unsigned long)objects.count);

            completion(objects);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)findObjectsofDate:(NSDate *)date ToCompletion:( void (^)(NSArray *array) )completion
{
    NSLog(@"date to find: %@", date);
    NSCalendar *calendarCurrent = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendarCurrent components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:1];
    NSDate *morningStart = [calendarCurrent dateFromComponents:components];

    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    NSDate *tonightEnd = [calendarCurrent dateFromComponents:components];

    PFQuery *query = [PFQuery queryWithClassName:@"Challenge"];
//    [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];
    [query whereKey:@"time" greaterThan:morningStart];
    [query whereKey:@"time" lessThan:tonightEnd];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error) {
            //Etc...
            completion(objects);
        }
    }];
}

//- (void)insertNewObjectToDatabase:(eventObject *)newObj ToCompletion:( void (^)() )completion
//{
//    [self insertNewObjectToDatabase:newObj createdBy:[PFUser currentUser] ToCompletion:completion];
//}
//
//- (void)insertNewObjectToDatabase:(eventObject *)newObj createdBy:(PFUser *)user ToCompletion:( void (^)() )completion
//{
//    PFObject *event = [PFObject objectWithClassName:@"Events"];
//
//    event[@"title"] = newObj.title;
//    event[@"time"] = newObj.time;
//    event[@"reminderDate"]  = newObj.reminderDate;
//
//    PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:newObj.location];
//
//    event[@"location"] = point;
//    if (newObj.locationDescription.length == 0) {
//        event[@"locationDescription"] = [NSNull null];
//    }
//    else{
//     event[@"locationDescription"] = newObj.locationDescription;   
//    }
//    event[@"eventNote"] = newObj.eventNote;
//
//    [event setObject:user forKey:@"createdBy"];
//
//
//    PFRelation *groupRelation = [event relationForKey:@"group"];
//
//    for (PFUser *user in newObj.group) {
//        [groupRelation addObject:user];
//    }
//    [groupRelation addObject:[PFUser currentUser]];
//
//    [event saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
//        if (!succeeded) {
//            // The object has been saved.
//            NSLog(@"%@", error);
//        } else {
//            completion();
//        }
//    }];
//}

- (Channels *)parseChannelToChannelObject:(PFObject *)object
{
    Channels *retrivedObj = [[Channels alloc] init];
    retrivedObj.channelName = [object objectForKey:@"channelName"];
    retrivedObj.channelImage = [object objectForKey:@"channelImage"];

    retrivedObj.objectId = object.objectId;

    return retrivedObj;
}

- (void)getAllUsersToCompletion:( void (^)(NSArray *array) )completion
{
    PFQuery *query = [PFUser query];

    [query orderByAscending:@"username"];

    [query findObjectsInBackgroundWithBlock: ^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"the error is %@", error);
        } else {
            completion(array);
        }
    }];
}

- (void)getMyFriendsToCompletion:( void (^)(NSArray *array) )completion
{
    if (![PFUser currentUser]) {
        return;
    }

    PFRelation *friendsRelation = [[PFUser currentUser] objectForKey:@"friendRelation"];
    PFQuery *query = [friendsRelation query];
    [query orderByAscending:@"username"];

    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error) {
            //Etc...
            completion(objects);
        } else {
            NSLog(@"the error is %@", error);
        }
    }];
}

- (void)getMyPendingReceivedRequestToCompletion:( void (^)(NSArray *array) )completion
{
    if (![PFUser currentUser]) {
        return;
    }

    PFQuery *query = [PFQuery queryWithClassName:@"friendRequest"];
    [query includeKey:@"from"];
    [query whereKey:@"to" equalTo:[PFUser currentUser]];
    [query whereKey:@"status" equalTo:@"pending"];

    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error info %@", error);
        } else {
            completion(objects);
        }
    }];
}

- (void)getMyPendingSentRequestToCompletion:( void (^)(NSArray *array) )completion
{
    if (![PFUser currentUser]) {
        return;
    }

    PFQuery *query = [PFQuery queryWithClassName:@"friendRequest"];
    [query whereKey:@"from" equalTo:[PFUser currentUser]];
    [query whereKey:@"status" equalTo:@"pending"];

    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error info %@", error);
        } else {
            NSLog(@"%lu requests sent", (unsigned long)objects.count);
            completion(objects);
        }
    }];
}

- (void)sendUserFriendRequest:(PFUser *)user
{
    PFObject *request = [PFObject objectWithClassName:@"friendRequest"];
    request[@"from"]  = [PFUser currentUser];
    request[@"to"] = user;
    request[@"status"] = @"pending";

    [request saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            NSLog(@"the error is %@", error);
        }
    }];
}

- (void)approvedFriendRequestFrom:(PFUser *)user
{
    PFRelation *friendRelation = [[PFUser currentUser] relationForKey:@"friendRelation"];

    [friendRelation addObject:user];
    [[PFUser currentUser] saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            NSLog(@"the error is %@", error);
        }
    }];
}

- (void)removeDeniedFriendRequestFrom:(PFUser *)user
{
    PFQuery *query = [PFQuery queryWithClassName:@"friendRequest"];
    [query whereKey:@"status" equalTo:@"denied"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
       
        for (PFObject * object in objects) {
            [object deleteEventually];
        }
    }];
    //Get all my denied requests and remove all the requests from the database
    
}

- (void)getApprovedUsersToCompletion:( void (^)(NSArray *array) )completion
{
    if (![PFUser currentUser]) {
        return;
    }
    PFQuery *query = [PFQuery queryWithClassName:@"friendRequest"];
    [query whereKey:@"from" equalTo:[PFUser currentUser]];
    [query whereKey:@"status" equalTo:@"approved"];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error info %@", error);
        } else {
            NSLog(@"%lu requests sent", (unsigned long)objects.count);
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (PFObject *request in objects)
            {
                PFUser *user = request[@"to"];
                [array addObject:user];
                PFRelation *friendRelation = [[PFUser currentUser] relationForKey:@"friendRelation"];
                [friendRelation addObject:user];
                [[PFUser currentUser] saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
                    if (!succeeded) {
                        NSLog(@"the error is %@", error);
                    }
                }];
                [request deleteEventually];
            }
            completion(array);
        }
    }];
}

- (void)deleteEventFromCloudByID:(NSString *)objectId ToCompletion:( void (^)() )completion
{
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];

    // Retrieve the object by id
    [query getObjectInBackgroundWithId:objectId
                                 block: ^(PFObject *eventObj, NSError *error) {
        [eventObj deleteInBackground];
        completion();
    }];
}

- (void)updateUser:(PFUser *)user Username:(NSString *)username ToCompletion:( void (^)(BOOL finished) )completion
{
    [user setUsername:username];
    [user saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
        completion(succeeded);
    }];
}

@end
