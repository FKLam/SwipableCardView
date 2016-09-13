//
//  ReusableCardView.m
//  SwipableCardView
//
//  Created by Marc Nieto on 8/31/16.
//  Copyright © 2016 KandidProductions. All rights reserved.
//

#import "ReusableCardView.h"

@implementation ReusableCardView {
    CGFloat widthOfCard;
    CGFloat heightOfCard;
    CGFloat kLeftRightInset;
    CGFloat diameterOfButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [[NSBundle mainBundle] loadNibNamed:@"ReusableCardView" owner:self options:nil];
    self.contentView.bounds = self.bounds;
    [self.contentView.layer setFrame:frame];
    [self addSubview:self.contentView];
    
    [self setupView];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [[NSBundle mainBundle] loadNibNamed:@"ReusableCardView" owner:self options:nil];
    self.contentView.bounds = self.bounds;
    [self addSubview:self.contentView];
    
    [self setupView];
    
    return self;
}

-(void)setupView {
    
    widthOfCard = self.bounds.size.width;
    heightOfCard = self.bounds.size.height;
    kLeftRightInset = 30.0;
    diameterOfButton = 80.0;
    
    /* Buttons */
    [self.leftDismissButton.layer setFrame:CGRectMake(kLeftRightInset, heightOfCard - kLeftRightInset - diameterOfButton, diameterOfButton, diameterOfButton)];
    [self.rightDismissButton.layer setFrame:CGRectMake(widthOfCard - kLeftRightInset - diameterOfButton, heightOfCard - kLeftRightInset - diameterOfButton, diameterOfButton, diameterOfButton)];
    
    self.contentView.layer.cornerRadius = 20;
    self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    self.contentView.layer.borderWidth = 0.5;
   
    self.contentView.delegate = self;
    
    self.leftDismissButton.layer.cornerRadius = (self.leftDismissButton.bounds.size.width / 2);
    self.rightDismissButton.layer.cornerRadius = (self.rightDismissButton.bounds.size.width / 2);
    
    /* Swipe Overlays */
    UIView *leftSwipeOverlayView = [[UIView alloc] initWithFrame:self.bounds];
    UIView *rightSwipeOverlayView = [[UIView alloc] initWithFrame:self.bounds];
    
    leftSwipeOverlayView.layer.cornerRadius = 20;
    rightSwipeOverlayView.layer.cornerRadius = 20;
    
    leftSwipeOverlayView.backgroundColor = [UIColor colorWithRed:214.0/255 green:59.0/255 blue:78.0/255 alpha:1.0];
    rightSwipeOverlayView.backgroundColor = [UIColor colorWithRed:0.0/255 green:192.0/255 blue:49.0/255 alpha:1.0];
    
    [self.contentView setupLeftSwipeOverlayView:leftSwipeOverlayView];
    [self.contentView setupRightSwipeOverlayView:rightSwipeOverlayView];
}

-(void)changeLabelWithValue:(int)value {
    NSString *labelText = [NSString stringWithFormat:@"Card #%d", value];
    self.cardLabel.text = labelText;
    [self.cardLabel sizeToFit];
    self.cardLabel.center = CGPointMake(widthOfCard/2, heightOfCard/2);
}

- (IBAction)leftButtonPressed:(id)sender {
    [self.contentView dismissCardWithFactor:-1];
    [self topCardSwiped];
}

- (IBAction)rightButtonPressed:(id)sender {
    [self.contentView dismissCardWithFactor:1];
    [self topCardSwiped];
}

- (void)topCardSwiped {
    id <ReusableCardViewDelegate> delegate = self.delegate;
    
    if([delegate respondsToSelector:@selector(topCardSwiped)]) {
        [delegate topCardSwiped];
    }
}



@end
