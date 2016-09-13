//
//  SwipeView.h
//  SwipableCardView
//
//  Created by Marc Nieto on 8/31/16.
//  Copyright © 2016 KandidProductions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwipeViewDelegate <NSObject>

- (void)topCardSwiped;

@end

@interface SwipeView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <SwipeViewDelegate> delegate;
@property (nonatomic, strong) UIPanGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UIView *leftSwipeOverlayView;
@property (nonatomic, strong) UIView *rightSwipeOverlayView;
@property BOOL swipeEnabled;

- (void)dismissCardWithFactor:(CGFloat)factor;
- (void)setupLeftSwipeOverlayView:(UIView *)view;
- (void)setupRightSwipeOverlayView:(UIView *)view;

@end
