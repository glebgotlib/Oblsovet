//
//  CommissionDetailsViewController.m
//  Oblsovet
//
//  Created by Gotlib on 22.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import "CommissionDetailsViewController.h"
#import "DeputatTableViewCell.h"
#import "ScaduleOfCommissionTableViewCell.h"
#import "DocListTableViewController.h"
@interface CommissionDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong ,nonatomic) NSMutableDictionary *cachedFeedImages;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation CommissionDetailsViewController
{
    NSMutableArray *jsonResultsArray;
    int selector;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.cachedFeedImages = [[NSMutableDictionary alloc] init];
    [mTable delegate];
    [mTable dataSource];
    self.navigationItem.title = _selectorName;
    NSLog(@"ID== %@",_selectedId);
    if ([_object isEqualToString:@"presidium"] || [_object isEqualToString:@"sovet"] || [_object isEqualToString:@"comission"]) {
        selector = 1;
        [self eventsFuture];
    }
    else{
        selector = 0;
        [self feedLine];
    }
    swither.selectedSegmentIndex = selector;
    if([_object isEqualToString:@"depgroup"])
    {
        UILabel*labq = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 20)];
        labq.text = self.selectorName;
        labq.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:labq];
        [swither setHidden:YES];
    }
    
    // Do any additional setup after loading the view.
}
#pragma mark -
#pragma mark Request
-(void)feedLine
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [jsonResultsArray removeAllObjects];
    
