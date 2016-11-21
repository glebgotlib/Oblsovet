//
//  MessDetailsViewController.m
//  Oblsovet
//
//  Created by Gotlib on 05.10.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import "MessDetailsViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MessDetailsViewController ()

@end

@implementation MessDetailsViewController
{
    NSDateFormatter *dateFormatter;
    NSURL* feedUrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    if(_ansver  !=  0){
        if(_wasansvwred == 0)
        {
            _yes_button.enabled = YES;
            _no_button.enabled = YES;
        }
        else{
            _yes_button.enabled = NO;
            _no_button.enabled = NO;
        }

    }
    else{
        _yes_button.enabled = NO;
        _no_button.enabled = NO;
    }
    
    
    _title_lab.text = _title_str;
    _date_lab.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[_date_str intValue]]];
    [_web_view setBackgroundColor: UIColorFromRGB(0xfbfbdc)];
    _web_view.backgroundColor = UIColorFromRGB(0xfbfbdc);
    [_web_view setBackgroundColor:UIColorFromRGB(0xfbfbdc)];
    [_web_view setOpaque:NO];
    [_web_view loadHTMLString:_web_str baseURL:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;

    NSLog(@"WEB = %@",_web_str);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Request
-(void)feedLine:(NSURL*)url
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [jsonResultsArray removeAllObjects];
    
    //    reload input views
//    NSURL* feedUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://oblsovet.y.od.ua/json/?object=deputat&action=messages&cookievar=%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"preferenceName"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"headUrl: %@", url);
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
                                          NSLog(@"----------- %@",data);
//                                          jsonResultsArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &JSONError];
                                            //json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
                                          
                                          if (JSONError) {
                                              UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry", nil) message:NSLocalizedString(@"Bad connection", nil)  delegate: self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                              [errorAlert show];
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          }
                                          else{
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                 // NSLog(@"YES %@",json);
                                                  UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", nil) message:NSLocalizedString(@"Message_send", nil)  delegate: self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                                  [errorAlert show];

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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)yes_button_action:(UIButton *)sender {
    [self feedLine:[NSURL URLWithString:[NSString stringWithFormat:@"http://oblsovet.y.od.ua/json/?object=deputat&action=answer&cookievar=%@&quest=%@&answer=1",[[NSUserDefaults standardUserDefaults] stringForKey:@"preferenceName"],_quest_str]]];
    _yes_button.enabled = NO;
    _no_button.enabled = NO;
}
- (IBAction)no_button_action:(UIButton *)sender {
        [self feedLine:[NSURL URLWithString:[NSString stringWithFormat:@"http://oblsovet.y.od.ua/json/?object=deputat&action=answer&cookievar=%@&quest=%@&answer=2",[[NSUserDefaults standardUserDefaults] stringForKey:@"preferenceName"],_quest_str]]];
    _yes_button.enabled = NO;
    _no_button.enabled = NO;
}
@end
