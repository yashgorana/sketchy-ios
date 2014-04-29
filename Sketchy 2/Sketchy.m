//
//  Sketchy.m
//  Sketchy Final
//
//  Created by Yash Gorana on 30/03/14.
//  Copyright (c) 2014 Yash Gorana. All rights reserved.
//

#import "Sketchy.h"
#import "UIImage-Extensions.h"
#import "ProgressHUD.h"

@implementation Sketchy
{
    CGImageRef cacheImage;
}

BOOL interactionEnabled, brushDynamics;


#pragma mark Init Methods

- (void) initialize {
    //drawingQueue = dispatch_queue_create("drawingQueue", NULL);
    
    if (undoArray == nil) {
        undoArray = [[NSMutableArray alloc] init];
    }
    
    if (redoArray == nil) {
        
        redoArray = [[NSMutableArray alloc] init];
    }
    
    [self initContext:self.bounds.size];
    
    interactionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearContext)];
    tap.numberOfTapsRequired = 2; // Tap twice to clear drawing!
    tap.numberOfTouchesRequired = 2;
    [self addGestureRecognizer:tap];
    
    cacheImage = CGBitmapContextCreateImage(cacheContext);
    [undoArray addObject:(__bridge id)(cacheImage)];
    CGImageRelease(cacheImage);
    
    self.saveImageButton.enabled = false;
    self.undoButton.enabled = false;
    self.redoButton.enabled = false;
}

