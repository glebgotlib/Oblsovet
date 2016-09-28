//
//  DeputatListTableViewController.h
//  Oblsovet
//
//  Created by Gotlib on 28.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "LeftMenuViewController.h"
@interface DeputatListTableViewController : UITableViewController<SlideNavigationControllerDelegate>
@property (nonatomic, strong) NSString *selectedId;
@property (nonatomic, strong) NSString *object;
-(void)refresh:(NSString*)str;

@property (nonatomic,readwrite) NSString *objectR;
@end
