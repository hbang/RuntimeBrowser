//
//  RTBSplitViewController.m
//  OCRuntime
//
//  Created by Adam Demasi on 8/5/21.
//  Copyright © 2021 Nicolas Seriot. All rights reserved.
//

#import "RTBSplitViewController.h"

@interface RTBSplitViewController () <UISplitViewControllerDelegate>

@end

@implementation RTBSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
}

#pragma mark - UISplitViewControllerDelegate

- (UISplitViewControllerColumn)splitViewController:(UISplitViewController *)splitViewController topColumnForCollapsingToProposedTopColumn:(UISplitViewControllerColumn)proposedTopColumn  API_AVAILABLE(ios(14.0)) {
    if (@available(iOS 14.0, *)) {
        return UISplitViewControllerColumnPrimary;
    }
    return 0;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

@end