- (BOOL) initContext:(CGSize)size {
	
	int bitmapByteCount;
	int	bitmapBytesPerRow;
    float scaleFactor = [[UIScreen mainScreen] scale];
    
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow = (size.width * scaleFactor * 4);
	bitmapByteCount = (bitmapBytesPerRow * size.height * scaleFactor);
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	cacheBitmap = malloc( bitmapByteCount );
	if (cacheBitmap == NULL){
		return NO;
	}
    
	//cacheContext = CGBitmapContextCreate (cacheBitmap, size.width, size.height, 8, bitmapBytesPerRow, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipFirst);
    
    cacheContext = CGBitmapContextCreate(cacheBitmap, size.width * scaleFactor, size.height * scaleFactor, 8, bitmapBytesPerRow, CGColorSpaceCreateDeviceRGB(), (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    
    CGContextScaleCTM(cacheContext, scaleFactor, scaleFactor);
    
    
    CGContextSetRGBFillColor(cacheContext, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(cacheContext, self.bounds);
    
	return YES;
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (void) awakeFromNib {
    [self initialize];
}



#pragma mark Touches Methods

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(interactionEnabled){
        drawMode = DRAW;
        
        NSSet *tchs= [event allTouches];
        
        if (tchs.count == 1) {
            
            UITouch *touch = [touches anyObject];
            
            point1 = [touch locationInView:self]; // previous previous point
            point2 = [touch locationInView:self]; // previous touch point
            point3 = [touch locationInView:self]; // current touch point
            
            [self touchesMoved:touches withEvent:event];
        }
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(interactionEnabled){
    
        NSSet *tchs= [event allTouches];
        
        if (tchs.count == 1) {
            
            UITouch *touch = [touches anyObject];
            point1 = point2;
            point2 = point3;
            point3 = [touch locationInView:self];
            [self drawToCache];
        }
        
        //    dispatch_async(drawingQueue, ^{
        //
        //        //do stuff on secondary thread
        //
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //
        //            //update the stuff that you did to the main thread
        //            //[self drawToCache];
        //
        //        });
        //    });
        
    }
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(interactionEnabled){
        
        self.undoButton.enabled = self.saveImageButton.enabled = true;
        self.redoButton.enabled = false;
        
        [redoArray removeAllObjects];
        
        cacheImage = CGBitmapContextCreateImage(cacheContext);
        [undoArray addObject:(__bridge id)(cacheImage)];
        
        if ([undoArray count]>25) {
            [undoArray removeObjectAtIndex:0];
        }
        CGImageRelease(cacheImage);
        
    }
}



#pragma mark Drawing Method

CGPoint midPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (void) drawToCache {
    
    if(interactionEnabled){
        
//        NSLog(@"%@, %@, %@", NSStringFromCGPoint(point1), NSStringFromCGPoint(point2), NSStringFromCGPoint(point3));
        
        CGPoint mid1    = midPoint(point2 , point1);    //last midpt
        CGPoint mid2    = midPoint(point3, point2);     //current midpt
        
//        NSLog(@"mid1= %@, mid2 = %@", NSStringFromCGPoint(mid1), NSStringFromCGPoint(mid2));
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, mid1.x, mid1.y);
        CGPathAddQuadCurveToPoint(path, NULL, point2.x, point2.y, mid2.x, mid2.y);
        CGContextAddPath(cacheContext, path);
        CGRect bounds = CGPathGetBoundingBox(path);
        
        CGPathRelease(path);
        
        CGContextSetStrokeColorWithColor(cacheContext, [color CGColor]);
        CGContextSetLineCap(cacheContext, kCGLineCapRound);
      
        if (brushDynamics) {
            CGFloat xDist = (point2.x - point3.x);
            CGFloat yDist = (point2.y - point3.y);
            CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
            
            distance = distance / 10;
            
            if (distance > 10) {
                distance = 10.0;
            }
            
            distance = distance / 10;
            distance = distance * 3;
            
            if (originalLineWidth - distance > lineWidth) {
                lineWidth = lineWidth + 0.3;
            } else {
                lineWidth = lineWidth - 0.3;
            }
        }
        
        
        CGContextSetLineWidth(cacheContext, lineWidth);
        CGContextSetAllowsAntialiasing(cacheContext, true);
        CGContextSetShouldAntialias(cacheContext, true);
        CGContextStrokePath(cacheContext);
        
        //NSLog(@"%@%@%@%@%@ \n", NSStringFromCGPoint(point2), NSStringFromCGPoint(point1), NSStringFromCGPoint(point3), NSStringFromCGPoint(mid1), NSStringFromCGPoint(mid2));
        CGRect drawBox = bounds;
        
        //Pad our values so the bounding box respects our line width
        drawBox.origin.x        -= lineWidth * 1;
        drawBox.origin.y        -= lineWidth * 1;
        drawBox.size.width      += lineWidth * 1.75;
        drawBox.size.height     += lineWidth * 1.75;
        
        
        
        [self setNeedsDisplayInRect:drawBox];
        
    }
    
}

- (void) drawRect:(CGRect)rect {
    
    //NSLog(@"call count = %d", count++);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (drawMode) {
        case DRAW:
            
            cacheImage = CGBitmapContextCreateImage(cacheContext);
            CGContextDrawImage(context, self.bounds, cacheImage);
            CGImageRelease(cacheImage);

            break;
            
        case EDIT:
            CGContextDrawImage(cacheContext, self.bounds, cacheImage);
            CGContextDrawImage(context, self.bounds, cacheImage);
            break;
            
        case LOAD:
            
            // save context states
            //CGContextSaveGState(context);
            CGContextSaveGState(cacheContext);
            
            // translate and scale co-ordinates
            CGContextTranslateCTM(context, 0, self.bounds.size.height);
            CGContextScaleCTM(context, 1, -1);
            
            CGContextTranslateCTM(cacheContext, 0, self.bounds.size.height);
            CGContextScaleCTM(cacheContext, 1, -1);
            
            //redraw image on new co-ordinate system
            CGContextDrawImage(cacheContext, self.bounds, cacheImage);
            CGContextDrawImage(context, self.bounds, cacheImage);
            
            //cacheImage is inverted, so we generate new cache image with new properly
            //oriented cacheContext
            cacheImage = CGBitmapContextCreateImage(cacheContext);
            [undoArray addObject:(__bridge id)(cacheImage)];
            
            if ([undoArray count]>25) {
                [undoArray removeObjectAtIndex:0];
            }
            
            //restore context states
            CGContextRestoreGState(cacheContext);
            //CGContextRestoreGState(context);
            break;
            
        default:
            break;
    }
}



#pragma mark Selectors

- (void) setBrushSize: (CGFloat)size withDynamics:(BOOL)dynamics {
    
    originalLineWidth = size;
    lineWidth = size;
    brushDynamics = dynamics;
}

- (void) setImageFromPhotoLibrary:(UIImage*)image {
    
    self.undoButton.enabled = true;
    
    if(image.size.width>image.size.height)
    {
        UIImage *tmp = image;
        image = [tmp imageRotatedByDegrees:90];
        tmp = nil;
    }
    NSLog(@"original size = %@", NSStringFromCGSize(image.size));
    
    float scaleFactor = [UIScreen mainScreen].scale;
    CGSize requiredSize = CGSizeMake(self.bounds.size.width * scaleFactor, self.bounds.size.height * scaleFactor);
    
    image = [image imageByScalingProportionallyToSize:requiredSize];

    NSLog(@"scaled size = %@", NSStringFromCGSize(image.size));
    
    cacheImage = image.CGImage;
    
    drawMode = LOAD;
    
    [self setNeedsDisplay];
}

- (void) setBrushColor:(UIColor*)selectedColor withBlendMode:(CGBlendMode)blendMode {
    color = selectedColor;
    CGContextSetBlendMode(cacheContext, blendMode);
}

- (void) setUserInteractionOnCanvasEnabled:(BOOL)enabled {
    
    interactionEnabled = enabled;
}

- (void) clearContext {
    
    self.undoButton.enabled = self.redoButton.enabled = self.saveImageButton.enabled = false;
    
    // clear undo redo array
    [undoArray removeAllObjects];
    [redoArray removeAllObjects];
    
    // clear cache image
    cacheImage = nil;
    CGImageRelease(cacheImage);
    
    // clear cache context
    CGContextClearRect(cacheContext, self.bounds);
    CGContextSetBlendMode(cacheContext, kCGBlendModeNormal);
    CGContextSetRGBFillColor(cacheContext, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(cacheContext, self.bounds);
    
    // fill first undo array to blank
    cacheImage = CGBitmapContextCreateImage(cacheContext);
    [undoArray addObject:(__bridge id)(cacheImage)];
    CGImageRelease(cacheImage);
    
    // drawing mode
    drawMode = DRAW;
    
    // update display
    [self setNeedsDisplay];
}



#pragma mark IBActions

- (IBAction)resetPressed:(id)sender {
    [self clearContext];
}

- (IBAction)undoPressed:(id)sender {
    if([undoArray count]>0)
    {
        self.redoButton.enabled = true;
        
        [redoArray addObject:[undoArray lastObject]];
        [undoArray removeLastObject];
        
        cacheImage = (__bridge CGImageRef)([undoArray lastObject]);
        
        if ([undoArray count] == 0) {
            self.undoButton.enabled = false;
        }
        
        drawMode = EDIT;
        [self setNeedsDisplay];
    }
}

- (IBAction)redoPressed:(id)sender {
    if([redoArray count]>0)
    {
        
        self.undoButton.enabled = true;
        
        [undoArray addObject:[redoArray lastObject]];
        
        //cacheContext = (__bridge CGContextRef)([redoArray lastObject]);
        cacheImage = (__bridge CGImageRef)([redoArray lastObject]);
        
        [redoArray removeLastObject];
        
        
        if ([redoArray count] == 0) {
            self.redoButton.enabled = false;
        }
        
        drawMode = EDIT;
        
        [self setNeedsDisplay];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    // Was there an error?
    if (error != NULL)
    {
        [ProgressHUD showError:@"Unable to save photo.\nPlease make sure that Sketchy has permission to save to your Camera Roll by checking in\n Settings → Privacy → Photos."];
        
    } else {
        
        [ProgressHUD showSuccess:@"Image Saved"];
    }
}

- (IBAction)saveImage:(id)sender {
    
    // save context state
    CGContextSaveGState(cacheContext);
    
    // translate and scale current co-ordinate system
    CGContextTranslateCTM(cacheContext, 0, self.bounds.size.height);
    CGContextScaleCTM(cacheContext, 1, -1);
    
    // draw one new co-ordinate system from previous cache image
    CGContextDrawImage(cacheContext, self.bounds, cacheImage);
    
    // get new cache image from newly drawn cacheContext
    cacheImage = CGBitmapContextCreateImage(cacheContext);
    
    // restore context state to it's orginal
    CGContextRestoreGState(cacheContext);
    
    // get UIImage from CGImage
    UIImage *image = [UIImage imageWithCGImage:cacheImage];
    
    //UIImage *image = [UIImage imageWithCGImage:cacheImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDownMirrored];
    
    // Save to album
    UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    image = nil;
}

@end
