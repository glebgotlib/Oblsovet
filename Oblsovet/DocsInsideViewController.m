//
//  DocsInsideViewController.m
//  Oblsovet
//
//  Created by Gotlib on 04.10.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import "DocsInsideViewController.h"

@interface DocsInsideViewController ()

@end

@implementation DocsInsideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.web_view loadRequest:[NSMutableURLRequest requestWithURL:[NSURL fileURLWithPath:_url_file]cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:3.0]];
    // Do any additional setup after loading the view.
    NSLog(@"_url_file - %@",_url_file);
    NSURL *myUrl = [NSURL URLWithString:_url_file];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myUrl];
    
    [_web_view loadRequest:myRequest];
}
//    QLPreviewController *previewController=[[QLPreviewController alloc]init];
//    previewController.delegate=self;
//    previewController.dataSource=self;
//    [self presentModalViewController:previewController animated:YES];
//    [previewController.navigationItem setRightBarButtonItem:nil];
//}
//
//- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
//{
//    return 1;
//}
//
//- (id)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask ,YES );
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"sessdocsfile_dok-22_30358.docx"];
//    return [NSURL fileURLWithPath:path];
//}
//
//- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item {
//    return YES;
//}
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
