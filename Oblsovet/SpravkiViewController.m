//
//  SpravkiViewController.m
//  Oblsovet
//
//  Created by Gotlib on 21.11.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import "SpravkiViewController.h"

@interface SpravkiViewController ()

@end

@implementation SpravkiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *websiteUrl = [NSURL URLWithString:@"http://oblsovet.y.od.ua/root//catalogue/?mob=1"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [_web_view loadRequest:urlRequest];
    // Do any additional setup after loading the view.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
