//
//  LeakingObjCViewController.m
//  Example
//
//  Created by Arkadiusz Holko on 22/09/2018.
//  Copyright © 2018 Arkadiusz Holko. All rights reserved.
//

#import "LeakingObjCViewController.h"
@import DeallocationChecker;

static LeakingObjCViewController *retained;

@interface LeakingObjCViewController ()

@end

@implementation LeakingObjCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    retained = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:true];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [DeallocationCheckerManager.shared checkDeallocationWithDefaultDelayOf:self];
}

@end
