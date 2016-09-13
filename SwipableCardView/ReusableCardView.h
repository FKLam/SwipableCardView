//
//  ReusableCardView.h
//  SwipableCardView
//
//  Created by Marc Nieto on 8/31/16.
//  Copyright © 2016 KandidProductions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"

@protocol ReusableCardViewDelegate <NSObject>

- (void)topCardSwiped;

@end

@interface ReusableCardView : UIView <SwipeViewDelegate>

@property (nonatomic, weak) id <ReusableCardViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet SwipeView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftDismissButton;
@property (weak, nonatomic) IBOutlet UIButton *rightDismissButton;


- (void)changeLabelWithValue:(int)value;

@end
