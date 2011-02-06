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

- (CATransform3D)originTransformForLayer:(CALayer *)layer;

@end

@implementation FlyingImagesAppDelegate

@synthesize window;
@synthesize imageContainer;
@synthesize durationStepper;

- (CATransform3D)originTransformForLayer:(CALayer *)layer; {
  CGPoint layerPosition = [layer position];
  CATransform3D originTransform = CATransform3DMakeTranslation(20.f - layerPosition.x, -layerPosition.y, 0.f);
  return originTransform;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [[self durationStepper] setIncrement:.05f];
  [[self durationStepper] setDoubleValue:.4f];
  shouldReverse_ = NO;

  //Start with all of the images at the origin
  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  for (CALayer *imageLayer in [[[self imageContainer] layer] sublayers]) {    
    [imageLayer setTransform:[self originTransformForLayer:imageLayer]];
  }
  [CATransaction commit];
}

- (IBAction)runAnimation:(id)sender {
  CALayer *containerLayer = [[self imageContainer] layer];
  
  NSTimeInterval delay = 0.f;
  NSTimeInterval delayStep = .05f;
  NSTimeInterval singleDuration = [[self durationStepper] doubleValue];
  NSTimeInterval fullDuration = singleDuration + (delayStep * [[containerLayer sublayers] count]);
  
  NSEnumerator *imageLayerEnumerator;
  if(shouldReverse_) {
    imageLayerEnumerator = [[containerLayer sublayers] reverseObjectEnumerator];
  } else {
    imageLayerEnumerator = [[containerLayer sublayers] objectEnumerator];
  } 
  
  for (CALayer *imageLayer in imageLayerEnumerator) {
    CATransform3D currentTransform = [[imageLayer presentationLayer] transform];
    CATransform3D newTransform;
    
    if(shouldReverse_) {
      newTransform = [self originTransformForLayer:imageLayer];
    } else {
      newTransform = CATransform3DIdentity;
    }
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.beginTime = delay;
    anim.fromValue = [NSValue valueWithCATransform3D:currentTransform];
    anim.toValue = [NSValue valueWithCATransform3D:newTransform];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fillMode = kCAFillModeBackwards;
    anim.duration = singleDuration;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObject:anim];
    group.duration = fullDuration;
    
    [imageLayer setTransform:newTransform];
    [imageLayer addAnimation:group forKey:@"transform"];
    delay += delayStep;
  }
  shouldReverse_ = !shouldReverse_;
}

@end
