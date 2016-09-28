//
//  TmpViewController.h
//  Oblsovet
//
//  Created by Gotlib on 27.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TmpViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *switchers;
- (IBAction)switchTap:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UITableView *mTable;

@property (nonatomic, strong) NSString *selectedId;
@property (nonatomic, strong) NSString *object;
@end
