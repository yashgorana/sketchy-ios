//
//  ViewController.m
//  Sketchy Final
//
//  Created by Yash Gorana on 30/03/14.
//  Copyright (c) 2014 Yash Gorana. All rights reserved.
//

#import "ViewController.h"
#import "NEOColorPickerViewController.h"
#import "BlurryModalSegue.h"
#import "UIImage+ImageEffects.h"
#import "Sketchy.h"
#import "FXBlurView.h"
#import "ProgressHUD.h"

@interface ViewController ()  <NEOColorPickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet FXBlurView *blurView;

@end

@implementation ViewController

bool dynamics;

#pragma mark View Initialization methods

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //sketchView = [[Sketchy alloc] initWithFrame:self.view.frame];
    
    red = green = blue = 0.0;
    
    {
        self.toolbar.hidden = YES;
        self.toolbar.alpha = 0;
        
        self.brushMode.hidden = YES;
        self.brushMode.alpha = 0;
        
        self.pencilMode.hidden = YES;
        self.pencilMode.alpha = 0;
        
        self.penMode.hidden = YES;
        self.penMode.alpha = 0;
        
        self.eraserMode.hidden = YES;
        self.eraserMode.alpha = 0;
        
        self.customMode.hidden = YES;
        self.customMode.alpha = 0;
        
        self.colorPicker.hidden = YES;
        self.colorPicker.alpha = 0;
        
        self.blurView.hidden = YES;
        self.blurView.alpha = 0;
        
        self.brushPreview.hidden = YES;
        self.brushPreview.alpha = 0;
        
        self.brushControl.hidden = YES;
        self.brushControl.alpha = 0;
        
        self.brushValueLabel.hidden = YES;
        self.brushValueLabel.alpha = 0;
        
        
        self.blurView.dynamic = YES;
        self.blurView.blurRadius = 20;
        self.blurView.tintColor = [UIColor blackColor];
        self.blurView.updateInterval = 0.8f;
        
        self.brushPreview.layer.shadowColor = [UIColor colorWithRed:0.29803921568627 green:0.29803921568627 blue:0.29803921568627 alpha:1.0].CGColor;
        self.brushPreview.layer.shadowOffset = CGSizeMake(0, 1);
        self.brushPreview.layer.shadowOpacity = 1;
        self.brushPreview.layer.shadowRadius = 1.0;
    }
    
    self.brushMode.selected = true;
    previousButton = self.brushMode;
    dynamics = NO;
    
    [(Sketchy*)self.view setBrushSize:self.brushControl.value withDynamics:dynamics];
    [(Sketchy*)self.view setBrushColor:[UIColor blackColor] withBlendMode:kCGBlendModeNormal];
    [self sliderChanged:self.brushControl];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Gesture Recognizer Methods

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (motion == UIEventSubtypeMotionShake)
    {
        [(Sketchy*)self.view clearContext];
    }
}


#pragma mark Custom View Methods

