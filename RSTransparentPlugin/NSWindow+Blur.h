//
//  NSWindow+Blur.h
//  RSTransparentPlugin
//
//  Created by Closure on 12/9/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (Blur)
- (void)enableBlur:(CGFloat)radius;
- (void)prepareForBlur;
@end
