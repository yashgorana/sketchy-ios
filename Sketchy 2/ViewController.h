//
//  ViewController.h
//  Sketchy Final
//
//  Created by Yash Gorana on 30/03/14.
//  Copyright (c) 2014 Yash Gorana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPopoverControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    CGFloat brushSize;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    UIButton *previousButton;
}
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (weak, nonatomic) IBOutlet UIButton *brushMode;
@property (weak, nonatomic) IBOutlet UIButton *pencilMode;
@property (weak, nonatomic) IBOutlet UIButton *penMode;
@property (weak, nonatomic) IBOutlet UIButton *eraserMode;
@property (weak, nonatomic) IBOutlet UIButton *customMode;
@property (weak, nonatomic) IBOutlet UIButton *colorPicker;
@property (weak, nonatomic) IBOutlet UIButton *showToolsButton;

@property (weak, nonatomic) IBOutlet UIImageView *brushPreview;
@property (weak, nonatomic) IBOutlet UISlider *brushControl;
@property (weak, nonatomic) IBOutlet UILabel *brushValueLabel;

@property (nonatomic, strong) UIPopoverController * popover;

- (IBAction)brushTapped:(id)sender;
- (IBAction)penTapped:(id)sender;
- (IBAction)customizeBrushTapped:(id)sender;
- (IBAction)showColorPicker:(UIButton *)sender;
- (IBAction)eraserTapped:(id)sender;
- (IBAction)pencilTapped:(id)sender;
- (IBAction)showTools:(UIButton *)sender;

- (IBAction)showImageChooser:(id)sender;

- (IBAction)sliderChanged:(id)sender;

- (void)showOverlay:(BOOL)really withBlurView:(BOOL)blur animated:(BOOL)animationEnabled;
- (void)getComponentsOfColor:(UIColor*)color;
- (void)selectDeselectUIButton:(UIButton*)sender;

@end