- (void)showOverlay:(BOOL)really withBlurView:(BOOL)blur animated:(BOOL)animationEnabled {
    
    [self.view.layer removeAllAnimations];
    
    self.showToolsButton.selected = really;
    
    if (animationEnabled) {
        if (really)
        {
            self.blurView.hidden = self.toolbar.hidden = self.brushMode.hidden = self.pencilMode.hidden = self.penMode.hidden = self.eraserMode.hidden = self.customMode.hidden = self.colorPicker.hidden = !really;
            
            self.brushPreview.alpha = self.brushControl.alpha = self.brushValueLabel.alpha = 0;
            
            
            self.brushPreview.hidden = self.brushControl.hidden = self.brushValueLabel.hidden = really;
            
            if (blur == YES) {
                
                [UIView animateWithDuration:0.8
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     self.blurView.alpha = 1;
                                 }
                                 completion:NULL
                 ];
            }
            
            [UIView animateWithDuration:0.2
                                  delay:0.1
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.toolbar.alpha = 1;
                             }
                             completion:NULL
             ];
            
            [UIView animateWithDuration:0.1
                                  delay:0.2
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^(void){
                                 self.brushMode.alpha = 1;
                             }
                             completion:NULL
             ];
            
            [UIView animateWithDuration:0.1
                                  delay:0.3
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^(void){
                                 self.penMode.alpha = 1;
                             }
                             completion:NULL
             ];
            
            [UIView animateWithDuration:0.1
                                  delay:0.4
                                options:UIViewAnimationOptionCurveLinear
                             animations:^(void){
                                 self.customMode.alpha = 1;
                             }
                             completion:NULL
             ];
            
            [UIView animateWithDuration:0.1
                                  delay:0.5
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^(void){
                                 self.colorPicker.alpha = 1;
                             }
                             completion:NULL
             ];
            
            [UIView animateWithDuration:0.1
                                  delay:0.6
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^(void){
                                 self.eraserMode.alpha = 1;
                             }
                             completion:NULL
             ];
            
            [UIView animateWithDuration:0.1
                                  delay:0.7
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^(void){
                                 self.pencilMode.alpha = 1;
                             }
                             completion:NULL
             ];
            
        }
        else
        {
            [UIView animateWithDuration:0.1
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.pencilMode.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 self.pencilMode.hidden = !really;
                             }
             ];
            
            [UIView animateWithDuration:0.1
                                  delay:0.1
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.eraserMode.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 self.eraserMode.hidden = !really;
                             }
             ];
            
            [UIView animateWithDuration:0.1
                                  delay:0.2
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.colorPicker.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 self.colorPicker.hidden = !really;
                             }
             ];
            
            [UIView animateWithDuration:0.1
                                  delay:0.3
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.customMode.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 self.customMode.hidden = !really;
                             }
             ];
            
            [UIView animateWithDuration:0.1
                                  delay:0.4
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.penMode.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 self.penMode.hidden = !really;
                             }
             ];
            
            [UIView animateWithDuration:0.1
                                  delay:0.5
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.brushMode.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 self.brushMode.hidden = !really;
                             }
             ];
            
            if (blur == NO) {
                
                [UIView animateWithDuration:0.2
                                      delay:0.6
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     self.toolbar.alpha = 0;
                                 }
                                 completion:^(BOOL finished) {
                                     
                                     self.toolbar.hidden = !really;
                                 }
                 ];
                
                [UIView animateWithDuration:0.8
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     self.blurView.alpha = 0;
                                 }
                                 completion:^(BOOL finished) {
                                     
                                     self.blurView.hidden = !really;
                                 }
                 ];
            }
        }
    }
    else
    {
        self.showToolsButton.selected = YES;
        if(really)
        {
            self.blurView.alpha = self.toolbar.alpha = self.brushMode.alpha = self.pencilMode.alpha = self.penMode.alpha = self.eraserMode.alpha = self.customMode.alpha = self.colorPicker.alpha = 1;
            
            self.blurView.hidden = self.toolbar.hidden = self.brushMode.hidden = self.pencilMode.hidden = self.penMode.hidden = self.eraserMode.hidden = self.customMode.hidden = self.colorPicker.hidden = !really;
        }
        else
        {
            self.blurView.alpha = self.toolbar.alpha = self.brushMode.alpha = self.pencilMode.alpha = self.penMode.alpha = self.eraserMode.alpha = self.customMode.alpha = self.colorPicker.alpha = 0;
            
            self.blurView.hidden = self.toolbar.hidden = self.brushMode.hidden = self.pencilMode.hidden = self.penMode.hidden = self.eraserMode.hidden = self.customMode.hidden = self.colorPicker.hidden = !really;
        }
    }
}

- (void)getComponentsOfColor:(UIColor*)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    red = components[0];
    green = components[1];
    blue = components[2];
    
    //NSLog(@"%f, %f, %f", red, green, blue);
}

- (void)selectDeselectUIButton:(UIButton*)sender {
    
    sender.selected = YES;
    
    if (previousButton == sender) {
        
        [previousButton setSelected:YES];
    }
    else {
        [previousButton setSelected:NO];
    }
    previousButton = sender;
}

#pragma mark IBActions

- (IBAction)brushTapped:(id)sender {
    
    [self selectDeselectUIButton:(UIButton*)sender];
    
    self.brushControl.value = 10.0f;
    self.brushControl.minimumValue = 3.0f;
    self.brushControl.maximumValue = 100.0f;
    
    red = green = blue = 0;
    
    dynamics = NO;
    [self sliderChanged:self.brushControl];
    [(Sketchy*)self.view setBrushSize:self.brushControl.value withDynamics:dynamics];
    [(Sketchy*)self.view setBrushColor:[UIColor blackColor] withBlendMode:kCGBlendModeNormal];
}

- (IBAction)penTapped:(id)sender {
    
    [self selectDeselectUIButton:(UIButton*)sender];
    
    self.brushControl.minimumValue = 3.0f;
    self.brushControl.maximumValue = 5.0f;
    self.brushControl.value = 3.0f;
    red = 0.250000f;
    green = 0.325000f;
    blue = 1.000000f;
    
    [self sliderChanged:self.brushControl];
    dynamics = YES;
    [(Sketchy*)self.view setBrushSize:self.brushControl.value withDynamics:dynamics];
    
    [(Sketchy*)self.view setBrushColor:[UIColor colorWithRed:red green:green blue:blue alpha:1] withBlendMode:kCGBlendModeNormal];
}

- (IBAction)customizeBrushTapped:(id)sender {
    
    [self showOverlay:NO withBlurView:YES animated:YES];
    
    [UIView animateWithDuration:0.4
                          delay:0.7
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.brushPreview.alpha = 1;
                         self.brushControl.alpha = 1;
                         self.brushValueLabel.alpha = 1;
                     }
                     completion:NULL
     ];
    
    
    self.brushPreview.hidden = self.brushControl.hidden = self.brushValueLabel.hidden = NO;
    
}

