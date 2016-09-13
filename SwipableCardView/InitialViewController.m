//
//  InitialViewController.m
//  SwipableCardView
//
//  Created by Marc Nieto on 9/2/16.
//  Copyright © 2016 KandidProductions. All rights reserved.
//

#import "InitialViewController.h"
#import "StackedCardViewController.h"

static NSString * const kShowStackedCardViewIdentifier = @"showStackedCardViewController";

@interface InitialViewController ()

@property (weak, nonatomic) IBOutlet UITextField *numCardTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.doneButton.layer.cornerRadius = 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kShowStackedCardViewIdentifier]) {
        StackedCardViewController *stackedCardViewController = [segue destinationViewController];
        stackedCardViewController.numCards = [self.numCardTextField.text intValue];
    }
}

#pragma mark - Actions

- (IBAction)doneButtonPressed:(id)sender {
    int number = [self.numCardTextField.text intValue];
    
    if(number >= 1 && number <= 20){
        [self performSegueWithIdentifier:kShowStackedCardViewIdentifier sender:self];
    }
    else {
        NSLog(@"Must be between 1 and 20");
    }
}


@end
