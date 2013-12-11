//
//  RSTransparentPluginSettingWindowController.m
//  RSTransparentPlugin
//
//  Created by Closure on 12/9/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import "RSTransparentPluginSettingWindowController.h"

#import "RSTransparentSetting.h"
@interface RSTransparentPluginSettingWindowController () <NSWindowDelegate>
@property (strong, nonatomic) NSColorPanel *colorPanel;
@property (strong) IBOutlet NSTextField *windowAlphaLabel;
@property (strong) IBOutlet NSTextField *colorAlphaLabel;
@property (strong) IBOutlet NSTextField *windowBlurLabel;
@property (strong) IBOutlet NSSlider *windowBlurSlider;
@property (strong) IBOutlet NSSlider *windowAlphaSlider;
@property (strong) IBOutlet NSSlider *colorAlphaSlider;
@end

@implementation RSTransparentPluginSettingWindowController
- (void)awakeFromNib {
    [super awakeFromNib];
    [[self colorPanel] addObserver:self forKeyPath:@"color" options:0 context:nil];
}

- (RSTransparentSetting *)setting {
    if (!_setting) _setting = [RSTransparentSetting sharedSetting];
    return _setting;
}

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        _color = [_setting backgroundColor];
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [[self showColorPanelWell] setColor:[_setting backgroundColor]];
}

// support for KVO
- (IBAction)windowBlurChangedAction:(NSSlider *)sender {
    [[self setting] setWindowBlurValue:[sender floatValue]];
    [_windowBlurLabel setFloatValue: [[self setting] windowBlurValue]];
}

- (IBAction)windowAlphaChangedAction:(NSSlider *)sender {
    [[self setting] setWindowAlphaValue:[sender floatValue]];
    [_windowAlphaLabel setFloatValue: [[self setting] windowAlphaValue]];
}

- (IBAction)colorAlphaChangedAction:(NSSlider *)sender {
    [[self setting] setBackgroundAlphaValue:[sender floatValue]];
    [_colorAlphaLabel setFloatValue: [[self setting] backgroundAlphaValue]];
}

- (IBAction)showColorPanel:(id)sender {
    [[self colorPanel] makeKeyAndOrderFront:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"color"] && object == _colorPanel) {
        _color = [_colorPanel color];
        [[self setting] setBackgroundColor:_color];
        [[self showColorPanelWell] setColor:[[self setting] backgroundColor]];
    }
}

- (NSColorPanel *)colorPanel {
    if (_colorPanel) {
        [_colorPanel setColor:[[self setting] backgroundColor]];
        return _colorPanel;
    }
    _colorPanel = [NSColorPanel sharedColorPanel];
    [_colorPanel setTitle:@""];
    [_colorPanel setDelegate:self];
    [_colorPanel setFloatingPanel:NO];
    [_colorPanel setHidesOnDeactivate:NO];
    [_colorPanel setHasShadow:YES];
    [_colorPanel setShowsAlpha:NO];
    [_colorPanel setWorksWhenModal:YES];
    [_colorPanel setColor:[[self setting] backgroundColor]];
    return _colorPanel;
}

- (IBAction)restoreDefaultButtonPressed:(NSButton *)sender {
    [[self setting] restoreDefault];
    [[self setting] setWindowBlurValue:[[self setting] windowBlurValue]];
    [[self setting] setWindowAlphaValue:[[self setting] windowAlphaValue]];
    [[self setting] setBackgroundColor:[[self setting] backgroundColor]];
    [[self setting] setBackgroundAlphaValue:[[self setting] backgroundAlphaValue]];
    
    // refresh UI
    [[self windowBlurSlider] setFloatValue: [[self setting] windowBlurValue]];
    [[self windowBlurLabel] setFloatValue:[[self setting] windowBlurValue]];
    [[self windowAlphaSlider] setFloatValue: [[self setting] windowAlphaValue]];
    [[self windowAlphaLabel] setFloatValue:[[self setting] windowAlphaValue]];
    [[self colorAlphaSlider] setFloatValue: [[self setting] backgroundAlphaValue]];
    [[self colorAlphaLabel] setFloatValue:[[self setting] backgroundAlphaValue]];
    [[self showColorPanelWell] setColor:[[self setting] backgroundColor]];
    [[self colorPanel] setColor:[[self setting] backgroundColor]];
}

- (void)dealloc {
    [[self colorPanel] removeObserver:self forKeyPath:@"color"];
}
@end
