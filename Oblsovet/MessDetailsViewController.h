//
//  MessDetailsViewController.h
//  Oblsovet
//
//  Created by Gotlib on 05.10.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessDetailsViewController : UIViewController
{
    NSMutableArray *jsonResultsArray;
    NSDictionary* json;
}
@property (weak, nonatomic) IBOutlet UILabel *title_lab;
@property (weak, nonatomic) IBOutlet UILabel *date_lab;
@property (weak, nonatomic) IBOutlet UIWebView *web_view;
@property (weak, nonatomic) IBOutlet UIButton *yes_button;
- (IBAction)yes_button_action:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *no_button;
- (IBAction)no_button_action:(UIButton *)sender;

@property (strong, nonatomic) NSString *title_str;
@property (strong, nonatomic) NSString *date_str;
@property (strong, nonatomic) NSString *web_str;
@property (strong, nonatomic) NSString *reciever_str;
@property (strong, nonatomic) NSString *level_str;
@property (strong, nonatomic) NSString *quest_str;
@property (readwrite) int ansver;
@property(readwrite) int wasansvwred;
@end
