//
//  DeputatsListTableViewController.m
//  Oblsovet
//
//  Created by Gotlib on 28.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import "DeputatsListTableViewController.h"
#import "DeputatsDetailsInfoViewController.h"
@interface DeputatsListTableViewController ()
@property (strong ,nonatomic) NSMutableDictionary *cachedFeedImages;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation DeputatsListTableViewController

{
    NSMutableArray *jsonResultsArray;
    int selector;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

-(void)refresh:(NSString*)str{
    NSLog(@"%@",str);
    _objectR = str;
    [self feedLine];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cachedFeedImages = [[NSMutableDictionary alloc] init];
    [self feedLine];
    self.navigationItem.title = NSLocalizedString(@"Deputat", nil);
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
    NSURL* feedUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://oblsovet.y.od.ua/json/?object=deputat&action=list"]];
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

                                          if (JSONError) {
                                              UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry", nil) message:NSLocalizedString(@"Bad connection", nil)  delegate: self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                              [errorAlert show];
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          }
                                          else{
                                              dispatch_async(dispatch_get_main_queue(),^{
//                                                  NSLog(@"YES %@",json);
                                                  [_items removeAllObjects];
                                                  _items = jsonResultsArray;
                                                  NSLog(@"--------- %@",_items);
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
    return _items.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeputatsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeputatsListTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DeputatsListTableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeputatsListTableViewCell"];
    }
    cell.name_lab.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"caption"];
    cell.work_lab.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"work"];
    cell.work_lab.numberOfLines = 2;
    NSString *identifier = [NSString stringWithFormat:@"Celltde__%ld", (long)indexPath.row];
    if (([self.cachedFeedImages objectForKey:identifier] == nil)) {
        [self imageThumb:[[_items objectAtIndex:indexPath.row] objectForKey:@"photo"] andImageView:cell.logo index:indexPath.row];
    }
    else    {
        cell.logo.image = [self.cachedFeedImages valueForKey:identifier];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [self storyboard];
    DeputatsDetailsInfoViewController*controller =  [storyBoard instantiateViewControllerWithIdentifier:@"DeputatsDetailsInfoViewController"];
    controller.name_str = [[_items objectAtIndex:indexPath.row] objectForKey:@"caption"];
    controller.work_str = [[_items objectAtIndex:indexPath.row] objectForKey:@"work"];
    controller.education_str = [[_items objectAtIndex:indexPath.row] objectForKey:@"education"];
    controller.takepart_str = [[_items objectAtIndex:indexPath.row] objectForKey:@"part"];
    controller.photo_str = [[_items objectAtIndex:indexPath.row] objectForKey:@"photo"];
    controller.id_str = [[_items objectAtIndex:indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)imageThumb:(NSString*)link andImageView:(UIImageView*)imgName index:(long)ind
{
    NSURLRequest* avatarRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:link] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    NSCachedURLResponse* cachedImageResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:avatarRequest];
    //    imgName.backgroundColor = [UIColor lightGrayColor];
    if (cachedImageResponse) {
        imgName.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithData:[NSMutableData dataWithData:[cachedImageResponse data]]]];
    } else {
        
        NSString *identifier = [NSString stringWithFormat:@"Celltde__%ld", ind];
        
        if (([self.cachedFeedImages objectForKey:identifier] != nil)) {
            imgName.hidden = NO;
            imgName.alpha = 1;
            imgName.image = [self.cachedFeedImages valueForKey:identifier];
        } else {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            NSURLSession *imgLoadSession = [NSURLSession sharedSession];
            NSURLSessionDownloadTask *getImageTask = [imgLoadSession downloadTaskWithURL:[NSURL URLWithString:link] completionHandler:^(NSURL *location,NSURLResponse *response, NSError *error){
                
                UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    [self.cachedFeedImages setValue:downloadedImage forKey:identifier];
                    
                    if ([[NSString stringWithFormat:@"Celltde__%ld", ind]isEqualToString:identifier]){
                        imgName.image = [self.cachedFeedImages valueForKey:identifier] ;
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    }
                });
            }];
            //            [imgName setContentMode:UIViewContentModeScaleAspectFit];
            
            [getImageTask resume];
        }
        
    }
}

@end
