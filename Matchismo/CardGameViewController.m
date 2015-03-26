//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Jeroen Wesbeek on 05/11/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
    self.startButton.enabled=YES;
    
}

- (IBAction)touchStartButton:(UIButton *)sender {
    self.startButton.enabled=NO;
    [self.game resetGame];
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        card.chosen=NO;
        card.matched=NO;
    }

    [self updateUI];
}
- (IBAction)changedGameTypeSegment:(UISegmentedControl *)sender {
    [self.game resetGame];
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    if (selectedSegment == 0) {
        NSLog(@"Selected 2");
        [self.game setGameTypeTo:2];
    }
    else{
        NSLog(@"Selected 3");
        [self.game setGameTypeTo:3];
    }
}
- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    
    // %ld and explicit typecast to long to support 32bit as well as 64bit
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long) self.game.score];
}

- (NSString *)titleForCard:(Card *)card
{
    return (card.isChosen) ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:(card.isChosen) ? @"cardFront" : @"cardBack"];
}

@end
