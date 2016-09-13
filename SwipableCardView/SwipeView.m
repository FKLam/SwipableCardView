//
//  SwipeView.m
//  SwipableCardView
//
//  Created by Marc Nieto on 8/31/16.
//  Copyright © 2016 KandidProductions. All rights reserved.
//

#import "SwipeView.h"

@implementation SwipeView {
    CGPoint originalCenter;
    CGFloat originalX;
    CGFloat translationX;
    CGFloat screenWidth;
    CGFloat screenHeight;
    BOOL markCompleteOnSwipeRelease;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self setupSwipeGesture];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self setupSwipeGesture];
    
    return self;
}

-(void)setupSwipeGesture {
    screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    screenHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);

    self.swipeGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    self.swipeGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.swipeGestureRecognizer];
}

#pragma mark - Gesture Delegate Methods

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if(self.swipeEnabled){
        CGPoint translation = [gestureRecognizer translationInView:[self superview]];

        if (translation.x != 0 ) {
            return YES;
        }
        else if(translation.y != 0) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        return NO;
    }
}

#pragma mark - Gesture

- (void)swipeAction:(UIPanGestureRecognizer *)swipeRecognizer
{
    if (swipeRecognizer.state == UIGestureRecognizerStateBegan) {
        originalCenter = self.center;
        originalX = CGRectGetMinX(self.frame);
    }
    else if (swipeRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [swipeRecognizer translationInView:self];
        
        self.center = CGPointMake(originalCenter.x + translation.x, originalCenter.y + translation.y);
        self.alpha = 1 - (0.3 * (fabs(translation.x) / (screenWidth/2)));
        
        if(translation.x < 0){
            self.leftSwipeOverlayView.alpha = 0.3 * (fabs(translation.x) / (screenWidth/2));
        }
        else if(translation.x > 0){
            self.rightSwipeOverlayView.alpha = 0.3 * (fabs(translation.x) / (screenWidth/2));
        }
        
        CGFloat rotationStrength = MIN(translation.x / 320, 1);
        CGFloat rotationAngle = M_PI/4 * rotationStrength;
        CGFloat scaleStrength = 1 - fabs(rotationStrength) / 4;
        CGFloat scale = MAX(scaleStrength, 0.93);
        CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngle);
        CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
        self.transform = scaleTransform;
        
        translationX = translation.x;
        markCompleteOnSwipeRelease = fabs(translation.x) >= screenWidth * 0.20;
    }
    else if (swipeRecognizer.state == UIGestureRecognizerStateEnded) {
        if(!markCompleteOnSwipeRelease) {

            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.center = originalCenter;
                                 self.alpha = 1.0;
                                 self.transform = CGAffineTransformIdentity;
                                 
                                 self.leftSwipeOverlayView.alpha = 0;
                                 self.rightSwipeOverlayView.alpha = 0;
                             }
             ];
            
        }
        else {            
            [self dismissCardWithFactor: translationX/fabs(translationX)];
            
            id <SwipeViewDelegate> delegate = self.delegate;
            
            if([delegate respondsToSelector:@selector(topCardSwiped)]) {
                [delegate topCardSwiped];
            }
            
        }
    }
}

- (void)dismissCardWithFactor:(CGFloat)factor {
    UIView *overlay;
    CGRect frame = CGRectMake(originalX + (factor * screenHeight), self.bounds.origin.y,
                              CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    if(factor < 0){
        overlay = self.leftSwipeOverlayView;
    }
    else {
        overlay = self.rightSwipeOverlayView;
    }
    
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.frame = frame;
                         self.transform = CGAffineTransformMakeRotation(factor * M_PI/2);
                         self.alpha = 0.4;
                         overlay.alpha = 0.6;
                     }
     ];
}

#pragma mark - Layout Setup Methods

- (void)setupLeftSwipeOverlayView:(UIView *)view {
    self.leftSwipeOverlayView = view;
    self.leftSwipeOverlayView.alpha = 0.0;
    [self insertSubview:self.leftSwipeOverlayView aboveSubview:self];
}

- (void)setupRightSwipeOverlayView:(UIView *)view {
    self.rightSwipeOverlayView = view;
    self.rightSwipeOverlayView.alpha = 0.0;
    [self insertSubview:self.rightSwipeOverlayView aboveSubview:self];
}

@end
