//
//  CommissionDetailsViewController.h
//  Oblsovet
//
//  Created by Gotlib on 22.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommissionDetailsViewController : UIViewController
{
    __weak IBOutlet UISegmentedControl *swither;
    __weak IBOutlet UITableView *mTable;

}
@property (nonatomic, strong) NSString *selectedId;
@property (nonatomic, strong) NSString *object;
@property (nonatomic, strong) NSString *selectorName;
- (IBAction)switchTap:(id)sender;
@end
