//
//  AppleXcode.m
//  RSTransparentPlugin
//
//  Created by Closure on 12/08/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import "AppleXcode.h"
#import "RSTransparentPlugin.h"

@interface AppleXcode()
//+ (IDEWorkspaceDocument *)workspaceDocument;
//+ (IDESourceCodeDocument *)sourceCodeDocument;
@end

@implementation AppleXcode
+ (void)load {
    NSLog(@"%@ - %@", [self class], NSStringFromSelector(_cmd));
}

+ (void)pluginDidLoad:(NSBundle *)plugin {
    [RSTransparentPlugin pluginDidLoad:plugin];
}

+ (id)editorForWindow:(NSWindow *)window {
    NSWindowController *currentWindowController = [window windowController];
    if ([currentWindowController isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
        IDEWorkspaceWindowController *workspaceController = (IDEWorkspaceWindowController *)currentWindowController;
        IDEEditorArea *editorArea = [workspaceController editorArea];
        IDEEditorContext *editorContext = [editorArea lastActiveEditorContext];
        return [editorContext editor];
    }
    return nil;
}

+ (NSMapTable *)editorsForWindows:(NSArray *)windows {
    NSMapTable *maptable = [[NSMapTable alloc] init];
    [windows enumerateObjectsUsingBlock:^(NSWindow *window, NSUInteger idx, BOOL *stop) {
        id editor = [self editorForWindow:window];
        if (editor) [maptable setObject:editor forKey:window];
    }];
    return maptable;
}

+ (id)currentEditor {
    return [self editorForWindow:[[NSApp keyWindow] windowController]];
}

+ (IDEWorkspaceDocument *)workspaceDocument {
    NSWindowController *currentWindowController = [[NSApp keyWindow] windowController];
    id document = [currentWindowController document];
    if (currentWindowController && [document isKindOfClass:NSClassFromString(@"IDEWorkspaceDocument")]) {
        return (IDEWorkspaceDocument *)document;
    }
    return nil;
}

+ (IDESourceCodeDocument *)sourceCodeDocument {
    if ([[self currentEditor] isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")]) {
        IDESourceCodeEditor *editor = [self currentEditor];
        return editor.sourceCodeDocument;
    }
    
    if ([[self currentEditor] isKindOfClass:NSClassFromString(@"IDESourceCodeComparisonEditor")]) {
        IDESourceCodeComparisonEditor *editor = [self currentEditor];
        if ([[editor primaryDocument] isKindOfClass:NSClassFromString(@"IDESourceCodeDocument")]) {
            IDESourceCodeDocument *document = (IDESourceCodeDocument *)editor.primaryDocument;
            return document;
        }
    }
    
    return nil;
}

+ (NSTextView *)textView {
    if ([[self currentEditor] isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")]) {
        IDESourceCodeEditor *editor = [self currentEditor];
        return editor.textView;
    }
    
    if ([[self currentEditor] isKindOfClass:NSClassFromString(@"IDESourceCodeComparisonEditor")]) {
        IDESourceCodeComparisonEditor *editor = [self currentEditor];
        return editor.keyTextView;
    }
    
    return nil;
}

#pragma mark - xalign

+ (NSRange)charaterRangeFromSelectedRange:(NSRange)range
{
	IDESourceCodeDocument * document = [AppleXcode sourceCodeDocument];
    if ( !document )
        return NSMakeRange( NSNotFound , 0 );
	
	NSRange lineRange = [[document textStorage] lineRangeForCharacterRange:range];
	NSRange charaterRange = [[document textStorage] characterRangeForLineRange:lineRange];
	
	return charaterRange;
}

+ (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)aString
{
    IDESourceCodeDocument * document = [AppleXcode sourceCodeDocument];
    if ( !document )
        return;
    [[document textStorage] beginEditing];
    [[document textStorage] replaceCharactersInRange:range withString:aString withUndoManager:[document undoManager]];
    [[document textStorage] endEditing];
}

+ (long long)tabWidth
{
    DVTTextPreferences * preferences = [DVTTextPreferences preferences];
    return preferences.tabWidth;
}

+ (void)logSelection:(NSRange)range
{
	IDESourceCodeDocument * document = [AppleXcode sourceCodeDocument];
    if ( !document )
        return;
    [[document textStorage] beginEditing];
	NSRange r = [[document textStorage] lineRangeForCharacterRange:range];
	NSLog( @"%@ %@" , NSStringFromRange(range), NSStringFromRange(r));
    [[document textStorage] endEditing];
}

@end
