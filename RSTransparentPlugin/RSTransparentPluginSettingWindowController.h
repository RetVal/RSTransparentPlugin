//
//  RSTransparentPluginSettingWindowController.h
//  RSTransparentPlugin
//
//  Created by Closure on 12/9/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RSTransparentSetting;
@interface RSTransparentPluginSettingWindowController : NSWindowController
@property (strong) IBOutlet NSTextView *textView;
@property (strong) IBOutlet NSColorWell *showColorPanelWell;

@property (strong, nonatomic) RSTransparentSetting *setting;

@property (strong, nonatomic) NSColor *color;
@property (assign, nonatomic) CGFloat colorAlpha;
@property (assign, nonatomic) CGFloat windowAlpha;
@property (assign, nonatomic) CGFloat windowBlur;
@end
