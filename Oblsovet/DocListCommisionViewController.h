//
//  DocListCommisionViewController.h
//  Oblsovet
//
//  Created by Gotlib on 12.10.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocListCommisionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *jsonResultsArray;
    NSDictionary* json;
    __weak IBOutlet UITextView *text_view;
    __weak IBOutlet UIWebView *web_view;
    __weak IBOutlet UITableView *mTable;
}
@property (strong, readwrite)  NSString* id_str;
@property (nonatomic, strong) NSString *object;

@end
