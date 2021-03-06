//  Created by Monte Hurd on 4/21/14.
//  Copyright (c) 2013 Wikimedia Foundation. Provided under MIT-style license; please copy and modify!

#import "PreviewChoicesMenuView.h"
#import "PaddedLabel.h"
#import "WikipediaAppUtils.h"
#import "NSString+FormattedAttributedString.h"
#import "BundledJson.h"

#define PREVIEW_BLUE_COLOR [UIColor colorWithRed:0.13 green:0.42 blue:0.68 alpha:1.0]

//#import "NSString+Extras.h"
//#import "UIView+Debugging.h"

@interface PreviewChoicesMenuView(){

}

@property (weak, nonatomic) IBOutlet UIView *topRowContainer;

@end

@implementation PreviewChoicesMenuView

// Load PreviewChoicesMenuView.xib
- (id) awakeAfterUsingCoder:(NSCoder*)aDecoder {

    BOOL isPlaceholder = ([[self subviews] count] == 0); // From: https://blog.compeople.eu/apps/?p=142
    if (!isPlaceholder) return self;
    
    UINib *previewChoicesMenuViewNib = [UINib nibWithNibName:@"PreviewChoicesMenuView" bundle:nil];
    
    PreviewChoicesMenuView *previewChoicesMenuView =
        [[previewChoicesMenuViewNib instantiateWithOwner:nil options:nil] firstObject];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    previewChoicesMenuView.translatesAutoresizingMaskIntoConstraints = NO;
    
    return previewChoicesMenuView;
}

-(void)didMoveToSuperview
{
    UIEdgeInsets padding = UIEdgeInsetsZero;
    self.signInTitleLabel.padding = padding;
    self.signInSubTitleLabel.padding = padding;
    self.saveAnonTitleLabel.padding = padding;
    self.saveAnonSubTitleLabel.padding = padding;

    self.saveAnonTitleLabel.text = MWLocalizedString(@"wikitext-upload-save-anonymously", nil);
    self.saveAnonSubTitleLabel.text = MWLocalizedString(@"wikitext-upload-save-anonymously-warning", nil);
    self.signInTitleLabel.text = MWLocalizedString(@"wikitext-upload-save-sign-in", nil);
    self.signInSubTitleLabel.text = MWLocalizedString(@"wikitext-upload-save-sign-in-benefits", nil);
    
    self.signInView.backgroundColor = PREVIEW_BLUE_COLOR;
    
    [self underlineLabelText: self.signInTitleLabel];

    /*
    self.signInTitleLabel.text = [@" abc " randomlyRepeatMaxTimes:100];
    self.signInSubTitleLabel.text = [@" abc " randomlyRepeatMaxTimes:100];
    self.saveAnonTitleLabel.text = [@" abc " randomlyRepeatMaxTimes:100];
    self.saveAnonSubTitleLabel.text = [@" abc " randomlyRepeatMaxTimes:100];
    [self randomlyColorSubviews];
    */

    if ([self isAnonymousEditingDisabled]) {
        [self.saveAnonView removeFromSuperview];
        // The right side of the signInView had been constrained to the left side of the
        // saveAnonView, but now that the saveAnonView is gone the right side of the
        // signInView needs to be constrained to the right side of the topRowContainer.
        [self.topRowContainer addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat: @"H:[signInView]|"
                                                 options: 0
                                                 metrics: nil
                                                   views: @{@"signInView" : self.signInView}]
         ];
    }else{
        [self underlineLabelText: self.saveAnonTitleLabel];
    }
}

-(void)underlineLabelText:(UILabel *)label
{
    NSMutableAttributedString *aString =
        [[NSMutableAttributedString alloc] initWithString:label.text attributes:nil];
    
    NSRange wholeRange = NSMakeRange(0, label.text.length);
    
    [aString beginEditing];
    [aString addAttribute:NSForegroundColorAttributeName value:label.textColor range:wholeRange];
    [aString addAttribute:NSFontAttributeName value:label.font range:wholeRange];
    [aString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:wholeRange];
    [aString endEditing];
    
    label.attributedText = aString;
}

-(BOOL)isAnonymousEditingDisabled
{
    NSDictionary *iosConfigJson = [BundledJson dictionaryFromBundledJsonFile:BUNDLED_JSON_CONFIG];
    NSNumber *disableAnonEditing = iosConfigJson[@"disableAnonEditing"];
    if (disableAnonEditing && (disableAnonEditing.boolValue == YES)) {
        return YES;
    }
    return NO;
}

@end
