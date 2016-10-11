//
//  DocListTableViewController.h
//  Oblsovet
//
//  Created by Gotlib on 04.10.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocListTableViewController : UITableViewController
{
    NSMutableArray *jsonResultsArray;
    NSDictionary* json;
}
@property (strong, readwrite)  NSString* id_str;
@property (nonatomic, strong) NSString *object;

@end
