//
//  DocsInsideViewController.h
//  Oblsovet
//
//  Created by Gotlib on 04.10.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickLook/QuickLook.h"
@interface DocsInsideViewController : UIViewController<QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *web_view;
@property (strong, nonatomic)NSString* url_file;
@end
