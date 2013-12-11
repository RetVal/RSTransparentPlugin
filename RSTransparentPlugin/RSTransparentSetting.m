//
//  RSTransparentSetting.m
//  RSTransparentPlugin
//
//  Created by Closure on 12/9/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import "RSTransparentSetting.h"

static NSString * RSTransparentSettingBackgroundColor = @"RSTransparentSettingBackgroundColor";
static NSString * RSTransparentSettingBackgroundColorAlpha = @"RSTransparentSettingBackgroundColorAlpha";
static NSString * RSTransparentSettingBlur = @"RSTransparentSettingBlur";
static NSString * RSTransparentSettingWindowAlpha = @"RSTransparentSettingWindowAlpha";
static NSString * RSTransparentSettingLogPath = @"RSTransparentSettingLogPath";
static NSString * RSTransparentSettingRunMode = @"RSTransparentSettingRunMode";

static NSString * RSTransparentSettingRootKey = @"RSTransparentSettingRootKey";
static NSString * RSTransparentSettingFileName = @"RSTransparentSetting.plist";

@interface RSTransparentSetting()
{
    NSMutableDictionary *_settings;
}
@end

static RSTransparentSetting *__sharedSetting = nil;
@implementation RSTransparentSetting

+ (instancetype)sharedSetting {
    return [[self alloc] init];
}

+ (NSDictionary *)defaultSetting {
    return @{RSTransparentSettingBackgroundColor: [NSColor whiteColor],
             RSTransparentSettingBackgroundColorAlpha: @(0.5),
             RSTransparentSettingBlur: @(20.0),
             RSTransparentSettingWindowAlpha: @(0.99999),
             RSTransparentSettingLogPath: [@"~/Library/Caches/com.apple.dt.Xcode/Plugins/RSTransparentPlugin/" stringByStandardizingPath],
             RSTransparentSettingRunMode: @"RSPluginDefaultMode"};
}

- (void)restoreDefault {
    _settings = [[RSTransparentSetting defaultSetting] mutableCopy];
}

- (void)loadSettingFromFileSystem {
    NSString *settingPath = [@"~/Library/Caches/com.apple.dt.Xcode/Plugins/RSTransparentPlugin/" stringByStandardizingPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:settingPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSMutableString *filePath = [settingPath mutableCopy];
    [filePath appendFormat:@"/%@", RSTransparentSettingFileName];
    _settings = [[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:filePath]] mutableCopy];
}

- (id)init {
    if (__sharedSetting) return __sharedSetting;
    NSString *settingPath = [@"~/Library/Caches/com.apple.dt.Xcode/Plugins/RSTransparentPlugin/" stringByStandardizingPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:settingPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSMutableString *filePath = [settingPath mutableCopy];
    [filePath appendFormat:@"/%@", RSTransparentSettingFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSKeyedArchiver archivedDataWithRootObject:[RSTransparentSetting defaultSetting]] writeToFile:filePath atomically:YES];
    }
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
        __sharedSetting = self;
        [self loadSettingFromFileSystem];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillTerminate:(NSNotification*)notification {
    NSString *settingPath = [@"~/Library/Caches/com.apple.dt.Xcode/Plugins/RSTransparentPlugin/" stringByStandardizingPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:settingPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSMutableString *filePath = [settingPath mutableCopy];
    [filePath appendFormat:@"/%@", RSTransparentSettingFileName];
    [[NSKeyedArchiver archivedDataWithRootObject:_settings] writeToFile:filePath atomically:YES];
}

- (NSColor *)backgroundColor {
    NSColor *color = _settings[RSTransparentSettingBackgroundColor];
    if (!color) {
        _settings[RSTransparentSettingBackgroundColor] = [NSColor whiteColor];
        color = _settings[RSTransparentSettingBackgroundColor];
    }
    return [color colorWithAlphaComponent:[self backgroundAlphaValue]];
}

- (void)setBackgroundColor:(NSColor *)color {
    if (!color) color = [NSColor whiteColor];
    if ([color isKindOfClass:[NSColor class]]) {
        _settings[RSTransparentSettingBackgroundColor] = color;
    } else {
        _settings[RSTransparentSettingBackgroundColor] = [NSColor whiteColor];
    }
}

- (CGFloat)backgroundAlphaValue {
    id alpha = _settings[RSTransparentSettingBackgroundColorAlpha];
    return [alpha floatValue];
}

- (void)setBackgroundAlphaValue:(CGFloat)alphaValue {
    if (alphaValue < 0.000001) alphaValue = 0.0f;
    else if (alphaValue > 0.99999) alphaValue = 1.0f;
    _settings[RSTransparentSettingBackgroundColorAlpha] = @(alphaValue);
}

- (CGFloat)windowBlurValue {
    id blur = _settings[RSTransparentSettingBlur];
    return [blur floatValue];
}

- (void)setWindowBlurValue:(CGFloat)windowBlurValue {
    if (windowBlurValue < 0.000001) windowBlurValue = 0.0f;
    _settings[RSTransparentSettingBlur] = @(windowBlurValue);
}

- (CGFloat)windowAlphaValue {
    id alpha = _settings[RSTransparentSettingWindowAlpha];
    return [alpha floatValue];
}

- (void)setWindowAlphaValue:(CGFloat)alphaValue {
    if (alphaValue < 0.000001) alphaValue = 0.0f;
    else if (alphaValue > 0.99999) alphaValue = 1.0f;
    _settings[RSTransparentSettingWindowAlpha] = @(alphaValue);
}

- (id)runMode {
    return _settings[RSTransparentSettingRunMode];
}

- (void)setRunMode:(id)runMode {
    _settings[RSTransparentSettingRunMode] = runMode;
}

- (NSString *)description {
    return [_settings description];
}
@end
