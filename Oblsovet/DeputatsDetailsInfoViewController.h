//
//  DeputatsDetailsInfoViewController.h
//  Oblsovet
//
//  Created by Gotlib on 28.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeputatsDetailsInfoViewController : UIViewController
{
    NSMutableArray *jsonResultsArray;
    NSDictionary* json;
}

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *name_lab;
@property (weak, nonatomic) IBOutlet UILabel *work_lab;
@property (weak, nonatomic) IBOutlet UILabel *education_lab;
@property (weak, nonatomic) IBOutlet UILabel *takepart_lab;
- (IBAction)switchTap:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UITableView *mTable;


@property (strong, readwrite)  NSString* name_str;
@property (strong, readwrite)  NSString* work_str;
@property (strong, readwrite)  NSString* education_str;
@property (strong, readwrite)  NSString* takepart_str;
@property (strong, readwrite)  NSString* photo_str;
@property (strong, readwrite)  NSString* id_str;


@end
