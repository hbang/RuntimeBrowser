//
//  ClassCell.m
//  RuntimeBrowser
//
//  Created by Nicolas Seriot on 13.08.08.
//  Copyright 2008 seriot.ch. All rights reserved.
//

#import "RTBProtocolCell.h"
#import "RTBClassDisplayVC.h"

@interface RTBProtocolCell ()
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIButton *button;
@end

@implementation RTBProtocolCell

- (void)setProtocolObject:(RTBProtocol *)p {
    _protocolObject = p;
    _label.text = [p protocolName];
    _label.font = [UIFont italicSystemFontOfSize:_label.font.pointSize];
    self.accessoryType = [p hasChildren] ? UITableViewCellAccessoryDetailDisclosureButton : UITableViewCellAccessoryNone;

    if (@available(iOS 13, *)) {
        if ([UIImage respondsToSelector:@selector(systemImageNamed:)]) {
            [self.button setImage:[UIImage systemImageNamed:@"arrow.up.right.diamond.fill"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)showHeaders:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RTBClassDisplayVC *classDisplayVC = (RTBClassDisplayVC *)[sb instantiateViewControllerWithIdentifier:@"RTBClassDisplayVC"];
    classDisplayVC.protocolName = [_protocolObject protocolName];

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
