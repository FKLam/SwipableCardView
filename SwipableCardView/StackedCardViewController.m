//
//  StackedCardViewController.m
//  SwipableCardView
//
//  Created by Marc Nieto on 8/31/16.
//  Copyright © 2016 KandidProductions. All rights reserved.
//

#import "StackedCardViewController.h"
#import "InitialViewController.h"
#import "ReusableCardView.h"

static NSString * const kShowInitialViewIdentifier = @"showInitialViewController";

/* Question Card Constraints */
static const CGFloat kTopBottomCardInset = 50.0;
static const CGFloat kLeftRightCardInset = 30.0;
static const CGFloat kSpaceFromTopCard = 6.0;
static const CGFloat kBottomCardScale = 0.92;

@interface StackedCardViewController () <ReusableCardViewDelegate>

/* Reusable Card properties */
@property NSMutableArray *cards;
@property int currentCardIndex;

@end

@implementation StackedCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Cards stored in this array */
    self.cards = [[NSMutableArray alloc] init];
    self.currentCardIndex = 0;
    
    /* Math to make sure the bottom card is always shows by 10px on all devices */
    CGFloat heightOfTopCard = self.view.bounds.size.height - (2.0 * kTopBottomCardInset);
    CGFloat bottomOfTopCard = kTopBottomCardInset + heightOfTopCard;
    CGFloat heightOfBottomCard = kBottomCardScale * heightOfTopCard;
    CGFloat topOfBottomCard = kTopBottomCardInset + ((heightOfTopCard - heightOfBottomCard) / 2.0);
    CGFloat bottomOfBottomCard = topOfBottomCard + heightOfBottomCard;
    
    CGFloat distanceFromCenter = (bottomOfTopCard + kSpaceFromTopCard) - (bottomOfBottomCard);
    
    /* Setup Top Card */
    ReusableCardView *newCardView = [[ReusableCardView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - (2*kLeftRightCardInset), self.view.bounds.size.height - (2*kTopBottomCardInset))];

    newCardView.center = self.view.center;
    [newCardView changeLabelWithValue:self.currentCardIndex + 1];
    [newCardView.contentView setSwipeEnabled:YES];
    newCardView.delegate = self;
    
    [self.view addSubview:newCardView];
    [self addCardToQueue:newCardView];
    
    /* Setup Bottom Cards */
    for(int i = 1; i < self.numCards; i++){
        ReusableCardView *newBottomCardView = [[ReusableCardView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - (2*kLeftRightCardInset), self.view.bounds.size.height - (2*kTopBottomCardInset))];
        
        newBottomCardView.center = CGPointMake(self.view.center.x, self.view.center.y + distanceFromCenter);
        CGAffineTransform transform = newBottomCardView.transform;
        transform = CGAffineTransformScale(transform, kBottomCardScale, kBottomCardScale);
        newBottomCardView.transform = transform;
        
        [newBottomCardView changeLabelWithValue:self.currentCardIndex + 1];
        [newBottomCardView.contentView setSwipeEnabled:NO];
        newBottomCardView.delegate = self;
        
        
        newBottomCardView.contentView.alpha = 0.5;
        
        if(i > 1){
            newBottomCardView.alpha = 0.0;
        }
        else {
            [self.view insertSubview:newBottomCardView belowSubview:self.cards[self.currentCardIndex - 1]];
        }
        
        [self addCardToQueue:newBottomCardView];
    }
    
    self.currentCardIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Card View Setup Methods

- (void)addCardToQueue:(ReusableCardView *)card{
    [self.cards addObject:card];
    self.currentCardIndex++;
}

# pragma mark - ReusableCardView Delegate

- (void)topCardSwiped {
    ReusableCardView *currentCard = self.cards[self.currentCardIndex];
    
    if(self.currentCardIndex < (self.numCards - 2)){
        ReusableCardView *bottomCard = self.cards[self.currentCardIndex + 1];
        ReusableCardView *secondFromBottomCard = self.cards[self.currentCardIndex + 2];
        
        [self.view insertSubview:secondFromBottomCard belowSubview:bottomCard];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            bottomCard.transform = CGAffineTransformIdentity;
            bottomCard.center = self.view.center;
            bottomCard.contentView.alpha = 1.0;
            
            secondFromBottomCard.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            [currentCard removeFromSuperview];
            
            [bottomCard.contentView setSwipeEnabled:YES];
            self.currentCardIndex++;
            
        }];
    }
    else if(self.currentCardIndex < (self.numCards - 1)){
        ReusableCardView *bottomCard = self.cards[self.currentCardIndex + 1];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            bottomCard.transform = CGAffineTransformIdentity;
            bottomCard.center = self.view.center;
            bottomCard.contentView.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            [currentCard removeFromSuperview];
            
            [bottomCard.contentView setSwipeEnabled:YES];
            self.currentCardIndex++;
            
        }];
    }
    else {
        /* all cards dismissed */
        [currentCard removeFromSuperview];
        [self performSegueWithIdentifier:kShowInitialViewIdentifier sender:self];
        
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kShowInitialViewIdentifier]) {
        [segue destinationViewController];
    }
}

@end
