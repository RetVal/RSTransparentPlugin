//
//  RSTransparentSetting.h
//  RSTransparentPlugin
//
//  Created by Closure on 12/9/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSTransparentSetting : NSObject
+ (instancetype)sharedSetting;
- (id)init;
- (void)restoreDefault;

- (NSColor *)backgroundColor;
- (void)setBackgroundColor:(NSColor *)color;

- (CGFloat)backgroundAlphaValue;
- (void)setBackgroundAlphaValue:(CGFloat)alphaValue;

- (CGFloat)windowBlurValue;
- (void)setWindowBlurValue:(CGFloat)windowBlurValue;

- (CGFloat)windowAlphaValue;
- (void)setWindowAlphaValue:(CGFloat)alphaValue;

- (id)runMode;
- (void)setRunMode:(id)runMode;
@end
