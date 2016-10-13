//
//  DocListCommisionViewController.m
//  Oblsovet
//
//  Created by Gotlib on 12.10.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import "DocListCommisionViewController.h"
#import "DocListCommisionTableViewCell.h"
#import "DocsInsideViewController.h"
@interface DocListCommisionViewController ()

@end

@implementation DocListCommisionViewController

{
    NSMutableArray*info;
    NSMutableArray*docs;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [mTable delegate];
    [mTable dataSource];
    docs = [[NSMutableArray alloc] init];
    info = [[NSMutableArray alloc] init];
    [web_view setOpaque:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;

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
                                          //                                          jsonResultsArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &JSONError];
                                          json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
                                          
                                          if (JSONError) {
                                              UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry", nil) message:NSLocalizedString(@"Bad connection", nil)  delegate: self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                              [errorAlert show];
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          }
                                          else{
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@"YES %@",json);
                                                  NSString*html_str = [[json objectForKey:@"info"] objectForKey:@"about"];
                                                  [web_view loadHTMLString:html_str baseURL:nil];
                                                  docs = [json objectForKey:@"docs"];
                                                  
                                                  
                                                  [mTable reloadData];
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
    return docs.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DocListCommisionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DocListCommisionTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DocListCommisionTableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DocListCommisionTableViewCell"];
    }
    cell.textLabel.text = [[docs objectAtIndex:indexPath.row] objectForKey:@"caption"];
    if ([[[docs objectAtIndex:indexPath.row] objectForKey:@"caption"] length]>50) {
        cell.textLabel.numberOfLines = 2;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [self storyboard];
    DocsInsideViewController*controller = [storyBoard instantiateViewControllerWithIdentifier:@"DocsInsideViewController"];
    controller.url_file = [[jsonResultsArray objectAtIndex:indexPath.row] objectForKey:@"file"];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
