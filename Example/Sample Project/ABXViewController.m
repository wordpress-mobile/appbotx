//
//  ABXViewController.m
//  Sample Project
//
//  Created by Stuart Hall on 21/05/2014.
//  Copyright (c) 2014 Appbot. All rights reserved.
//

#import "ABXViewController.h"

#import "ABX.h"
#import "ABXPromptView.h"
#import "NSString+ABXLocalized.h"
#import "UIViewController+ABXScreenshot.h"

@interface ABXViewController ()<ABXPromptViewDelegate>

@property (nonatomic, strong) ABXPromptView *promptView;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@end

@implementation ABXViewController

static NSString* const kiTunesID = @"650762525";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // The prompt view is an example workflow using AppbotX
    // It's also good to only show it after a positive interaction
    // or a number of usages of the app
    if (![ABXPromptView hasHadInteractionForCurrentVersion]) {
        self.promptView = [[ABXPromptView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 100, CGRectGetWidth(self.view.bounds), 100)];
        self.promptView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.promptView];
        self.promptView.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.frame), 460)];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - Buttons

- (IBAction)onFetchNotifications:(id)sender
{
    [ABXNotificationView fetchAndShowInController:self
                                  backgroundColor:[UIColor colorWithRed:0x86/255.0f green:0xcc/255.0f blue:0xf1/255.0f alpha:1]
                                        textColor:[UIColor blackColor]
                                      buttonColor:[UIColor whiteColor]
                                         complete:^(BOOL shown) {
                                             // Here you may want to chain fetching versions
                                             // if it wasn't shown
                                         }];
}

- (IBAction)onFetchVersions:(id)sender
{
    [ABXVersion fetch:^(NSArray *versions, ABXResponseCode responseCode, NSInteger httpCode, NSError *error) {
        switch (responseCode) {
            case ABXResponseCodeSuccess: {
                [self showAlert:@"Versions" message:[NSString stringWithFormat:@"Received %ld versions", (unsigned long)versions.count]];
            }
                break;
                
            default: {
                [self showAlert:@"Versions" message:[NSString stringWithFormat:@"%lu", (unsigned long)responseCode]];
            }
                break;
        }
    }];
}

- (IBAction)onFetchCurrentVersion:(id)sender
{
    // This is a convenient wrapper, or dig in and control it yourself
    [ABXVersionNotificationView fetchAndShowInController:self
                                             foriTunesID:kiTunesID
                                         backgroundColor:[UIColor colorWithRed:0xf4/255.0f green:0x7d/255.0f blue:0x67/255.0f alpha:1]
                                               textColor:[UIColor blackColor]
                                             buttonColor:[UIColor whiteColor]
                                                complete:^(BOOL shown) {
                                                    // Here you may want to chain fetching notifications
                                                    // if it wasn't shown
                                                }];
}

- (IBAction)onFetchFAQs:(id)sender
{
    [ABXFaq fetch:^(NSArray *faqs, ABXResponseCode responseCode, NSInteger httpCode, NSError *error) {
        switch (responseCode) {
            case ABXResponseCodeSuccess: {
                [self showAlert:@"FAQs" message:[NSString stringWithFormat:@"Received %ld faqs", (unsigned long)faqs.count]];
            }
                break;
                
            default: {
                [self showAlert:@"FAQs" message:[NSString stringWithFormat:@"%lu", (unsigned long)responseCode]];
            }
                break;
        }
    }];
}

- (IBAction)showFAQs:(id)sender
{
    [ABXFAQsViewController showFromController:self hideContactButton:NO contactMetaData:nil initialSearch:nil];
}

- (IBAction)showVersions:(id)sender
{
    [ABXVersionsViewController showFromController:self];
}

- (IBAction)showNotifications:(id)sender
{
    [ABXNotificationsViewController showFromController:self];
}

- (IBAction)showFeedback:(id)sender
{
    [ABXFeedbackViewController showFromController:self placeholder:nil email:nil metaData:nil image:nil];
}

- (IBAction)showFeedbackWithImage:(id)sender
{
    // An example of the feedback window that you might launch from a 'report an issue' button
    // Where some meta data and a screenshot is attached
    [ABXFeedbackViewController showFromController:self placeholder:nil email:nil metaData:@{ @"BugPrompt" : @YES } image:[self takeScreenshot] ];
}

#pragma mark - Alert

- (void)showAlert:(NSString*)title message:(NSString*)message
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:[@"OK" localizedString]
                      otherButtonTitles:nil] show];
}

#pragma mark - ABXPromptViewDelegate

- (void)appbotPromptForReview
{
    [ABXAppStore openAppStoreReviewForApp:kiTunesID];
    self.promptView.hidden = YES;
}

- (void)appbotPromptForFeedback
{
    [ABXFeedbackViewController showFromController:self placeholder:nil];
    self.promptView.hidden = YES;
}

- (void)appbotPromptClose
{
    self.promptView.hidden = YES;
}

@end
