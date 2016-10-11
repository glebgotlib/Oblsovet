//
//  MessagesTableViewController.h
//  Oblsovet
//
//  Created by Gotlib on 04.10.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesTableViewController : UITableViewController
{
    NSMutableArray *jsonResultsArray;
    NSDictionary* json;
}
@end
