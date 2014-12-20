//
//  RSTransparentPlugin.m
//  RSTransparentPlugin
//
//  Created by Closure on 11/15/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import "RSTransparentPlugin.h"
#import "AppleXcode.h"
#import "NSWindow+Blur.h"
#import "RSTransparentPluginSettingWindowController.h"
#import "RSTransparentSetting.h"

#include <objc/message.h>
#include <objc/runtime.h>

static RSTransparentPlugin *sharedPlugin;

@interface RSTransparentPlugin()
@property (strong, nonatomic) RSTransparentPluginSettingWindowController *settingWindowController;
@property (strong, nonatomic) NSBundle *bundle;
@property (strong, nonatomic) RSTransparentSetting *setting;
@end

typedef void (*NSView_drawRectFuncPtr)(id self, SEL _cmd, NSRect dirtyRect);
static NSView_drawRectFuncPtr __IMP_DVTSourceCodeEditor_drawRect__ = nil;

static void __RS_IMP_DVTSourceCodeEditor_drawRect__(id self, SEL _cmd, NSRect dirtyRect) {
    id setting = [RSTransparentSetting sharedSetting];
    NSColor *color = [[setting backgroundColor] colorWithAlphaComponent:[setting backgroundAlphaValue]];
    [color set];
    NSRectFillUsingOperation(dirtyRect, NSCompositeCopy);
    __IMP_DVTSourceCodeEditor_drawRect__(self, _cmd, dirtyRect);
}

@implementation RSTransparentPlugin

+ (void)load {
    NSLog(@"%@ - %@", [self class], NSStringFromSelector(_cmd));
}

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        self.bundle = plugin;
        [self setupMenu];
        _setting = [RSTransparentSetting sharedSetting];
        [_setting addObserver:self forKeyPath:@"backgroundColor" options:0 context:nil];
        [_setting addObserver:self forKeyPath:@"backgroundAlphaValue" options:0 context:nil];
        [_setting addObserver:self forKeyPath:@"windowBlurValue" options:0 context:nil];
    }
    return self;
}

- (NSString *)_dumpSourceCodeEditor {
    NSMutableString *description = [[NSMutableString alloc] init];
    [description appendFormat:@"%@\n", NSStringFromSelector(_cmd)];
    NSArray *windows = [NSApp windows];
    [windows enumerateObjectsUsingBlock:^(NSWindow *window, NSUInteger idx, BOOL *stop) {
        [description appendFormat:@"window = %@\n", window];
    }];
    [self applyBlur:[_setting windowBlurValue] forIDEWorkspaceWindow:(IDEWorkspaceWindow *)[NSApp keyWindow] enumBlock:^(NSView *view) {
        if ([view respondsToSelector:@selector(drawsBackground)]) {
            [description appendFormat:@"\t%@(%@)\n", view, @([(NSTextView *)view drawsBackground])];
        } else {
            [description appendFormat:@"\t%@\n", view];
        }
    }];
    return [description copy];
}

- (void)applyBlur:(CGFloat)blurValue forIDEWorkspaceWindow:(IDEWorkspaceWindow *)window enumBlock:(void(^)(NSView *view))enumBlock {
    if ([window isKindOfClass:NSClassFromString(@"IDEWorkspaceWindow")]) {
        [self applyBlur:blurValue forWindow:window enumBlock:enumBlock];
    }
}

- (void)applyBlur:(CGFloat)blurValue forWindows:(NSArray *)windows enumBlock:(void(^)(NSView *view))enumBlock {
    [windows enumerateObjectsUsingBlock:^(NSWindow *window, NSUInteger idx, BOOL *stop) {
        [self applyBlur:blurValue forWindow:window enumBlock:enumBlock];
    }];
}

