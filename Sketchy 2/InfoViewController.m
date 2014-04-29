//
//  InfoViewController.m
//  Sketchy Final
//
//  Created by Yash Gorana on 29/04/14.
//  Copyright (c) 2014 Yash Gorana. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self.licenseView  setTextContainerInset:UIEdgeInsetsMake(50, 20, 0, 20)];
    else
    {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        [self.licenseView  setTextContainerInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL) prefersStatusBarHidden
{
    return YES;
}

- (IBAction)closePressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
