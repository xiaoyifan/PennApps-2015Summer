//
//  HLChallengeListTableViewController.m
//  HappyLearn
//
//  Created by Yifan Xiao on 9/5/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "HLChallengeListTableViewController.h"
#import "HLChallengeTableViewCell.h"
@interface HLChallengeListTableViewController ()

@property (strong, nonatomic) NSMutableArray *liveChallenges;
@property (strong, nonatomic) NSMutableArray *pastChallenges;

@end

@implementation HLChallengeListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return HLChallengeTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLChallengeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChallengeObjectCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *sectionName;
    
    switch (section) {
        case HLChallengeTypeLive:
            sectionName = @"Live Challenges";
            break;
        case HLChallengeTypePast:
            sectionName = @"Past Challenges";
        default:
            break;
    }
    return sectionName;
}



@end
