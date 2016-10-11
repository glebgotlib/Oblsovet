//
//  SessionsTableViewController.h
//  Oblsovet
//
//  Created by Gotlib on 28.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "LeftMenuViewController.h"
#import "ListOfCommissionsTableViewCell.h"
#import "CommissionDetailsViewController.h"
#import "TmpViewController.h"
@interface SessionsTableViewController : UITableViewController<SlideNavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *mTable;
@property (nonatomic, strong) NSMutableArray *items;
-(void)refresh:(NSString*)str;

@property (nonatomic,readwrite) NSString *objectR;
@property (nonatomic, readwrite) int rreerr;
@property (nonatomic, strong) NSString *objectR111111;
@end