//    reload input views
    NSURL* feedUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://oblsovet.y.od.ua/json/?object=%@&action=deputat&id=%@",_object,_selectedId]];
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
                                          NSDictionary* json;
                                          jsonResultsArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &JSONError];
                                          json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
                                          NSLog(@"feedLine  - - - %@",json);
                                          if (JSONError) {
                                              UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry", nil) message:NSLocalizedString(@"Bad connection", nil)  delegate: self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                              [errorAlert show];
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          }
                                          else{
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@"YES %@",json);
                                                  [_items removeAllObjects];
                                                  if([_object isEqualToString:@"comission"])
                                                  {
                                                      _items = [[NSMutableArray alloc] init];
                                                      if ([[json objectForKey:@"golova"] isKindOfClass:[NSDictionary class]]) {
                                                      NSDictionary* dict = [json objectForKey:@"golova"];
                                                          [_items addObject:dict];
                                                      }
                                                      if ([[json objectForKey:@"zam"] isKindOfClass:[NSDictionary class]]) {
                                                          NSDictionary* dict = [json objectForKey:@"zam"];
                                                          [_items addObject:dict];
                                                      }
                                                      if ([[json objectForKey:@"secretar"] isKindOfClass:[NSDictionary class]]) {
                                                          NSDictionary* dict = [json objectForKey:@"secretar"];
                                                          [_items addObject:dict];
                                                      }
                                                    
                                                      NSMutableArray*arr = [json objectForKey:@"list"];
                                                      for (int i = 0; i<arr.count; i++) {
                                                          [_items addObject:[arr objectAtIndex:i]];
                                                      }
                                                  }
                                                  else if([_object isEqualToString:@"fraction"])
                                                  {
                                                      if ([[json objectForKey:@"lider"] isKindOfClass:[NSDictionary class]]) {
                                                          NSDictionary* dict = [json objectForKey:@"lider"];
                                                          _items = [[NSMutableArray alloc] initWithObjects:dict, nil];
                                                      }
                                                      else
                                                      {
                                                          _items = [[NSMutableArray alloc] init];
                                                      }
                                                      NSMutableArray*arr = [json objectForKey:@"list"];
                                                      for (int i = 0; i<arr.count; i++) {
                                                          [_items addObject:[arr objectAtIndex:i]];
                                                      }
                                                  }
                                                  else if([_object isEqualToString:@"depgroup"])
                                                  {
                                                      if ([[json objectForKey:@"predsedatel"] isKindOfClass:[NSDictionary class]]) {
                                                          NSDictionary* dict = [json objectForKey:@"predsedatel"];
                                                          _items = [[NSMutableArray alloc] initWithObjects:dict, nil];
                                                      }
                                                      else
                                                      {
                                                          _items = [[NSMutableArray alloc] init];
                                                      }
                                                      NSMutableArray*arr = [json objectForKey:@"list"];
                                                      for (int i = 0; i<arr.count; i++) {
                                                          [_items addObject:[arr objectAtIndex:i]];
                                                      }
                                                  }
                                                  else{
                                                      _items = jsonResultsArray;
                                                  }
                                                  NSLog(@"--------- %@",_items);
                                                  [mTable reloadData];
                                                  
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selector    ==  0) {
        return 100;
    }
    else
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selector    ==  0) {
        static NSString *CellIdentifier = @"DeputatTableViewCell";
        DeputatTableViewCell *cell = (DeputatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DeputatTableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if([_object isEqualToString:@"comission"])
        {
            [cell.status_lab setHidden:NO];
            if (indexPath.row == 0) {
                cell.status_lab.text =  NSLocalizedString(@"Head", nil);
            }
            if (indexPath.row == 1) {
                cell.status_lab.text =  NSLocalizedString(@"Zam", nil);
            }
            if (indexPath.row == 2) {
                cell.status_lab.text =  NSLocalizedString(@"Secretar", nil);
            }
        }
        else if([_object isEqualToString:@"fraction"])
        {
            [cell.status_lab setHidden:NO];
            if (indexPath.row == 0) {
                cell.status_lab.text =  @"Лидер фракции";
            }
        }
        else{
            [cell.status_lab setHidden:YES];
        }
        cell.name_label.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"caption"];
        cell.job_lab.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"work"];
        
        NSString *identifier = [NSString stringWithFormat:@"Celltde__%ld", (long)indexPath.row];
        if (([self.cachedFeedImages objectForKey:identifier] == nil)) {
            [self imageThumb:[[_items objectAtIndex:indexPath.row] objectForKey:@"photo"] andImageView:cell.img index:indexPath.row];
        }
        else    {
            cell.img.image = [self.cachedFeedImages valueForKey:identifier];
        }

        return cell;
    }
    else  if (selector    ==  1)  {
        static NSString *CellIdentifier = @"ScaduleOfCommissionTableViewCell";
        ScaduleOfCommissionTableViewCell *cell1 = (ScaduleOfCommissionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell1 == nil) {
            cell1 = [[ScaduleOfCommissionTableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell1.date_lab.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"date"];
        //cell1.caption_lab.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"caption"];
        
        return cell1;
    }
    else   {
        static NSString *CellIdentifier = @"ScaduleOfCommissionTableViewCell";
        ScaduleOfCommissionTableViewCell *cell2 = (ScaduleOfCommissionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell2 == nil) {
            cell2 = [[ScaduleOfCommissionTableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell2.date_lab.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"date"];
        //cell2.caption_lab.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"caption"];
        
        return cell2;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selector    !=      0 && ![_object isEqualToString:@"fraction"]) {
        UIStoryboard *storyBoard = [self storyboard];
        DocListTableViewController*controller = [storyBoard instantiateViewControllerWithIdentifier:@"DocListTableViewController"];
        controller.id_str = [[_items objectAtIndex:indexPath.row] objectForKey:@"id"];
        controller.object = _object;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//http://oblsovet.y.od.ua/json/?object=comission&action=timetable&id=1&type=new

- (IBAction)switchTap:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        NSLog(@"1");
        selector = 0;
        [self feedLine];
        
    }
    else if (selectedSegment == 1)   {
        //toggle the correct view to be visible
        NSLog(@"2");
        selector = 1;
        [self eventsFuture];
    }
    else    {
        NSLog(@"3");
        selector = 2;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
