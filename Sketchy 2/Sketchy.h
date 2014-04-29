//
//  Sketchy.h
//  Sketchy Final
//
//  Created by Yash Gorana on 30/03/14.
//  Copyright (c) 2014 Yash Gorana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
enum
{
	DRAW					= 0,
	EDIT                    = 1,
    LOAD                    = 2,
    NONE                    = 3,
};

@interface Sketchy : UIView  {
    
    void *cacheBitmap;
    
    CGContextRef cacheContext;
    
    CGFloat lineWidth, originalLineWidth;
    
    CGPoint point1;
    CGPoint point2;
    CGPoint point3;
    
    UIColor *color;
    
    NSMutableArray *undoArray;
    NSMutableArray *redoArray;
    
    int drawMode;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveImageButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *importButton;

- (BOOL)initContext:(CGSize)size;
- (void)drawToCache;

- (void)clearContext;
- (void)setUserInteractionOnCanvasEnabled:(BOOL)enabled;
- (void)setBrushColor:(UIColor*)selectedColor withBlendMode:(CGBlendMode)blendMode;
- (void)setImageFromPhotoLibrary:(UIImage*)image;
- (void)setBrushSize: (CGFloat)size withDynamics:(BOOL)dynamics;

- (IBAction)resetPressed:(id)sender;
- (IBAction)undoPressed:(id)sender;
- (IBAction)redoPressed:(id)sender;
- (IBAction)saveImage:(id)sender;

CGPoint midPoint(CGPoint p1, CGPoint p2);

@end
