//
//  MessagesTableViewController.m
//  Oblsovet
//
//  Created by Gotlib on 04.10.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import "MessagesTableViewController.h"
#import "MessagesTableViewCell.h"
#import "MessDetailsViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface MessagesTableViewController ()

@end

@implementation MessagesTableViewController
{
    NSDateFormatter *dateFormatter;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:NO];
//    [self feedLine];
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self feedLine];
    NSLog(@"viewWillAppear");
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
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
    NSLog(@"jsonResultsArray.count === %lu",(unsigned long)jsonResultsArray.count);
    return jsonResultsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 144;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessagesTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MessagesTableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessagesTableViewCell"];
    }

    if(![[[jsonResultsArray objectAtIndex:indexPath.row] objectForKey:@"read"] boolValue] ) {
        [cell setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
    }
    else{
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];

    cell.title_lab.text = [[jsonResultsArray objectAtIndex:indexPath.row] objectForKey:@"caption"];
    cell.date_lab.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[[[jsonResultsArray objectAtIndex:indexPath.row] objectForKey:@"date"]intValue]]];
    cell.resiver.text = [[jsonResultsArray objectAtIndex:indexPath.row] objectForKey:@"reciever"];
    cell.for_whom.text = [[jsonResultsArray objectAtIndex:indexPath.row] objectForKey:@"level"];

    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [self storyboard];
    MessDetailsViewController*controller =  [storyBoard instantiateViewControllerWithIdentifier:@"MessDetailsViewController"];
    controller.title_str = [[jsonResultsArray objectAtIndex:indexPath.row] objectForKey:@"caption"];
    controller.date_str = [[jsonResultsArray objectAtIndex:indexPath.row] objectForKey:@"date"];
    controller.web_str = [[jsonResultsArray objectAtIndex:indexPath.row] objectForKey:@"text"];
    controller.ansver = [[[jsonResultsArray objectAtIndex:indexPath.row] objectForKey:@"quest"] intValue];
    controller.reciever_str = [[jsonResultsArray objectAtIndex:indexPath.row] objectForKey:@"reciever"];
    controller.level_str = [[jsonResultsArray objectAtIndex:indexPath.row] objectForKey:@"level"];
    controller.quest_str = [[jsonResultsArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    controller.wasansvwred = [[[jsonResultsArray objectAtIndex:indexPath.row] objectForKey:@"ans"] intValue];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark Request
-(void)feedLine
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [jsonResultsArray removeAllObjects];
    
    //    reload input views
    NSURL* feedUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://oblsovet.y.od.ua/json/?object=deputat&action=messages&cookievar=%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"preferenceName"]]];
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
                                          
                                          NSError *JSONError = nil;
                                          jsonResultsArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &JSONError];
//                                          json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
                                          
                                          if (JSONError) {
                                              UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry", nil) message:NSLocalizedString(@"Bad connection", nil)  delegate: self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                              [errorAlert show];
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          }
                                          else{
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@"YES %@",jsonResultsArray);
                                                  [self.tableView reloadData];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
