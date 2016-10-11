//
//  MessagesTableViewCell.h
//  Oblsovet
//
//  Created by Gotlib on 04.10.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *date_lab;
@property (weak, nonatomic) IBOutlet UILabel *title_lab;
@property (weak, nonatomic) IBOutlet UILabel *resiver;
@property (weak, nonatomic) IBOutlet UILabel *for_whom;

@end
