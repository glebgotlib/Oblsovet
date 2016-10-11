//
//  DocListTableViewController.m
//  Oblsovet
//
//  Created by Gotlib on 04.10.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import "DocListTableViewController.h"
#import "DocsInsideViewController.h"
#import "DocListTableViewCell.h"
@interface DocListTableViewController ()

@end

@implementation DocListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self feedLine];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Request
-(void)feedLine
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [jsonResultsArray removeAllObjects];
    
    //    reload input views
    NSURL* feedUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://oblsovet.y.od.ua/json/?object=%@&action=docs&id=%@",_object,_id_str]];
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
                                          json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
                                          
                                          if (JSONError) {
                                              UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry", nil) message:NSLocalizedString(@"Bad connection", nil)  delegate: self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                              [errorAlert show];
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          }
                                          else{
                                              dispatch_async(dispatch_get_main_queue(),^{
//                                                  NSLog(@"YES %@",json);
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return jsonResultsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DocListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DocListTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DocListTableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DocListTableViewCell"];
    }
    cell.textLabel.text = [[jsonResultsArray objectAtIndex:indexPath.row] objectForKey:@"caption"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [self storyboard];
    DocsInsideViewController*controller = [storyBoard instantiateViewControllerWithIdentifier:@"DocsInsideViewController"];
    controller.url_file = [[jsonResultsArray objectAtIndex:indexPath.row] objectForKey:@"file"];
    [self.navigationController pushViewController:controller animated:YES];
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
