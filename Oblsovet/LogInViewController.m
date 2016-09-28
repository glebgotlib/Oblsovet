//
//  LogInViewController.m
//  Oblsovet
//
//  Created by Gotlib on 20.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import "LogInViewController.h"
#import "MainTableViewController.h"
@interface LogInViewController ()<UITextFieldDelegate>

@end

@implementation LogInViewController
{
    NSMutableArray *jsonResultsArray;
    NSDictionary* json;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_logIn_button setTitle:@"Шалом!" forState:UIControlStateNormal];
    _login_textfield.delegate = self;
    _login_textfield.returnKeyType = UIReturnKeyDone;
    _login_textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _login_textfield.autocorrectionType = UITextAutocorrectionTypeNo;
    
    _pass_textfield.delegate = self;
    _pass_textfield.returnKeyType = UIReturnKeyGo;
    _pass_textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pass_textfield.autocorrectionType = UITextAutocorrectionTypeNo;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_login_textfield resignFirstResponder];
    [_pass_textfield resignFirstResponder];
    return NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    NSString* str = _login_textfield.text;
    NSLog(@"login_textfield ---%@",str);
}
/*
 http://oblsovet.y.od.ua/json/?object=deputat&action=login&login=ivanov&password=123456
*/

- (IBAction)log_in_action:(UIButton *)sender {
    if (![_login_textfield.text isEqualToString:@""]    &&    ![_pass_textfield.text isEqualToString:@""]) {
        NSLog(@"sdfsdfsdfsd %@",_login_textfield.text);
        [self feedLine];
    }
}

#pragma mark -
#pragma mark Request
-(void)feedLine
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    NSURL* feedUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://oblsovet.y.od.ua/json/?object=deputat&action=login&login=%@&password=%@",_login_textfield.text,_pass_textfield.text]];
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
                                          json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
                                          jsonResultsArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &JSONError];
                                          //NSLog(@"feedLine  - - - %@",json);
                                          if (JSONError) {
                                              UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry", nil) message:NSLocalizedString(@"Bad connection", nil)  delegate: self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                              [errorAlert show];
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          }
                                          else{
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@"YES %@",jsonResultsArray);
                                                   [[NSUserDefaults standardUserDefaults] setObject:[[jsonResultsArray objectAtIndex:0] objectForKey:@"cookievar"] forKey:@"preferenceName"];
                                                  UIStoryboard *storyBoard = [self storyboard];
                                                  MainTableViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"MainTableViewController"];
                                                  [self.navigationController pushViewController:controller animated:YES];
                                                  
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
@end
