//
//  AttributorViewController.m
//  Attributor
//
//  Created by Kathryn Hodge on 6/23/14.
//  Copyright (c) 2014 Kathryn Hodge Software. All rights reserved.
//

#import "AttributorViewController.h"
#import "TextStatsViewController.h"

@interface AttributorViewController ()

@property (weak, nonatomic) IBOutlet UITextView *body;
@property (weak, nonatomic) IBOutlet UILabel *headLine;
@property (weak, nonatomic) IBOutlet UIButton *outlineButton;

@end

@implementation AttributorViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Analyze Text"])
    {
        if ([segue.destinationViewController isKindOfClass:[TextStatsViewController class]]) {
            TextStatsViewController *tsvc = (TextStatsViewController *)segue.destinationViewController;
            //giving it our info
            tsvc.textToAnalyze = self.body.textStorage;
            //attributed string = mutuable attributed string 
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableAttributedString *title =
    [[NSMutableAttributedString alloc] initWithString:self.outlineButton.currentTitle];
    [title setAttributes: @{NSStrokeWidthAttributeName :@+3,
                            NSStrokeColorAttributeName : self.outlineButton.tintColor}
                   range: NSMakeRange(0, [title length])
     ];
    [self.outlineButton setAttributedTitle:title forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self usePreferredFonts]; //sync's back up with the world
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredFontsChanged:)
                                                 name: UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    //update if notified
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object: nil];
    //use this in case you make another one where you don't want it to disappear (although that's rare)
}

-(void)preferredFontsChanged:(NSNotification *)notification
{
    [self usePreferredFonts];
    //encapsulate so we can call usePreferredFonts in viewWillAppear
}


-(void)usePreferredFonts {
    self.body.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    //if it had any attributed traits then you have to re-iterate them here (bold, etc.)
    
    self.headLine.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}


- (IBAction)changeBodySelectionColorToMatchBackgroundOfButton:(UIButton *)sender
{
    [self.body.textStorage addAttribute:NSForegroundColorAttributeName
                                  value:sender.backgroundColor
                                  range:self.body.selectedRange];
}



- (IBAction)outlineBodySelection {
    
    [self.body.textStorage addAttributes:@{NSStrokeWidthAttributeName :@-3, NSStrokeColorAttributeName : [UIColor blackColor]} range:self.body.selectedRange];
}
//stroke width of three and also fill --> +3 is just stroke



- (IBAction)unoutlineBodySelection
{
    [self.body.textStorage removeAttribute:NSStrokeWidthAttributeName
                                     range:self.body.selectedRange];
    
    //no need to worry about color
    
}

- (IBAction)touchResetButton:(id)sender
{
    [self.body.textStorage removeAttribute: NSStrokeWidthAttributeName range:self.body.selectedRange];
    [self.body.textStorage removeAttribute:NSForegroundColorAttributeName range:self.body.selectedRange];
}


@end
