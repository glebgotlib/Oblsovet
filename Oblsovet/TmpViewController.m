//
//  TmpViewController.m
//  Oblsovet
//
//  Created by Gotlib on 27.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import "TmpViewController.h"
#import "ScaduleOfCommissionTableViewCell.h"
#import "DocListTableViewController.h"
@interface TmpViewController ()
@property (strong ,nonatomic) NSMutableDictionary *cachedFeedImages;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation TmpViewController
{
    NSMutableArray *jsonResultsArray;
    int selector;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_mTable delegate];
    [_mTable dataSource];
    self.cachedFeedImages = [[NSMutableDictionary alloc] init];
    NSLog(@"ID== %@",_selectedId);
    selector = 0;
    if ([_object isEqualToString:@"session"]){
        [_switchers setTitle:@"Анонс" forSegmentAtIndex:0];
    }
    [self eventsFuture];
    // Do any additional setup after loading the view.
}
#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        UIStoryboard *storyBoard = [self storyboard];
        DocListTableViewController*controller = [storyBoard instantiateViewControllerWithIdentifier:@"DocListTableViewController"];
        controller.id_str = [[_items objectAtIndex:indexPath.row] objectForKey:@"id"];
        controller.object = _object;
        [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selector    ==  0)  {
        static NSString *CellIdentifier = @"ScaduleOfCommissionTableViewCell";
        ScaduleOfCommissionTableViewCell *cell1 = (ScaduleOfCommissionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell1 == nil) {
            cell1 = [[ScaduleOfCommissionTableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell1.date_lab.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"date"];
        cell1.caption_lab.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"caption"];
        
        return cell1;
    }
    else   {
        static NSString *CellIdentifier = @"ScaduleOfCommissionTableViewCell";
        ScaduleOfCommissionTableViewCell *cell2 = (ScaduleOfCommissionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell2 == nil) {
            cell2 = [[ScaduleOfCommissionTableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell2.date_lab.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"date"];
        cell2.caption_lab.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"caption"];
        
        return cell2;
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//http://oblsovet.y.od.ua/json/?object=comission&action=timetable&id=1&type=new

- (IBAction)switchTap:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0)   {
        //toggle the correct view to be visible
        NSLog(@"1");
        selector = 0;
        [self eventsFuture];
    }
    else    {
        NSLog(@"2");
        selector = 1;
        [self eventsPast];
    }
}

-(void)eventsFuture
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [jsonResultsArray removeAllObjects];
    
    
    NSURL* feedUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://oblsovet.y.od.ua/json/?object=%@&action=timetable&id=%@&type=new",_object,_selectedId]];
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
                                          
                                          NSLog(@"feedRequest - %@",request);
                                          NSError *JSONError = nil;
                                          [jsonResultsArray removeAllObjects];
                                          jsonResultsArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &JSONError];
                                          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
                                          //NSLog(@"feedLine  - - - %@",json);
                                          if (JSONError) {
                                              UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry", nil) message:NSLocalizedString(@"Bad connection", nil)  delegate: self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                              [errorAlert show];
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          }
                                          else{
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@"YES %@",jsonResultsArray);
                                                  [_items removeAllObjects];
                                                  _items = jsonResultsArray;
                                                  [_mTable reloadData];
                                              });
                                              
                                              
                                          }
                                      }
                                      else
                                      {
                                          if (error.code !=-999){
                                              UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry", nil) message:NSLocalizedString(@"Bad connection", nil)  delegate: self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                              [errorAlert show];
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          }
                                      }
                                      
                                  }];
    // Start the task.
    [task resume];
}
//////////////////////////////////////////////////////////////////////////////////////////
-(void)eventsPast
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [jsonResultsArray removeAllObjects];
    
    
    NSURL* feedUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://oblsovet.y.od.ua/json/?object=%@&action=timetable&id=%@&type=old",_object,_selectedId]];
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
                                          
                                          NSLog(@"feedRequest - %@",request);
                                          NSError *JSONError = nil;
                                          [jsonResultsArray removeAllObjects];
                                          jsonResultsArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &JSONError];
                                          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
                                          //NSLog(@"feedLine  - - - %@",json);
                                          if (JSONError) {
                                              UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry", nil) message:NSLocalizedString(@"Bad connection", nil)  delegate: self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                              [errorAlert show];
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          }
                                          else{
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@"YES %@",jsonResultsArray);
                                                  [_items removeAllObjects];
                                                  _items = jsonResultsArray;
                                                  [_mTable reloadData];
                                              });
                                              
                                              
                                          }
                                      }
                                      else
                                      {
                                          if (error.code !=-999){
                                              UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry", nil) message:NSLocalizedString(@"Bad connection", nil)  delegate: self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                              [errorAlert show];
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


@end
