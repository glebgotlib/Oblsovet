//
//  DeputatsDetailsInfoViewController.m
//  Oblsovet
//
//  Created by Gotlib on 28.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import "DeputatsDetailsInfoViewController.h"
#import "ListOfCommissionsTableViewCell.h"
@interface DeputatsDetailsInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong ,nonatomic) NSMutableDictionary *cachedFeedImages;
@property (nonatomic, strong) NSMutableArray *items;



@end

@implementation DeputatsDetailsInfoViewController
{
    NSDictionary* sovet_dict;
    NSDictionary* presidium_dict;
    NSDictionary* fraction_dict;
    NSMutableArray* depgroup_arr;
    NSDictionary* comission_dict;
    int selector;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_mTable delegate];
    [_mTable dataSource];
    self.cachedFeedImages = [[NSMutableDictionary alloc] init];
    NSString *identifier = [NSString stringWithFormat:@"Celltde__111"];
    if (([self.cachedFeedImages objectForKey:identifier] == nil)) {
        [self imageThumb:_photo_str andImageView:_logo index:111];
    }
    else    {
        _logo.image = [self.cachedFeedImages valueForKey:identifier];
    }
    _name_lab.text = _name_str;
    _work_lab.text = _work_str;
    _education_lab.text = _education_str;
    _takepart_lab.text = _takepart_str;
    [self feedLine];
}
#pragma mark -
#pragma mark Request
-(void)feedLine
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [jsonResultsArray removeAllObjects];
    
    //    reload input views
    NSURL* feedUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://oblsovet.y.od.ua/json/?object=deputat&action=info&id=%@",_id_str]];
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
                                                  NSLog(@"YES %@",json);
                                                  sovet_dict = [json objectForKey:@"sovet"];
                                                  presidium_dict = [json objectForKey:@"presidium"];
                                                  fraction_dict = [json objectForKey:@"fraction"];
                                                  depgroup_arr = [json objectForKey:@"depgroup"];
                                                  comission_dict = [json objectForKey:@"comission"];
                                                   _items = [[NSMutableArray alloc] initWithObjects:comission_dict, nil];
//                                                  [_items addObject:sovet_dict];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ListOfCommissionsTableViewCell";
    ListOfCommissionsTableViewCell *cell = (ListOfCommissionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ListOfCommissionsTableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"caption"];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)switchTap:(UISegmentedControl *)sender {
        UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
        NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
//        [_items removeAllObjects];
    
        if (selectedSegment == 0) {
            //toggle the correct view to be visible
            NSLog(@"1");
            selector = 0;
            _items = [[NSMutableArray alloc] initWithObjects:comission_dict, nil];
        }
        else if (selectedSegment == 1)   {
            //toggle the correct view to be visible
            NSLog(@"2");
            selector = 1;
            _items = [[NSMutableArray alloc] initWithObjects:presidium_dict, nil];
        }
        else if (selectedSegment == 2)   {
            //toggle the correct view to be visible
            NSLog(@"3");
            selector = 1;
            _items = [[NSMutableArray alloc] initWithObjects:sovet_dict, nil];
        }
        else if (selectedSegment == 3)   {
            //toggle the correct view to be visible
            NSLog(@"4");
            selector = 1;
            _items = [[NSMutableArray alloc] initWithObjects:fraction_dict, nil];
        }
        else    {
            NSLog(@"5");
            selector = 2;
            _items = depgroup_arr;
        }
    [_mTable reloadData];
}
@end
