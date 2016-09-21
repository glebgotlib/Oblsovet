//
//  LogInViewController.h
//  Oblsovet
//
//  Created by Gotlib on 20.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *login_textfield;
@property (weak, nonatomic) IBOutlet UITextField *pass_textfield;
@property (weak, nonatomic) IBOutlet UIButton *logIn_button;
- (IBAction)log_in_action:(UIButton *)sender;

@end
