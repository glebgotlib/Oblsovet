//
//  FractionTableViewController.h
//  Oblsovet
//
//  Created by Gotlib on 29.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "LeftMenuViewController.h"
#import "ListOfCommissionsTableViewCell.h"
#import "CommissionDetailsViewController.h"
#import "TmpViewController.h"
@interface FractionTableViewController : UITableViewController<SlideNavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *mTable;
@property (nonatomic, strong) NSMutableArray *items;
-(void)refresh:(NSString*)str;

@property (nonatomic,readwrite) NSString *objectR;
@end
