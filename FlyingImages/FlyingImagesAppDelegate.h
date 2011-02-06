//
//  FlyingImagesAppDelegate.h
//  FlyingImages
//
//  Created by Nathan Eror on 2/5/11.
//  Copyright 2011 Free Time Studios. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FlyingImagesAppDelegate : NSObject <NSApplicationDelegate> {
  NSWindow *window;
  NSView *imageContainer;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *imageContainer;

- (IBAction)runAnimation:(id)sender;

@end
