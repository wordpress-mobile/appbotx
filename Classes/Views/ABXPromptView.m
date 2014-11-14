//
//  ABXPromptView.m
//  Sample Project
//
//  Created by Stuart Hall on 30/05/2014.
//  Copyright (c) 2014 Appbot. All rights reserved.
//

#import "ABXPromptView.h"

#import "NSString+ABXLocalized.h"

@interface ABXPromptView ()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, assign) BOOL step2;
@property (nonatomic, assign) BOOL liked;

@end

@implementation ABXPromptView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialise];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialise];
    }
    return self;
}

#pragma mark - Setup

- (void)initialise
{
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 100)];
    self.container.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.container.backgroundColor = [UIColor clearColor];
    [self addSubview:self.container];
    self.container.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.container.bounds), 52)];
    self.label.textColor = [UIColor colorWithRed:50/255.0f green:65/255.0f blue:85/255.0f alpha:1.0f];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 0;
    self.label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    
    self.label.text = NSLocalizedString(@"What do you think about WordPress?", @"This is the string we display when prompting the user to review the app");
    [self.container addSubview:self.label];
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(CGRectGetMidX(self.container.bounds) - 135, 50, 130, 30);
    self.leftButton.backgroundColor = [UIColor colorWithRed:0/255.0f green:170/255.0f blue:220/255.0f alpha:1.0f];

    self.leftButton.layer.cornerRadius = 4;
    self.leftButton.layer.masksToBounds = YES;
    [self.leftButton setTitle:NSLocalizedString(@"I Like It", @"This is one of the buttons we display inside of the prompt to review the app") forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.leftButton addTarget:self action:@selector(onLove) forControlEvents:UIControlEventTouchUpInside];
    [self.container addSubview:self.leftButton];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(CGRectGetMidX(self.container.bounds) + 5, 50, 130, 30);
    self.rightButton.backgroundColor = [UIColor colorWithRed:144/255.0f green:174/255.0f blue:194/255.0f alpha:1.0f];
    self.rightButton.layer.cornerRadius = 4;
    self.rightButton.layer.masksToBounds = YES;
    [self.rightButton setTitle:NSLocalizedString(@"Could Be Better", @"This is one of the buttons we display inside of the prompt to review the app") forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.rightButton.titleLabel.textColor = [UIColor colorWithRed:50/255.0f green:65/255.0f blue:85/255.0f alpha:1.0f];
    [self.rightButton addTarget:self action:@selector(onImprove) forControlEvents:UIControlEventTouchUpInside];
    [self.container addSubview:self.rightButton];
}

#pragma mark - Buttons

- (void)onLove
{
    if (self.step2) {
        [[self class] setHasHadInteractionForCurrentVersion];
        if (self.liked && self.delegate && [self.delegate respondsToSelector:@selector(appbotPromptForReview)]) {
            [self.delegate appbotPromptForReview];
        }
        else if (!self.liked && self.delegate && [self.delegate respondsToSelector:@selector(appbotPromptForFeedback)]) {
            [self.delegate appbotPromptForFeedback];
        }
    }
    else {
        [self.delegate appbotPromptLiked];
        self.liked = YES;
        self.step2 = YES;
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.label.text = NSLocalizedString(@"Great! Could you leave us a nice review?\r\nIt really helps.", @"This is the text we display to the user when we ask them for a review and they've indicated they like the app");
                             [self.leftButton setTitle:NSLocalizedString(@"Leave a Review", @"This is one of the buttons we display when prompting the user for a review")forState:UIControlStateNormal];
                             [self.rightButton setTitle:NSLocalizedString(@"No Thanks", @"This is one of the buttons we display when prompting the user for a review") forState:UIControlStateNormal];
                         }];
    }
}

- (void)onImprove
{
    if (self.step2) {
        [[self class] setHasHadInteractionForCurrentVersion];
        if (self.delegate && [self.delegate respondsToSelector:@selector(appbotPromptClose)]) {
            [self.delegate appbotPromptClose];
        }
    }
    else {
        [self.delegate appbotPromptDidntLike];
        self.liked = NO;
        self.step2 = YES;
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.label.text = NSLocalizedString(@"Could you tell us how we could improve?", @"This is the text we display to the user when we ask them for a review and they've indicated they don't like the app");
                             [self.leftButton setTitle:NSLocalizedString(@"Send Feedback", @"This is one of the buttons we display when prompting the user for a review") forState:UIControlStateNormal];
                             [self.rightButton setTitle:NSLocalizedString(@"No Thanks", @"This is one of the buttons we display when prompting the user for a review") forState:UIControlStateNormal];
                         }];
    }
}

static NSString* const kInteractionKey = @"ABXPromptViewInteraction";

+ (NSString*)keyForCurrentVersion
{
    NSString *version = NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"] ?: NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"];
    return [kInteractionKey stringByAppendingString:version];
}

+ (BOOL)hasHadInteractionForCurrentVersion
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:[self keyForCurrentVersion]];
}

+ (void)setHasHadInteractionForCurrentVersion
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[self keyForCurrentVersion]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
