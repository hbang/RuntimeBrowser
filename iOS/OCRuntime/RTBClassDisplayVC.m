//
//  ClassDisplayViewController.m
//  RuntimeBrowser
//
//  Created by Nicolas Seriot on 31.08.08.
//  Copyright 2008 seriot.ch. All rights reserved.
//

#import "RTBClassDisplayVC.h"
#import "RTBAppDelegate.h"
#import "RTBObjectsTVC.h"
#import "NSString+SyntaxColoring.h"
#import "RTBRuntimeHeader.h"

@interface RTBClassDisplayVC () <UIDocumentPickerDelegate>

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) UIBarButtonItem *useButton;

@end

@implementation RTBClassDisplayVC

- (void)use:(id)sender {

	[self dismissViewControllerAnimated:YES completion:^{
        
        RTBAppDelegate *appDelegate = (RTBAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate useClass:self.className];
    }];
}

- (void)save:(id)sender {
    NSURL *url = [self tempFileURL];
    [self.textView.attributedText.string writeToURL:url atomically:NO encoding:NSUTF8StringEncoding error:nil];

    UIDocumentPickerViewController *viewController = [[UIDocumentPickerViewController alloc] initWithURL:url inMode:UIDocumentPickerModeExportToService];
    [viewController setDelegate:self];
    [[self navigationController] presentViewController:viewController animated:YES completion:nil];
}

- (NSURL *)tempFileURL {
    return [[[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:_className ?: _protocolName] URLByAppendingPathExtension:@"h"];
}

- (void)dismissModalView:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.textView.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];

    if (_className != nil) {
        self.useButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Use", nil) style:UIBarButtonItemStylePlain target:self action:@selector(use:)];
        if (@available(iOS 13, *)) {
            if ([UIImage respondsToSelector:@selector(systemImageNamed:)]) {
                self.useButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"lightbulb"] style:UIBarButtonItemStylePlain target:self action:@selector(use:)];
            }
        }
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissModalView:)];

    NSMutableArray <UIBarButtonItem *> *items = [NSMutableArray array];
    if (self.useButton != nil) {
        [items addObject:self.useButton];
    }
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(save:)]];
    self.navigationItem.leftBarButtonItems = items;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
	self.textView.text = @"";
    self.title = _className ? _className : _protocolName;
	
//	// FIXME: ??
//	NSArray *forbiddenClasses = [NSArray arrayWithObjects:@"NSMessageBuilder", /*, @"NSObject", @"NSProxy", */@"Object", @"_NSZombie_", nil];
//	
//	self.useButton.enabled = ![forbiddenClasses containsObject:self.className];
    self.useButton.enabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
	self.textView.text = @"";
    
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *header = nil;
    
    if(_className) {
        BOOL displayPropertiesDefaultValues = [[NSUserDefaults standardUserDefaults] boolForKey:@"RTBDisplayPropertiesDefaultValues"];
        header = [RTBRuntimeHeader headerForClass:NSClassFromString(self.className) displayPropertiesDefaultValues:displayPropertiesDefaultValues];
    } else if (_protocolName) {
        RTBProtocol *p = [RTBProtocol protocolStubWithProtocolName:_protocolName];
        header = [RTBRuntimeHeader headerForProtocol:p];
    }
    
    NSString *keywordsPath = [[NSBundle mainBundle] pathForResource:@"Keywords" ofType:@"plist"];
	
	NSArray *keywords = [NSArray arrayWithContentsOfFile:keywordsPath];
    
    NSAttributedString *as = [header colorizeWithKeywords:keywords classes:nil colorize:YES];
    
    self.textView.attributedText = as;
}

#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    [[NSFileManager defaultManager] moveItemAtURL:[self tempFileURL] toURL:url error:nil];
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    [[NSFileManager defaultManager] removeItemAtURL:[self tempFileURL] error:nil];
}

@end
