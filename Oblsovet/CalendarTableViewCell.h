//
//  CalendarTableViewCell.h
//  Oblsovet
//
//  Created by Gotlib on 29.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *date_lab;
@property (weak, nonatomic) IBOutlet UILabel *title_lab;

@end
