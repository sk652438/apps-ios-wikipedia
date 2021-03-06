//  Created by Monte Hurd on 1/23/14.
//  Copyright (c) 2013 Wikimedia Foundation. Provided under MIT-style license; please copy and modify!

#import <UIKit/UIKit.h>

@interface LanguagesTableVC : UITableViewController<UITextFieldDelegate>

-(CATransition *)getTransition;

@property (nonatomic) BOOL downloadLanguagesForCurrentArticle;

@property (nonatomic, copy) void (^selectionBlock)(NSDictionary *);

@end
