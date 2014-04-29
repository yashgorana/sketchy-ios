//
//  InfoViewController.h
//  Sketchy Final
//
//  Created by Yash Gorana on 29/04/14.
//  Copyright (c) 2014 Yash Gorana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController
- (IBAction)closePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *licenseView;

@end
