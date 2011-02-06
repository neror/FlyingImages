//
//  FlyingImagesAppDelegate.m
//  FlyingImages
//
//  Created by Nathan Eror on 2/5/11.
//  Copyright 2011 Free Time Studios. All rights reserved.
//

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
