/*
 The MIT License
 
 Copyright (c) 2011 Free Time Studios and Nathan Eror
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

#import "FlyingImagesAppDelegate.h"
#import <Quartz/Quartz.h>

@interface FlyingImagesAppDelegate()

- (CATransform3D)centeringTransformForView:(NSView *)imageView;

@end

@implementation FlyingImagesAppDelegate

@synthesize window;
@synthesize imageContainer;

- (CATransform3D)centeringTransformForView:(NSView *)imageView {
  CALayer *layer = [imageView layer];
  CGSize layerSize = [layer bounds].size;
  CGPoint layerPosition = [layer position];

  CGRect superBounds = [[layer superlayer] bounds];
  CGPoint center = CGPointMake(CGRectGetMidX(superBounds) - layerSize.width / 2.f, 
                               CGRectGetMidY(superBounds) - layerSize.height / 2.f);
  
  CATransform3D originTransform = CATransform3DMakeTranslation(center.x - layerPosition.x, 
                                                               center.y - layerPosition.y, 
                                                               0.f);
  return originTransform;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  //Start with all of the images at the origin
  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  for (NSImageView *imageView in [[self imageContainer] subviews]) {    
    [[imageView layer] setTransform:[self centeringTransformForView:imageView]];
  }
  [CATransaction commit];
}

- (IBAction)runAnimation:(id)sender {
  BOOL shiftKeyDown = ([[NSApp currentEvent] modifierFlags] & (NSShiftKeyMask | NSAlphaShiftKeyMask)) != 0;
  if(shiftKeyDown) {
    [[[self imageContainer] layer] setSpeed:.2f];
  } else {
    [[[self imageContainer] layer] setSpeed:1.f];
  }
  
  for (NSImageView *imageView in [[self imageContainer] subviews]) {
    if(CATransform3DIsIdentity([[imageView layer] transform])) {
      [[imageView layer] setTransform:[self centeringTransformForView:imageView]];
    } else {
      [[imageView layer] setTransform:CATransform3DIdentity];
    }
  }
}

@end
