//
//  NewsDetailsViewController.h
//  Oblsovet
//
//  Created by Gotlib on 19.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *web_view;
@property (weak, nonatomic) IBOutlet UILabel *lab_title;
@property (weak, nonatomic) NSString *description_html_text;
@property (weak, nonatomic) NSString *description_title_text;
@end
