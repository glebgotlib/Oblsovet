//
//  DeputatDetailsViewController.m
//  Oblsovet
//
//  Created by Gotlib on 28.09.16.
//  Copyright © 2016 Yog.group. All rights reserved.
//

#import "DeputatDetailsViewController.h"

@interface DeputatDetailsViewController ()
@property (strong ,nonatomic) NSMutableDictionary *cachedFeedImages;

@end

@implementation DeputatDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

@end
