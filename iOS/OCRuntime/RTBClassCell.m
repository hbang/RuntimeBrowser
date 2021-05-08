//
//  ClassCell.m
//  RuntimeBrowser
//
//  Created by Nicolas Seriot on 13.08.08.
//  Copyright 2008 seriot.ch. All rights reserved.
//

#import "RTBClassCell.h"
#import "RTBClassDisplayVC.h"

@interface RTBClassCell ()
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIButton *button;
@end

@implementation RTBClassCell

- (void)setClassName:(NSString *)s {
    _label.text = s;

    if (@available(iOS 13, *)) {
        if ([UIImage respondsToSelector:@selector(systemImageNamed:)]) {
            [self.button setImage:[UIImage systemImageNamed:@"doc.text.fill"] forState:UIControlStateNormal];
        }
    }
}

- (NSString *)className {
    return _label.text;
}

- (IBAction)showHeaders:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RTBClassDisplayVC *classDisplayVC = (RTBClassDisplayVC *)[sb instantiateViewControllerWithIdentifier:@"RTBClassDisplayVC"];
    classDisplayVC.className = _label.text;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:classDisplayVC];

    UISplitViewController *splitViewController = [self splitViewController];
    [splitViewController showDetailViewController:navigationController sender:self];
}

- (UISplitViewController *)splitViewController {
    UIResponder *responder = self;
    while (![responder isKindOfClass:UIViewController.class]) {
        responder = [responder nextResponder];
    }
    return [(UIViewController *)responder splitViewController];
}

@end
