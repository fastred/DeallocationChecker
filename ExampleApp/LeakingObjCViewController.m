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
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [DeallocationCheckerManager.shared checkDeallocationWithDefaultDelayOf:self];
}

@end