- (IBAction)showTools:(UIButton *)sender {
    
    
    [FXBlurView setUpdatesEnabled];
    
    sender.selected = !sender.selected;
    
    [self showOverlay:[sender isSelected] withBlurView:[sender isSelected] animated:YES];
    
    
    if (sender.selected == YES) {
        [(Sketchy*)self.view setUserInteractionOnCanvasEnabled:NO];
    }
    else
        
        [(Sketchy*)self.view setUserInteractionOnCanvasEnabled:YES];
    
}

- (IBAction)showColorPicker:(UIButton *)sender {
    
    [FXBlurView setUpdatesDisabled];
    
    NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];
    controller.delegate = self;
    controller.selectedColor = self.view.backgroundColor;
    controller.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    controller.title = @"Color Picker";
    
    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:controller];
    navVC.navigationBar.translucent = NO;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        self.popover = [[UIPopoverController alloc] initWithContentViewController:navVC];
        self.popover.delegate = self;
        [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    else
    {
        [self presentViewController:navVC animated:YES completion:nil];
    }
}

- (IBAction)eraserTapped:(id)sender {
    
    [self selectDeselectUIButton:(UIButton*)sender];
    
    self.brushControl.maximumValue = 100.0f;
    self.brushControl.minimumValue = 3.0f;
    dynamics = NO;
    
    red = blue = green = 1.0f;
    
    [(Sketchy*)self.view setBrushSize:self.brushControl.value withDynamics:dynamics];
    [(Sketchy*)self.view setBrushColor:[UIColor clearColor] withBlendMode:kCGBlendModeClear];
    [self sliderChanged:self.brushControl];
}

- (IBAction)pencilTapped:(id)sender {
    
    [self selectDeselectUIButton:(UIButton*)sender];
    
    self.brushControl.maximumValue = 10.0f;
    self.brushControl.minimumValue = 1.0f;
    self.brushControl.value = 1.0f;
    
    
    dynamics = NO;
    
    red = blue = green = 85.0f/255.0f;
    [self sliderChanged:self.brushControl];
    
    [(Sketchy*)self.view setBrushSize:self.brushControl.value withDynamics:dynamics];
    [(Sketchy*)self.view setBrushColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.0f] withBlendMode:kCGBlendModeNormal];
    
}

- (IBAction)showImageChooser:(id)sender {
    
    [FXBlurView setUpdatesDisabled];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Close" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", @"Paste From Clipboard",  nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)sliderChanged:(id)sender {
    
    brushSize = self.brushControl.value;
    
    [(Sketchy*)self.view setBrushSize:brushSize withDynamics:dynamics];
    
    self.brushValueLabel.text = [NSString stringWithFormat:@"%.1f", self.brushControl.value];
    self.brushPreview.layer.shadowOffset = CGSizeMake(0, 1+self.brushControl.value/50);
    self.brushPreview.layer.shadowRadius = 1.0 + (self.brushControl.value/20);
    
    //  Draw brush size circle here
    // UIGraphicsBeginImageContext(self.brushPreview.frame.size);                                       // Begin image context
    UIGraphicsBeginImageContextWithOptions(self.brushPreview.frame.size, NO, 0);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);                                // Draw circle
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),self.brushControl.value);                                     // Set diameter of circle to value of slider
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 50, 50);                                        // Make center as 50,50
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 50, 50);                                     // Draw line through center
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());                                                 // Paint the circle
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();                                 // Display the circle in image view
    UIGraphicsEndImageContext();
}


#pragma mark Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    UIImage *image;
    // image picker needs a delegate,
    [imagePickerController setDelegate:self];
    
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            else
                NSLog(@"no camera.");
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
            break;
            
        case 1:
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
                self.popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
                self.popover.delegate = self;
                //[self.popover presentPopoverFromBarButtonItem:[(Sketchy*)self.view importButton] permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
                
                [self.popover presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
            }
            else
                [self presentViewController:imagePickerController animated:YES completion:nil];
            
            break;
            
        case 2:
            image = [UIPasteboard generalPasteboard].image;
            if (image) {
                
                [(Sketchy*)self.view setImageFromPhotoLibrary:image];
                [ProgressHUD showSuccess:nil];
            }
            else
            {
                [ProgressHUD showError:@"Nothing On Clipboard."];
            }
            
            break;
            
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [(Sketchy*)self.view setImageFromPhotoLibrary:image];
    
    image = nil;
    
    
    [FXBlurView setUpdatesEnabled];
}

- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color {
    
    // get color components of uicolor and mimic as if we changed the slider to get new brushpreview
    [self getComponentsOfColor:color];
    [self sliderChanged:self.brushControl];
    
    [(Sketchy*)self.view setBrushColor:color withBlendMode:kCGBlendModeNormal];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        [self.popover dismissPopoverAnimated:YES];
    else
        [controller dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
    
	if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        [self.popover dismissPopoverAnimated:YES];
    else
        [controller dismissViewControllerAnimated:YES completion:nil];
    
    [FXBlurView setUpdatesEnabled];
}


#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
