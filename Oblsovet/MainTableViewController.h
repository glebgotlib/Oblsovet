//
//  MainTableViewController.h
//  Oblsovet
//
//  Created by Gotlib on 19.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "LeftMenuViewController.h"
@interface MainTableViewController : UITableViewController<SlideNavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mTable;
@end
