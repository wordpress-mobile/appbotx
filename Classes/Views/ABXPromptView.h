//
//  ABXPromptView.h
//  Sample Project
//
//  Created by Stuart Hall on 30/05/2014.
//  Copyright (c) 2014 Appbot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABXPromptViewDelegate <NSObject>

- (void)appbotPromptLiked;
- (void)appbotPromptDidntLike;
- (void)appbotPromptForReview;
- (void)appbotPromptForFeedback;
- (void)appbotPromptClose;

@end

@interface ABXPromptView : UIView

@property (weak) id<ABXPromptViewDelegate> delegate;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

+ (BOOL)hasHadInteractionForCurrentVersion;

@end