//
//  PresidiumTableViewController.m
//  Oblsovet
//
//  Created by Gotlib on 28.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import "PresidiumTableViewController.h"

@interface PresidiumTableViewController ()

@end

@implementation PresidiumTableViewController
{
    NSMutableArray *jsonResultsArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_mTable delegate];
    [_mTable dataSource];
    self.navigationItem.title = NSLocalizedString(@"Presidium", nil);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}
-(void)refresh:(NSString*)str{
    NSLog(@"%@",str);
    _objectR = str;
    [_mTable delegate];
    [_mTable dataSource];
    [self feedLine];
}

//SlideNavigationControllerDidClose

#pragma mark -
#pragma mark Request
-(void)feedLine
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [jsonResultsArray removeAllObjects];
    [_items removeAllObjects];
    [_mTable reloadData];
    
    NSURL* feedUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://oblsovet.y.od.ua/json/?object=%@&action=list",_objectR]];//object=session
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:feedUrl];
    NSLog(@"headUrl: %@", feedUrl);
    [request addValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"X-Csrf-Token"] forHTTPHeaderField:@"X-CSRF-Token" ];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"] forHTTPHeaderField:@"Set-Cookie"];
    
    request.HTTPMethod = @"GET";
    // Create a download task.
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          
                                          //                                          NSLog(@"feedRequest - %@",request);
                                          NSError *JSONError = nil;
                                          [jsonResultsArray removeAllObjects];
                                          jsonResultsArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &JSONError];
                                          //NSLog(@"feedLine  - - - %@",json);
                                          if (JSONError) {
                                              UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry", nil) message:NSLocalizedString(@"Bad connection", nil)  delegate: self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                              [errorAlert show];
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          }
                                          else{
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  //                                                  NSLog(@"YES %@",jsonResultsArray);
                                                  [_items removeAllObjects];
                                                  _items = jsonResultsArray;
                                                  NSLog(@"TER %@",[[_items objectAtIndex:0] objectForKey:@"caption"]);
                                                  [_mTable reloadData];
                                                  [self.view reloadInputViews];
                                                  [self.tableView reloadData];
                                                  
                                              });
                                              
                                          }
                                      }
                                      else
                                      {
                                          if (error.code !=-999){
                                              UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry", nil) message:NSLocalizedString(@"Bad connection", nil)  delegate: self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                              [errorAlert show];
                                              //                                 [activityIndicator stopAnimating];
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          }
                                      }
                                      
                                  }];
    // Start the task.
    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ListOfCommissionsTableViewCell";
    ListOfCommissionsTableViewCell *cell = (ListOfCommissionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ListOfCommissionsTableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"caption"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [self storyboard];
    
    if([_objectR isEqualToString:@"session"]){
        TmpViewController*controller = [storyBoard instantiateViewControllerWithIdentifier:@"TmpViewController"];
        controller.selectedId = [[_items objectAtIndex:indexPath.row] objectForKey:@"id"];
        controller.object = _objectR;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else{
        CommissionDetailsViewController*controller = [storyBoard instantiateViewControllerWithIdentifier:@"CommissionDetailsViewController"];
        controller.selectedId = [[_items objectAtIndex:indexPath.row] objectForKey:@"id"];
        controller.object = _objectR;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
