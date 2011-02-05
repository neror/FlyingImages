//
//  FlyingImagesAppDelegate.h
//  FlyingImages
//
//  Created by Nathan Eror on 2/5/11.
//  Copyright 2011 Free Time Studios. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FlyingImagesAppDelegate : NSObject <NSApplicationDelegate> {
@private
  NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
