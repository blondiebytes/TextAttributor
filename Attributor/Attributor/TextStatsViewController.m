//
//  TextStatsViewController.m
//  Attributor
//
//  Created by Kathryn Hodge on 6/24/14.
//  Copyright (c) 2014 Kathryn Hodge Software. All rights reserved.
//

#import "TextStatsViewController.h"

@interface TextStatsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *colorfulCharactersLabel;
@property (weak, nonatomic) IBOutlet UILabel *outlinedCharactersLabel;

@end

@implementation TextStatsViewController

//TESTING!

//-(void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.textToAnalyze = [[NSAttributedString alloc] initWithString:@"test" attributes:@{NSForegroundColorAttributeName: [UIColor greenColor], NSStrokeWidthAttributeName: @-3}];
// }

-(void)setTextToAnalyze:(NSAttributedString *)textToAnalyze
{
    _textToAnalyze = textToAnalyze;
    if (self.view.window) [self updateUI];
    //if nil, not on screen
    //if I'm on screen update UI, otherwise let viewWillAppear do it
    //common pattern here:
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}


-(NSAttributedString *)charactersWithAttribute:(NSString *)attributeName
{
    NSMutableAttributedString *characters = [[NSMutableAttributedString alloc] init];
    
    //while loop to collect the characters
    
    NSInteger index = 0;
    while (index < [self.textToAnalyze length]) {
        //we want to capture the range
        NSRange range;
        id value = [self.textToAnalyze attribute:attributeName atIndex:index effectiveRange: &range];
        //id because color/outline/etc.
        //capturing the range
        //the value is the outlined/colored characters
        
        //if there are characters --> append them to the list
        if (value) {
            [characters appendAttributedString: [self.textToAnalyze attributedSubstringFromRange: range]];
            index = range.location + range.length; //jumping to the end of the range
        } else {
            //then just move on to the next character
            index++;
        }
    }
    
    return characters;
}


-(void)updateUI
{
    self.colorfulCharactersLabel.text = [NSString stringWithFormat: @"%lu colorful characters", (unsigned long)[[self charactersWithAttribute:NSForegroundColorAttributeName] length]];
    self.outlinedCharactersLabel.text = [NSString stringWithFormat: @"%lu outlined characters", (unsigned long)[[self charactersWithAttribute:NSStrokeWidthAttributeName] length]];
    
}



@end
