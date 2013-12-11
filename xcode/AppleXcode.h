//
//  AppleXcode.m
//  RSTransparentPlugin
//
//  Created by Closure on 12/08/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppleXcode : NSObject
+ (void)pluginDidLoad:(NSBundle *)plugin;

+ (id)editorForWindow:(NSWindow *)window;
+ (NSMapTable *)editorsForWindows:(NSArray *)windows;

+ (id)currentEditor;
+ (IDEWorkspaceDocument *)workspaceDocument;
+ (IDESourceCodeDocument *)sourceCodeDocument;
+ (void)logSelection:(NSRange)range;

// IDE
+ (NSTextView *)textView;
+ (NSRange)charaterRangeFromSelectedRange:(NSRange)range;
// Edit
+ (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)aString;
// Settings
+ (long long)tabWidth;
//+ (NSDictionary *)defaultSetting;
//+ (void)setValue:(NSString *)value forSettingKey:(NSString *)key;

@end