- (void)applyBlur:(CGFloat)blurValue forWindow:(NSWindow *)window enumBlock:(void(^)(NSView *view))enumBlock {
    [window prepareForBlur];
    [window enableBlur:blurValue];
    id editor = [AppleXcode editorForWindow:window];
    BOOL currentEditorIsSourceCodeEditor = [editor isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")];
    NSLog(@"start(%@)", @(currentEditorIsSourceCodeEditor));
    
    NSView *view = nil;
    if (currentEditorIsSourceCodeEditor) {
        [[editor textView] setDrawsBackground:NO];
        [[editor textView] setNeedsDisplay:YES];
        view = [editor textView];
    } else {
        view = editor;
        id cls = [view class];
        while (cls) {
            NSLog(@"%@", cls);
            cls = [cls superclass];
        }
        return;
    }
    while (view) {
        if (enumBlock) enumBlock(view);
        if ([view respondsToSelector:@selector(drawsBackground)]) {
            [(NSTextView *)view setDrawsBackground:NO];
        }
        view = [view superview];
    }
}

- (NSArray *)windowsForBlur {
    NSMapTable *mt = [AppleXcode editorsForWindows:[NSApp windows]];
    if (mt && [mt count]) {
        NSMutableArray *windows = [[NSMutableArray alloc] initWithCapacity:[mt count]];
        for (NSWindow * window in [mt keyEnumerator]) {
            [windows addObject:window];
        }
        return windows;
    }
    return nil;
}

- (NSArray *)editorsForBlur {
    NSMapTable *mt = [AppleXcode editorsForWindows:[NSApp windows]];
    if (mt && [mt count]) {
        NSMutableArray *windows = [[NSMutableArray alloc] initWithCapacity:[mt count]];
        for (NSWindow * window in [mt objectEnumerator]) {
            [windows addObject:window];
        }
        return windows;
    }
    return nil;
}

- (void)sourceCodeEditorBlurred
{
    if (!__IMP_DVTSourceCodeEditor_drawRect__)
        __IMP_DVTSourceCodeEditor_drawRect__ = (NSView_drawRectFuncPtr)class_replaceMethod(NSClassFromString(@"DVTSourceTextView"), @selector(drawRect:), (IMP)__RS_IMP_DVTSourceCodeEditor_drawRect__, nil);
    if (__IMP_DVTSourceCodeEditor_drawRect__) NSLog(@"DVTSourceTextView hooked");
    NSArray *windows = [self windowsForBlur];
    [self applyBlur:[_setting windowBlurValue] forWindows:windows enumBlock:nil];
}

- (void)showSettingWindowController {
    if (!_settingWindowController)
        _settingWindowController = [[RSTransparentPluginSettingWindowController alloc] initWithWindowNibName:@"RSTransparentPluginSettingWindowController"];
    [_settingWindowController showWindow:_settingWindowController];
}

- (void)showMsg:(NSString *)message {
    [[NSAlert alertWithMessageText:message defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
}

- (void)setupMenu {
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Xcode"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"HLM(Closure)" action:@selector(sourceCodeEditorBlurred) keyEquivalent:@"-"];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
        
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"HLM Setting" action:@selector(showSettingWindowController) keyEquivalent:@"+"];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    @autoreleasepool {
        if (object == _setting && [keyPath isEqualToString:@"backgroundColor"]) {
            NSArray *editors = [self editorsForBlur];
            for (id editor in editors) {
                BOOL currentEditorIsSourceCodeEditor = [editor isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")];
                if (currentEditorIsSourceCodeEditor) {
                    [[editor textView] setNeedsDisplay:YES];
                }
            }
        } else if (object == _setting && [keyPath isEqualToString:@"backgroundAlphaValue"]) {
            NSArray *editors = [self editorsForBlur];
            for (id editor in editors) {
                BOOL currentEditorIsSourceCodeEditor = [editor isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")];
                if (currentEditorIsSourceCodeEditor) {
                    [[editor textView] setNeedsDisplay:YES];
                }
            }
        } else if (object == _setting && [keyPath isEqualToString:@"windowBlurValue"]) {
            [self sourceCodeEditorBlurred];
        }
    }
}

- (void)dealloc
{
    [_setting removeObserver:self forKeyPath:@"backgroundColor"];
    [_setting removeObserver:self forKeyPath:@"backgroundAlphaValue"];
    [_setting removeObserver:self forKeyPath:@"windowBlurValue"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSArchiver archivedDataWithRootObject:nil];
}

@end
