//
//  NewsDetailsViewController.m
//  Oblsovet
//
//  Created by Gotlib on 19.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import "NewsDetailsViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface NewsDetailsViewController ()

@end

@implementation NewsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    _web_view.backgroundColor = UIColorFromRGB(0xfbfbdc);
    [_web_view setBackgroundColor:UIColorFromRGB(0xfbfbdc)];
    [_web_view setOpaque:NO];
    _lab_title.numberOfLines = 2;
    _lab_title.text = _description_title_text;
    [_web_view loadHTMLString:_description_html_text baseURL:nil];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];


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
