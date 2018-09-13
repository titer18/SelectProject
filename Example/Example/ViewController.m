//
//  ViewController.m
//  Example
//
//  Created by HZ on 2018/9/12.
//  Copyright © 2018年 HZ. All rights reserved.
//

#import "ViewController.h"
#import <SelectProject/SelectProjectViewController.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SelectProjectViewController *vc = [[SelectProjectViewController alloc] init];
        [vc selectProjectAction:^(NSString *projectName, NSString *projectID) {
            
        }];
        [self presentViewController:vc animated:YES completion:nil];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
